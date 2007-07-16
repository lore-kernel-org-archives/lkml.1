Return-Path: <linux-kernel-owner+w=401wt.eu-S933478AbXGPQzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbXGPQzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759812AbXGPQz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:55:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:19770 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbXGPQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=iGAYYSXG0WuUknVzHUF2zNrXRkUR8CpQIyNKh1cIe5HDsB034yyYVhyis8TmH0Kb1ghIIyw8Ygu7Q88tkEwtLGX7ydZ+zG9lIAEL77yA1FiYkFVKzjjPvDhIG75vW2tTtox9CRIJ6cd3B8tRNO/6PhVUcgffBb4+HdhEpJGRDBM=
Message-ID: <469BA2CF.5090002@googlemail.com>
Date: Mon, 16 Jul 2007 18:54:39 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, htejun@gmail.com, gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>	 <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469A5C94.7030201@googlemail.com>	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com> <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com> <469B91A7.909@googlemail.com>
In-Reply-To: <469B91A7.909@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Satyam Sharma wrote:
>   
>> Hi Gabriel,
>>
>> On 7/16/07, Gabriel C <nix.or.die@googlemail.com> wrote:
>>
>>   
>>     
>>> ( http://194.231.229.228/Oops.txt )
>>>     
>>>       
>>   
>>     
>>> I cannot reproduce this on plain 2.6.22 so I've started to bisect the
>>> problem.
>>>     
>>>       
>> Could you reproduce this oops at will at the "bad" points? [ Note that
>> git-bisect isn't quite applicable to bugs that are not 100% reproducible.
>> The ones that passed as "good" may have passed only because the
>> bug didn't get triggered on that particular test. Also, a perfectly good
>> commit could get unnecessarily marked "bad" because the bug
>> happened to get triggered for it ... so it's not quite trust-worthy for
>> your case. ]
>>   
>>     
>
> Yes all marked 'bad' ponts have the Oops , at least here.
>
>   
>>   
>>     
>>> Here the bisect result:
>>>
>>> 3007e997de91ec59af39a3f9c91595b31ae6e08b is first bad commit
>>> commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
>>> Author: Tejun Heo <htejun@gmail.com>
>>> Date:   Thu Jun 14 04:27:23 2007 +0900
>>>
>>>     sysfs: use sysfs_mutex to protect the sysfs_dirent tree
>>>
>>>     As kobj sysfs dentries and inodes are gonna be made reclaimable,
>>>     i_mutex can't be used to protect sysfs_dirent tree.  Use sysfs_mutex
>>>     globally instead.  As the whole tree is protected with sysfs_mutex,
>>>     there is no reason to keep sysfs_rename_sem.  Drop it.
>>>
>>>     While at it, add docbook comments to functions which require
>>>     sysfs_mutex locking.
>>>
>>>     Signed-off-by: Tejun Heo <htejun@gmail.com>
>>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>>
>>> :040000 040000 9deba7887752bc343cc4f5dea2dac70e895ea8b6
>>> 75340b6e18c1ada500bb1a2b99ee88fd93ebae8c M      fs
>>>     
>>>       
>> Hmm, I don't see why this one could introduce an oops in SLUB,
>> but it's doing some locking-related stuff, and if it didn't get it right,
>> the resulting races /could/ lead to some oops. But ... a recently
>> posted patch (http://lkml.org/lkml/2007/7/16/204) from Akinobu
>> Mita does point to an oops that was introduced by commit
>> 0c096b507f15397da890051ee73de4266d3941fb that belongs to the
>> same patchset -- kmem_cache_free(NULL) is illegal and so will oops.
>> A curious coincidence is that you do see sysfs_new_dirent() in the
>> stack trace there, but the oops there is in kmem_cache_free(), not
>> kmem_cache_zalloc() as your dmesg output indicated.
>>
>> Try that patch anyway, but I don't think that'll solve your problem --
>> if it was, you would've been seeing "unable to handle kernel NULL
>> pointer dereference" but what you've been posting is "unable to
>> handle kernel paging request at virtual address <non_null_ptr>" ...
>>   
>>     
>
> I will try this patch and look whatever it helps.
>
>   
>> Gaah.
>>
>> And the worst thing about it all is that we're not able to trigger the
>> oops with debugging options -- that backtrace is horrible, so I'd
>> suggest CONFIG_FRAME_POINTER, at the very least. And also
>> perhaps DEBUG_INFO while we're at it -- that'll make later
>> analysis easier, if nothing else.
>>   
>>     
>
> I will enable DEBUG option and reproduce in a bit.
>
>   
>> [ BTW I couldn't even get my compiler to generate the same
>> "Code:" as we saw in your dmesg (I suspect all the oopsen
>> have occurred with DEBUG=n, yes?) so my earlier analysis
>> that suspected SLUB's page->lockless_freelist in slab_alloc()
>> as the source of that invalid kernel address was actually
>> based on some human-work rather than simple tools doing
>> their thing. Gaah, again! ]
>>   
>>     
>
> My original report ( also first Oops posted here ) was with DEBUG_KERNEL=y
> but as I said I will reproduce in a bit with all the DEBUG options you
> suggested.
>
> Shall I enable DEBUG_PAGEALLOC too ?
>   

Here it is :

Jul 16 18:24:27 lara [  217.417182] Fixed PHY: Registered new driver
Jul 16 18:24:27 lara [  217.417329] Device 'fixed@100:1' does not have a
release() function, it is broken and must be fixed.
Jul 16 18:24:27 lara [  217.417340] WARNING: at drivers/base/core.c:107
device_release()
Jul 16 18:24:27 lara [  217.417348]  [<c0104e3e>]
show_trace_log_lvl+0x1a/0x2f
Jul 16 18:24:27 lara [  217.417369]  [<c01059d4>] show_trace+0x12/0x14
Jul 16 18:24:27 lara [  217.417378]  [<c0105a46>] dump_stack+0x16/0x18
Jul 16 18:24:27 lara [  217.417387]  [<c0234078>] device_release+0x7c/0x7e
Jul 16 18:24:27 lara [  217.417402]  [<c01d3197>] kobject_cleanup+0x45/0x5f
Jul 16 18:24:27 lara [  217.417412]  [<c01d31bc>] kobject_release+0xb/0xd
Jul 16 18:24:27 lara [  217.417421]  [<c01d3dc7>] kref_put+0x63/0x71
Jul 16 18:24:27 lara [  217.417430]  [<c01d3150>] kobject_put+0x14/0x16
Jul 16 18:24:27 lara [  217.417438]  [<c0234276>] put_device+0x11/0x13
Jul 16 18:24:27 lara [  217.417450]  [<c023492c>]
device_unregister+0x12/0x15
Jul 16 18:24:27 lara [  217.417459]  [<e8c432e8>]
fixed_mdio_register_device+0x1dc/0x208 [fixed]
Jul 16 18:24:27 lara [  217.417473]  [<e8c4601e>] fixed_init+0x1e/0x33
[fixed]
Jul 16 18:24:27 lara [  217.417482]  [<c013834f>]
sys_init_module+0x1589/0x1677
Jul 16 18:24:27 lara [  217.417493]  [<c0103e76>]
sysenter_past_esp+0x5f/0x85
Jul 16 18:24:27 lara [  217.417502]  =======================
Jul 16 18:24:27 lara [  217.417545] BUG: unable to handle kernel paging
request at virtual address 58b7e000
Jul 16 18:24:27 lara [  217.417576]  printing eip:
Jul 16 18:24:27 lara [  217.417602] c015e330
Jul 16 18:24:27 lara [  217.417618] *pde = 00000000
Jul 16 18:24:27 lara [  217.417639] Oops: 0000 [#1]
Jul 16 18:24:27 lara [  217.417653] PREEMPT SMP DEBUG_PAGEALLOC
Jul 16 18:24:27 lara [  217.417719] Modules linked in: fixed pc87360
hwmon_vid i2c_isa eeprom adm1021 uhci_hcd sr_mod shpchp pci_hotplug
ohci_hcd iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801
ehci_hcd usbcore edac_mc cdrom agpgart 3c59x mii ext4dev jbd2 capability
commoncap loop lp parport_pc parport
Jul 16 18:24:27 lara [  217.418058] CPU:    3
Jul 16 18:24:27 lara [  217.418061] EIP:    0060:[<c015e330>]    Not
tainted VLI
Jul 16 18:24:27 lara [  217.418066] EFLAGS: 00210006  
(2.6.22-g8f41958b-dirty #26)
Jul 16 18:24:27 lara [  217.418096] EIP is at kmem_cache_zalloc+0x73/0x86
Jul 16 18:24:27 lara [  217.418118] eax: 00000000   ebx: 00200282   ecx:
c13eb160   edx: 58b7e000
Jul 16 18:24:27 lara [  217.418145] esi: e7f75840   edi: e78056f8   ebp:
e1221d78   esp: e1221d58
Jul 16 18:24:27 lara [  217.418162] ds: 007b   es: 007b   fs: 00d8  gs:
0033  ss: 0068
Jul 16 18:24:27 lara [  217.418182] Process modprobe (pid: 2161,
ti=e1220000 task=db6a8c20 task.ti=e1220000)
Jul 16 18:24:27 lara [  217.418203] Stack: c014e0cd c0376a85 58b7e000
000000d0 e773b900 c0376a85 db60bc90 e78056f8
Jul 16 18:24:27 lara [  217.418283]        e1221d9c c01999e0 00000002
41ed0000 e78056f8 c01722a9 c0376a85 db60bc90
Jul 16 18:24:27 lara [  217.418334]        c0376a85 e1221dc4 c0199e9c
df58b888 c0199bd5 e1221db4 e1221de0 df58b888
Jul 16 18:24:27 lara [  217.418461] Call Trace:
Jul 16 18:24:27 lara [  217.418474]  [<c0104e3e>]
show_trace_log_lvl+0x1a/0x2f
Jul 16 18:24:27 lara [  217.418506]  [<c0104eee>]
show_stack_log_lvl+0x9b/0xa3
Jul 16 18:24:27 lara [  217.418545]  [<c01050c4>] show_registers+0x1ce/0x2de
Jul 16 18:24:27 lara [  217.418566]  [<c01052f1>] die+0x11d/0x1f6
Jul 16 18:24:27 lara [  217.418582]  [<c0113757>] do_page_fault+0x425/0x4f2
Jul 16 18:24:27 lara [  217.418614]  [<c030c04a>] error_code+0x72/0x78
Jul 16 18:24:27 lara [  217.418662]  [<c01999e0>] sysfs_new_dirent+0x44/0xe1
Jul 16 18:24:27 lara [  217.418693]  [<c0199e9c>] create_dir+0x21/0x93
Jul 16 18:24:27 lara [  217.418714]  [<c0199f84>]
sysfs_create_subdir+0x16/0x1a
Jul 16 18:24:27 lara [  217.418739]  [<c019b30a>]
sysfs_create_group+0x26/0xe8
Jul 16 18:24:27 lara [  217.418771]  [<c0239573>] dpm_sysfs_add+0x12/0x14
Jul 16 18:24:27 lara [  217.418805]  [<c0238fae>] device_pm_add+0x3b/0x79
Jul 16 18:24:27 lara [  217.418845]  [<c0234bf1>] device_add+0x21e/0x3bc
Jul 16 18:24:27 lara [  217.418872]  [<c0234da1>] device_register+0x12/0x15
Jul 16 18:24:27 lara [  217.418894]  [<e8c43283>]
fixed_mdio_register_device+0x177/0x208 [fixed]
Jul 16 18:24:27 lara [  217.418935]  [<e8c4602f>] fixed_init+0x2f/0x33
[fixed]
Jul 16 18:24:27 lara [  217.418955]  [<c013834f>]
sys_init_module+0x1589/0x1677
Jul 16 18:24:27 lara [  217.419004]  [<c0103e76>]
sysenter_past_esp+0x5f/0x85
Jul 16 18:24:27 lara [  217.419032]  =======================
Jul 16 18:24:27 lara [  217.419045] Code: 83 7d e8 00 74 2d 8b 56 08 31
c0 89 d1 c1 e9 02 8b 7d e8 f3 ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa
eb 0f 0f b7 41 0a 8b 55 e8 <8b> 04 82 89 41 0c eb cb 8b 45 e8 83 c4 14
5b 5e 5f 5d c3 55 89
Jul 16 18:24:27 lara [  217.419404] EIP: [<c015e330>]
kmem_cache_zalloc+0x73/0x86 SS:ESP 0068:e1221d58
Jul 16 18:24:27 lara [  217.420974] BUG: unable to handle kernel paging
request at virtual address 58b7e000
Jul 16 18:24:27 lara [  217.420986]  printing eip:
Jul 16 18:24:27 lara [  217.420993] c015e330
Jul 16 18:24:27 lara [  217.420997] *pde = 00000000
Jul 16 18:24:27 lara [  217.421007] Oops: 0000 [#2]
Jul 16 18:24:27 lara [  217.421011] PREEMPT SMP DEBUG_PAGEALLOC
Jul 16 18:24:27 lara [  217.421022] Modules linked in: fixed pc87360
hwmon_vid i2c_isa eeprom adm1021 uhci_hcd sr_mod shpchp pci_hotplug
ohci_hcd iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801
ehci_hcd usbcore edac_mc cdrom agpgart 3c59x mii ext4dev jbd2 capability
commoncap loop lp parport_pc parport
Jul 16 18:24:27 lara [  217.421100] CPU:    3
Jul 16 18:24:27 lara [  217.421103] EIP:    0060:[<c015e330>]    Not
tainted VLI
Jul 16 18:24:27 lara [  217.421108] EFLAGS: 00010006  
(2.6.22-g8f41958b-dirty #26)
Jul 16 18:24:27 lara [  217.421129] EIP is at kmem_cache_zalloc+0x73/0x86
Jul 16 18:24:27 lara [  217.421140] eax: 00000000   ebx: 00000286   ecx:
c13eb160   edx: 58b7e000
Jul 16 18:24:27 lara [  217.421150] esi: e7f75840   edi: fffffff4   ebp:
e7311ef4   esp: e7311ed4
Jul 16 18:24:27 lara [  217.421160] ds: 007b   es: 007b   fs: 00d8  gs:
0033  ss: 0068
Jul 16 18:24:27 lara [  217.421168] Process udevd (pid: 610, ti=e7310000
task=e7e87840 task.ti=e7310000)
Jul 16 18:24:27 lara [  217.421176] Stack: 000200d0 00000010 58b7e000
000000d0 00000296 ddce8c20 e7e87840 fffffff4
Jul 16 18:24:27 lara [  217.421195]        e7311f00 c0144748 ddce8c20
e7311f50 c0119854 00000202 00000878 00000878
Jul 16 18:24:27 lara [  217.421215]        e7311fb8 bf9e7958 01200011
c0129500 ddce8c20 ddce8c20 e7e23910 00000878
Jul 16 18:24:27 lara [  217.421238] Call Trace:
Jul 16 18:24:27 lara [  217.421243]  [<c0104e3e>]
show_trace_log_lvl+0x1a/0x2f
Jul 16 18:24:27 lara [  217.421258]  [<c0104eee>]
show_stack_log_lvl+0x9b/0xa3
Jul 16 18:24:27 lara [  217.421269]  [<c01050c4>] show_registers+0x1ce/0x2de
Jul 16 18:24:27 lara [  217.421280]  [<c01052f1>] die+0x11d/0x1f6
Jul 16 18:24:27 lara [  217.421288]  [<c0113757>] do_page_fault+0x425/0x4f2
Jul 16 18:24:27 lara [  217.421298]  [<c030c04a>] error_code+0x72/0x78
Jul 16 18:24:27 lara [  217.421313]  [<c0144748>]
__delayacct_tsk_init+0x15/0x2f
Jul 16 18:24:27 lara [  217.421327]  [<c0119854>] copy_process+0x28b/0x118f
Jul 16 18:24:27 lara [  217.421339]  [<c011a9c3>] do_fork+0x99/0x1bf
Jul 16 18:24:27 lara [  217.421347]  [<c010222f>] sys_clone+0x33/0x39
Jul 16 18:24:27 lara [  217.421355]  [<c0103e76>]
sysenter_past_esp+0x5f/0x85
Jul 16 18:24:27 lara [  217.421365]  =======================
Jul 16 18:24:27 lara [  217.421369] Code: 83 7d e8 00 74 2d 8b 56 08 31
c0 89 d1 c1 e9 02 8b 7d e8 f3 ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa
eb 0f 0f b7 41 0a 8b 55 e8 <8b> 04 82 89 41 0c eb cb 8b 45 e8 83 c4 14
5b 5e 5f 5d c3 55 89
Jul 16 18:24:27 lara [  217.421489] EIP: [<c015e330>]
kmem_cache_zalloc+0x73/0x86 SS:ESP 0068:e7311ed4

(gdb) l *kmem_cache_zalloc+0x73
0xc015e330 is in kmem_cache_zalloc (mm/slub.c:1499).
1494
1495                    object = __slab_alloc(s, gfpflags, node, addr,
page);
1496
1497            else {
1498                    object = page->lockless_freelist;
1499                    page->lockless_freelist = object[page->offset];
1500            }
1501            local_irq_restore(flags);
1502            return object;
1503    }


(gdb) l *kmem_cache_zalloc+0x73/0x86
0xc015e2bd is in kmem_cache_zalloc (mm/slub.c:2608).
2603            return s;
2604    }
2605    EXPORT_SYMBOL(kmem_cache_create);
2606
2607    void *kmem_cache_zalloc(struct kmem_cache *s, gfp_t flags)
2608    {
2609            void *x;
2610
2611            x = slab_alloc(s, flags, -1, __builtin_return_address(0));
2612            if (x)

If you want any other gdb things let me know and please let me know what
else I can do to help killing this bug.

Used config there : http://194.231.229.228/2.6.22-g8f41958b/config

>   
>> I'm thoroughly mystified ... Christoph? Tejun? Someone?
>>
>> Satyam
>>
>>   
>>     
>
>   

Gabriel
