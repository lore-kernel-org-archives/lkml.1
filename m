Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZJPHpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZJPHpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbZJPHpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:45:54 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59660 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZJPHpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HXTH3tpdwT9PewEXXAX3M2WkCpB5758ikKRMn87Rt1VFF/3cRvOjIXCBxoC69xv7jw
         qAT/L8mdzMUlMLZHd73IPmJDCP/wIySCXgx7TiJDIoXDL3Dm05fGEylCwGFuIo870zmm
         tpGTGqEEs4RAe7VlKvsf4wki2l0nTaiSi4gM8=
MIME-Version: 1.0
In-Reply-To: <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
Date: Fri, 16 Oct 2009 09:45:17 +0200
Message-ID: <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
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

2009/10/15 Catalin Marinas <catalin.marinas@arm.com>:
> On Thu, 2009-10-15 at 17:46 +0800, Li Zefan wrote:
>> Zdenek Kabelac wrote:
>> > I've noticed your latest patch for memory leak in filter setting
>> > (8ad807318fcd...) - but even with this patch - kmemleak seems to still
>> > report  lots  (~900) of following leaks - note - they come only from
>> > i915 and kvm module - so I'm not sure if these two modules are doing
>> > something wrong or the problem is in trace code.
>> >
>> > It looks like whole directory is somehow forgotten.
>> >
>>
>> Fortunately those are false-positives:
>>
>>  # modprobe i915
>>  # echo scan > /debug/kmemleak
>>  # cat /debug/kmemleak
>>  (lots of "leaks")
>>  # rmmod i915
>>  # echo scan > /debug/kmemleak
>>  # cat /debug/kmemleak
>>  (no leaks)
>>
>> All the memory allocated when loading the module is
>> freed in trace_module_remove_events() at module unload.
>>
>> But I haven't looked into how to suppress those false-postives.
>> I'd like to, but I'm going to leave my office and won't be
>> back until 26th..
>
> It is probably caused by the fact that kmemleak doesn't scan the
> mod->trace_events data in a module (the _ftrace_events section). It only
> scans those sections beginning with .data and .bss in a module. Maybe we
> should add "_ftrace_events" as well or just prefix it with ".data".
>
> Something like below may fix this (untested):
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 8b7d880..1449691 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2383,6 +2383,9 @@ static noinline struct module *load_module(void __user *umod,
>                                         "_ftrace_events",
>                                         sizeof(*mod->trace_events),
>                                         &mod->num_trace_events);
> +       kmemleak_scan_area(mod->module_core, mod->trace_events,
> +                          sizeof(*mod->trace_events) * mod->num_trace_events,
> +                          GFP_KERNEL);
>  #endif
>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
>        /* sechdrs[0].sh_size is always zero */
>
>

Yep - I've assume it could be also a problem of missing memory segment
in kmemleak scanning routine - but it was weird that just these two
modules (i915 & kvm) are doing such strange thing.

I've tested patch above with added cast  ( (unsigned
long)mod->trace_events) to pacify warning - but it did not helped -
leaks are still printed.

And I add another leak - which might be from the same range of problem :
(it's also present many times - and it even looks like hex dump is
changing so it's probably even frequently used memory region - at
least in few such objects)

unreferenced object 0xffff88013aa4ad80 (size 192):
  comm "swapper", pid 1, jiffies 4294877809
  hex dump (first 32 bytes):
    c0 dc a4 3a 01 88 ff ff 00 0c 79 39 01 88 ff ff  ...:......y9....
    90 00 cf 3a 01 88 ff ff 02 00 00 00 00 00 00 00  ...:............
  backtrace:
    [<ffffffff8140e9a6>] kmemleak_alloc+0x26/0x60
    [<ffffffff81126a01>] kmem_cache_alloc_notrace+0xc1/0x140
    [<ffffffff8127256a>] dma_debug_init+0x23a/0x3a0
    [<ffffffff81864a37>] pci_iommu_init+0xe/0x28
    [<ffffffff8100904c>] do_one_initcall+0x3c/0x1d0
    [<ffffffff8185f4e6>] kernel_init+0x150/0x1a6
    [<ffffffff8100d21a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff


Zdenek
