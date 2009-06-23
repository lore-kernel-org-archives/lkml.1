Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbZFWOls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbZFWOls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbZFWOlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:41:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597AbZFWOlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:41:21 -0400
Date: Tue, 23 Jun 2009 10:38:56 -0400
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
Subject: Re: [PATCH 07/20] io-controller: Export disk time used and nr
	sectors dipatched through cgroups
Message-ID: <20090623143856.GB4262@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-8-git-send-email-vgoyal@redhat.com> <4A40C64E.8040305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40C64E.8040305@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 08:10:54PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
> > +				struct cftype *cftype, struct seq_file *m)
> > +{
> > +	struct io_cgroup *iocg;
> > +	struct io_group *iog;
> > +	struct hlist_node *n;
> > +
> > +	if (!cgroup_lock_live_group(cgroup))
> > +		return -ENODEV;
> > +
> > +	iocg = cgroup_to_io_cgroup(cgroup);
> > +
> > +	spin_lock_irq(&iocg->lock);
> 
> It's better to make use of rcu_read_lock instead since it's
> a read action.
> 

Thanks Gui. Queued for next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 2ad40eb..d779282 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1418,7 +1418,7 @@ static int io_cgroup_disk_time_read(struct cgroup *cgroup,
>  
>  	iocg = cgroup_to_io_cgroup(cgroup);
>  
> -	spin_lock_irq(&iocg->lock);
> +	rcu_read_lock();
>  	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
>  		/*
>  		 * There might be groups which are not functional and
> @@ -1430,7 +1430,7 @@ static int io_cgroup_disk_time_read(struct cgroup *cgroup,
>  					iog->entity.total_service);
>  		}
>  	}
> -	spin_unlock_irq(&iocg->lock);
> +	rcu_read_unlock();
>  	cgroup_unlock();
>  
>  	return 0;
> @@ -1448,7 +1448,7 @@ static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
>  
>  	iocg = cgroup_to_io_cgroup(cgroup);
>  
> -	spin_lock_irq(&iocg->lock);
> +	rcu_read_lock();
>  	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
>  		/*
>  		 * There might be groups which are not functional and
> @@ -1460,7 +1460,7 @@ static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
>  					iog->entity.total_sector_service);
>  		}
>  	}
> -	spin_unlock_irq(&iocg->lock);
> +	rcu_read_unlock();
>  	cgroup_unlock();
>  
>  	return 0;
> @@ -1478,7 +1478,7 @@ static int io_cgroup_disk_queue_read(struct cgroup *cgroup,
>  		return -ENODEV;
>  
>  	iocg = cgroup_to_io_cgroup(cgroup);
> -	spin_lock_irq(&iocg->lock);
> +	rcu_read_lock();
>  	/* Loop through all the io groups and print statistics */
>  	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
>  		/*
> @@ -1491,7 +1491,7 @@ static int io_cgroup_disk_queue_read(struct cgroup *cgroup,
>  					iog->queue_duration);
>  		}
>  	}
> -	spin_unlock_irq(&iocg->lock);
> +	rcu_read_unlock();
>  	cgroup_unlock();
>  
>  	return 0;
> -- 
> 1.5.4.rc3
> 
> 
> 
> > +	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
> > +		/*
> > +		 * There might be groups which are not functional and
> > +		 * waiting to be reclaimed upon cgoup deletion.
> > +		 */
> > +		if (iog->key) {
> > +			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> > +					MINOR(iog->dev),
> > +					iog->entity.total_sector_service);
> > +		}
> > +	}
> > +	spin_unlock_irq(&iocg->lock);
> > +	cgroup_unlock();
> > +
> > +	return 0;
> > +}
> > +
> >
