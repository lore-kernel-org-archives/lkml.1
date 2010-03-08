Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0CHXJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:09:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0CHXJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:09:23 -0500
Date: Mon, 8 Mar 2010 18:09:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jens.axboe@oracle.com,
       Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface
	"weight_device" for IO-Controller
Message-ID: <20100308230905.GB3614@redhat.com>
References: <20100303143311.GA2866@redhat.com> <20100303154748.GC2866@redhat.com> <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com> <20100304152400.GB18786@redhat.com> <4B906BB6.3080104@cn.fujitsu.com> <20100305141300.GA3296@redhat.com> <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 11:39:54AM -0800, Nauman Rafique wrote:
> On Fri, Mar 5, 2010 at 6:13 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Mar 05, 2010 at 10:25:58AM +0800, Gui Jianfeng wrote:
> >> Currently, IO Controller makes use of blkio.weight to assign weight for
> >> all devices. Here a new user interface "blkio.weight_device" is introduced to
> >> assign different weights for different devices. blkio.weight becomes the
> >> default value for devices which are not configured by "blkio.weight_device"
> >>
> >> You can use the following format to assigned specific weight for a given
> >> device:
> >>
> >> major:minor represents device number.
> >>
> >> And you can remove a specific weight as following:
> >>
> >> V1->V2 changes:
> >> - use user interface "weight_device" instead of "policy" suggested by Vivek
> >> - rename some struct suggested by Vivek
> >> - rebase to 2.6-block "for-linus" branch
> >> - remove an useless list_empty check pointed out by Li Zefan
> >> - some trivial typo fix
> >>
> >> V2->V3 changes:
> >> - Move policy_*_node() functions up to get rid of forward declarations
> >> - rename related functions by adding prefix "blkio_"
> >>
> >
> > Thanks for the changes Gui. Looks good to me.
> >
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> >
> > Vivek
> >
> >> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> >> ---
> >>  block/blk-cgroup.c  |  236 ++++++++++++++++++++++++++++++++++++++++++++++++++-
> >>  block/blk-cgroup.h  |   10 ++
> >>  block/cfq-iosched.c |    2 +-
> >>  3 files changed, 246 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> >> index c85d74c..8825e49 100644
> >> --- a/block/blk-cgroup.c
> >> +++ b/block/blk-cgroup.c
> >> @@ -16,6 +16,7 @@
> >>  #include <linux/module.h>
> >>  #include <linux/err.h>
> >>  #include "blk-cgroup.h"
> >> +#include <linux/genhd.h>
> >>
> >>  static DEFINE_SPINLOCK(blkio_list_lock);
> >>  static LIST_HEAD(blkio_list);
> >> @@ -23,6 +24,32 @@ static LIST_HEAD(blkio_list);
> >>  struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
> >>  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
> >>
> >> +static inline void blkio_policy_insert_node(struct blkio_cgroup *blkcg,
> >> +                                         struct blkio_policy_node *pn)
> >> +{
> >> +     list_add(&pn->node, &blkcg->policy_list);
> >> +}
> >> +
> >> +/* Must be called with blkcg->lock held */
> >> +static inline void blkio_policy_delete_node(struct blkio_policy_node *pn)
> >> +{
> >> +     list_del(&pn->node);
> >> +}
> >> +
> >> +/* Must be called with blkcg->lock held */
> >> +static struct blkio_policy_node *
> >> +blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev)
> >> +{
> >> +     struct blkio_policy_node *pn;
> >> +
> >> +     list_for_each_entry(pn, &blkcg->policy_list, node) {
> >> +             if (pn->dev == dev)
> >> +                     return pn;
> >> +     }
> >> +
> >> +     return NULL;
> >> +}
> >> +
> >>  struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
> >>  {
> >>       return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
> >> @@ -128,6 +155,7 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
> >>       struct blkio_group *blkg;
> >>       struct hlist_node *n;
> >>       struct blkio_policy_type *blkiop;
> >> +     struct blkio_policy_node *pn;
> >>
> >>       if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
> >>               return -EINVAL;
> >> @@ -136,7 +164,13 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
> >>       spin_lock(&blkio_list_lock);
> >>       spin_lock_irq(&blkcg->lock);
> >>       blkcg->weight = (unsigned int)val;
> >> +
> >>       hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> >> +             pn = blkio_policy_search_node(blkcg, blkg->dev);
> >> +
> >> +             if (pn)
> >> +                     continue;
> >> +
> >>               list_for_each_entry(blkiop, &blkio_list, list)
> >>                       blkiop->ops.blkio_update_group_weight_fn(blkg,
> >>                                       blkcg->weight);
> >> @@ -178,15 +212,208 @@ SHOW_FUNCTION_PER_GROUP(dequeue);
> >>
> >>  #ifdef CONFIG_DEBUG_BLK_CGROUP
> >>  void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
> >> -                     unsigned long dequeue)
> >> +                                           unsigned long dequeue)
> >>  {
> >>       blkg->dequeue += dequeue;
> >>  }
> >>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
> >>  #endif
> >>
> >> +static int blkio_check_dev_num(dev_t dev)
> >> +{
> >> +     int part = 0;
> >> +     struct gendisk *disk;
> >> +
> >> +     disk = get_gendisk(dev, &part);
> >> +     if (!disk || part)
> >> +             return -ENODEV;
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static int blkio_policy_parse_and_set(char *buf,
> >> +                                   struct blkio_policy_node *newpn)
> >> +{
> >> +     char *s[4], *p, *major_s = NULL, *minor_s = NULL;
> >> +     int ret;
> >> +     unsigned long major, minor, temp;
> >> +     int i = 0;
> >> +     dev_t dev;
> >> +
> >> +     memset(s, 0, sizeof(s));
> >> +
> >> +     while ((p = strsep(&buf, " ")) != NULL) {
> >> +             if (!*p)
> >> +                     continue;
> >> +
> >> +             s[i++] = p;
> >> +
> >> +             /* Prevent from inputing too many things */
> >> +             if (i == 3)
> >> +                     break;
> >> +     }
> >> +
> >> +     if (i != 2)
> >> +             return -EINVAL;
> >> +
> >> +     p = strsep(&s[0], ":");
> >> +     if (p != NULL)
> >> +             major_s = p;
> >> +     else
> >> +             return -EINVAL;
> >> +
> >> +     minor_s = s[0];
> >> +     if (!minor_s)
> >> +             return -EINVAL;
> >> +
> >> +     ret = strict_strtoul(major_s, 10, &major);
> >> +     if (ret)
> >> +             return -EINVAL;
> >> +
> >> +     ret = strict_strtoul(minor_s, 10, &minor);
> >> +     if (ret)
> >> +             return -EINVAL;
> >> +
> >> +     dev = MKDEV(major, minor);
> 
> I am not quite sure if exposing a mojor,minor number is the best
> interface that can be exposed to user space. How about actual disk
> names like sda, sdb, .. etc? The only problem I see there is that it
> seems tricky to get to these disk names from within the block layer.
> "struct request_queue" has a pointer to backing_dev which has a device
> from which we can get major,minor. But in order to get to disk name,
> we would have to call get_gendisk which can hold a semaphore. Is this
> the reason for us going with major,minor as a user interface to
> specify a disk? I bet there are good reasons for us not keeping a
> pointer to "struct gendisk" from "struct request_queue". If we could
> keep that pointer, our user interface could be very easily modified to
> be the disk name like sda, sdb, etc.

That's a good question. Why not use device names instead of device
numbers? From user's perspective, device names will be more intutive
to use.

At the same time, will it look odd to handle devices with their names as WWID.

/dev/mapper/3600508b400105df70000e000026f0000

Though I see that there is an alternate way to address the same device
like /dev/dm-2 etc.

So from user's perspective I think it will be more intutive to handle
disk names instead of numbers.

Gui, did you forsee issues in implementing disk names?

Thanks
Vivek
