Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZGFXoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZGFXoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZGFXn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:43:57 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:46853 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753187AbZGFXn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:43:57 -0400
Date: Mon, 06 Jul 2009 16:44:00 -0700
From: john.gregor@qlogic.com (John A. Gregor)
To: hpa@zytor.com
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
Cc: ralph.campbell@qlogic.com, linux-kernel@vger.kernel.org
Message-ID: <4a528c40.zpEvWzPTM5aCPBai%john.gregor@qlogic.com>
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com>
 <4A526CE6.30200@zytor.com>
 <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com>
 <4A527EE4.1080102@zytor.com>
In-Reply-To: <4A527EE4.1080102@zytor.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> wrote:
> Thanks.  That should go into the patch header with a reference to the
> erratum, rather than saying "some processors".  Additionally, there
> should be a comment in the code to that effect.  Otherwise when 5-10
> years from now we're trying to figure out what is going on, there is
> absolutely no hope, and we'll either re-trigger the bug or end up being
> stuck with cargo-cult programming.

I agree, there can be better info in the patch submission.  I'll take
a 2nd stab at writing it up.

> It's probably also worth nothing that with this change, there probably
> is little point in writing this in assembly at all.  This is especially
> so since your implementation is buggy: by definition, __iowrite32_copy()
> does the I/O operations 32 bits at a time, but you are using 64-bit
> operations.

The point of the routine is to make sure that transfers are *at least*
32-bit aligned and *at least* multiples of 32-bits in length.  64-bit
transfers meet those conditions.

Another, less clearly stated, condition (which is imposed by the adapter
the code was written for(*)) is that we can't take multiple writes
to the same memory location (i.e. the number of dwords written to the
adapter's buffer must == the number of dwords in the transfer).  It is
this condition that rep mov doesn't always respect.  It appears that
(possibly due to the processor taking an interrupt) the rep mov can
"back up" and redo part of the transfer.  We've gotten PCIe analyzer
traces that confirm this behavior.

(*) Now you might wonder why such an adapter-specific routine is living in
arch/x86/lib.  And I might agree.  But years ago, when we submitted ipath
for inclusion into the kernel, it was felt by some that the arch-specific
.S down in the driver was the wrong place and that it should be made
into a generally-available routine with an optimized x86_64 variant.
So here we are.

> Note the irony in that your patch actually takes the problem described
> in the erratum and implementing it in software -- with your change,
> *all* stores would be 8 bytes, which of course violates the definition
> entirely.

See above, 8-byte alignment and transfers (being a subset of 4-byte
alignments) are fine.  Since we are writing into a WC space, we don't
have control over how many dwords get stuck together in a transfer
anyway.

> Note how critical detailed information of the erratum was to being able
> to make an actual analysis of the patch, too.  Again, this is not just a
> case immediately, but possibly down the line.

> - your description of the problem was both incomplete and incorrect (it
>   might be correct if there is another erratum, but if so please
>   describe it, it is not Nehalem AAK6);

You are right, AAK6 was what got us to investigate the rep mov sequences
when we started having problems, but it is not an exact match for what
we encountered.  As far as I know, there is no errata published directly
detailing the conditions where we found the problem.  We do have PCIe
traces confirming that, when doing write-combining PIO writes using
rep mov, that some dword locations were being written to multiple times.
This appears to be associated with taking interrupts and not with crossing
any page boundaries.

-John Gregor
