Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbZE2NjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbZE2NjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbZE2Ni7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:38:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51889 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbZE2Ni7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:38:59 -0400
Date: Fri, 29 May 2009 09:38:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 15/20] io-controller: map async requests to appropriate
	cgroup
Message-ID: <20090529133804.GA26962@redhat.com>
References: <1243377729-2176-16-git-send-email-vgoyal@redhat.com> <20090528.182740.193697101.ryov@valinux.co.jp> <20090528165710.GB4335@redhat.com> <20090529.121737.189708024.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529.121737.189708024.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 12:17:37PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, May 28, 2009 at 06:27:40PM +0900, Ryo Tsuruta wrote:
> > > Hi Vivek,
> > > 
> > > > +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
> > > > +	if (elv_bio_sync(bio)) {
> > > > +		/* sync io. Determine cgroup from submitting task context. */
> > > > +		cgroup = task_cgroup(current, io_subsys_id);
> > > > +		return cgroup;
> > > > +	}
> > > > +
> > > > +	/* Async io. Determine cgroup from with cgroup id stored in page */
> > > > +	bio_cgroup_id = get_blkio_cgroup_id(bio);
> > > > +
> > > > +	if (!bio_cgroup_id)
> > > > +		return NULL;
> > > > +
> > > > +	cgroup = blkio_cgroup_lookup(bio_cgroup_id);
> > > > +#else
> > > > +	cgroup = task_cgroup(current, io_subsys_id);
> > > > +#endif
> > > > +	return cgroup;
> > > > +}
> > > 
> > > There is a case where a kernel thread (such as device-mapper drivers)
> > > submits a sync IO instead of a task which originates the IO. I think
> > > you should always use get_blkio_cgroup_id() to determine cgroup.
> > > 
> > 
> > Hi Ryo,
> > 
> > Ok. Can you give some examples of drivers which are submitting reads in
> > different context al-together. You mentioned in the past that dm-crypt
> > looks like the one. How does current CFQ takes care of that. So if a 
> > BE prio 7 or an RT prio 0, task is submitting a READ, CFQ will not know it
> > and it will put that READ in the queue of the READ submitting device
> > mapper thread (may be BE prio 3 or 4)? 
> 
> In the case of READ, dm-raid1 submits read IOs in differenct context
> under some conditions. dm-ioband also does it.
> 
> > Always determining the cgroup from bio, will make things slower at the 
> > same time complicated from the CFQ point of view. Right now cfq creates
> > and caches the queue pointer in the io context of the bio submitting task
> > and assumes sync requests are coming from that task/io context. Currently
> > there can only be one sync queue associated with one context. So if a single
> > thread is submitting reads (may be a worker thread) on behalf of other
> > processes, then we loose the io context information. In fact currently we
> > don't even carry ioprio and io class information in bio.
> > 
> > So looks like we need to carry task io context information also in bio
> > to be able to associate the bio to right queue at CFQ level. This makes
> > it bit more complicated. For the time being I will keep it in my TODO
> > list and handle it once other more severe problems have been taken care
> > of.
> 
> There is a patchset which makes every bio points the iocontext of the
> process which is originally generated an IO request.
> 
>   Date Tue, 22 Apr 2008 22:51:31 +0900 (JST)
>   Subject [RFC][PATCH 1/10] I/O context inheritance
>   From Hirokazu Takahashi <>
>   http://lkml.org/lkml/2008/4/22/195

Ok, Thanks. This is good. So once above patches make to upstream, I will
just forward port my patches to make use of this infrastructure.

Thanks
Vivek
