Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZGGADY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZGGADY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZGGADP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:03:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbZGGADO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:03:14 -0400
Message-ID: <4A5290C5.5040905@zytor.com>
Date: Mon, 06 Jul 2009 17:03:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "John A. Gregor" <john.gregor@qlogic.com>
CC: ralph.campbell@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com> <4A526CE6.30200@zytor.com> <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com> <4A527EE4.1080102@zytor.com> <4a528c40.zpEvWzPTM5aCPBai%john.gregor@qlogic.com>
In-Reply-To: <4a528c40.zpEvWzPTM5aCPBai%john.gregor@qlogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John A. Gregor wrote:
> 
>> It's probably also worth nothing that with this change, there probably
>> is little point in writing this in assembly at all.  This is especially
>> so since your implementation is buggy: by definition, __iowrite32_copy()
>> does the I/O operations 32 bits at a time, but you are using 64-bit
>> operations.
> 
> The point of the routine is to make sure that transfers are *at least*
> 32-bit aligned and *at least* multiples of 32-bits in length.  64-bit
> transfers meet those conditions.

No.  That may be what *you* want, but that's not what the function is
documented or specified to do.

/**
 * __iowrite32_copy - copy data to MMIO space, in 32-bit units
 * @to: destination, in MMIO space (must be 32-bit aligned)
 * @from: source (must be 32-bit aligned)
 * @count: number of 32-bit quantities to copy
 *
 * Copy data from kernel space to MMIO space, in units of 32 bits at a
 * time.  Order of access is not guaranteed, nor is a memory barrier
 * performed afterwards.
 */

That is the generic version and the documented ABI, which the x86
version must mimic.  This is not the function to use if you don't care
about access size, which you better not if you're accessing WC memory.

> Another, less clearly stated, condition (which is imposed by the adapter
> the code was written for(*)) is that we can't take multiple writes
> to the same memory location (i.e. the number of dwords written to the
> adapter's buffer must == the number of dwords in the transfer).  It is
> this condition that rep mov doesn't always respect.  It appears that
> (possibly due to the processor taking an interrupt) the rep mov can
> "back up" and redo part of the transfer.  We've gotten PCIe analyzer
> traces that confirm this behavior.
  [...]
> See above, 8-byte alignment and transfers (being a subset of 4-byte
> alignments) are fine.  Since we are writing into a WC space, we don't
> have control over how many dwords get stuck together in a transfer
> anyway.

If you're doing this to WC memory, I believe your driver (or hardware)
is broken.  WC does not guarantee this condition to the best of my
knowledge, although I haven't found anything that explicitly states that
WC memory has to be idempotent (it is documented, though, that it can
collapse stores to the same address, so it might have been considered a
resulting issue.)

Anyway, I'm fine simply removing the x86 assembly version of this
routine and simply using the generic routine.  The checkin should
reference the observed behavior (which I would also suggest escalating
via your Intel FAEs if you can; I can try to investigate internally as
well.)  If you want 64-bit transfers, you should use __iowrite64_copy();
if you want completely private behavior you should use your own routine
(and just write it in C) rather than changing the documented behavior of
an existing routine from one that might be useful for other drivers
(although currently aren't used as far as I can tell) to one which is
guaranteed not to be.

	-hpa


	-hpa
