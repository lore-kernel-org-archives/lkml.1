Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXDVABH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXDVABH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 20:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXDVABH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 20:01:07 -0400
Received: from mail24.syd.optusnet.com.au ([211.29.133.165]:41988 "EHLO
	mail24.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbXDVABF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 20:01:05 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sun, 22 Apr 2007 09:59:34 +1000
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu>
In-Reply-To: <20070421160008.GA28783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704220959.34978.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 02:00, Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > >   Feels even better, mouse movements are very smooth even under high
> > >   load. I noticed that X gets reniced to -19 with this scheduler.
> > >   I've not looked at the code yet but this looked suspicious to me.
> > >   I've reniced it to 0 and it did not change any behaviour. Still
> > >   very good.
> >
> > Looks like this code does it:
> >
> > +int sysctl_sched_privileged_nice_level __read_mostly = -19;
>
> correct. 

Oh I definitely was not advocating against renicing X, I just suspect that 
virtually all the users who gave glowing reports to CFS comparing it to SD 
had no idea it had reniced X to -19 behind their back and that they were 
comparing it to SD running X at nice 0. I think had they been comparing CFS 
with X nice -19 to SD running nice -10 in this interactivity soft and squishy 
comparison land their thoughts might have been different. I missed it in the 
announcement and had to go looking in the code since Willy just kinda tripped 
over it unwittingly as well.

> Note that Willy reniced X back to 0 so it had no relevance on 
> his test.

Oh yes I did notice that, but since the array swap is the remaining longest 
deadline in SD which would cause noticeable jerks, renicing X on SD by 
default would make the experience very different since reniced tasks do much 
better over array swaps compared to non niced tasks. I really should go and 
make the whole thing one circular list and blow away the array swap (if I can 
figure out how to do it). 

> Also note that i pointed this change out in the -v4 CFS 
>
> announcement:
> || Changes since -v3:
> ||
> ||  - usability fix: automatic renicing of kernel threads such as
> ||    keventd, OOM tasks and tasks doing privileged hardware access
> ||    (such as Xorg).

Reading the changelog in the gloss-over fashion that I unfortunately did, even 
I missed it. 

> i've attached it below in a standalone form, feel free to put it into
> SD! :)

Hmm well I have tried my very best to do all the changes without 
changing "policy" as much as possible since that trips over so many emotive 
issues that noone can agree on, and I don't have a strong opinion on this as 
I thought it would be better for it to be a config option for X in userspace 
instead. Either way it needs to be turned on/off by admin and doing it by 
default in the kernel is... not universally accepted as good. What else 
accesses ioports that can get privileged nice levels? Does this make it 
relatively exploitable just by poking an ioport?

> 	Ingo
>
> ---
>  arch/i386/kernel/ioport.c   |   13 ++++++++++---
>  arch/x86_64/kernel/ioport.c |    8 ++++++--
>  drivers/block/loop.c        |    5 ++++-
>  include/linux/sched.h       |    7 +++++++
>  kernel/sched.c              |   40

Thanks for the patch. I'll consider it. Since end users are testing this in 
fuzzy interactivity land I may simply be forced to do this just for 
comparisons to be meaningful between CFS and SD otherwise they're not really 
comparing them on a level playing field. I had almost given up SD for dead 
meat with all the momentum CFS had gained... until recently.

-- 
-ck
