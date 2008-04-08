Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbYDHGKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbYDHGKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYDHGKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:10:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbYDHGKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:10:42 -0400
Date: Mon, 7 Apr 2008 23:10:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerlof Langeveld <gerlof@ATComputing.nl>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 1/3] accounting: task counters for disk/network
Message-Id: <20080407231007.4946410d.akpm@linux-foundation.org>
In-Reply-To: <20080408054837.GA7103@atcmpg.ATComputing.nl>
References: <20080402073037.GA8419@atcmpg.ATComputing.nl>
	<20080403125416.ead5cd38.akpm@linux-foundation.org>
	<20080408054837.GA7103@atcmpg.ATComputing.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008 07:48:37 +0200 Gerlof Langeveld <gerlof@ATComputing.nl> wrote:

> > > --- linux-2.6.24.4-vanilla/block/ll_rw_blk.c	2008-03-24 19:49:18.000000000 +0100
> > > +++ linux-2.6.24.4-modified/block/ll_rw_blk.c	2008-03-25 13:52:14.000000000 +0100
> > > @@ -2739,6 +2739,19 @@ static void drive_stat_acct(struct reque
> > >  		disk_round_stats(rq->rq_disk);
> > >  		rq->rq_disk->in_flight++;
> > >  	}
> > > +
> > > +#ifdef CONFIG_TASK_IO_ACCOUNTING
> > > +	switch (rw) {
> > > +	case READ:
> > > +		current->group_leader->ioac.dsk_rio += new_io;
> > > +		current->group_leader->ioac.dsk_rsz += rq->nr_sectors;
> > > +		break;
> > > +	case WRITE:
> > > +		current->group_leader->ioac.dsk_wio += new_io;
> > > +		current->group_leader->ioac.dsk_wsz += rq->nr_sectors;
> > > +		break;
> > > +	}
> > > +#endif
> > 
> > For many workloads, this will cause almost all writeout to be accounted to
> > pdflush and perhaps kswapd.  This makes the per-task write accounting
> > largely unuseful.
> 
> There are several situations that writeouts are accounted to the user-process
> itself, e.g. when issueing direct writes (open mode O_DIRECT) or synchronous
> writes (open mode O_SYNC, syscall sync/fsync, synchronous file attribute,
> synchronous mounted filesystem).

yup.

> Apart from that, swapping out of process pages by kswapd is currently not
> accounted at all as shown by the following snapshot of 'atop' on a heavily
> swapping system:

Under heavy load, callers into alloc_pages() will themselves perform disk
writeout.  So under the proposed scheme, process A will be accounted for
writeout which was in fact caused by process B.

> So the extra counters can be considered as a useful addition to the I/O 
> counters that are currently maintained.

mmm, maybe.  But if we implement a partial solution like this we really
should have a plan to finish it off.

There have been numerous attempts at this, which tend to involve adding
backpointers to the pageframe structure and such.

This sort of accounting will presumably be needed by a disk bandwidth
cgroup controller.  Perhaps the containers/cgroup people have plans of code
already?

