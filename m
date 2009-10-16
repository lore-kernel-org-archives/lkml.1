Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbZJPNdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbZJPNdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbZJPNdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:33:37 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40196 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332AbZJPNdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qNq5riOPd61svpIFn5HwVrvjsLEUOV3o2m8JJ1aJosup5rbqUVZ7vFwc2GqN9w/Q0n
         lyNGuWABO5953JsO+T6lTnZ+VFuSVC7inz5S01X+R2G0yKcXB70gj2tM8QwGItfgGjJg
         6cuHqyO69idHQFyBnP6z6wiqCTs2LtIsl6o0M=
MIME-Version: 1.0
In-Reply-To: <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
Date: Fri, 16 Oct 2009 15:32:59 +0200
Message-ID: <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
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

2009/10/16 Catalin Marinas <catalin.marinas@arm.com>:
> On Fri, 2009-10-16 at 09:45 +0200, Zdenek Kabelac wrote:
>> 2009/10/15 Catalin Marinas <catalin.marinas@arm.com>:
>> >> Zdenek Kabelac wrote:
>> >> > I've noticed your latest patch for memory leak in filter setting
>> >> > (8ad807318fcd...) - but even with this patch - kmemleak seems to still
>> >> > report  lots  (~900) of following leaks - note - they come only from
>> >> > i915 and kvm module - so I'm not sure if these two modules are doing
>> >> > something wrong or the problem is in trace code.
>> >
>> > It is probably caused by the fact that kmemleak doesn't scan the
>> > mod->trace_events data in a module (the _ftrace_events section). It only
>> > scans those sections beginning with .data and .bss in a module. Maybe we
>> > should add "_ftrace_events" as well or just prefix it with ".data".
>> >
>> > Something like below may fix this (untested):
>> >
>> > diff --git a/kernel/module.c b/kernel/module.c
>> > index 8b7d880..1449691 100644
>> > --- a/kernel/module.c
>> > +++ b/kernel/module.c
>> > @@ -2383,6 +2383,9 @@ static noinline struct module *load_module(void __user *umod,
>> >                                         "_ftrace_events",
>> >                                         sizeof(*mod->trace_events),
>> >                                         &mod->num_trace_events);
>> > +       kmemleak_scan_area(mod->module_core, mod->trace_events,
>> > +                          sizeof(*mod->trace_events) * mod->num_trace_events,
>> > +                          GFP_KERNEL);
>> >  #endif
>> >  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
>> >        /* sechdrs[0].sh_size is always zero */
>>
>> Yep - I've assume it could be also a problem of missing memory segment
>> in kmemleak scanning routine - but it was weird that just these two
>> modules (i915 & kvm) are doing such strange thing.
>>
>> I've tested patch above with added cast  ( (unsigned
>> long)mod->trace_events) to pacify warning - but it did not helped -
>> leaks are still printed.
>
> Same trace-related leaks?
>


