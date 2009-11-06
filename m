Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZKFA4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZKFA4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbZKFA4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:56:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15412 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbZKFA4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:56:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=whpPYsKa/vCo0oyWhkacCiGcWHkVTORRt/Jw/WRRcqgC2MQA7wdFD8xOG557u0aiP
	bsPJd0akWiMXGOzi86EPA==
MIME-Version: 1.0
In-Reply-To: <20091105144222.GD4001@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> 
	<1257291837-6246-12-git-send-email-vgoyal@redhat.com> <af41c7c40911041910s20e9ac8dpe56f32ecc9f5886a@mail.gmail.com> 
	<20091105144222.GD4001@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Thu, 5 Nov 2009 16:56:10 -0800
Message-ID: <af41c7c40911051656n55a14a82hffd3f31d98c12139@mail.gmail.com>
Subject: Re: [PATCH 11/20] blkio: Some CFQ debugging Aid
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 5, 2009 at 6:42 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 04, 2009 at 07:10:00PM -0800, Divyesh Shah wrote:
>> In the previous patchset when merged with the bio tracking patches we
>> had a very convenient
>>  biocg_id we could use for debugging. If the eventual plan is to merge
>> the biotrack patches, do you think it makes sense to introduce the
>> per-blkio cgroup id here when DEBUG_BLK_CGROUP=y and use that for all
>> traces? The cgroup path name seems ugly to me.
>>
>
> Hi Divyesh,
>
> We still have biocg_id. Just that new name is "blkcg_id". So in evrey
> blkio_group, we embed this id to know which cgroup this blkio_group
> belongs to.

Ok. So isn't the blkcg_id enough to identify a particular cgroup in
the blktrace output? Is the path really necessary (stored in
blkio_group or referenced repeatedly, either way)?

