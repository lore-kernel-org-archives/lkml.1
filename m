Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbXAXVPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbXAXVPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXAXVPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:15:21 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51568 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXAXVPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:15:20 -0500
X-AuditID: d80ac287-9ea9ebb0000026f2-1a-45b7ce4effd0 
Date: Wed, 24 Jan 2007 21:15:32 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: yunfeng zhang <zyf.zeroos@gmail.com>
cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20-rc5 1/1] MM: enhance Linux swap subsystem
In-Reply-To: <4df04b840701222108o6992933bied5fff8a525413@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701242015090.1770@blonde.wat.veritas.com>
References: <4df04b840701212309l2a283357jbdaa88794e5208a7@mail.gmail.com> 
 <200701222300.41960.a1426z@gawab.com>  <4df04b840701222021w5e1aaab2if2ba7fc38d06d64b@mail.gmail.com>
 <4df04b840701222108o6992933bied5fff8a525413@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Jan 2007 21:15:19.0198 (UTC) FILETIME=[C02F43E0:01C73FFC]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, yunfeng zhang wrote:
> re-code my patch, tab = 8. Sorry!

Please stop resending this patch until you can attend to the advice
you've been given: Pavel made several very useful remarks on Monday:

> No, this is not the way to submit major rewrite of swap subsystem.
> 
> You need to (at minimum, making fundamental changes _is_ hard):
> 
> 1) Fix your mailer not to wordwrap.
> 
> 2) Get some testing. Identify workloads it improves.
> 
> 3) Get some _external_ testing. You are retransmitting wordwrapped
> patch. That means noone other then you is actually using it.
> 
> I thought I told you to read the CodingStyle in some previous mail?

Another piece of advice would be to stop mailing it to linux-kernel,
and direct it to linux-mm instead, where specialists might be more
attentive.  But don't bother if you cannot follow Pavel's advice.

The only improvement I notice is that you are now sending a patch
against a recently developed kernel, 2.6.20-rc5, rather than the
2.6.16.29 you were offering earlier in the month: good, thank you.

I haven't done anything at all with Tuesday's recode tab=8 version,
I get too sick of "malformed patch" if ever I try to apply your mail
(it's probably related to the "format=flowed" in your mailer), and
don't usually have time to spend fixing them up.

But I did make the effort to reform it once before,
and again with Monday's version, the one that says:

> 4) It simplifies Linux memory model dramatically.

You have an interesting idea of "simplifies", given
 16 files changed, 997 insertions(+), 25 deletions(-)
(omitting your Documentation), and over 7k more code.
You'll have to be much more persuasive (with good performance
results) to get us to welcome your added layer of complexity.

Please make an effort to support at least i386 3level pagetables:
you don't actually need >4GB of memory to test CONFIG_HIGHMEM64G.
HIGHMEM testing shows you're missing a couple of pte_unmap()s,
in pps_swapoff_scan_ptes() and in shrink_pvma_scan_ptes().

It would be nice if you could support at least x86_64 too
(you have pte_low code peculiar to i386 in vmscan.c, which is
preventing that), but that's harder if you don't have the hardware.

But I have to admit, I've not been trying your patch because I
support it and want to see it in: the reverse, I've been trying
it because I want quickly to check whether it's something we
need to pay attention to and spend time on, hoping to rule
it out and turn to other matters instead.

And so far I've been (from that point of view) very pleased:
the first tests I ran went about 50% slower; but since they
involve tmpfs (and I suspect you've not considered the tmpfs
use of swap at all) that seemed a bit unfair, so I switched
to running the simplest memhog kind of tests (you know, in
a 512MB machine with plenty of swap, try to malloc and touch
600MB in rotation: I imagine should suit your design optimally):
quickly killed Out Of Memory.  Tried running multiple hogs for
smaller amounts (maybe one holds a lock you're needing to free
memory), but the same OOMs.  Ended up just doing builds on disk
with limited memory and 100% swappiness: consistently around
50% slower (elapsed time, also user time, also system time).

I've not reviewed the code at all, that would need a lot more
time.  But I get the strong impression that you're imposing on
Linux 2.6 ideas that seem obvious to you, without finding out
whether they really fit in and get good results.

I expect you'd be able to contribute much more if you spent a
while studying the behaviour of Linux swapping, and made incremental
tweaks to improve that (e.g. changing its swap allocation strategy),
rather than coming in with some preconceived plan.

Hugh