Yes -same - though I forget to mention that log contained these two
extra messages:
(got lost in other debug stuff :( )...

So it could be the parameters in your first patch were not correct ?

[drm] Initialized drm 1.1.0 20060810
kmemleak: Scan area larger than object 0xffffffffa033b000
Pid: 1083, comm: modprobe Not tainted 2.6.32-rc5-00002-ga8ed0d4 #25
Call Trace:
 [<ffffffff8140ee5f>] kmemleak_scan_area+0x15f/0x1a0
 [<ffffffff810a0086>] load_module+0xff6/0x1ae0
 [<ffffffff8109ca70>] ? setup_modinfo_srcversion+0x0/0x30
 [<ffffffff810a0beb>] sys_init_module+0x7b/0x260
 [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
kmemleak: Object 0xffffffffa033b000 (size 307200):
kmemleak:   comm "modprobe", pid 1083, jiffies 4294881856
kmemleak:   min_count = 0
kmemleak:   count = -1
kmemleak:   flags = 0x9
kmemleak:   backtrace:
     [<ffffffff8140eae6>] kmemleak_alloc+0x26/0x60
     [<ffffffff8111992a>] __vmalloc_area+0x4a/0x60
     [<ffffffff8102b6ee>] module_alloc+0x5e/0x60
     [<ffffffff8109c626>] module_alloc_update_bounds+0x16/0x50
     [<ffffffff8109f8d3>] load_module+0x843/0x1ae0
     [<ffffffff810a0beb>] sys_init_module+0x7b/0x260
     [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
pci 0000:00:02.0: power state changed by ACPI to D0
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
acpi device:01: registered as cooling_device2
input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input8
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
kmemleak: Scan area larger than object 0xffffffffa0399000
Pid: 1090, comm: modprobe Not tainted 2.6.32-rc5-00002-ga8ed0d4 #25
Call Trace:
 [<ffffffff8140ee5f>] kmemleak_scan_area+0x15f/0x1a0
 [<ffffffff810a0086>] load_module+0xff6/0x1ae0
 [<ffffffff8109ca70>] ? setup_modinfo_srcversion+0x0/0x30
 [<ffffffff810a0beb>] sys_init_module+0x7b/0x260
 [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
kmemleak: Object 0xffffffffa0399000 (size 278528):
kmemleak:   comm "modprobe", pid 1090, jiffies 4294881947
kmemleak:   min_count = 0
kmemleak:   count = -1
kmemleak:   flags = 0x9
kmemleak:   backtrace:
     [<ffffffff8140eae6>] kmemleak_alloc+0x26/0x60
     [<ffffffff8111992a>] __vmalloc_area+0x4a/0x60
     [<ffffffff8102b6ee>] module_alloc+0x5e/0x60
     [<ffffffff8109c626>] module_alloc_update_bounds+0x16/0x50
     [<ffffffff8109f8d3>] load_module+0x843/0x1ae0
     [<ffffffff810a0beb>] sys_init_module+0x7b/0x260
     [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff




> Do any of the leaks disappear with subsequent memory scans (echo scan >
> debug/kmemleak)?
>

Yep - they are persistent until module unload - for i915 though there
are some left.

BTW - it's kind of ugly - that module removal destroys stack trace -
it would be nice to see some hook for module unload - to eventually
create a permanent stack trace for this occasion??
Otherwise when i915 is unloaded - I get leaks with unresolved addresses.
(as a workaround I store leaks before unload and do a manual compare)

> Could you try the patch below? It ensures that all the module memory is
> scanned:
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 8b7d880..fc6ef3a 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2036,36 +2036,6 @@ static void *module_alloc_update_bounds(unsigned long size)
>        return ret;
>  }
>
> -#ifdef CONFIG_DEBUG_KMEMLEAK
> -static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
> -                                Elf_Shdr *sechdrs, char *secstrings)
> -{

I'll check with next reboot.

>> And I add another leak - which might be from the same range of problem :
>> (it's also present many times - and it even looks like hex dump is
>> changing so it's probably even frequently used memory region - at
>> least in few such objects)
>>
>> unreferenced object 0xffff88013aa4ad80 (size 192):
>>   comm "swapper", pid 1, jiffies 4294877809
>>   hex dump (first 32 bytes):
>>     c0 dc a4 3a 01 88 ff ff 00 0c 79 39 01 88 ff ff  ...:......y9....
>>     90 00 cf 3a 01 88 ff ff 02 00 00 00 00 00 00 00  ...:............
>>   backtrace:
>>     [<ffffffff8140e9a6>] kmemleak_alloc+0x26/0x60
>>     [<ffffffff81126a01>] kmem_cache_alloc_notrace+0xc1/0x140
>>     [<ffffffff8127256a>] dma_debug_init+0x23a/0x3a0
>>     [<ffffffff81864a37>] pci_iommu_init+0xe/0x28
>>     [<ffffffff8100904c>] do_one_initcall+0x3c/0x1d0
>>     [<ffffffff8185f4e6>] kernel_init+0x150/0x1a6
>>     [<ffffffff8100d21a>] child_rip+0xa/0x20
>>     [<ffffffffffffffff>] 0xffffffffffffffff
>
> Same as above, does it disappear with subsequent scans? This doesn't
> look immediately like a false positive, it needs a bit more
> investigation.
>

No they seem to be permanent - but the hex dump area is changing for
some of those objects.
That's why I assume they are false positives.

Zdenek
