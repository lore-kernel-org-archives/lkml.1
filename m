Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbZJPPIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbZJPPIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbZJPPIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:08:37 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:53173 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbZJPPIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qsoMpaAgL+/+Crx+q+sSMYoLppD+zbIDPHZXn8L9QiNdZaD7wqj9xVnk0qonI8xZ9d
         sYQlbCvh5BgretAlfU+Njn0kNH1K4Ruk0+XqL5e/rADkSvt3FSOf6lDCAJQa3cBxl+3z
         F+r99SL1BlYHIIaGyiFCo0HuzjobfJFbu+8vg=
MIME-Version: 1.0
In-Reply-To: <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
Date: Fri, 16 Oct 2009 17:07:59 +0200
Message-ID: <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
Subject: Re: Leaks in trace reported by kmemleak
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/16 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/10/16 Catalin Marinas <catalin.marinas@arm.com>:
>> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>>> Yes -same - though I forget to mention that log contained these two
>>> extra messages:
>>> (got lost in other debug stuff :( )...
>>>
>>> So it could be the parameters in your first patch were not correct ?
>>>
>>> [drm] Initialized drm 1.1.0 20060810
>>> kmemleak: Scan area larger than object 0xffffffffa033b000
>>
>> Ah, I forgot that kmemleak_scan_area takes an offset inside an object
>> rather than an absolute address. Something like below (I should
>> actually change this prototype of this function, it doesn't need to be
>> so complex):
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 8b7d880..8cc4406 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2383,6 +2383,10 @@ static noinline struct module *load_module(void __user *umod,
>>                                         "_ftrace_events",
>>                                         sizeof(*mod->trace_events),
>>                                         &mod->num_trace_events);
>> +       kmemleak_scan_area(mod->module_core, (unsigned long)mod->trace_events -
>> +                          (unsigned long)mod->module_core,
>> +                          sizeof(*mod->trace_events) * mod->num_trace_events,
>> +                          GFP_KERNEL);
>>  #endif
>>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
>>        /* sechdrs[0].sh_size is always zero */
>


So I've tested this modified version and it gives much better result
with respect to amount of leaked objects
It gets even to 0 - so even dma is not usually printed now - thus I
think the dma_debug_init is not a real issue.
As on some scan they are present and on some they are not there.

And also traces' strdup leaks are now gone for i915 and kvm.

But it's still not perfect - as my machine now has a lot of these
entries in the boot log:
(I'm using only this patch - and not the next one where you removed
call to kmemleak_load_module)

kmemleak: Scan area larger than object 0xffffffffa04f0000
Pid: 1752, comm: modprobe Not tainted 2.6.32-rc5-00002-gdab7e9a #27
Call Trace:
 [<ffffffff8140ee6f>] kmemleak_scan_area+0x15f/0x1a0
 [<ffffffff810a0089>] load_module+0xff9/0x1af0
 [<ffffffff8109ca70>] ? setup_modinfo_srcversion+0x0/0x30
 [<ffffffff810a0bfb>] sys_init_module+0x7b/0x260
 [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
kmemleak: Object 0xffffffffa04f0000 (size 8192):
kmemleak:   comm "modprobe", pid 1752, jiffies 4294886643
kmemleak:   min_count = 0
kmemleak:   count = -1
kmemleak:   flags = 0x9
kmemleak:   backtrace:
     [<ffffffff8140eaf6>] kmemleak_alloc+0x26/0x60
     [<ffffffff8111993a>] __vmalloc_area+0x4a/0x60
     [<ffffffff8102b6ee>] module_alloc+0x5e/0x60
     [<ffffffff8109c626>] module_alloc_update_bounds+0x16/0x50
     [<ffffffff8109f8d3>] load_module+0x843/0x1af0
     [<ffffffff810a0bfb>] sys_init_module+0x7b/0x260
     [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff

Zdenek
