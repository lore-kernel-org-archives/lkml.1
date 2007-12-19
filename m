Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbXLSLTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbXLSLTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 06:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLSLTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 06:19:07 -0500
Received: from il.qumranet.com ([82.166.9.18]:54959 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbXLSLTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 06:19:05 -0500
Message-ID: <4768FE27.7020305@qumranet.com>
Date: Wed, 19 Dec 2007 13:19:03 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels prior
 to tsc sync cleanup
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu> <4768BB43.1000609@qumranet.com>
In-Reply-To: <4768BB43.1000609@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Ingo Molnar wrote:
>   
>>> While the change mentions that it fixes a time warp bug, it also says 
>>> it should be rare.  So clearly kvm smp tsc handing is buggy.  
>>> Ingo/Thomas, (or anybody else), do you have any insight as to what kvm 
>>> can be doing wrong to trigger this behavior?
>>>     
>>>       
>> hm. Those time warps were really small, due to the small imperfections 
>> in the "sync up all CPUs to the same moment and do a WRMSR to clear all 
>> their TSCs" mechanism. I.e. at most a few usec time warps. I really dont 
>> know how that should result in udevd hanging. Can you debug udevd in any 
>> way?
>>
>>   
>>     
>
> Adding debug didn't help.  I'll try some sysrq keys to see what the 
> guest thinks is happening.
>
>   

many udev children are exiting; udevd itself is sleeping:

> udevd         S D5DCDF24  2924   573    372   594     629   535 (NOTLB)
>        d5dcdf38 00000086 00000002 d5dcdf24 d5dcdf20 00000000 d5dcdefc 
> d6169f68
>        d7db7f68 d5dcdf68 00000001 d5dd7560 c13b8a90 749ae8d2 00000002 
> 000326a1
>        d5dd7684 c131c700 00000003 d74f8900 892d6946 00000402 ffffffff 
> 00000000
> Call Trace:
>  [<c060d2c9>] do_nanosleep+0x3b/0x66
>  [<c0439b20>] hrtimer_nanosleep+0x50/0x106
>  [<c04397ee>] hrtimer_wakeup+0x0/0x18
>  [<c0439c1f>] sys_nanosleep+0x49/0x59
>  [<c0404e4c>] syscall_call+0x7/0xb
>  [<c0600000>] xfrm_state_find+0x49f/0x51e

So likely sleeping is screwed up somehow (though only on smp).


>> so the only thing that KVM might be doing incorrectly here is the 
>> emulation of the WRMSR that clears the TSC of each vcpu?
>>   
>>     
>
> By inspection, it is correct.  Of course I may be missing something, so 
> I'll write a unit test for it.  It should also be much slower than the 
> native wrmsr.
>
>   

Testing shows wrmsr and rdtsc function normally.

I'll try pinning the vcpus to cpus and see if that helps.

-- 
error compiling committee.c: too many arguments to function

