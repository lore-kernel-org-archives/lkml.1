Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbXLRWUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbXLRWUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:20:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXLRWTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:19:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbXLRWTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:19:52 -0500
Date: Tue, 18 Dec 2007 23:19:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Guest kernel hangs in smp kvm for older kernels prior to tsc
	sync cleanup
Message-ID: <20071218221930.GA26109@elte.hu>
References: <47680173.6060606@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47680173.6060606@qumranet.com>
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


* Avi Kivity <avi@qumranet.com> wrote:

> Booting RHEL 5 i386 in kvm with -no-kvm-irqchip -smp 4 will hang in udev.  
> I bisected this to a change in the _guest_ kernel:
>
>> commit 95492e4646e5de8b43d9a7908d6177fb737b61f0
>> Author: Ingo Molnar <mingo@elte.hu>
>> Date:   Fri Feb 16 01:27:34 2007 -0800
>>
>>     [PATCH] x86: rewrite SMP TSC sync code
>>
>>     make the TSC synchronization code more robust, and unify it between 
>> x86_64 and
>>     i386.
>>
>>     The biggest change is the removal of the 'fix up TSCs' code on x86_64 
>> and
>>     i386, in some rare cases it was /causing/ time-warps on SMP systems.
>>
>>     The new code only checks for TSC asynchronity - and if it can prove a
>>     time-warp (if it can observe the TSC going backwards when going from 
>> one CPU
>>     to another within a critical section), then the TSC clock-source is 
>> turned
>>     off.
>>
>>     The TSC synchronization-checking code also got moved into a separate 
>> file.
>
> So, guest kernels prior to this commit will hang in kvm smp; after this 
> commit they will boot fine.
>
> While the change mentions that it fixes a time warp bug, it also says 
> it should be rare.  So clearly kvm smp tsc handing is buggy.  
> Ingo/Thomas, (or anybody else), do you have any insight as to what kvm 
> can be doing wrong to trigger this behavior?

hm. Those time warps were really small, due to the small imperfections 
in the "sync up all CPUs to the same moment and do a WRMSR to clear all 
their TSCs" mechanism. I.e. at most a few usec time warps. I really dont 
know how that should result in udevd hanging. Can you debug udevd in any 
way?

so the only thing that KVM might be doing incorrectly here is the 
emulation of the WRMSR that clears the TSC of each vcpu?

	Ingo
