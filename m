Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbZEMOyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbZEMOyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZEMOx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:53:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41869 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZEMOx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:53:56 -0400
Date: Wed, 13 May 2009 10:51:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/18] io-controller: Export disk time used and nr
	sectors dipatched through cgroups
Message-ID: <20090513145127.GB7696@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-8-git-send-email-vgoyal@redhat.com> <4A0A32CB.4020609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A32CB.4020609@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 10:39:07AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  
> > +/*
> > + * traverse through all the io_groups associated with this cgroup and calculate
> > + * the aggr disk time received by all the groups on respective disks.
> > + */
> > +static u64 calculate_aggr_disk_time(struct io_cgroup *iocg)
> > +{
> > +	struct io_group *iog;
> > +	struct hlist_node *n;
> > +	u64 disk_time = 0;
> > +
> > +	rcu_read_lock();
> 
>   This function is in slow-path, so no need to call rcu_read_lock(), just need to ensure
>   that the caller already holds the iocg->lock.
> 

Or can we get rid of requirement of iocg_lock here and just read the io
group data under rcu read lock? Actually I am wondering why do we require
an iocg_lock here. We are not modifying the rcu protected list. We are
just traversing through it and reading the data.

Thanks
Vivek

> > +	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
> > +		/*
> > +		 * There might be groups which are not functional and
> > +		 * waiting to be reclaimed upon cgoup deletion.
> > +		 */
> > +		if (rcu_dereference(iog->key))
> > +			disk_time += iog->entity.total_service;
> > +	}
> > +	rcu_read_unlock();
> > +
> > +	return disk_time;
> > +}
> > +
> 
> -- 
> Regards
> Gui Jianfeng