>
> We had cgroup path in previous patches also. The only advantage of path
> is that we don't have to call cgroup_path() again and again and we can
> call it once when blkio_group instanciates and then store the path in
> blio_group and use it.
>
> Thanks
> Vivek
>
>> -Divyesh
>>
>> On Tue, Nov 3, 2009 at 3:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > o Some CFQ debugging Aid.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  block/Kconfig         |    9 +++++++++
>> >  block/Kconfig.iosched |    9 +++++++++
>> >  block/blk-cgroup.c    |    4 ++++
>> >  block/blk-cgroup.h    |   13 +++++++++++++
>> >  block/cfq-iosched.c   |   33 +++++++++++++++++++++++++++++++++
>> >  5 files changed, 68 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/block/Kconfig b/block/Kconfig
>> > index 6ba1a8e..e20fbde 100644
>> > --- a/block/Kconfig
>> > +++ b/block/Kconfig
>> > @@ -90,6 +90,15 @@ config BLK_CGROUP
>> >        control disk bandwidth allocation (proportional time slice allocation)
>> >        to such task groups.
>> >
>> > +config DEBUG_BLK_CGROUP
>> > +       bool
>> > +       depends on BLK_CGROUP
>> > +       default n
>> > +       ---help---
>> > +       Enable some debugging help. Currently it stores the cgroup path
>> > +       in the blk group which can be used by cfq for tracing various
>> > +       group related activity.
>> > +
>> >  endif # BLOCK
>> >
>> >  config BLOCK_COMPAT
>> > diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
>> > index a521c69..9c5f0b5 100644
>> > --- a/block/Kconfig.iosched
>> > +++ b/block/Kconfig.iosched
>> > @@ -48,6 +48,15 @@ config CFQ_GROUP_IOSCHED
>> >        ---help---
>> >          Enable group IO scheduling in CFQ.
>> >
>> > +config DEBUG_CFQ_IOSCHED
>> > +       bool "Debug CFQ Scheduling"
>> > +       depends on CFQ_GROUP_IOSCHED
>> > +       select DEBUG_BLK_CGROUP
>> > +       default n
>> > +       ---help---
>> > +         Enable CFQ IO scheduling debugging in CFQ. Currently it makes
>> > +         blktrace output more verbose.
>> > +
>> >  choice
>> >        prompt "Default I/O scheduler"
>> >        default DEFAULT_CFQ
>> > diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> > index a62b8a3..4c68682 100644
>> > --- a/block/blk-cgroup.c
>> > +++ b/block/blk-cgroup.c
>> > @@ -39,6 +39,10 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>> >        blkg->blkcg_id = css_id(&blkcg->css);
>> >        hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
>> >        spin_unlock_irqrestore(&blkcg->lock, flags);
>> > +#ifdef CONFIG_DEBUG_BLK_CGROUP
>> > +       /* Need to take css reference ? */
>> > +       cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
>> > +#endif
>> >  }
>> >
>> >  static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
>> > diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
>> > index 2bf736b..cb72c35 100644
>> > --- a/block/blk-cgroup.h
>> > +++ b/block/blk-cgroup.h
>> > @@ -26,12 +26,25 @@ struct blkio_group {
>> >        void *key;
>> >        struct hlist_node blkcg_node;
>> >        unsigned short blkcg_id;
>> > +#ifdef CONFIG_DEBUG_BLK_CGROUP
>> > +       /* Store cgroup path */
>> > +       char path[128];
>> > +#endif
>> >  };
>> >
>> >  #define BLKIO_WEIGHT_MIN       100
>> >  #define BLKIO_WEIGHT_MAX       1000
>> >  #define BLKIO_WEIGHT_DEFAULT   500
>> >
>> > +#ifdef CONFIG_DEBUG_BLK_CGROUP
>> > +static inline char *blkg_path(struct blkio_group *blkg)
>> > +{
>> > +       return blkg->path;
>> > +}
>> > +#else
>> > +static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
>> > +#endif
>> > +
>> >  extern struct blkio_cgroup blkio_root_cgroup;
>> >  struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
>> >  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> > index b9a052b..2fde3c4 100644
>> > --- a/block/cfq-iosched.c
>> > +++ b/block/cfq-iosched.c
>> > @@ -258,8 +258,29 @@ CFQ_CFQQ_FNS(sync);
>> >  CFQ_CFQQ_FNS(coop);
>> >  #undef CFQ_CFQQ_FNS
>> >
>> > +#ifdef CONFIG_DEBUG_CFQ_IOSCHED
>> > +#define cfq_log_cfqq(cfqd, cfqq, fmt, args...) \
>> > +       blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
>> > +                       cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
>> > +                       blkg_path(&cfqq_to_cfqg((cfqq))->blkg), ##args);
>> > +
>> > +#define cfq_log_cfqe(cfqd, cfqe, fmt, args...)                 \
>> > +       if (cfqq_of(cfqe)) {                                            \
>> > +               struct cfq_queue *cfqq = cfqq_of(cfqe);                 \
>> > +               blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt,     \
>> > +                       (cfqq)->pid, cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
>> > +                       blkg_path(&cfqq_to_cfqg((cfqq))->blkg), ##args);\
>> > +       } else {                                                        \
>> > +               struct cfq_group *cfqg = cfqg_of(cfqe);                 \
>> > +               blk_add_trace_msg((cfqd)->queue, "%s " fmt,             \
>> > +                               blkg_path(&(cfqg)->blkg), ##args);      \
>> > +       }
>> > +#else
>> >  #define cfq_log_cfqq(cfqd, cfqq, fmt, args...) \
>> >        blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
>> > +#define cfq_log_cfqe(cfqd, cfqe, fmt, args...)
>> > +#endif
>> > +
>> >  #define cfq_log(cfqd, fmt, args...)    \
>> >        blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
>> >
>> > @@ -400,6 +421,8 @@ cfq_init_cfqe_parent(struct cfq_entity *cfqe, struct cfq_entity *p_cfqe)
>> >  #define for_each_entity(entity)        \
>> >        for (; entity && entity->parent; entity = entity->parent)
>> >
>> > +#define cfqe_is_cfqq(cfqe)     (!(cfqe)->my_sd)
>> > +
>> >  static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
>> >  {
>> >        if (blkg)
>> > @@ -588,6 +611,8 @@ void cfq_delink_blkio_group(void *key, struct blkio_group *blkg)
>> >  #define for_each_entity(entity)        \
>> >        for (; entity != NULL; entity = NULL)
>> >
>> > +#define cfqe_is_cfqq(cfqe)     1
>> > +
>> >  static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
>> >  static inline void cfq_get_cfqg_ref(struct cfq_group *cfqg) {}
>> >  static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
>> > @@ -885,6 +910,10 @@ static void dequeue_cfqq(struct cfq_queue *cfqq)
>> >                struct cfq_sched_data *sd = cfq_entity_sched_data(cfqe);
>> >
>> >                dequeue_cfqe(cfqe);
>> > +               if (!cfqe_is_cfqq(cfqe)) {
>> > +                       cfq_log_cfqe(cfqq->cfqd, cfqe, "del_from_rr group");
>> > +               }
>> > +
>> >                /* Do not dequeue parent if it has other entities under it */
>> >                if (sd->nr_active)
>> >                        break;
>> > @@ -970,6 +999,8 @@ static void requeue_cfqq(struct cfq_queue *cfqq, int add_front)
>> >
>> >  static void cfqe_served(struct cfq_entity *cfqe, unsigned long served)
>> >  {
>> > +       struct cfq_data *cfqd = cfqq_of(cfqe)->cfqd;
>> > +
>> >        for_each_entity(cfqe) {
>> >                /*
>> >                 * Can't update entity disk time while it is on sorted rb-tree
>> > @@ -979,6 +1010,8 @@ static void cfqe_served(struct cfq_entity *cfqe, unsigned long served)
>> >                cfqe->vdisktime += cfq_delta_fair(served, cfqe);
>> >                update_min_vdisktime(cfqe->st);
>> >                __enqueue_cfqe(cfqe->st, cfqe, 0);
>> > +               cfq_log_cfqe(cfqd, cfqe, "served: vt=%llx min_vt=%llx",
>> > +                               cfqe->vdisktime, cfqe->st->min_vdisktime);
>> >
>> >                /* If entity prio class has changed, take that into account */
>> >                if (unlikely(cfqe->ioprio_class_changed)) {
>> > --
>> > 1.6.2.5
>> >
>> >
>
