Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZFALZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZFALZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZFALZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:25:21 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37532 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754610AbZFALZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:25:20 -0400
Date: Mon, 01 Jun 2009 20:25:21 +0900 (JST)
Message-Id: <20090601.202521.189722764.ryov@valinux.co.jp>
To: vgoyal@redhat.com
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
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090529133804.GA26962@redhat.com>
References: <20090528165710.GB4335@redhat.com>
	<20090529.121737.189708024.ryov@valinux.co.jp>
	<20090529133804.GA26962@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, May 29, 2009 at 12:17:37PM +0900, Ryo Tsuruta wrote:
> > Hi Vivek,
> > 
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Thu, May 28, 2009 at 06:27:40PM +0900, Ryo Tsuruta wrote:
> > > > Hi Vivek,
> > > > 
> > > > > +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
> > > > > +	if (elv_bio_sync(bio)) {
> > > > > +		/* sync io. Determine cgroup from submitting task context. */
> > > > > +		cgroup = task_cgroup(current, io_subsys_id);
> > > > > +		return cgroup;
> > > > > +	}
> > > > > +
> > > > > +	/* Async io. Determine cgroup from with cgroup id stored in page */
> > > > > +	bio_cgroup_id = get_blkio_cgroup_id(bio);
> > > > > +
> > > > > +	if (!bio_cgroup_id)
> > > > > +		return NULL;
> > > > > +
> > > > > +	cgroup = blkio_cgroup_lookup(bio_cgroup_id);
> > > > > +#else
> > > > > +	cgroup = task_cgroup(current, io_subsys_id);
> > > > > +#endif
> > > > > +	return cgroup;
> > > > > +}
> > > > 
> > > > There is a case where a kernel thread (such as device-mapper drivers)
> > > > submits a sync IO instead of a task which originates the IO. I think
> > > > you should always use get_blkio_cgroup_id() to determine cgroup.
> > > > 
> > > 
> > > Hi Ryo,
> > > 
> > > Ok. Can you give some examples of drivers which are submitting reads in
> > > different context al-together. You mentioned in the past that dm-crypt
> > > looks like the one. How does current CFQ takes care of that. So if a 
> > > BE prio 7 or an RT prio 0, task is submitting a READ, CFQ will not know it
> > > and it will put that READ in the queue of the READ submitting device
> > > mapper thread (may be BE prio 3 or 4)? 
> > 
> > In the case of READ, dm-raid1 submits read IOs in differenct context
> > under some conditions. dm-ioband also does it.
> > 
> > > Always determining the cgroup from bio, will make things slower at the 
> > > same time complicated from the CFQ point of view. Right now cfq creates
> > > and caches the queue pointer in the io context of the bio submitting task
> > > and assumes sync requests are coming from that task/io context. Currently
> > > there can only be one sync queue associated with one context. So if a single
> > > thread is submitting reads (may be a worker thread) on behalf of other
> > > processes, then we loose the io context information. In fact currently we
> > > don't even carry ioprio and io class information in bio.
> > > 
> > > So looks like we need to carry task io context information also in bio
> > > to be able to associate the bio to right queue at CFQ level. This makes
> > > it bit more complicated. For the time being I will keep it in my TODO
> > > list and handle it once other more severe problems have been taken care
> > > of.
> > 
> > There is a patchset which makes every bio points the iocontext of the
> > process which is originally generated an IO request.
> > 
> >   Date Tue, 22 Apr 2008 22:51:31 +0900 (JST)
> >   Subject [RFC][PATCH 1/10] I/O context inheritance
> >   From Hirokazu Takahashi <>
> >   http://lkml.org/lkml/2008/4/22/195
> 
> Ok, Thanks. This is good. So once above patches make to upstream, I will
> just forward port my patches to make use of this infrastructure.

If there are other people who also need this patchset, I'll consider
to port it to the latest kernel. I would like to hear opinions from
other people. I think it is useful for CFQ users.

Thanks,
Ryo Tsuruta
