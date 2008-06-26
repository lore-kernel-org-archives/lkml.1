Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbYFZOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbYFZOBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYFZOBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:01:07 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:36244 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYFZOBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:01:06 -0400
To: Agner Fog <agner@agner.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
From: Andi Kleen <andi@firstfloor.org>
References: <48626514.2040905@agner.org>
Date: Thu, 26 Jun 2008 16:01:03 +0200
In-Reply-To: <48626514.2040905@agner.org> (Agner Fog's message of "Wed, 25 Jun 2008 17:32:36 +0200")
Message-ID: <87fxr0qork.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jun 2008 13:53:45.0231 (UTC) FILETIME=[0CF0F9F0:01C8D794]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Agner Fog <agner@agner.org> writes:

> Some details are not covered in the Intel documents. I have discussed
> this with an Intel engineer who has supplied all the details I asked
> for. I have listed the necessary ABI changes in detail in my manual on
> calling conventions (see below).

The discussion there pretty much only applies to other operating
systems, not Linux.

> One problem that has not been resolved yet, AFAIK, is how to handle
> the possible use of YMM registers in device drivers. Should these
> registers be saved before calling a device driver from an interrupt or
> should it be the responsibility of the device driver?

The Linux kernel always saves FP and related state only in the function
that uses it (in the "device driver" in your terminology), never on
kernel entry/exit (at least on x86, some other architectures like
IA64 use slightly different schemes because there even standard 
integer code sometimes uses the FPU for common operations) 

Also actually using it is very rare. In the mainline kernel it's only
the software RAID support functions.

So you could say it's solved.

> This is particularly problematic for the following reasons:
>
> 1. The YMM registers must be saved with the new instruction XSAVE and
> restored with XRESTOR if done in the device driver. Saving registers
> individually will be incompatible with future extensions of the
> register size to more than 256 bits.

The device driver should know what registers it uses so it can 
call the right functions. But Linux has standard functions to do this
anyways, and I believe in the current XSAVE patchkit they already
use XSAVE.

> 3. When compiling a device driver, the compiler may insert implicit
> calls to library functions such as memcpy and memset. These functions
> typically have a CPU dispatcher that chooses the largest register size

Not in the Linux kernel.  Or rather there is a CPU dispatcher,
but it only selects between two simple integer copying strategies
(string instructions and an unrolled loop). 

That works because most operations in the Linux kernel are only
on 4K pieces where SSE* operations tend to not make too much sense.

> A. The operating system saves the state with XSAVE before calling a
> device driver from an interrupt and restores with XRESTOR. The device
> driver can use any register. This method is safe but has a performance
> penalty.

Linux never did that and there's no need to do it.

> C. Make it the responsibility of the device driver to avoid the use of
> YMM registers unless it saves the state with XSAVE. This solution
> requires that available compilers have a switch to disable calls to
> library functions with internal CPU dispatchers. Appears unsafe to me.

Kernel modules are always compiled with FP/MMX/SSE/etc. disabled
on the compiler level. And we only support one compiler (gcc)

BTW there's also a D. you didn't mention: many OS (including Linux) use lazy 
FPU saving schemes and the exception handler doing that could be fixed for 
supporting kernel code too. Right now it doesn't on Linux because there's 
no need.

-Andi
