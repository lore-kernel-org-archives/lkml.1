Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZFPIxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZFPIxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZFPIxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:53:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53290 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbZFPIxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:53:33 -0400
Message-ID: <4A375D6B.3000105@redhat.com>
Date: Tue, 16 Jun 2009 11:52:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu> <4A369573.1060504@zytor.com> <20090615184536.GH11248@elte.hu> <4A369914.4010903@zytor.com> <4A369ADF.2050305@redhat.com> <20090616083635.GE16229@elte.hu>
In-Reply-To: <20090616083635.GE16229@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 11:36 AM, Ingo Molnar wrote:
>
>>> I can try to find out internally what Intel's position on writing
>>> %cr2 is, but it'll take a while; however, KVM should be able to
>>> tell you if any random OS uses %cr2 writes (as should a static
>>> disassembly of their kernel.)
>>>        
>> Linux is one such OS.  When acting as a hypervisor it writes cr2
>> to present its guests with their expected environment (any
>> hypervisor that uses virtualization extensions will of course need
>> to do this).
>>      
>
> Ah, it does save/restore it in svm_vcpu_run. VMX can do this via its
> context structure (without explicit CR manipulations in host space),
> right?
>    

It's the other way around.  svm switches the guest cr2 in hardware 
(through svm->vmcb->save.cr2).  The code you're referring to saves and 
restores the host cr2, which is completely unnecessary.  I'm currently 
in the middle of dropping it :)

vmx has no hardware support for switching cr2, so vmx_vcpu_run() 
switches it using mov cr2.  Given that it's pretty expensive, I've 
switched it to write-if-changed, which dropped 70 cycles from the vmexit 
latency.

-- 
error compiling committee.c: too many arguments to function

