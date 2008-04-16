Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbYDPLqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbYDPLqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 07:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbYDPLqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 07:46:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42917 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153AbYDPLqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 07:46:24 -0400
Date: Wed, 16 Apr 2008 13:46:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com
Subject: Re: [BUG/PATCH] x86 mmiotrace: dynamically disable non-boot CPUs
Message-ID: <20080416114609.GA20054@elte.hu>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi> <20080413230552.33ca587a@daedalus.pq.iki.fi> <20080414065713.GB16163@elte.hu> <20080414210242.2329997d@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414210242.2329997d@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

> > we should fix this restriction ASAP. Forcibly dropping to UP will 
> > cause mmiotrace to be much less useful for diagnostic purposes of 
> > Linux
> 
> Ok, how do you propose we solve this?
> 
> I have asked the question before, and then I had two ideas. Well, the
> first one was actually your idea (so I hear) to solve the same problem for
> kmemcheck.
> - per-cpu page tables
> - instead of single-stepping, emulate the faulting instruction and never
> disarm pages during tracing. (Use and modify code from KVM.)
> 
> I don't believe either of these is easy or fast to implement. Given 
> some months, I might be able to achieve emulation. Page tables are 
> still magic to me.

yeah - it looks complex. Not a showstopper for now :-)

but given that Xorg is usually just a single task, do we _really_ need 
this?

> > drivers. We want to enable the mmiotrace-ing of specific devices via 
> > some /sys flag. For example via:
> > 
> >    cat /sys/devices/pci0000\:00/0000\:00\:1f.2/mmiotrace
> > 
> > this should start mmiotracing of that specific device - or something 
> > like that. Hm?
> 
> Ooh, that sounds like a neat interface. I like it. I've been 
> half-thinking of different ways of specifying the set of devices to 
> trace, but none of them was particularly nice. This feature is for 
> post-2.6.26, right?

yeah, most likely.

> Ok, so first select mmiotrace tracer, at which point those sysfs files 
> appear, but mmiotrace is not activated yet. Then, when any of the 
> device specific files, or the global file in debugfs, is opened, 
> mmiotrace activates. And if the file is closed, mmiotrace deactivates.

sounds good to me!

> Should we support several "cats" at the same time?

if it's possible ...

> > i suspect the bug is that you bring the CPU down from an atomic 
> > (spinlocked or irq disabled) context.
> 
> Hmm, it should not be... I have to double-check, but all the other 
> code, too, from where enter_uniprocessor() is called, may sleep. The 
> first thing the caller does is to acquire a mutex, which I assume 
> would complain loudly if spinlocked or irq-disabled.
> 
> Ingo, thank you for fixing this patch, though I'd like to suggest to 
> leave it out for now, since there clearly are worse problems with it 
> than without it. And if we can solve the SMP issue, this is not 
> needed. For the time being we can just instruct users to disable all 
> but one CPU when try want to trace.

i think we still need to make this as 'transparent' to users as 
possible. Disabling CPUs can be tedious.

are lost events really a problem in practice, given Xorg's 
single-threadedness?

i'm leaving out this patch from the series for now.

	Ingo
