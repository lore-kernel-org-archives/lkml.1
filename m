Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZDNIHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZDNIHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZDNIGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:06:54 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:29870 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZDNIGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RL1B7krBgg5OVH4Ubjvgwu/8B56lPIU6LYMTChltbWO/tAS/16/1hpL+FpeihmSt7N
         kl1BaWYj6c3NTmnKrKcV/I5vj2OHz4lSHL6s7PVUlsFwf5RdzOiiyXLvvB2EQLkkyRPP
         1en4tjZuD3kQKhbcU+ffQzabWY/ADZUTHfpeg=
Message-ID: <49E44415.1040500@tuffmail.co.uk>
Date: Tue, 14 Apr 2009 09:06:45 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <200904131315.55519.bjorn.helgaas@hp.com> <49E3990C.6040303@tuffmail.co.uk> <200904131628.35407.bjorn.helgaas@hp.com>
In-Reply-To: <200904131628.35407.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Monday 13 April 2009 01:57:00 pm Alan Jenkins wrote:
>   
>> Bjorn Helgaas wrote:
>>     
>>> On Sunday 12 April 2009 07:11:57 am Alan Jenkins wrote:
>>>   
>>> You mention that this occurs when booting off battery.  So I
>>> assume everything works fine when the EEE is plugged in to the
>>> wall socket?
>>>       
>> When I tested it before, that was what I found.
>>
>> However, I now find that's not quite right.  It only works (i.e. doesn't
>> hang) if I remove the battery as well as plugging it into the wall.  If
>> I have the battery in, it hangs.
>>     

... and right now, I can only reproduce it by booting with it plugged
into the wall and the battery present.  If I unplug it from the wall, it
boots fine.

It must be affected by something else as well, maybe battery level or
charging / discharging status.

