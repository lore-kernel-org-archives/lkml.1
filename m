Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZKEOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZKEOnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbZKEOnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:43:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765AbZKEOnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:43:18 -0500
Date: Thu, 5 Nov 2009 09:42:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 09/20] blkio: Porpogate blkio cgroup weight or ioprio
	class updation to cfq groups
Message-ID: <20091105144245.GE4001@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-10-git-send-email-vgoyal@redhat.com> <4AF2641A.7030306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF2641A.7030306@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 01:35:22PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > o If a user decides the change the weight or ioprio class of a cgroup, this
> >   information needs to be passed on to io controlling policy module also so
> >   that new information can take effect.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/blk-cgroup.c  |   16 ++++++++++++++++
> >  block/cfq-iosched.c |   18 ++++++++++++++++++
> >  2 files changed, 34 insertions(+), 0 deletions(-)
> > 
> > diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> > index 7bde5c4..0d52a2c 100644
> > --- a/block/blk-cgroup.c
> > +++ b/block/blk-cgroup.c
> > @@ -13,6 +13,10 @@
> >  #include <linux/ioprio.h>
> >  #include "blk-cgroup.h"
> >  
> > +extern void cfq_update_blkio_group_weight(struct blkio_group *, unsigned int);
> > +extern void cfq_update_blkio_group_ioprio_class(struct blkio_group *,
> > +		unsigned short);
> > +
> >  struct blkio_cgroup blkio_root_cgroup = {
> >  	.weight = BLKIO_WEIGHT_DEFAULT,
> >  	.ioprio_class = IOPRIO_CLASS_BE,
> > @@ -75,12 +79,18 @@ static int
> >  blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
> >  {
> >  	struct blkio_cgroup *blkcg;
> > +	struct blkio_group *blkg;
> > +	struct hlist_node *n;
> >  
> >  	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
> >  		return -EINVAL;
> >  
> >  	blkcg = cgroup_to_blkio_cgroup(cgroup);
> > +	spin_lock_irq(&blkcg->lock);
> >  	blkcg->weight = (unsigned int)val;
> > +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
> > +		cfq_update_blkio_group_weight(blkg, blkcg->weight);
> > +	spin_unlock_irq(&blkcg->lock);
> >  	return 0;
> >  }
> >  
> > @@ -88,12 +98,18 @@ static int blkiocg_ioprio_class_write(struct cgroup *cgroup,
> >  					struct cftype *cftype, u64 val)
> >  {
> >  	struct blkio_cgroup *blkcg;
> > +	struct blkio_group *blkg;
> > +	struct hlist_node *n;
> >  
> >  	if (val < IOPRIO_CLASS_RT || val > IOPRIO_CLASS_IDLE)
> >  		return -EINVAL;
> >  
> >  	blkcg = cgroup_to_blkio_cgroup(cgroup);
> > +	spin_lock_irq(&blkcg->lock);
> >  	blkcg->ioprio_class = (unsigned int)val;
> > +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
> > +		cfq_update_blkio_group_weight(blkg, blkcg->weight);
> 
>   Here should be cfq_update_blkio_group_ioprio_class()
> 

Good catch Gui. Will fix it in next version.

Thanks
Vivek
