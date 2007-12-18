Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbXLRRVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbXLRRVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759979AbXLRRUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:20:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:46905 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471AbXLRRUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:20:52 -0500
Message-ID: <47680173.6060606@qumranet.com>
Date: Tue, 18 Dec 2007 19:20:51 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Guest kernel hangs in smp kvm for older kernels prior to tsc sync
 cleanup
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting RHEL 5 i386 in kvm with -no-kvm-irqchip -smp 4 will hang in 
udev.  I bisected this to a change in the _guest_ kernel:

> commit 95492e4646e5de8b43d9a7908d6177fb737b61f0
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Feb 16 01:27:34 2007 -0800
>
>     [PATCH] x86: rewrite SMP TSC sync code
>
>     make the TSC synchronization code more robust, and unify it 
> between x86_64 and
>     i386.
>
>     The biggest change is the removal of the 'fix up TSCs' code on 
> x86_64 and
>     i386, in some rare cases it was /causing/ time-warps on SMP systems.
>
>     The new code only checks for TSC asynchronity - and if it can prove a
>     time-warp (if it can observe the TSC going backwards when going 
> from one CPU
>     to another within a critical section), then the TSC clock-source 
> is turned
>     off.
>
>     The TSC synchronization-checking code also got moved into a 
> separate file.

So, guest kernels prior to this commit will hang in kvm smp; after this 
commit they will boot fine.

While the change mentions that it fixes a time warp bug, it also says it 
should be rare.  So clearly kvm smp tsc handing is buggy.  Ingo/Thomas, 
(or anybody else), do you have any insight as to what kvm can be doing 
wrong to trigger this behavior?


-- 
error compiling committee.c: too many arguments to function

