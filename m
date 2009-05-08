Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbZEHVJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbZEHVJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZEHVJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:09:40 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:14695 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbZEHVJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BMYO7u0SYtobU03Xl1P8OruouKHV8x4zsE2BVFIyTpoJeO7V1H8txKB7i2VOKTATQa
         17WTYSHNwhwY2yhJkNbW7KmMJ2ITT5FLRNkdEGNEbHf7PpL9RnEpdAHa4slroyKabWFl
         l7x+XjfvZtfV4evOdyl901p3Bet5wzWVr0XLY=
Date: Fri, 8 May 2009 23:09:37 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 05/18] io-controller: Common hierarchical fair queuing
	code in elevaotor layer
Message-ID: <20090508210936.GA5763@linux>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-6-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241553525-28095-6-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 03:58:32PM -0400, Vivek Goyal wrote:
> +#define STORE_FUNCTION(__VAR, __MIN, __MAX)				\
> +static int io_cgroup_##__VAR##_write(struct cgroup *cgroup,		\
> +					struct cftype *cftype,		\
> +					u64 val)			\
> +{									\
> +	struct io_cgroup *iocg;					\
> +	struct io_group *iog;						\
> +	struct hlist_node *n;						\
> +									\
> +	if (val < (__MIN) || val > (__MAX))				\
> +		return -EINVAL;						\
> +									\
> +	if (!cgroup_lock_live_group(cgroup))				\
> +		return -ENODEV;						\
> +									\
> +	iocg = cgroup_to_io_cgroup(cgroup);				\
> +									\
> +	spin_lock_irq(&iocg->lock);					\
> +	iocg->__VAR = (unsigned long)val;				\
> +	hlist_for_each_entry(iog, n, &iocg->group_data, group_node) {	\
> +		iog->entity.new_##__VAR = (unsigned long)val;		\
> +		smp_wmb();						\
> +		iog->entity.ioprio_changed = 1;				\
> +	}								\
> +	spin_unlock_irq(&iocg->lock);					\
> +									\
> +	cgroup_unlock();						\
> +									\
> +	return 0;							\
> +}
> +
> +STORE_FUNCTION(weight, 0, WEIGHT_MAX);

A small fix: io.weight should be strictly greater than 0 if we don't
want to automatically trigger the BUG_ON(entity->weight == 0) in
bfq_calc_finish().

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 block/elevator-fq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 9500619..de25f44 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1136,7 +1136,7 @@ static int io_cgroup_##__VAR##_write(struct cgroup *cgroup,		\
 	return 0;							\
 }
 
-STORE_FUNCTION(weight, 0, WEIGHT_MAX);
+STORE_FUNCTION(weight, 1, WEIGHT_MAX);
 STORE_FUNCTION(ioprio_class, IOPRIO_CLASS_RT, IOPRIO_CLASS_IDLE);
 #undef STORE_FUNCTION
 
