Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbXH2IQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbXH2IQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXH2IPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:15:49 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:39800 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754893AbXH2IPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:15:46 -0400
X-YMail-OSG: jzzHd.AVM1kO2TPhtsMpf7TPRquYVkdTmny3Cstof5.HCIEXc51899ZGt32zRx0k0MRaAsy2c5F9I2DPtSfj9MWXhA--
X-RocketYMMF: knobi.rm
Date: Wed, 29 Aug 2007 01:15:45 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour - next try
To: Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com
In-Reply-To: <388351538.28936@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <353439.71100.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Tue, Aug 28, 2007 at 08:53:07AM -0700, Martin Knoblauch wrote:
> [...]
> >  The basic setup is a dual x86_64 box with 8 GB of memory. The
> DL380
> > has a HW RAID5, made from 4x72GB disks and about 100 MB write
> cache.
> > The performance of the block device with O_DIRECT is about 90
> MB/sec.
> > 
> >  The problematic behaviour comes when we are moving large files
> through
> > the system. The file usage in this case is mostly "use once" or
> > streaming. As soon as the amount of file data is larger than 7.5
> GB, we
> > see occasional unresponsiveness of the system (e.g. no more ssh
> > connections into the box) of more than 1 or 2 minutes (!) duration
> > (kernels up to 2.6.19). Load goes up, mainly due to pdflush threads
> and
> > some other poor guys being in "D" state.
> [...]
> >  Just by chance I found out that doing all I/O inc sync-mode does
> > prevent the load from going up. Of course, I/O throughput is not
> > stellar (but not much worse than the non-O_DIRECT case). But the
> > responsiveness seem OK. Maybe a solution, as this can be controlled
> via
> > mount (would be great for O_DIRECT :-).
> > 
> >  In general 2.6.22 seems to bee better that 2.6.19, but this is
> highly
> > subjective :-( I am using the following setting in /proc. They seem
> to
> > provide the smoothest responsiveness:
> > 
> > vm.dirty_background_ratio = 1
> > vm.dirty_ratio = 1
> > vm.swappiness = 1
> > vm.vfs_cache_pressure = 1
> 
> You are apparently running into the sluggish kupdate-style writeback
> problem with large files: huge amount of dirty pages are getting
> accumulated and flushed to the disk all at once when dirty background
> ratio is reached. The current -mm tree has some fixes for it, and
> there are some more in my tree. Martin, I'll send you the patch if
> you'd like to try it out.
>
Hi Fengguang,

 Yeah, that pretty much describes the situation we end up. Although
"sluggish" is much to friendly if we hit the situation :-)

 Yes, I am very interested  to check out your patch. I saw your
postings on LKML already and was already curious. Any chance you have
something agains 2.6.22-stable? I have reasons not to move to -23 or
-mm.

> >  Another thing I saw during my tests is that when writing to NFS,
> the
> > "dirty" or "nr_dirty" numbers are always 0. Is this a conceptual
> thing,
> > or a bug?
> 
> What are the nr_unstable numbers?
>

 Ahh. Yes, they go up to 80-90k pages. Comparable to the nr_dirty
numbers for the disk case. Good to know.

 For NFS, the nr_writeback numbers seem surprisingly high. They also go
to 80-90k (pages ?). In the disk case they rarely go over 12k.

Cheers
Martin
> Fengguang
> 
> 


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
