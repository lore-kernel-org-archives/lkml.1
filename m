Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbYHFROJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbYHFROJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYHFRNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:13:39 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:51786 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbYHFRNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:13:38 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: "Wahlig, Elsie" <elsie.wahlig@amd.com>
Subject: Re: Opteron Rev E has a bug ... a locked instruction doesn't act as a read-acquire barrier (confirmed)
Date: Wed, 6 Aug 2008 19:13:34 +0200
User-Agent: PLD Linux KMail/1.9.9
Cc: mikpe@it.uu.se, linux-kernel@vger.kernel.org
References: <CB2417C2B1152C41919D5B9DE58840FA72D828@sausexmb5.amd.com>
In-Reply-To: <CB2417C2B1152C41919D5B9DE58840FA72D828@sausexmb5.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808061913.34874.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, Wahlig, Elsie wrote:
> Your issue may be one that has been seen on 1st generation
> AMD Opteron processor's with cpuid family 0Fh, cpuid model's
> < 40h with the code sequence that performs a read-modify write
> operation after acquiring a semaphore.

Matches my hardware

cpu family      : 15
model           : 33

>
> The memory read ordering between a semaphore operation and a
> subsequent read-modify-write instruction (an instruction which
> uses the same memory location as both a source and destination)
> may allow the read-modify-write instruction to operate on the
> memory location ahead of the completion of the semaphore
> operation and an erratum may occur.

I wonder why there was no official errata about this?


> If you think your software is encountering this code sequence,
> a work-around should be implemented by adding an LFENCE
> instruction right after the semaphore, after a cpuid check.
> The workaround's applied to OpenSolaris at
> http://mail.opensolaris.org/pipermail/onnv-notify/2006-October/009080.ht
> ml
> and Google performance tools tool at
> http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/at
> omicops-internals-x86.cc
> are suitable examples.
> A list of the model numbers this issue may occur on is at
> http://products.amd.com/en-us/downloads/AMD_Opteron_First_Generation_Ref
> erence_101607.pdf.

Would be better to fix the bug on kernel level if this is possible. Just 
someone with the knowledge needs to do this. Anyone interested?

> Mikael Pettersson writes:
> ... snip ...
>
> > I investigated the Solaris track, but I've found no detailed
> > explanation of the alleged bug. I've asked the Sun engineer
> > who committed the fix for an explanation, but so far there's
> > been no reply.
> >
> > Anyway, here's what I've found out.
> >
> > It's Solaris bug # 6323525.
> >
> > They call it "Mutex primitives don't work as expected."
> >
> > if (number_of_cores() < 2) then don't have bug if (family ==
> > 0xf && Model < 0x40) then have bug if
> > (rdmsr(MSR_BU_CFG/*0xC0011023*/) & 2) then bug is masked
> > lock: // mutex_lock, spin_lock, etc
> > ...
> > lock; cmpxchg ..
> > jnz fail
> > ret; nop; nop; nop // patched to "lfence; ret" if bug The
> > workaround is to place a fencing instruction (lfence) between
> > the mutex operation and the subsequent read-modify-write instruction.
> > (This provides the necessary load memory barrier.)
> >
> > There's no change to the unlock code.
> >
> > Anyone know who to contact @ AMD about confirming or denying this?
> >
> > /Mikael



-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
