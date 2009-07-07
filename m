Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbZGGQGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbZGGQGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZGGQGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:06:18 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:38536 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753803AbZGGQGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:06:18 -0400
Date: Tue, 07 Jul 2009 09:06:17 -0700
From: john.gregor@qlogic.com (John A. Gregor)
To: hpa@zytor.com
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
Cc: ralph.campbell@qlogic.com, linux-kernel@vger.kernel.org
Message-ID: <4a537279./HlkzM7mavpN0Wx2%john.gregor@qlogic.com>
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com>
 <4A526CE6.30200@zytor.com>
 <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com>
 <4A527EE4.1080102@zytor.com>
 <4a528c40.zpEvWzPTM5aCPBai%john.gregor@qlogic.com>
 <4A5290C5.5040905@zytor.com>
In-Reply-To: <4A5290C5.5040905@zytor.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> wrote:
> WC does not guarantee this condition to the best of my
> knowledge, although I haven't found anything that explicitly states that
> WC memory has to be idempotent (it is documented, though, that it can
> collapse stores to the same address, so it might have been considered a
> resulting issue.)

Yes, dealing with WC IO memory is (and has been) a pain.  But it is
also the only way to get the kind of performance IB requires.  We aren't
the only hardware that does this.  Protestations that our ASIC is just
wrong really aren't helpful at this stage.  We're well aware of how much
we are at the mercy of the processors and chipsets and there is little
architectural guarantee for much of anything.  Welcome to HPC.

> Anyway, I'm fine simply removing the x86 assembly version of this
> routine and simply using the generic routine.

And, I'm fine with taking the asm back into our driver as long as people
then don't just turn around and give us grief for having an #ifdef for
X86_64 and inline asm.

> The checkin should
> reference the observed behavior (which I would also suggest escalating
> via your Intel FAEs if you can; I can try to investigate internally as
> well.)

I haven't felt at liberty to disclose what we have or haven't discussed
with Intel; I'm just sharing our direct findings - rep movs to WC MMIO
leads to multiple writes to the same address in some instances on some
processors (at least Nehalem).  So this is an issue for us (and anyone
doing similar io).  And since the C compiler is free to emit a rep movs
sequence, this needs to be done as asm.

Since the __iowrite_* routines are meant to do, well, I/O, they should be
as robust as possible against things that might break I/O for particular
hardware.  I suggest that the issue with rep movs is just such a case.

> If you want 64-bit transfers, you should use __iowrite64_copy();

What we need would probably be most accurately called
__iowrite_atleast32_copy().

> if you want completely private behavior you should use your own routine
> (and just write it in C) rather than changing the documented behavior of
> an existing routine from one that might be useful for other drivers
> (although currently aren't used as far as I can tell) to one which is
> guaranteed not to be.

Again, just as a bit of history, the routine exists explicitly because
of our driver.  See commits c27a0d75b33 and 0f07496144c.  We just goofed
up a bit by not being more clear about the requirements of the routines
we submitted.  In fact, in 2006 it probably wasn't even clear to us
what the precise requirements were going to turn out to be.

Anyway, we're very likely going to have to stick with asm for X86_64 no
matter how it gets implemented both for performance and as protection
against the compiler generating a rep movs sequence.

So, I see at least a couple possible courses of action:

1. Redefine __iowrite32_copy(), document it better, and take the
   new asm.
2. Delete the .S file, warn about the possibility of the compiler
   generating a rep movs sequence in the C code, and the ipath driver
   will have a private copy routine again.

Thoughts?

-John Gregor