>>>>>>> Magic SysRQ keys work though.  ...
>>>>>>>           
>>>>>>>               
>>>>> I was able to run SysRq-P, and found the following backtrace -
>>>>>
>>>>> Pid: 0
>>>>> EIP is at acpi_idle_enter_bm+0x1df/0x208 [processor]
>>>>>           
>>> Can you figure out where this is in acpi_idle_enter_bm() or
>>> maybe just email me your processor.ko module?
>>>
>>> Does it always happen at the same point?
>>>       
>> Yes, it always happens at the same point.
>>
>> It turns out I can read the runes, but I don't understand what they're
>> saying :-).
>>     
>
> I'm not much good with x86 assembly either :-)
>
> I think that in both cases below, you're right after enabling
> interrupts and about to exit the idle routine.  My guess is the
> system is not really hung; it just doesn't think it has anything
> to do and is spending all its time in the idle loop.
>
>   
>> 00001bd0 <acpi_idle_enter_bm>:
>>
>> ...
>> 00001bd0 + 0x1df = 00001daf
>> ...
>>     1d70:       b8 03 00 00 00          mov    $0x3,%eax
>>     1d75:       e8 90 f3 ff ff          call   110a <tsc_halts_in_c>
>>     1d7a:       85 c0                   test   %eax,%eax
>>     1d7c:       74 0a                   je     1d88 <acpi_idle_enter_bm+0x1b8>
>>     1d7e:       b8 0e 09 00 00          mov    $0x90e,%eax
>>                         1d7f: R_386_32  .rodata.str1.1
>>     1d83:       e8 fc ff ff ff          call   1d84 <acpi_idle_enter_bm+0x1b4>
>>                         1d84: R_386_PC32        mark_tsc_unstable
>>     1d88:       8b 45 e8                mov    -0x18(%ebp),%eax
>>     1d8b:       8b 55 ec                mov    -0x14(%ebp),%edx
>>     1d8e:       e8 ab fd ff ff          call   1b3e <us_to_pm_timer_ticks>
>>     1d93:       89 c3                   mov    %eax,%ebx
>>     1d95:       b8 17 01 00 00          mov    $0x117,%eax
>>     1d9a:       69 ca 17 01 00 00       imul   $0x117,%edx,%ecx
>>     1da0:       89 d6                   mov    %edx,%esi
>>     1da2:       f7 e3                   mul    %ebx
>>     1da4:       8d 14 11                lea    (%ecx,%edx,1),%edx
>>     1da7:       e8 fc ff ff ff          call   1da8 <acpi_idle_enter_bm+0x1d8>
>>                         1da8: R_386_PC32        sched_clock_idle_wakeup_event
>>     1dac:       fb                      sti
>>     1dad:       89 e0                   mov    %esp,%eax
>> ->  1daf:       31 c9                   xor    %ecx,%ecx              <---------
>>     1db1:       25 00 e0 ff ff          and    $0xffffe000,%eax
>>     1db6:       89 fa                   mov    %edi,%edx
>>     1db8:       83 48 0c 04             orl    $0x4,0xc(%eax)
>>     1dbc:       ff 47 18                incl   0x18(%edi)
>>     1dbf:       8b 45 e4                mov    -0x1c(%ebp),%eax
>>     1dc2:       e8 a4 f5 ff ff          call   136b <acpi_state_timer_broadcast>
>>     1dc7:       01 5f 1c                add    %ebx,0x1c(%edi)
>>     1dca:       11 77 20                adc    %esi,0x20(%edi)
>>     1dcd:       8b 45 e8                mov    -0x18(%ebp),%eax
>>     1dd0:       83 c4 10                add    $0x10,%esp
>>     1dd3:       5b                      pop    %ebx
>>     1dd4:       5e                      pop    %esi
>>     1dd5:       5f                      pop    %edi
>>     1dd6:       5d                      pop    %ebp
>>     1dd7:       c3                      ret
>>
>>     
>>> If you blacklist or rename the processor module to prevent it
>>> from loading, does that keep the hang from occurring?
>>>       
>> No.  In that case I get the hang in default_idle+0x59/0x95
>>
>> 0000007a <default_idle>:
>>   7a:   55                      push   %ebp
>>   7b:   89 e5                   mov    %esp,%ebp
>>   7d:   56                      push   %esi
>>   7e:   53                      push   %ebx
>>   7f:   83 ec 18                sub    $0x18,%esp
>>   82:   83 3d 18 00 00 00 00    cmpl   $0x0,0x18
>>                         84: R_386_32    .bss
>>   89:   75 7a                   jne    105 <default_idle+0x8b>
>>   8b:   80 3d 05 00 00 00 00    cmpb   $0x0,0x5
>>                         8d: R_386_32    boot_cpu_data
>>   92:   74 71                   je     105 <default_idle+0x8b>
>>   94:   83 3d 04 00 00 00 00    cmpl   $0x0,0x4
>>                         96: R_386_32    __tracepoint_power_start
>>   9b:   74 23                   je     c0 <default_idle+0x46>
>>   9d:   8b 1d 08 00 00 00       mov    0x8,%ebx
>>                         9f: R_386_32    __tracepoint_power_start
>>   a3:   85 db                   test   %ebx,%ebx
>>   a5:   74 19                   je     c0 <default_idle+0x46>
>>   a7:   8d 75 e0                lea    -0x20(%ebp),%esi
>>   aa:   b9 01 00 00 00          mov    $0x1,%ecx
>>   af:   ba 01 00 00 00          mov    $0x1,%edx
>>   b4:   89 f0                   mov    %esi,%eax
>>   b6:   ff 13                   call   *(%ebx)
>>   b8:   83 c3 04                add    $0x4,%ebx
>>   bb:   83 3b 00                cmpl   $0x0,(%ebx)
>>   be:   75 ea                   jne    aa <default_idle+0x30>
>>   c0:   89 e0                   mov    %esp,%eax
>>   c2:   25 00 e0 ff ff          and    $0xffffe000,%eax
>>   c7:   83 60 0c fb             andl   $0xfffffffb,0xc(%eax)
>>   cb:   f6 40 08 08             testb  $0x8,0x8(%eax)
>>   cf:   75 04                   jne    d5 <default_idle+0x5b>
>>   d1:   fb                      sti
>>   d2:   f4                      hlt
>> -->  d3:   eb 01                   jmp    d6 <default_idle+0x5c>    <--------
>>   d5:   fb                      sti
>>   d6:   89 e0                   mov    %esp,%eax
>>   d8:   25 00 e0 ff ff          and    $0xffffe000,%eax
>>   dd:   83 48 0c 04             orl    $0x4,0xc(%eax)
>>   e1:   83 3d 04 00 00 00 00    cmpl   $0x0,0x4
>>                         e3: R_386_32    __tracepoint_power_end
>>   e8:   74 1e                   je     108 <default_idle+0x8e>
>>
>>
>>     
>>>> 7ec0a7290797f57b780f792d12f4bcc19c83aa4f is first bad commit
>>>> commit 7ec0a7290797f57b780f792d12f4bcc19c83aa4f
>>>> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
>>>> Date:   Mon Mar 30 17:48:24 2009 +0000
>>>>         
>>> Ouch, sorry about that.  Thanks for doing all the bisection work.
>>>   
>>>       
>>>>     ACPI: processor: use .notify method instead of installing handler
>>>> directly
>>>>
>>>>     This patch adds a .notify() method.  The presence of .notify() causes
>>>>     Linux/ACPI to manage event handlers and notify handlers on our behalf,
>>>>     so we don't have to install and remove them ourselves.
>>>>
>>>>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>>>>     CC: Zhang Rui <rui.zhang@intel.com>
>>>>     CC: Zhao Yakui <yakui.zhao@intel.com>
>>>>     CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>>>>     CC: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>>>>     Signed-off-by: Len Brown <len.brown@intel.com>
>>>>
>>>> However, reverting this commit from v2.6.30-rc1 doesn't solve the hang.
>>>>         
>>> I don't see the problem in that commit yet, and if there is a problem
>>> with it, I would think that reverting it from 2.6.30-rc1 would solve
>>> it.  But maybe it'd be useful to revert the whole .notify series to
>>> make sure.  From 2.6.30-rc1, you should be able to revert these:
>>>
>>>   7ec0a7290797f57b780f792d12f4bcc19c83aa4f processor
>>>   373cfc360ec773be2f7615e59a19f3313255db7c button
>>>   46ec8598fde74ba59703575c22a6fb0b6b151bb6 Linux/ACPI infrastructure
>>>
>>> What happens with those commits reverted?
>>>       
>> I'll find out tomorrow.
>>     
>
> The fact that it still hangs even when you don't load the processor
> driver at all suggests that the 7ec0a729079 commit identified by the
> bisection is not the real problem.  That commit only touches
> drivers/acpi/processor_core.c.
>   

Yah.

> I think it's more likely some kind of race or missed wakeup.
>
> Since it seems to be sensitive to whether the battery is present,
> I guess you could try blacklisting the battery.ko driver.  There
> have been a few changes to it since 2.6.29-rc8.  If things work
> without battery.ko, we can look through those changes.
>   

Good guess :-).  I tried a couple of times either way, and blacklisting
"battery" definitely avoids the hang.

Thanks
Alan
