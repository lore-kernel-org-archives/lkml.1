Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbYD3QTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbYD3QTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYD3QT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:19:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbYD3QT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:19:26 -0400
Message-ID: <4818962D.4040906@redhat.com>
Date: Wed, 30 Apr 2008 12:54:21 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>, linux-visws-devel@lists.sourceforge.net,
       pazke@donpac.ru
CC: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Problems with -git14
References: <20080430015655.5a42f63d@werewolf.home> <Pine.LNX.4.64.0804301516580.30549@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0804301516580.30549@blonde.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 30 Apr 2008, J.A. Magallón wrote:
>> I have a couple problems with latest git (-14):
>>
>> - It only recognises 2 processors out of 4 (dual Xeon HT)
>> - It oopses on the swapper process just on boot...
>>
>> Difference in dmesg is below. If full correct dmesg or config is
>> needed, please ask for them. The kernel was built copying old
>> 2.6.25 config to .config && make oldconfig. I filled the missing
>> gaps like PAT and others...
>>
>> -Brought up 4 CPUs
>> +native_cpu_up: bad cpu 2
>> +native_cpu_up: bad cpu 3
>> +Brought up 2 CPUs
> 
> Yes, I've been getting this for some days too: only 2 processors on
> dual Xeon HT in 32-bit mode; whereas x86_64 finds all 4 just fine.
> Ran lots of testing on 2.6.25-mm1 before I noticed it there.
> 
> I bisected for a while, but it got confusing (arrived at a bisect
> point which gave only 1 processor: smpboot code getting rearranged),
> so I was forced (quel horreur!) to investigate properly.  I've just
> now had success with the patch below, please give it a try:
> but it'll need an Ack from Glauber before it can go in.
> 
>> +WARNING: at include/linux/blkdev.h:427 blk_queue_init_tags+0x110/0x11f()
> 
> I presume this warning and backtrace is what you report as an oops:
> I think you'll find Linus included a fix for this one overnight, and
> it should have gone away in 2.6.25-git15 (but I didn't see it myself).
> 
> Hugh
> 
> [PATCH] x86_32: fix HT cpu booting
> 
> Since recent smpboot 32/64-bit merge, my dual Xeon with HT has been
> booting only 2 of its 4 cpus (when running an i386 kernel; but x86_64
> is okay).  J.A. Magallón reports the same.
> 
> native_cpu_up: bad cpu 2
> native_cpu_up: bad cpu 3
> 
> The mach-default cpu_present_to_apicid() was just returning cpu number
> (2, 3) instead of apicid (6, 7): looks like we now need the x86_64 code
> even for the i386 case.
> 
> Comparing with other versions of cpu_present_to_apicid(), it seems a
> good idea to include an NR_CPUS test too, since cpu_present() doesn't
> include that; but that wasn't a problem here, and may no problem at all.
> 
> One point worth noting - is it a worry?  Prior to that smpboot merge,
> my Xeon booted the two HT siblings on one physical first, then the
> two siblings on the other physical after - when i386, but alternated
> them when x86_64.  Since the merge, the x86_64 sequence is unchanged,
> but the i386 sequence is now like x86_64.  I prefer this consistency,
> and I prefer the new sequence: booting with maxcpus=2 then uses the
> independent physicals without HT sharing; but surprises in store?
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> --- 2.6.25-git/include/asm-x86/mach-default/mach_apic.h	2008-04-23 07:24:16.000000000 +0100
> +++ linux/include/asm-x86/mach-default/mach_apic.h	2008-04-30 14:55:14.000000000 +0100
> @@ -109,13 +109,8 @@ static inline int cpu_to_logical_apicid(
>  
>  static inline int cpu_present_to_apicid(int mps_cpu)
>  {
> -#ifdef CONFIG_X86_64
> -	if (cpu_present(mps_cpu))
> +	if (mps_cpu < NR_CPUS && cpu_present(mps_cpu))
>  		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
> -#else
> -	if (mps_cpu < get_physical_broadcast())
> -		return  mps_cpu;
> -#endif
>  	else
>  		return BAD_APICID;
>  }

Hugh, thanks for tracing this. The patch looks sane to me

However, since this problem was raised, I'm still concerned that visws 
may have the same problem, since it uses the same logic that i386 
mach_default used to. (and I did not touched, since x86_64 code went int 
o mach_default).

Could anyone with access to such hardware give it a try ?
