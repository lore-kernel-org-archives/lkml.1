Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZC0Lgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZC0Lgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZC0Lgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:36:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:19658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbZC0Lgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:36:37 -0400
Message-ID: <49CCBA3F.6040703@petalogix.com>
Date: Fri, 27 Mar 2009 12:36:31 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michal Simek <monstr@monstr.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       torvalds@linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>, microblaze-uclinux@itee.uq.edu.au,
       Andrew Morton <akpm@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
       Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [GIT PULL] Microblaze initial pack
References: <49CC8A41.4060503@monstr.eu> <20090327103032.GA12485@elte.hu>
In-Reply-To: <20090327103032.GA12485@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I have noticed one relatively big (but easily fixable) commit 
> structure problem in this tree.
>
> All of the commits have these tags:
>
>     Reviewed-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
>     Acked-by: John Linn <john.linn@xilinx.com>
>     Acked-by: John Williams<john.williams@petalogix.com>
>   
Not all of them but some of them.
> I think this is the result of an misunderstanding of how to use the 
> tags properly. Those should all be Signed-off-by tags (with the 
> permission, authorization and full knowledge of each person along 
> the signoff chain).
>
> Acked-by does not carry the same legal weight as Signed-off-by. See 
> Documentation/SubmittingPatches and in particular for details:
>
>      Developer's Certificate of Origin 1.1
>   
Thanks, I am reading it.
> I've also done a (quick) license scan and there's this one file i 
> found:
>
>   arch/microblaze/kernel/hw_exception_handler.S
>
>    * Copyright (C) 2004 Xilinx, Inc. All rights reserved.
>    *
>    * Xilinx, Inc.
>    * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
>    * COURTESY TO YOU.BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
>    * ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
>    * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
>    * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
>    * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
>
> That is an all rights reserved copyrighted file, and i'm not sure 
> the above constitutes a GPLv2 compatible license. It would be less 
> ambigious to add what you do in the other places instead, something 
> like:
>
>  * (C) Copyright 2004 Xilinx, Inc.
>  *
>  * This program is free software; you can redistribute it and/or modify it
>  * under the terms of the GNU General Public License version 2 as published
>  * by the Free Software Foundation.
>   
This is no my license. I'll ask a Xilinx guys for permission to change
it for this file.
John L, Stephen: Could I change the license as Ingo suggested?
> A quick look at the technical details suggest that arch/microblaze 
> certainly looks like a nicely done architecture.
>
> It is spartan but uses modern core kernel facilities for everything: 
> genirq, clockevents, generic-time, etc.
>   
I hope that I will be able to add MMU code in next release.
> Missing bits (you might want to look into this in the future) are 
> various (optional) bits of instrumentation:
>
>  - irqflags-tracking (needed for lockdep)
>
>  - stacktrace support (needed for lockdep)
>
>  - function tracer bits
>
>  - latencytop support (I suspect you could flip on 
>    HAVE_LATENCYTOP_SUPPORT right now as it needs no real arch code)
>
> Etc. All of these are optional and can be added later.
>   
Thanks for noticing. I'll add them to my list.
> There's a few obsolete comments with x86isms and old-Linux-isms in 
> them:
>
>         .long sys_ni_syscall            /* old sys_vm86old */
>         .long sys_ni_syscall            /* modify_ldt */
>         .long sys_ni_syscall            /* was fork */
>         .long sys_ni_syscall            /* old break syscall holder */
>         .long sys_ni_syscall            /* old stat */
>
> You could have compacted your syscall table eliminating these but i 
> guess you started from an existing experimental codebase and the ABI 
> stuck with you, right? It's not an issue.
>   
We do libc upgrade and we will do LTP tests on it. I believe we will
clean up all syscalls in near future.
But for now I am not able to clean it.
> And i guess along the way you want to remove this from your 
> libraries:
>
>         .long sys_ipc
>
> ... as this is a really ancient hack of a syscall. 64-bit x86 does 
> not have the syscall anymore. No big deal though.
>   
This will go away too.
> Anyway, all in one it is nice work!
>
>   Reviewed-by: Ingo Molnar <mingo@elte.hu>
>   
Thanks for your help,
Michal

> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

