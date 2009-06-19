Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbZFSOJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbZFSOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZFSOJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:09:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41738 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZFSOJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:09:21 -0400
Date: Fri, 19 Jun 2009 10:08:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 18/19] io-controller: Debug hierarchical IO scheduling
Message-ID: <20090619140854.GC3726@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-19-git-send-email-vgoyal@redhat.com> <4A3B2F7E.10405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3B2F7E.10405@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 02:26:06PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +static inline void bfq_account_for_entity_addition(struct io_entity *entity)
> > +{
> > +	struct io_group *iog = io_entity_to_iog(entity);
> > +
> > +	if (iog) {
> > +		struct elv_fq_data *efqd;
> > +		char path[128];
> > +
> > +		/*
> > +		 * Keep track of how many times a group has been removed
> > +		 * from active tree because it did not have any active
> > +		 * backlogged ioq under it
> > +		 */
> > +		iog->queue++;
> > +		iog->queue_start = jiffies;
> > +
> > +		/* Log group addition event */
> > +		rcu_read_lock();
> > +		efqd = rcu_dereference(iog->key);
> > +		if (efqd) {
> > +			io_group_path(iog, path, sizeof(path));
> > +			elv_log(efqd, "add group=%s weight=%ld", path,
> > +					iog->entity.weight);
> 
> Since cgroup path is already cached, why not use it. :)
> 

Thanks Gui. Queued for next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index bfa79c9..1a397c3 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -183,7 +183,6 @@ static inline void bfq_account_for_entity_addition(struct io_entity *entity)
>  
>  	if (iog) {
>  		struct elv_fq_data *efqd;
> -		char path[128];
>  
>  		/*
>  		 * Keep track of how many times a group has been removed
> @@ -197,9 +196,8 @@ static inline void bfq_account_for_entity_addition(struct io_entity *entity)
>  		rcu_read_lock();
>  		efqd = rcu_dereference(iog->key);
>  		if (efqd) {
> -			io_group_path(iog, path, sizeof(path));
> -			elv_log(efqd, "add group=%s weight=%ld", path,
> -					iog->entity.weight);
> +			elv_log(efqd, "add group=%s weight=%ld", iog->path,
> +				iog->entity.weight);
>  		}
>  		rcu_read_unlock();
>  	}
> @@ -215,7 +213,6 @@ static inline void bfq_account_for_entity_deletion(struct io_entity *entity)
>  
>  	if (iog) {
>  		struct elv_fq_data *efqd;
> -		char path[128];
>  
>  		iog->dequeue++;
>  		/* Keep a track of how long group was on active tree */
> @@ -227,9 +224,8 @@ static inline void bfq_account_for_entity_deletion(struct io_entity *entity)
>  		rcu_read_lock();
>  		efqd = rcu_dereference(iog->key);
>  		if (efqd) {
> -			io_group_path(iog, path, sizeof(path));
> -			elv_log(efqd, "del group=%s weight=%ld", path,
> -					iog->entity.weight);
> +			elv_log(efqd, "del group=%s weight=%ld", iog->path,
> +				iog->entity.weight);
>  		}
>  		rcu_read_unlock();
>  	}
> -- 
> 1.5.4.rc3
> 
> 
