Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZJTJ6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZJTJ6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 05:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZJTJ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 05:58:37 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51516 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZJTJ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 05:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QhI1fK83zY9fOfuxCvu8jVSHR+6kpv5obJRJYjnad3b2Vec0cmMDfhlzAGQRMdWGjP
         OpC/gbHFdKatyb71Ce4aw8XlLoUzZTnIZhManYI4yjBWI8na2KcwzZ0knosgV0OgrodY
         0AeBTDBbrqWTU4SZY3E2Jv/KyaysYoG8otKoM=
MIME-Version: 1.0
In-Reply-To: <1255958422.31096.33.camel@pc1117.cambridge.arm.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
	 <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
	 <1255711285.3008.59.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910190215j129e61ey5e20634a4bc19292@mail.gmail.com>
	 <1255953605.31096.26.camel@pc1117.cambridge.arm.com>
	 <1255958422.31096.33.camel@pc1117.cambridge.arm.com>
Date: Tue, 20 Oct 2009 11:58:39 +0200
Message-ID: <c4e36d110910200258q7c1d6b4uf74b6d365ffb3f40@mail.gmail.com>
Subject: Re: Leaks in trace reported by kmemleak
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/19 Catalin Marinas <catalin.marinas@arm.com>:
> On Mon, 2009-10-19 at 13:00 +0100, Catalin Marinas wrote:
>> On Mon, 2009-10-19 at 11:15 +0200, Zdenek Kabelac wrote:
>> > What is however interesting is the false positive leak for
>> > dma_debug_init(). Which is sometimes listed and sometimes not - the
>> > memory is allocated just once in the code during boot, so it's strange
>> > that pointers to that area are sometimes out of kmemleak scan.
>>
>> A workaround I had in the past was to not report an object unless it was
>> found as a leak in two consecutive scans. I should probably reinstate
>> this feature (could be optimised to use a second prio_tree containing
>> only objects found as leaks).
>
> OK, I re-added a form of this to the kmemleak.git tree and simplified
> the scanning logic (meant initially to reduce the false positives). Now,
> for an object to be reported, it needs to be found as leak during two
> consecutive scans (this works around pointer moving from a structure to
> a different one which was already scanned).
>
> If you have time, could you please give it a try and see whether you
> still get transient false positives?
>
> As for the patch showing where an object is referred from, I think it's
> still useful for debugging possible false negatives, so I'll leave it
> in.
>
> Thanks.

I've tested your git with updates - and here is my experience:

I'm still able to get FP leaks printed even with the print of
more-then-once appearanc.

i.e. here is output of dump=

kmemleak: Object 0xffff8801390fd300 (size 192):
kmemleak:   comm "swapper", pid 1, jiffies 4294877823
kmemleak:   min_count = 1
kmemleak:   count = 0
kmemleak:   flags = 0xb
kmemleak:   backtrace:
     [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
     [<ffffffff811269f1>] kmem_cache_alloc_notrace+0xc1/0x140
     [<ffffffff8127243a>] dma_debug_init+0x23a/0x3a0
     [<ffffffff81864a37>] pci_iommu_init+0xe/0x28
     [<ffffffff8100904c>] do_one_initcall+0x3c/0x1d0
     [<ffffffff8185f4e6>] kernel_init+0x150/0x1a6
     [<ffffffff8100d21a>] child_rip+0xa/0x20
     [<ffffffffffffffff>] 0xffffffffffffffff


i think it would be useful to print count of leak appearance - i.e.
leak was seen during XX scans.
Also jiffies might be eventually more readable via data/time - but
this can be preprocessed via script.
So it still looks like some memory areas are missing in scan.

I think new interesting 'probably real leak is being printed from
cpufreq during pm-suspend - it seems to be repeatable.

unreferenced object 0xffff880139bdfc10 (size 8):
  comm "swapper", pid 1, jiffies 4294878042
  hex dump (first 8 bytes):
    63 70 75 66 72 65 71 00                          cpufreq.
  backtrace:
    [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
    [<ffffffff81127953>] __kmalloc_track_caller+0x143/0x230
    [<ffffffff81104395>] kstrdup+0x45/0x80
    [<ffffffff8119e2cc>] sysfs_new_dirent+0x10c/0x120
    [<ffffffff8119f132>] create_dir+0x42/0xb0
    [<ffffffff8119f1d9>] sysfs_create_dir+0x39/0x50
    [<ffffffff8126048b>] kobject_add_internal+0x11b/0x210
    [<ffffffff812606a8>] kobject_add_varg+0x38/0x60
    [<ffffffff81260723>] kobject_init_and_add+0x53/0x70
    [<ffffffff81373552>] cpufreq_add_dev_interface+0x42/0x220
    [<ffffffff81373cee>] cpufreq_add_dev+0x27e/0x410
    [<ffffffff8130e636>] sysdev_driver_register+0xa6/0x130
    [<ffffffff81371d38>] cpufreq_register_driver+0x88/0x160
    [<ffffffff81867c8c>] acpi_cpufreq_init+0x91/0xc7
    [<ffffffff8100904c>] do_one_initcall+0x3c/0x1d0
    [<ffffffff8185f4e6>] kernel_init+0x150/0x1a6

unreferenced object 0xffff8801350a5410 (size 80):
  comm "pm-suspend", pid 2841, jiffies 4296695092
  hex dump (first 32 bytes):
    04 00 00 00 00 00 00 00 00 50 0a 35 01 88 ff ff  .........P.5....
    00 00 00 00 00 00 00 00 28 58 20 3a 01 88 ff ff  ........(X :....
  backtrace:
    [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
    [<ffffffff81126c73>] kmem_cache_alloc+0x133/0x1c0
    [<ffffffff8119e201>] sysfs_new_dirent+0x41/0x120
    [<ffffffff8119f132>] create_dir+0x42/0xb0
    [<ffffffff8119f20b>] sysfs_create_subdir+0x1b/0x20
    [<ffffffff811a0508>] internal_create_group+0x58/0x1a0
    [<ffffffff811a0683>] sysfs_create_group+0x13/0x20
    [<ffffffff8137477a>] cpufreq_stat_notifier_policy+0xda/0x2b0
    [<ffffffff81424788>] notifier_call_chain+0x78/0xb0
    [<ffffffff8107f190>] __blocking_notifier_call_chain+0x60/0x90
    [<ffffffff8107f1d6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff81373329>] __cpufreq_set_policy+0xc9/0x190
    [<ffffffff813736e3>] cpufreq_add_dev_interface+0x1d3/0x220
    [<ffffffff81373cee>] cpufreq_add_dev+0x27e/0x410
    [<ffffffff8141d244>] cpufreq_cpu_callback+0x71/0x7e
    [<ffffffff81424788>] notifier_call_chain+0x78/0xb0
.....


I've made also test with removal of as much modules as possible
(though for some reason some of them were kept in memory, because I
couldn't decrease module count to 0 - while nearly every userland task
was killed except for bash and mingetty


ipt_MASQUERADE          1823  1
iptable_nat             4228  1
nf_nat                 18462  2 ipt_MASQUERADE,iptable_nat
nf_conntrack_ipv4      12687  3 iptable_nat,nf_nat
nf_defrag_ipv4          1353  1 nf_conntrack_ipv4
nf_conntrack           72037  4
ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4
ip_tables              16520  1 iptable_nat
x_tables               20541  3 ipt_MASQUERADE,iptable_nat,ip_tables
sunrpc                221415  1
ipv6                  292258  10
binfmt_misc             7686  1
usbcore               168536  1


This left few other leaks - however because trace after module removal
is meaningless it's hard to say from where the leak comes from. Well -
how about adding new command    "echo resolve >debug/kmemleak". This
would resolve all backtraces - it would surely eat 'some' memory - but
it would give the usable trace for removed modules. I think lots' of
stack traces could eventually use some sort of heap - to avoid
duplicate resolving of same stack and keeping same strings in memory.


Anyway here are few leaks from i915 -

unreferenced object 0xffff8800bf15fba0 (size 544):
  comm "X", pid 2014, jiffies 4299475327
  hex dump (first 32 bytes):
    ff ff ff ff ff ff ff ff 40 db aa ba 00 88 ff ff  ........@.......
    00 df aa ba 00 88 ff ff c0 d0 aa ba 00 88 ff ff  ................
  backtrace:
    [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
    [<ffffffff81126c73>] kmem_cache_alloc+0x133/0x1c0
    [<ffffffff8125f43f>] idr_pre_get+0x5f/0x90
    [<ffffffffa03374cd>] drm_gem_handle_create+0x3d/0xb0 [drm]
    [<ffffffffa0379815>] i915_gem_create_ioctl+0x65/0xc0 [i915]
    [<ffffffffa0335f76>] drm_ioctl+0x176/0x390 [drm]
    [<ffffffff81143b9c>] vfs_ioctl+0x7c/0xa0
    [<ffffffff81143ce4>] do_vfs_ioctl+0x84/0x590
    [<ffffffff81144271>] sys_ioctl+0x81/0xa0
    [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Those are present also after i915 removal:

unreferenced object 0xffff880132f31760 (size 544):
  comm "X", pid 2014, jiffies 4294899254
  hex dump (first 32 bytes):
    ff ff ff df fe dd f5 9a 40 4e 34 30 01 88 ff ff  ........@N40....
    80 41 34 30 01 88 ff ff c0 46 34 30 01 88 ff ff  .A40.....F40....
  backtrace:
    [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
    [<ffffffff81126c73>] kmem_cache_alloc+0x133/0x1c0
    [<ffffffff8125f43f>] idr_pre_get+0x5f/0x90
    [<ffffffffa03374cd>] 0xffffffffa03374cd
    [<ffffffffa0379815>] 0xffffffffa0379815
    [<ffffffffa0335f76>] 0xffffffffa0335f76
    [<ffffffff81143b9c>] vfs_ioctl+0x7c/0xa0
    [<ffffffff81143ce4>] do_vfs_ioctl+0x84/0x590
    [<ffffffff81144271>] sys_ioctl+0x81/0xa0
    [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff


And one from  iwl3945:

unreferenced object 0xffff8801280f4900 (size 256):
  comm "events/0", pid 9, jiffies 4301085444
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
    [<ffffffff81126c73>] kmem_cache_alloc+0x133/0x1c0
    [<ffffffff813891ea>] __alloc_skb+0x4a/0x180
    [<ffffffff8140b292>] wireless_send_event+0x1f2/0x410
    [<ffffffffa00fdeec>] ___cfg80211_scan_done+0xcc/0xf0 [cfg80211]
    [<ffffffffa00fdf3b>] __cfg80211_scan_done+0x2b/0x50 [cfg80211]
    [<ffffffff81073ada>] worker_thread+0x21a/0x400
    [<ffffffff810794a6>] kthread+0x96/0xa0
    [<ffffffff8100d21a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff

after removal of iwl3945:

unreferenced object 0xffff8801280f4900 (size 256):
  comm "events/0", pid 9, jiffies 4301085444
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8140e986>] kmemleak_alloc+0x26/0x50
    [<ffffffff81126c73>] kmem_cache_alloc+0x133/0x1c0
    [<ffffffff813891ea>] __alloc_skb+0x4a/0x180
    [<ffffffff8140b292>] wireless_send_event+0x1f2/0x410
    [<ffffffffa00fdeec>] 0xffffffffa00fdeec
    [<ffffffffa00fdf3b>] 0xffffffffa00fdf3b
    [<ffffffff81073ada>] worker_thread+0x21a/0x400
    [<ffffffff810794a6>] kthread+0x96/0xa0
    [<ffffffff8100d21a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff


And could be matched because of   idr_pre_get()    vfs_ioctl()  usage pattern

I'll try to look later in the code myself.

Zdenek
