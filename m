Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbZAIAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbZAIAQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZAIAQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:16:26 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:13418 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZAIAQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:16:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=nGywSeKS34hlzbz0z8Zd2OmAGikE8pY7wEt9EyQPTuVaswZzI+XDf1UckXvzkqVBHH
         oPXSe557gwLUr9lHYDAsVoDc80xlNtWFADT8rV2n4O0VB2Orcu7MrXXpXokRywnBmYSa
         +st55K12nidRrjJ9pduqjIE1rnjRspnM9+Pa0=
Message-ID: <4966974B.3090700@gmail.com>
Date: Thu, 08 Jan 2009 16:16:11 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: torvalds@linux-foundation.org, Pekka Paalanen <pq@iki.fi>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [fix] Too async libata breakage
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>	<20090108221753.78648cd6@daedalus.pq.iki.fi>	<20090108125317.648397d2@infradead.org>	<49667C36.4080300@gmail.com> <20090108143127.437c15de@infradead.org>
In-Reply-To: <20090108143127.437c15de@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------000206020700080805030608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000206020700080805030608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
> On Thu, 08 Jan 2009 14:20:38 -0800
> "Justin P. Mattock" <justinmattock@gmail.com> wrote:
>
>   
>> Arjan van de Ven wrote:
>>     
>>>>> Additional async_synchronize_full() helps and box boot to the end.
>>>>>       
>>>>>           
>>> Hi Linus,
>>>
>>> can you add the patch below to your tree? This makes the
>>> async_synchronize_full() a real absolute async barrier, rather than
>>> just synchronizing the work scheduled upto the starting point.
>>> It's a bit too much for some cases (so later on I might introduce
>>> the softer synchronization again) but it solves some real problems
>>> for people so this should go into -rc1 please...
>>>
>>> >From ca1827b142e41b54c612026b3c0b5d239f21a715 Mon Sep 17 00:00:00
>>>       
>>>> 2001
>>>>         
>>> From: Arjan van de Ven <arjan@linux.intel.com>
>>> Date: Thu, 8 Jan 2009 12:35:11 -0800
>>> Subject: [PATCH] async: make async_synchronize_full() more
>>> serializing
>>>
>>> turns out that there are real problems with allowing async
>>> tasks that are scheduled from async tasks to run after
>>> the async_synchronize_full() returns.
>>>
>>> This patch makes the _full more strict and a complete
>>> synchronization. Later I might need to add back a lighter
>>> form of synchronization for other uses.. but not right now.
>>>
>>> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>>> ---
>>>  kernel/async.c |    4 +++-
>>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/kernel/async.c b/kernel/async.c
>>> index 9737338..64cc916 100644
>>> --- a/kernel/async.c
>>> +++ b/kernel/async.c
>>> @@ -206,7 +206,9 @@ EXPORT_SYMBOL_GPL(async_schedule_special);
>>>  
>>>  void async_synchronize_full(void)
>>>  {
>>> -	async_synchronize_cookie(next_cookie);
>>> +	do {
>>> +		async_synchronize_cookie(next_cookie);
>>> +	} while (!list_empty(&async_running)
>>> || !list_empty(&async_pending)); }
>>>  EXPORT_SYMBOL_GPL(async_synchronize_full);
>>>  
>>>   
>>>       
>> I have to say that ohci/firescope is nice
>> poof right up: dmesg shows up:
>> attach is the results.
>> unfortunantly nothing different than
>> what the boot screen shows.
>>     
>
> just to make clear: this is with the patch right?
> because if not... try that..
>
>   
O.K. attached is the results of
dmesg after doing a git-pull
(system didn't freeze, but there's
a slew of warnings); i.g.

[    1.739745] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[    1.741682] Hardware name: MacBookPro2,2
[    1.741682] Modules linked in:
[    1.741682] Pid: 1, comm: swapper Not tainted 2.6.28-07812-g5fbbf5f #9
[    1.741682] Call Trace:
[    1.741682]  [<c01292ca>] warn_slowpath+0x76/0xad
[    1.741682]  [<c0263865>] ? cfb_fillrect+0x182/0x275
[    1.741682]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    1.741682]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    1.741682]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    1.741682]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    1.741682]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    1.741682]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    1.741682]  [<c0104bc9>] do_IRQ+0x92/0xad
[    1.741682]  [<c010396c>] common_interrupt+0x2c/0x34
[    1.741682]  [<c012007b>] ? sched_debug_show+0x803/0xbbd
[    1.741682]  [<c012da4f>] ? __do_softirq+0x6b/0x154
[    1.741682]  [<c012db6c>] ? do_softirq+0x34/0x7e
[    1.741682]  [<c012db8a>] do_softirq+0x52/0x7e
[    1.741682]  [<c012dcd6>] irq_exit+0x49/0x77
[    1.741682]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
[    1.741682]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
[    1.741682]  [<c0129e84>] ? vprintk+0x2aa/0x2d5
[    1.741682]  [<c03df731>] printk+0x14/0x1b
[    1.741682]  [<c05780e8>] mousedev_init+0x70/0x78
[    1.741682]  [<c0101137>] _stext+0x4f/0x127
[    1.741682]  [<c0578078>] ? mousedev_init+0x0/0x78
[    1.741682]  [<c015be1c>] ? register_irq_proc+0x84/0xa0
[    1.741682]  [<c015be90>] ? init_irq_proc+0x58/0x65
[    1.741682]  [<c055a309>] kernel_init+0x105/0x156
[    1.741682]  [<c055a204>] ? kernel_init+0x0/0x156
[    1.741682]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
[    1.741682] ---[ end trace a1303c5fb15c2002 ]---

[    2.013026] ------------[ cut here ]------------
[    2.013028] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[    2.013030] Hardware name: MacBookPro2,2
[    2.013031] Modules linked in:
[    2.013033] Pid: 578, comm: scsi_eh_3 Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[    2.013035] Call Trace:
[    2.013038]  [<c01292ca>] warn_slowpath+0x76/0xad
[    2.013042]  [<c011bbac>] ? update_curr+0xae/0x189
[    2.013045]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[    2.013048]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    2.013050]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    2.013053]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    2.013056]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    2.013059]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    2.013061]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    2.013064]  [<c0104bc9>] do_IRQ+0x92/0xad
[    2.013066]  [<c010396c>] common_interrupt+0x2c/0x34
[    2.013068]  [<c012007b>] ? sched_debug_show+0x803/0xbbd
[    2.013071]  [<c012da4f>] ? __do_softirq+0x6b/0x154
[    2.013073]  [<c012db6c>] ? do_softirq+0x34/0x7e
[    2.013075]  [<c012db8a>] do_softirq+0x52/0x7e
[    2.013077]  [<c012dcd6>] irq_exit+0x49/0x77
[    2.013080]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
[    2.013082]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
[    2.013085]  [<c03e007b>] ? schedule+0x695/0x8f1
[    2.013088]  [<c03e214c>] ? _spin_unlock_irqrestore+0x31/0x3c
[    2.013090]  [<c02e8818>] ata_eh_thaw_port+0x3b/0x3f
[    2.013093]  [<c02e94b4>] ata_eh_reset+0x6cc/0x9bd
[    2.013096]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[    2.013098]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
[    2.013101]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013105]  [<c02e032a>] ? ata_dev_init+0x5d/0x80
[    2.013107]  [<c02ead0a>] ata_eh_recover+0x29c/0xafd
[    2.013110]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013112]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
[    2.013115]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013117]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
[    2.013120]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[    2.013122]  [<c011ef1c>] ? dequeue_task_fair+0x5c/0x61
[    2.013125]  [<c0101e73>] ? __switch_to+0xce/0x14f
[    2.013127]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[    2.013130]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[    2.013132]  [<c0125c92>] ? finish_task_switch+0x37/0x8a
[    2.013134]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[    2.013137]  [<c0131627>] ? lock_timer_base+0x24/0x43
[    2.013140]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013143]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
[    2.013145]  [<c02eb6f8>] ata_do_eh+0x30/0x72
[    2.013148]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
[    2.013150]  [<c02ecf19>] ata_sff_error_handler+0x12b/0x135
[    2.013153]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
[    2.013155]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013158]  [<c02ebec7>] ata_scsi_error+0x2b5/0x5e6
[    2.013162]  [<c02ce15b>] scsi_error_handler+0xc1/0x454
[    2.013164]  [<c012390a>] ? default_wake_function+0x10/0x12
[    2.013167]  [<c03e2148>] ? _spin_unlock_irqrestore+0x2d/0x3c
[    2.013169]  [<c011e4d1>] ? complete+0x39/0x43
[    2.013171]  [<c02ce09a>] ? scsi_error_handler+0x0/0x454
[    2.013175]  [<c0139f9c>] kthread+0x40/0x66
[    2.013178]  [<c0139f5c>] ? kthread+0x0/0x66
[    2.013180]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
[    2.013182] ---[ end trace a1303c5fb15c2003 ]---

[    2.436869] ------------[ cut here ]------------
[    2.442849] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[    2.446154] Hardware name: MacBookPro2,2
[    2.446154] Modules linked in:
[    2.446154] Pid: 1, comm: swapper Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[    2.446154] Call Trace:
[    2.446154]  [<c01292ca>] warn_slowpath+0x76/0xad
[    2.446154]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[    2.446154]  [<c0101e73>] ? __switch_to+0xce/0x14f
[    2.446154]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[    2.446154]  [<c0243563>] ? _raw_spin_trylock+0xf/0x30
[    2.446154]  [<c0125c92>] ? finish_task_switch+0x37/0x8a
[    2.446154]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    2.446154]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    2.446154]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    2.446154]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    2.446154]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    2.446154]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    2.446154]  [<c0104bc9>] do_IRQ+0x92/0xad
[    2.446154]  [<c010396c>] common_interrupt+0x2c/0x34
[    2.446154]  [<c01c00d8>] ? proc_task_readdir+0x76/0x283
[    2.446154]  [<c0243830>] ? _raw_spin_lock+0x0/0xf8
[    2.446154]  [<c03e21f4>] ? _spin_lock+0xd/0xf
[    2.446154]  [<c01c79a1>] sysfs_new_dirent+0x5a/0xe0
[    2.446154]  [<c01c7347>] sysfs_add_file_mode+0x2b/0x72
[    2.446154]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[    2.446154]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[    2.446154]  [<c01c73a1>] sysfs_add_file+0x13/0x18
[    2.446154]  [<c01c7445>] sysfs_create_file+0x25/0x27
[    2.446154]  [<c02b2857>] driver_create_file+0x1b/0x1d
[    2.446154]  [<c02b1955>] bus_add_driver+0xd9/0x1c2
[    2.446154]  [<c02b275b>] driver_register+0x86/0xe6
[    2.446154]  [<c03215a9>] __hid_register_driver+0x43/0x68
[    2.446154]  [<c0325ba2>] ch_init+0x19/0x1b
[    2.446154]  [<c0101137>] _stext+0x4f/0x127
[    2.446154]  [<c0325b89>] ? ch_init+0x0/0x1b
[    2.446154]  [<c015be1c>] ? register_irq_proc+0x84/0xa0
[    2.446154]  [<c015be90>] ? init_irq_proc+0x58/0x65
[    2.446154]  [<c055a309>] kernel_init+0x105/0x156
[    2.446154]  [<c055a204>] ? kernel_init+0x0/0x156
[    2.446154]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
[    2.446154] ---[ end trace a1303c5fb15c2004 ]---


[   10.336705] ------------[ cut here ]------------
[   10.354651] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   10.354651] Hardware name: MacBookPro2,2
[   10.354651] Modules linked in:
[   10.354651] Pid: 889, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   10.354651] Call Trace:
[   10.354651]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.354651]  [<c011b7ad>] ? resched_task+0x25/0x69
[   10.354651]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   10.354651]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[   10.354651]  [<c016e6cf>] ? get_page_from_freelist+0x2a6/0x3ed
[   10.354651]  [<c0169974>] ? find_get_page+0x22/0x86
[   10.354651]  [<c016ea87>] ? __alloc_pages_internal+0x9b/0x36a
[   10.354651]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.354651]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.354651]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.354651]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.354651]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.354651]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.354651]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.354651]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.354651]  [<c03e007b>] ? schedule+0x695/0x8f1
[   10.354651]  [<c03e3ee5>] ? do_page_fault+0x272/0x6f9
[   10.354651]  [<c011e70c>] ? set_next_entity+0xa7/0x113
[   10.354651]  [<c011eeb9>] ? pick_next_task_fair+0x73/0x7a
[   10.354651]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   10.354651]  [<c018a64d>] ? check_object+0x139/0x190
[   10.354651]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.354651]  [<c0240320>] ? trace_hardirqs_on_thunk+0xc/0x10
[   10.354651]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   10.354651]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.354651]  [<c03e2427>] error_code+0x77/0x7c
[   10.354651] ---[ end trace a1303c5fb15c2006 ]---
[   10.647515] ------------[ cut here ]------------

[   10.647515] ------------[ cut here ]------------
[   10.654832] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   10.656261] Hardware name: MacBookPro2,2
[   10.656261] Modules linked in:
[   10.656261] Pid: 893, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   10.656261] Call Trace:
[   10.656261]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.656261]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.656261]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.656261]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.656261]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.656261]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.656261]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.656261]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.656261]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.656261]  [<c011007b>] ? acpi_processor_ffh_cstate_enter+0x3/0x2c
[   10.656261]  [<c016a048>] ? filemap_fault+0x9/0x308
[   10.656261]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
[   10.656261]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   10.656261]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   10.656261]  [<c0179723>] __do_fault+0x40/0x345
[   10.656261]  [<c017b345>] handle_mm_fault+0x29e/0x606
[   10.656261]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   10.656261]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   10.656261]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   10.656261]  [<c018a64d>] ? check_object+0x139/0x190
[   10.656261]  [<c014129b>] ? getnstimeofday+0x56/0xdf
[   10.656261]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   10.656261]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
[   10.656261]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   10.656261]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
[   10.656261]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   10.656261]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   10.656261]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
[   10.656261]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   10.656261]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.656261]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.656261]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.656261]  [<c03e2427>] error_code+0x77/0x7c
[   10.656261] ---[ end trace a1303c5fb15c2007 ]---
[   10.910249] ------------[ cut here ]------------

[   10.910249] ------------[ cut here ]------------
[   10.916793] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   10.920003] Hardware name: MacBookPro2,2
[   10.920003] Modules linked in:
[   10.920003] Pid: 891, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   10.920003] Call Trace:
[   10.920003]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.920003]  [<c0180030>] ? move_page_tables+0x88/0x28b
[   10.920003]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   10.920003]  [<c018beb3>] ? kmem_cache_free+0xae/0xc2
[   10.920003]  [<c034872d>] ? __kfree_skb+0x73/0x76
[   10.920003]  [<c034872d>] ? __kfree_skb+0x73/0x76
[   10.920003]  [<c0348760>] ? kfree_skb+0x30/0x32
[   10.920003]  [<c03ab36c>] ? unix_dgram_sendmsg+0x437/0x47b
[   10.920003]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.920003]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.920003]  [<c017b345>] ? handle_mm_fault+0x29e/0x606
[   10.920003]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.920003]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.920003]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.920003]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.920003]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.920003]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.920003]  [<c0116eed>] ? __ticket_spin_trylock+0x4/0x21
[   10.920003]  [<c0243883>] _raw_spin_lock+0x53/0xf8
[   10.920003]  [<c018a64d>] ? check_object+0x139/0x190
[   10.920003]  [<c03e21f4>] _spin_lock+0xd/0xf
[   10.920003]  [<c023aa85>] _atomic_dec_and_lock+0x29/0x48
[   10.920003]  [<c019e26d>] iput+0x29/0x53
[   10.920003]  [<c019bea5>] dentry_iput+0x81/0x9c
[   10.920003]  [<c019bf74>] d_kill+0x32/0x4c
[   10.920003]  [<c019c663>] dput+0x101/0x10a
[   10.920003]  [<c018fed3>] __fput+0x13b/0x15c
[   10.920003]  [<c018ff12>] fput+0x1e/0x20
[   10.920003]  [<c018d67f>] filp_close+0x56/0x60
[   10.920003]  [<c018d6f8>] sys_close+0x6f/0xa9
[   10.920003]  [<c010329f>] sysenter_do_call+0x12/0x34
[   10.920003] ---[ end trace a1303c5fb15c2008 ]---
[   11.187174] ------------[ cut here ]------------
[   11.190008] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   11.196573] Hardware name: MacBookPro2,2
[   11.203397] Modules linked in:
[   11.209319] Pid: 923, comm: path_id Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   11.219223] Call Trace:
[   11.219223]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.219223]  [<c0230030>] ? elv_attr_store+0x15/0x5e
[   11.219223]  [<c011160a>] ? flush_tlb_page+0x47/0x6e
[   11.219223]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
[   11.219223]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.256355]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   11.256355]  [<c017a1b4>] ? do_wp_page+0x586/0x5eb
[   11.272445]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   11.272445]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.272445]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.272445]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.272445]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.304326]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.304326]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.304326]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.304326]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.304326]  [<c0196c85>] ? putname+0x29/0x34
[   11.304326]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   11.304326]  [<c018beb7>] ? kmem_cache_free+0xb2/0xc2
[   11.304326]  [<c0196c85>] ? putname+0x29/0x34
[   11.304326]  [<c0196c85>] putname+0x29/0x34
[   11.304326]  [<c0198701>] user_path_at+0x4a/0x67
[   11.304326]  [<c013a41e>] ? remove_wait_queue+0x35/0x39
[   11.304326]  [<c018feec>] ? __fput+0x154/0x15c
[   11.304326]  [<c018e048>] sys_chdir+0x23/0x64
[   11.304326]  [<c010329f>] sysenter_do_call+0x12/0x34
[   11.304326] ---[ end trace a1303c5fb15c2009 ]---
[   11.404868] ------------[ cut here ]------------
[   11.411491] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   11.412573] Hardware name: MacBookPro2,2
[   11.412573] Modules linked in:
[   11.412573] Pid: 966, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   11.412573] Call Trace:
[   11.412573]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.412573]  [<c0169974>] ? find_get_page+0x22/0x86
[   11.412573]  [<c0169cb5>] ? find_lock_page+0x18/0x4c
[   11.412573]  [<c016a0d0>] ? filemap_fault+0x91/0x308
[   11.412573]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.412573]  [<c0169c9a>] ? unlock_page+0x43/0x46
[   11.412573]  [<c01799f0>] ? __do_fault+0x30d/0x345
[   11.412573]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.412573]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.412573]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.412573]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.412573]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.412573]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.412573]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.412573]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.412573]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   11.412573]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.412573]  [<c0196cb5>] getname+0x25/0xbc
[   11.412573]  [<c01986d1>] user_path_at+0x1a/0x67
[   11.412573]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   11.412573]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   11.412573]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
[   11.412573]  [<c0191e60>] sys_readlinkat+0x2b/0x86
[   11.412573]  [<c0191ed3>] sys_readlink+0x18/0x1a
[   11.412573]  [<c010329f>] sysenter_do_call+0x12/0x34
[   11.412573] ---[ end trace a1303c5fb15c200a ]---
[   11.631708] ------------[ cut here ]------------
[   11.637944] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   11.640002] Hardware name: MacBookPro2,2
[   11.640002] Modules linked in:
[   11.640002] Pid: 960, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   11.640002] Call Trace:
[   11.640002]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.640002]  [<c0169974>] ? find_get_page+0x22/0x86
[   11.640002]  [<c0169cb5>] ? find_lock_page+0x18/0x4c
[   11.640002]  [<c016a0d0>] ? filemap_fault+0x91/0x308
[   11.640002]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.640002]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.640002]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.640002]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   11.640002]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.640002]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.640002]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.640002]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.640002]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.640002]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.640002]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   11.640002]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.640002]  [<c0196cb5>] getname+0x25/0xbc
[   11.640002]  [<c01986d1>] user_path_at+0x1a/0x67
[   11.640002]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
[   11.640002]  [<c0191e60>] sys_readlinkat+0x2b/0x86
[   11.640002]  [<c0191ed3>] sys_readlink+0x18/0x1a
[   11.640002]  [<c010329f>] sysenter_do_call+0x12/0x34
[   11.640002] ---[ end trace a1303c5fb15c200b ]---
[   11.859983] ------------[ cut here ]------------
[   11.863325] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   11.870937] Hardware name: MacBookPro2,2
[   11.878612] Modules linked in:
[   11.882417] Pid: 988, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   11.889932] Call Trace:
[   11.896866]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.901313]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.906787]  [<c01799f0>] ? __do_fault+0x30d/0x345
[   11.906787]  [<c0212f70>] ? avc_has_perm+0x3e/0x48
[   11.906787]  [<c018a64d>] ? check_object+0x139/0x190
[   11.932317]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.932317]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.932317]  [<c0217852>] ? selinux_inode_alloc_security+0x2e/0x73
[   11.932317]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.932317]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.932317]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.932317]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.932317]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.932317]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.932317]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.932317]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.932317]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   12.009738]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   12.009738]  [<c0196cb5>] ? getname+0x25/0xbc
[   12.009738]  [<c0196cb5>] getname+0x25/0xbc
[   12.009738]  [<c018d74b>] do_sys_open+0x19/0xbc
[   12.009738]  [<c018d83a>] sys_open+0x23/0x2b
[   12.009738]  [<c010329f>] sysenter_do_call+0x12/0x34
[   12.009738] ---[ end trace a1303c5fb15c200c ]---
[   12.065027] ------------[ cut here ]------------
[   12.070720] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   12.070720] Hardware name: MacBookPro2,2
[   12.070720] Modules linked in:
[   12.070720] Pid: 1018, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   12.070720] Call Trace:
[   12.070720]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.070720]  [<c0190029>] ? get_empty_filp+0x82/0x175
[   12.070720]  [<c018fd49>] ? file_free_rcu+0x35/0x38
[   12.070720]  [<c011160a>] ? flush_tlb_page+0x47/0x6e
[   12.070720]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
[   12.070720]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   12.070720]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   12.070720]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.070720]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.070720]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.070720]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.070720]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.070720]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.070720]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.070720]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.070720]  [<c03e007b>] ? schedule+0x695/0x8f1
[   12.070720]  [<c03e3ee5>] ? do_page_fault+0x272/0x6f9
[   12.070720]  [<c0190029>] ? get_empty_filp+0x82/0x175
[   12.070720]  [<c018fd49>] ? file_free_rcu+0x35/0x38
[   12.070720]  [<c018a64d>] ? check_object+0x139/0x190
[   12.070720]  [<c03e2423>] ? error_code+0x73/0x7c
[   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.070720]  [<c0240320>] ? trace_hardirqs_on_thunk+0xc/0x10
[   12.070720]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   12.070720]  [<c03e2423>] ? error_code+0x73/0x7c
[   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.070720]  [<c03e2427>] error_code+0x77/0x7c
[   12.070720] ---[ end trace a1303c5fb15c200d ]---
[   12.300395] ------------[ cut here ]------------
[   12.306909] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   12.310003] Hardware name: MacBookPro2,2
[   12.310003] Modules linked in:
[   12.310003] Pid: 999, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   12.310003] Call Trace:
[   12.310003]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.310003]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   12.310003]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   12.310003]  [<c016e6cf>] ? get_page_from_freelist+0x2a6/0x3ed
[   12.310003]  [<c0169974>] ? find_get_page+0x22/0x86
[   12.310003]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.310003]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.310003]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.310003]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.310003]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.310003]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.310003]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.310003]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.310003]  [<c03e00d8>] ? schedule+0x6f2/0x8f1
[   12.310003]  [<c013d32b>] ? down_read_trylock+0x17/0x20
[   12.310003]  [<c03e3f32>] do_page_fault+0x2bf/0x6f9
[   12.310003]  [<c011e70c>] ? set_next_entity+0xa7/0x113
[   12.310003]  [<c014129b>] ? getnstimeofday+0x56/0xdf
[   12.310003]  [<c023de7b>] ? rb_insert_color+0x9b/0xc0
[   12.310003]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   12.310003]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
[   12.310003]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   12.310003]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
[   12.310003]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   12.310003]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   12.310003]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
[   12.310003]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   12.310003]  [<c03e2423>] ? error_code+0x73/0x7c
[   12.310003]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.310003]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.310003]  [<c03e2427>] error_code+0x77/0x7c
[   12.310003] ---[ end trace a1303c5fb15c200e ]---
[   12.547900] ------------[ cut here ]------------
[   12.554293] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   12.555950] Hardware name: MacBookPro2,2
[   12.555950] Modules linked in:
[   12.555950] Pid: 998, comm: udevd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   12.555950] Call Trace:
[   12.555950]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.555950]  [<c018a64d>] ? check_object+0x139/0x190
[   12.601146]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   12.601146]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   12.601146]  [<c018bcfd>] ? kfree+0xd5/0xe9
[   12.601146]  [<c015c92f>] ? call_rcu+0x63/0x74
[   12.601146]  [<c018fd0e>] ? put_filp+0x47/0x4d
[   12.601146]  [<c0196c53>] ? release_open_intent+0x16/0x1f
[   12.601146]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.601146]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.601146]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.601146]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.601146]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.601146]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.601146]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.601146]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.601146] ---[ end trace a1303c5fb15c200f ]---

[   20.550550] ------------[ cut here ]------------
[   20.550554] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.550556] Hardware name: MacBookPro2,2
[   20.550558] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.550621] Pid: 0, comm: swapper Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.550623] Call Trace:
[   20.550630]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.550635]  [<c013e562>] ? sched_clock_cpu+0x137/0x146
[   20.550639]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.550642]  [<c013c4e7>] ? hrtimer_forward+0xf9/0x10f
[   20.550646]  [<c014129b>] ? getnstimeofday+0x56/0xdf
[   20.550650]  [<c01119f4>] ? lapic_next_event+0x18/0x1c
[   20.550653]  [<c0143380>] ? clockevents_program_event+0xe0/0xef
[   20.550659]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.550662]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.550665]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.550669]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.550672]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.550677]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.550680]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.550684]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.550687]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.550699]  [<f806c727>] ? acpi_idle_enter_bm+0x2df/0x36b [processor]
[   20.550703]  [<c0144b5a>] ? tick_nohz_restart_sched_tick+0x139/0x14b
[   20.550708]  [<c031e695>] cpuidle_idle_call+0x65/0x98
[   20.550711]  [<c01023b7>] cpu_idle+0x84/0xa5
[   20.550714]  [<c03d388f>] rest_init+0x53/0x55
[   20.550717] ---[ end trace a1303c5fb15c2010 ]---
[   20.551664] ------------[ cut here ]------------
[   20.551669] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.551673] Hardware name: MacBookPro2,2
[   20.551676] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.551785] Pid: 0, comm: swapper Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.551789] Call Trace:
[   20.551797]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.551805]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.551812]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[   20.551819]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.551828]  [<c02ce674>] ? scsi_eh_scmd_add+0x83/0x8c
[   20.551835]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.551842]  [<c02ce674>] ? scsi_eh_scmd_add+0x83/0x8c
[   20.551849]  [<c02ce6cf>] ? scsi_times_out+0x52/0x6c
[   20.551856]  [<c0235c66>] ? blk_rq_timed_out+0x11/0x4b
[   20.551863]  [<c0235ce3>] ? blk_abort_request+0x43/0x46
[   20.551870]  [<c02ebb5c>] ? ata_qc_schedule_eh+0x49/0x50
[   20.551877]  [<c02e1d9f>] ? ata_qc_complete+0x75/0x1a9
[   20.551884]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.551892]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.551899]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.551906]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.551914]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.551921]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.551928]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.551934]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.551954]  [<f806c727>] ? acpi_idle_enter_bm+0x2df/0x36b [processor]
[   20.551961]  [<c0144b5a>] ? tick_nohz_restart_sched_tick+0x139/0x14b
[   20.551969]  [<c031e695>] cpuidle_idle_call+0x65/0x98
[   20.551975]  [<c01023b7>] cpu_idle+0x84/0xa5
[   20.551982]  [<c03d388f>] rest_init+0x53/0x55
[   20.551986] ---[ end trace a1303c5fb15c2011 ]---
[   20.558509] ------------[ cut here ]------------
[   20.558512] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.558514] Hardware name: MacBookPro2,2
[   20.558516] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.558573] Pid: 2519, comm: hald-addon-macb Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.558575] Call Trace:
[   20.558580]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.558585]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   20.558588]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.558600]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   20.558600]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   20.558600]  [<c023c89f>] ? prio_tree_insert+0x18c/0x1ff
[   20.558602]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.558606]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.558610]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   20.558613]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.558617]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.558630]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.558630]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.558630]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.558631]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.558633] ---[ end trace a1303c5fb15c2012 ]---
[   20.623177] ------------[ cut here ]------------
[   20.623181] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.623184] Hardware name: MacBookPro2,2
[   20.623185] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.623245] Pid: 2519, comm: hald-addon-macb Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.623247] Call Trace:
[   20.623252]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.623257]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   20.623260]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.623264]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   20.623267]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   20.623272]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   20.623276]  [<c017e7d2>] ? vma_adjust+0x31a/0x378
[   20.623279]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.623283]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.623286]  [<c017f421>] ? mmap_region+0x17e/0x435
[   20.623289]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.623293]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.623296]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.623300]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.623304]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.623307]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.623309] ---[ end trace a1303c5fb15c2013 ]---
[   20.624217] ------------[ cut here ]------------
[   20.624220] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.624222] Hardware name: MacBookPro2,2
[   20.624224] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.624279] Pid: 2519, comm: hald-addon-macb Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.624281] Call Trace:
[   20.624285]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.624289]  [<c023fac6>] ? vsnprintf+0x866/0x8c5
[   20.624293]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.624296]  [<c01299ba>] ? release_console_sem+0x1b8/0x1e5
[   20.624300]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.624303]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.624307]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.624310]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.624314]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.624317]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.624320]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.624323]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.624328]  [<c017734f>] ? __inc_zone_state+0x1b/0x7b
[   20.624331]  [<c01773cc>] __inc_zone_page_state+0x1d/0x1f
[   20.624334]  [<c018168f>] page_add_new_anon_rmap+0x44/0x6a
[   20.624338]  [<c017b2a5>] handle_mm_fault+0x1fe/0x606
[   20.624343]  [<c02155a8>] ? selinux_socket_unix_stream_connect+0xa4/0xac
[   20.624346]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   20.624349]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   20.624352]  [<c03e20e4>] ? _read_unlock+0xd/0xf
[   20.624357]  [<c03454d3>] ? sock_def_readable+0x60/0x65
[   20.624362]  [<c03acb34>] ? unix_stream_connect+0x338/0x398
[   20.624365]  [<c0343d18>] ? sys_connect+0x65/0x82
[   20.624368]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.624371]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   20.624374]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   20.624379]  [<c01326c9>] ? do_sigaction+0x13d/0x14e
[   20.624382]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.624385]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   20.624388]  [<c03e2423>] ? error_code+0x73/0x7c
[   20.624391]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   20.624394]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   20.624397]  [<c03e2427>] error_code+0x77/0x7c
[   20.624400] ---[ end trace a1303c5fb15c2014 ]---
[   20.625285] ------------[ cut here ]------------
[   20.625288] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.625290] Hardware name: MacBookPro2,2
[   20.625292] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.625344] Pid: 2466, comm: hald Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.625346] Call Trace:
[   20.625349]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.625353]  [<c0213328>] ? selinux_socket_recvmsg+0x1a/0x1c
[   20.625357]  [<c0342ccb>] ? sock_aio_read+0x109/0x117
[   20.625361]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.625364]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.625367]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.625371]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.625374]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.625377]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.625381]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.625384]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.625386] ---[ end trace a1303c5fb15c2015 ]---
[   20.660553] ------------[ cut here ]------------
[   20.660556] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.660558] Hardware name: MacBookPro2,2
[   20.660560] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.660619] Pid: 2519, comm: hald-addon-macb Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.660621] Call Trace:
[   20.660626]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.660631]  [<c013cca6>] ? hrtimer_cancel+0x12/0x1d
[   20.660635]  [<c03e1285>] ? schedule_hrtimeout_range+0x10b/0x12a
[   20.660639]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660642]  [<c03e2148>] ? _spin_unlock_irqrestore+0x2d/0x3c
[   20.660647]  [<c013a41e>] ? remove_wait_queue+0x35/0x39
[   20.660651]  [<c019a87b>] ? poll_freewait+0x34/0x7d
[   20.660654]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.660658]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.660661]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   20.660665]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.660668]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.660672]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.660676]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.660679]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.660682]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.660687]  [<c016e758>] ? get_page_from_freelist+0x32f/0x3ed
[   20.660691]  [<c016ea87>] __alloc_pages_internal+0x9b/0x36a
[   20.660694]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660697]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660700]  [<c016ed6f>] get_zeroed_page+0x19/0x2b
[   20.660704]  [<c01c82f5>] sysfs_follow_link+0x22/0x13d
[   20.660708]  [<c01971a5>] __link_path_walk+0x459/0xc5a
[   20.660712]  [<c0215291>] ? selinux_file_alloc_security+0x2d/0x46
[   20.660715]  [<c0197b43>] path_walk+0x55/0xaa
[   20.660718]  [<c0197d66>] do_path_lookup+0x145/0x18d
[   20.660721]  [<c0197e50>] path_lookup_open+0x4b/0x7c
[   20.660724]  [<c01988d6>] do_filp_open+0xa8/0x6e8
[   20.660728]  [<c018bb89>] ? __slab_alloc+0x409/0x4a8
[   20.660731]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660734]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660737]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.660739]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.660743]  [<c018d779>] do_sys_open+0x47/0xbc
[   20.660746]  [<c018d83a>] sys_open+0x23/0x2b
[   20.660749]  [<c010329f>] sysenter_do_call+0x12/0x34
[   20.660751] ---[ end trace a1303c5fb15c2016 ]---
[   20.662220] ------------[ cut here ]------------
[   20.662223] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.662225] Hardware name: MacBookPro2,2
[   20.662226] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.662280] Pid: 2423, comm: klogd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.662282] Call Trace:
[   20.662286]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.662290]  [<c03e0b94>] ? __mutex_lock_slowpath+0x25b/0x263
[   20.662293]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.662296]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.662298]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.662302]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   20.662306]  [<c01a1823>] ? mnt_drop_write+0x68/0xcc
[   20.662309]  [<c019e22a>] ? touch_atime+0xa5/0xbf
[   20.662313]  [<c019541e>] ? pipe_read+0x2f7/0x305
[   20.662316]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.662320]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.662323]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.662327]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.662330]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.662334]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.662337]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.662340]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.662342] ---[ end trace a1303c5fb15c2017 ]---
[   20.663258] ------------[ cut here ]------------
[   20.663260] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x49c/0x6d0()
[   20.663262] Hardware name: MacBookPro2,2
[   20.663264] Modules linked in: fan battery container ipt_LOG xt_limit 
xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware 
uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave 
cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 
firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 
thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac 
button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm 
snd_page_alloc pata_acpi evdev
[   20.663318] Pid: 2420, comm: dd Tainted: G        W  
2.6.28-07812-g5fbbf5f #9
[   20.663320] Call Trace:
[   20.663323]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.663327]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.663331]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[   20.663334]  [<c011bbac>] ? update_curr+0xae/0x189
[   20.663337]  [<c01206a1>] ? enqueue_entity+0x26c/0x274
[   20.663341]  [<c011b7ad>] ? resched_task+0x25/0x69
[   20.663344]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.663347]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.663351]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.663354]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.663358]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.663361]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.663364]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.663368]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.663371]  [<c03e007b>] ? schedule+0x695/0x8f1
[   20.663374]  [<c03e2111>] ? _spin_unlock_irq+0x14/0x1e
[   20.663378]  [<c0125c92>] finish_task_switch+0x37/0x8a
[   20.663381]  [<c03e026d>] schedule+0x887/0x8f1
[   20.663385]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   20.663388]  [<c0103210>] ? resume_userspace+0x14/0x28
[   20.663391]  [<c010344e>] work_resched+0x5/0x2d
[   20.663393] ---[ end trace a1303c5fb15c2018 ]---

this was just after compiling. rebooted to this.
seems harmless,(just warnings);


regards;

Justin P. Mattock






--------------000206020700080805030608
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="dmesg"

[    0.000000] Linux version 2.6.28-07812-g5fbbf5f (root@unix) (gcc version 4.3.3 20081217 (prerelease) (Ubuntu 4.3.2-2ubuntu9) ) #9 SMP Thu Jan 8 15:57:17 PST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-d000
[    0.000000] init_ohci1394_dma: initializing OHCI-1394 at 0c:03.0
[    0.000000] init_ohci1394_dma: finished initializing OHCI DMA
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       A5       1000013)
[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5 Loki       5F)
[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002 INTL 20050309)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000 INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 120MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00009000 - 0000ff00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000669210]    TEXT DATA BSS ==> [0000100000 - 0000669210]
[    0.000000]   #4 [000066a000 - 000066d000]    INIT_PG_TABLE ==> [000066a000 - 000066d000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f0ea
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258185
[    0.000000] free_area_init_node: node 0, pgdat c053bb40, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 242 pages used for memmap
[    0.000000]   HighMem zone: 30714 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 40960 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256167
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.28-07812-g5fbbf5f root=/dev/sda1 vga=790 debug pnpacpi=off pci=routeirq acpi_osi=Darwin audit=1 selinux=1 ohci1394_dma=early enforcing=0
[    0.000000] ACPI: Added _OSI(Darwin)
[    0.000000] audit: enabled (after initialization)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using PMTIMER reference calibration
[    0.000000] Detected 2161.212 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Memory: 1017788k/1033128k available (2968k kernel code, 14592k reserved, 1457k data, 404k init, 123824k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfff9e000 - 0xfffff000   ( 388 kB)
[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.010000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.010000]       .init : 0xc055a000 - 0xc05bf000   ( 404 kB)
[    0.010000]       .data : 0xc03e635e - 0xc05529c4   (1457 kB)
[    0.010000]       .text : 0xc0100000 - 0xc03e635e   (2968 kB)
[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.010000] hpet clockevent registered
[    0.010000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4322.42 BogoMIPS (lpj=21612120)
[    0.010000] Security Framework initialized
[    0.010000] SELinux:  Initializing.
[    0.010000] SELinux:  Starting in permissive mode
[    0.010000] Failure registering Root Plug module with the kernel
[    0.010000] Mount-cache hash table entries: 512
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] [ds] using core 2 configuration
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#0.
[    0.010000] using mwait in idle threads.
[    0.010000] Checking 'hlt' instruction... OK.
[    0.041107] ACPI: Core revision 20080926
[    0.061151] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.061159] ftrace: allocating 15027 entries in 59 pages
[    0.067219]   alloc irq_2_pin on cpu 0 node 0
[    0.067228]   alloc irq_2_pin on cpu 0 node 0
[    0.067234]   alloc irq_2_pin on cpu 0 node 0
[    0.067240]   alloc irq_2_pin on cpu 0 node 0
[    0.067246]   alloc irq_2_pin on cpu 0 node 0
[    0.067252]   alloc irq_2_pin on cpu 0 node 0
[    0.067258]   alloc irq_2_pin on cpu 0 node 0
[    0.067264]   alloc irq_2_pin on cpu 0 node 0
[    0.067270]   alloc irq_2_pin on cpu 0 node 0
[    0.067275]   alloc irq_2_pin on cpu 0 node 0
[    0.067281]   alloc irq_2_pin on cpu 0 node 0
[    0.067287]   alloc irq_2_pin on cpu 0 node 0
[    0.067293]   alloc irq_2_pin on cpu 0 node 0
[    0.067299]   alloc irq_2_pin on cpu 0 node 0
[    0.067304]   alloc irq_2_pin on cpu 0 node 0
[    0.067461] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.167480] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.170000] Testing tracer nop: PASSED
[    0.170000] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 4322.51 BogoMIPS (lpj=21612593)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] [ds] using core 2 configuration
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#1.
[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.321750] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.321786] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.330032] Brought up 2 CPUs
[    0.330037] Total of 2 processors activated (8644.94 BogoMIPS).
[    0.330104] CPU0 attaching sched-domain:
[    0.330109]  domain 0: span 0-1 level MC
[    0.330113]   groups: 0 1
[    0.330120] CPU1 attaching sched-domain:
[    0.330123]  domain 0: span 0-1 level MC
[    0.330127]   groups: 1 0
[    0.330215] net_namespace: 800 bytes
[    0.330215] Booting paravirtualized kernel on bare hardware
[    0.330327] NET: Registered protocol family 16
[    0.330327] EISA bus registered
[    0.330327] ACPI: bus type pci registered
[    0.330327] PCI: Using configuration type 1 for base access
[    0.340112] bio: create slab <bio-0> at 0
[    0.341245] ACPI: EC: EC description table is found, configuring boot EC
[    0.341497] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.355528] ACPI: Interpreter enabled
[    0.355536] ACPI: (supports S0 S3 S4 S5)
[    0.355609] ACPI: Using IOAPIC for interrupt routing
[    0.371528] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.371528] ACPI: EC: driver started in interrupt mode
[    0.371528] ACPI: No dock devices found.
[    0.371528] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.371528] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.371528] pci 0000:00:01.0: PME# disabled
[    0.371528] pci 0000:00:07.0: reg 10 32bit mmio: [0x50404000-0x50404fff]
[    0.371528] pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
[    0.371528] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.371528] pci 0000:00:1b.0: PME# disabled
[    0.371528] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.371528] pci 0000:00:1c.0: PME# disabled
[    0.371528] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.371528] pci 0000:00:1c.1: PME# disabled
[    0.371528] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.371528] pci 0000:00:1c.2: PME# disabled
[    0.371528] pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
[    0.371528] pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
[    0.371528] pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
[    0.371528] pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
[    0.371528] pci 0000:00:1d.7: reg 10 32bit mmio: [0x50405400-0x504057ff]
[    0.371528] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.371528] pci 0000:00:1d.7: PME# disabled
[    0.371528] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.371528] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.371528] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    0.371528] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
[    0.371528] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
[    0.371528] pci 0000:00:1f.1: reg 10 io port: [0x40d8-0x40df]
[    0.371528] pci 0000:00:1f.1: reg 14 io port: [0x40ec-0x40ef]
[    0.371528] pci 0000:00:1f.1: reg 18 io port: [0x40d0-0x40d7]
[    0.371528] pci 0000:00:1f.1: reg 1c io port: [0x40e8-0x40eb]
[    0.371528] pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
[    0.371528] pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
[    0.371528] pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
[    0.371528] pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
[    0.371528] pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
[    0.371528] pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
[    0.371528] pci 0000:00:1f.2: reg 24 32bit mmio: [0x50405000-0x504053ff]
[    0.371528] pci 0000:00:1f.2: PME# supported from D3hot
[    0.371528] pci 0000:00:1f.2: PME# disabled
[    0.371588] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.371666] pci 0000:01:00.0: reg 10 32bit mmio: [0x40000000-0x47ffffff]
[    0.371677] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
[    0.371687] pci 0000:01:00.0: reg 18 32bit mmio: [0x50300000-0x5030ffff]
[    0.371709] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.371741] pci 0000:01:00.0: supports D1 D2
[    0.371803] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    0.371809] pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
[    0.371816] pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x47ffffff]
[    0.371899] pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x50203fff]
[    0.371912] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
[    0.371950] pci 0000:02:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.372009] pci 0000:02:00.0: supports D1 D2
[    0.372012] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.372021] pci 0000:02:00.0: PME# disabled
[    0.372087] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.372094] pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
[    0.372175] pci 0000:03:00.0: reg 10 64bit mmio: [0x50100000-0x5010ffff]
[    0.372272] pci 0000:03:00.0: supports D1
[    0.372276] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.372284] pci 0000:03:00.0: PME# disabled
[    0.372362] pci 0000:00:1c.1: bridge 32bit mmio: [0x50100000-0x501fffff]
[    0.372431] pci 0000:00:1c.2: bridge io port: [0x1000-0x1fff]
[    0.372438] pci 0000:00:1c.2: bridge 32bit mmio: [0x4c100000-0x500fffff]
[    0.372448] pci 0000:00:1c.2: bridge 64bit mmio pref: [0x48000000-0x4bffffff]
[    0.372508] pci 0000:0c:03.0: reg 10 32bit mmio: [0x4c004000-0x4c0047ff]
[    0.372519] pci 0000:0c:03.0: reg 14 32bit mmio: [0x4c000000-0x4c003fff]
[    0.372587] pci 0000:0c:03.0: supports D1 D2
[    0.372591] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.372598] pci 0000:0c:03.0: PME# disabled
[    0.380057] pci 0000:00:1e.0: transparent bridge
[    0.380066] pci 0000:00:1e.0: bridge 32bit mmio: [0x4c000000-0x4c0fffff]
[    0.380105] pci_bus 0000:00: on NUMA node 0
[    0.380119] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.381972] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.382568] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.383151] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.383731] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.384339] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.401133] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401133] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.401133] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401133] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.401401] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.401689] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.410231] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.410516] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.410634] SCSI subsystem initialized
[    0.410634] libata version 3.00 loaded.
[    0.410634] usbcore: registered new interface driver usbfs
[    0.410634] usbcore: registered new interface driver hub
[    0.410634] usbcore: registered new device driver usb
[    0.410634] PCI: Using ACPI for IRQ routing
[    0.410634] PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
[    0.410634]   alloc irq_2_pin on cpu 0 node 0
[    0.410634] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410634] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410634]   alloc irq_2_pin on cpu 0 node 0
[    0.410634] pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.410634]   alloc irq_2_pin on cpu 0 node 0
[    0.410634] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.410634] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.410634]   alloc irq_2_pin on cpu 0 node 0
[    0.410634] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.410634]   alloc irq_2_pin on cpu 0 node 0
[    0.410634] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.410634]   alloc irq_2_pin on cpu 0 node 0
[    0.410634] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410634] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.410634] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.410634] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.410634] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.410634] pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410634] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410634] vendor=8086 device=27a1
[    0.410634] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410634] vendor=8086 device=27d0
[    0.410634] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410634] vendor=8086 device=27d2
[    0.410634] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.410634] vendor=8086 device=2448
[    0.410634] pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.440091] cfg80211: Using static regulatory domain info
[    0.440091] cfg80211: Regulatory domain: US
[    0.440091] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.440091] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.440091] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440091] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440091] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440091] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440091] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.440094] cfg80211: Calling CRDA for country: US
[    0.440122] NetLabel: Initializing
[    0.440122] NetLabel:  domain hash size = 128
[    0.440122] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.440141] NetLabel:  unlabeled traffic allowed by default
[    0.440155] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.440162] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.470029] pnp: PnP ACPI: disabled
[    0.501822] Switched to high resolution mode on CPU 1
[    0.505909] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.505917] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.505923] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    0.505929] pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x00000047ffffff
[    0.505938] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.505944] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.505952] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    0.505959] pci 0000:00:1c.0:   PREFETCH window: 0x00000050500000-0x000000505fffff
[    0.505970] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.505974] pci 0000:00:1c.1:   IO window: disabled
[    0.505982] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
[    0.505988] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.505998] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.506003] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.506012] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
[    0.506019] pci 0000:00:1c.2:   PREFETCH window: 0x00000048000000-0x0000004bffffff
[    0.506030] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.506033] pci 0000:00:1e.0:   IO window: disabled
[    0.506041] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
[    0.506048] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.506061] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.506067] pci 0000:00:01.0: setting latency timer to 64
[    0.506074] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.506082] pci 0000:00:1c.0: setting latency timer to 64
[    0.506090] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.506097] pci 0000:00:1c.1: setting latency timer to 64
[    0.506104] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.506112] pci 0000:00:1c.2: setting latency timer to 64
[    0.510004] Switched to high resolution mode on CPU 0
[    0.510545] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.510555] pci 0000:00:1e.0: setting latency timer to 64
[    0.510561] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.510566] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.510570] pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
[    0.510574] pci_bus 0000:01: resource 1 mem: [0x50300000-0x503fffff]
[    0.510578] pci_bus 0000:01: resource 2 mem: [0x40000000-0x47ffffff]
[    0.510582] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.510586] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.510590] pci_bus 0000:02: resource 1 mem: [0x50200000-0x502fffff]
[    0.510594] pci_bus 0000:02: resource 2 mem: [0x50500000-0x505fffff]
[    0.510598] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.510602] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.510606] pci_bus 0000:03: resource 1 mem: [0x50100000-0x501fffff]
[    0.510610] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.510613] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.510617] pci_bus 0000:04: resource 0 io:  [0x1000-0x1fff]
[    0.510621] pci_bus 0000:04: resource 1 mem: [0x4c100000-0x500fffff]
[    0.510625] pci_bus 0000:04: resource 2 mem: [0x48000000-0x4bffffff]
[    0.510629] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.510633] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
[    0.510637] pci_bus 0000:0c: resource 1 mem: [0x4c000000-0x4c0fffff]
[    0.510641] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
[    0.510645] pci_bus 0000:0c: resource 3 io:  [0x00-0xffff]
[    0.510648] pci_bus 0000:0c: resource 4 mem: [0x000000-0xffffffff]
[    0.510682] NET: Registered protocol family 2
[    0.540086] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.540448] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.540898] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
[    0.541448] TCP: Hash tables configured (established 131072 bind 65536)
[    0.541453] TCP reno registered
[    0.550163] NET: Registered protocol family 1
[    0.551235] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.553512] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.555127] Initializing RT-Tester: OK
[    0.555257] audit: initializing netlink socket (enabled)
[    0.555322] type=2000 audit(1231459427.550:1): initialized
[    0.558397] Testing tracer sched_switch: PASSED
[    0.660046] Testing tracer function: PASSED
[    0.790743] Testing dynamic ftrace: PASSED
[    1.030058] Testing tracer irqsoff: PASSED
[    1.040354] Testing tracer wakeup: PASSED
[    1.370268] highmem bounce pool size: 64 pages
[    1.370277] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.388688] fuse init (API version 7.11)
[    1.389362] msgmni has been set to 1746
[    1.389625] SELinux:  Registering netfilter hooks
[    1.390488] alg: No test for stdrng (krng)
[    1.390507] io scheduler noop registered
[    1.390888] io scheduler cfq registered (default)
[    1.391044] pci 0000:01:00.0: Boot video device
[    1.391734] vesafb: framebuffer at 0x40000000, mapped to 0xf8100000, using 3072k, total 16384k
[    1.391741] vesafb: mode is 1024x768x16, linelength=2048, pages=9
[    1.391745] vesafb: protected mode interface info at c000:ad0c
[    1.391749] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
[    1.391753] vesafb: scrolling: redraw
[    1.391757] vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
[    1.416121] Console: switching to colour frame buffer device 128x48
[    1.438335] fb0: VESA VGA frame buffer device
[    1.453873] loop: module loaded
[    1.454025] Linux video capture interface: v2.00
[    1.454514] input: Macintosh mouse button emulation as /class/input/input0
[    1.455175] Driver 'sd' needs updating - please use bus_type methods
[    1.455577] Driver 'sr' needs updating - please use bus_type methods
[    1.456262] ata_piix 0000:00:1f.1: version 2.12
[    1.456568] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    1.456867] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.457240] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.457606] scsi0 : ata_piix
[    1.458305] scsi1 : ata_piix
[    1.460476] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    1.460797] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    1.461136] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.461584] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    1.620021] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.631397] scsi2 : ata_piix
[    1.639179] scsi3 : ata_piix
[    1.642999] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    1.658248] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    1.665969] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    1.673977] usbcore: registered new interface driver usblcd
[    1.681822] usbcore: registered new interface driver usbled
[    1.682913] ata1.00: configured for UDMA/66
[    1.698133] PNP: No PS/2 controller found. Probing ports directly.
[    1.706934] i8042.c: No controller found.
[    1.714799] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D  KCV9 PQ: 0 ANSI: 5
[    1.723637] mice: PS/2 mouse device common for all mice
[    1.731716] ------------[ cut here ]------------
[    1.739745] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[    1.741682] Hardware name: MacBookPro2,2
[    1.741682] Modules linked in:
[    1.741682] Pid: 1, comm: swapper Not tainted 2.6.28-07812-g5fbbf5f #9
[    1.741682] Call Trace:
[    1.741682]  [<c01292ca>] warn_slowpath+0x76/0xad
[    1.741682]  [<c0263865>] ? cfb_fillrect+0x182/0x275
[    1.741682]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    1.741682]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    1.741682]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    1.741682]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    1.741682]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    1.741682]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    1.741682]  [<c0104bc9>] do_IRQ+0x92/0xad
[    1.741682]  [<c010396c>] common_interrupt+0x2c/0x34
[    1.741682]  [<c012007b>] ? sched_debug_show+0x803/0xbbd
[    1.741682]  [<c012da4f>] ? __do_softirq+0x6b/0x154
[    1.741682]  [<c012db6c>] ? do_softirq+0x34/0x7e
[    1.741682]  [<c012db8a>] do_softirq+0x52/0x7e
[    1.741682]  [<c012dcd6>] irq_exit+0x49/0x77
[    1.741682]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
[    1.741682]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
[    1.741682]  [<c0129e84>] ? vprintk+0x2aa/0x2d5
[    1.741682]  [<c03df731>] printk+0x14/0x1b
[    1.741682]  [<c05780e8>] mousedev_init+0x70/0x78
[    1.741682]  [<c0101137>] _stext+0x4f/0x127
[    1.741682]  [<c0578078>] ? mousedev_init+0x0/0x78
[    1.741682]  [<c015be1c>] ? register_irq_proc+0x84/0xa0
[    1.741682]  [<c015be90>] ? init_irq_proc+0x58/0x65
[    1.741682]  [<c055a309>] kernel_init+0x105/0x156
[    1.741682]  [<c055a204>] ? kernel_init+0x0/0x156
[    1.741682]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
[    1.741682] ---[ end trace a1303c5fb15c2002 ]---
[    1.991585] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.999594] EDAC MC: Ver: 2.1.0 Jan  8 2009
[    2.008048] cpuidle: using governor ladder
[    2.013026] ------------[ cut here ]------------
[    2.013028] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[    2.013030] Hardware name: MacBookPro2,2
[    2.013031] Modules linked in:
[    2.013033] Pid: 578, comm: scsi_eh_3 Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[    2.013035] Call Trace:
[    2.013038]  [<c01292ca>] warn_slowpath+0x76/0xad
[    2.013042]  [<c011bbac>] ? update_curr+0xae/0x189
[    2.013045]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[    2.013048]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    2.013050]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    2.013053]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    2.013056]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    2.013059]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    2.013061]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    2.013064]  [<c0104bc9>] do_IRQ+0x92/0xad
[    2.013066]  [<c010396c>] common_interrupt+0x2c/0x34
[    2.013068]  [<c012007b>] ? sched_debug_show+0x803/0xbbd
[    2.013071]  [<c012da4f>] ? __do_softirq+0x6b/0x154
[    2.013073]  [<c012db6c>] ? do_softirq+0x34/0x7e
[    2.013075]  [<c012db8a>] do_softirq+0x52/0x7e
[    2.013077]  [<c012dcd6>] irq_exit+0x49/0x77
[    2.013080]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
[    2.013082]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
[    2.013085]  [<c03e007b>] ? schedule+0x695/0x8f1
[    2.013088]  [<c03e214c>] ? _spin_unlock_irqrestore+0x31/0x3c
[    2.013090]  [<c02e8818>] ata_eh_thaw_port+0x3b/0x3f
[    2.013093]  [<c02e94b4>] ata_eh_reset+0x6cc/0x9bd
[    2.013096]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[    2.013098]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
[    2.013101]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013105]  [<c02e032a>] ? ata_dev_init+0x5d/0x80
[    2.013107]  [<c02ead0a>] ata_eh_recover+0x29c/0xafd
[    2.013110]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013112]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
[    2.013115]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013117]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
[    2.013120]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[    2.013122]  [<c011ef1c>] ? dequeue_task_fair+0x5c/0x61
[    2.013125]  [<c0101e73>] ? __switch_to+0xce/0x14f
[    2.013127]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[    2.013130]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[    2.013132]  [<c0125c92>] ? finish_task_switch+0x37/0x8a
[    2.013134]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[    2.013137]  [<c0131627>] ? lock_timer_base+0x24/0x43
[    2.013140]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013143]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
[    2.013145]  [<c02eb6f8>] ata_do_eh+0x30/0x72
[    2.013148]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
[    2.013150]  [<c02ecf19>] ata_sff_error_handler+0x12b/0x135
[    2.013153]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
[    2.013155]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
[    2.013158]  [<c02ebec7>] ata_scsi_error+0x2b5/0x5e6
[    2.013162]  [<c02ce15b>] scsi_error_handler+0xc1/0x454
[    2.013164]  [<c012390a>] ? default_wake_function+0x10/0x12
[    2.013167]  [<c03e2148>] ? _spin_unlock_irqrestore+0x2d/0x3c
[    2.013169]  [<c011e4d1>] ? complete+0x39/0x43
[    2.013171]  [<c02ce09a>] ? scsi_error_handler+0x0/0x454
[    2.013175]  [<c0139f9c>] kthread+0x40/0x66
[    2.013178]  [<c0139f5c>] ? kthread+0x0/0x66
[    2.013180]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
[    2.013182] ---[ end trace a1303c5fb15c2003 ]---
[    2.418087] cpuidle: using governor menu
[    2.420564] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    2.420566] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.436869] ------------[ cut here ]------------
[    2.442849] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[    2.446154] Hardware name: MacBookPro2,2
[    2.446154] Modules linked in:
[    2.446154] Pid: 1, comm: swapper Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[    2.446154] Call Trace:
[    2.446154]  [<c01292ca>] warn_slowpath+0x76/0xad
[    2.446154]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[    2.446154]  [<c0101e73>] ? __switch_to+0xce/0x14f
[    2.446154]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[    2.446154]  [<c0243563>] ? _raw_spin_trylock+0xf/0x30
[    2.446154]  [<c0125c92>] ? finish_task_switch+0x37/0x8a
[    2.446154]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    2.446154]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    2.446154]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    2.446154]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    2.446154]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    2.446154]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    2.446154]  [<c0104bc9>] do_IRQ+0x92/0xad
[    2.446154]  [<c010396c>] common_interrupt+0x2c/0x34
[    2.446154]  [<c01c00d8>] ? proc_task_readdir+0x76/0x283
[    2.446154]  [<c0243830>] ? _raw_spin_lock+0x0/0xf8
[    2.446154]  [<c03e21f4>] ? _spin_lock+0xd/0xf
[    2.446154]  [<c01c79a1>] sysfs_new_dirent+0x5a/0xe0
[    2.446154]  [<c01c7347>] sysfs_add_file_mode+0x2b/0x72
[    2.446154]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[    2.446154]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[    2.446154]  [<c01c73a1>] sysfs_add_file+0x13/0x18
[    2.446154]  [<c01c7445>] sysfs_create_file+0x25/0x27
[    2.446154]  [<c02b2857>] driver_create_file+0x1b/0x1d
[    2.446154]  [<c02b1955>] bus_add_driver+0xd9/0x1c2
[    2.446154]  [<c02b275b>] driver_register+0x86/0xe6
[    2.446154]  [<c03215a9>] __hid_register_driver+0x43/0x68
[    2.446154]  [<c0325ba2>] ch_init+0x19/0x1b
[    2.446154]  [<c0101137>] _stext+0x4f/0x127
[    2.446154]  [<c0325b89>] ? ch_init+0x0/0x1b
[    2.446154]  [<c015be1c>] ? register_irq_proc+0x84/0xa0
[    2.446154]  [<c015be90>] ? init_irq_proc+0x58/0x65
[    2.446154]  [<c055a309>] kernel_init+0x105/0x156
[    2.446154]  [<c055a204>] ? kernel_init+0x0/0x156
[    2.446154]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
[    2.446154] ---[ end trace a1303c5fb15c2004 ]---
[    2.716828] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.723345] Uniform CD-ROM driver Revision: 3.20
[    2.730033] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.730551] usbcore: registered new interface driver hiddev
[    2.730678] usbcore: registered new interface driver usbhid
[    2.730682] usbhid: v2.6:USB HID core driver
[    2.730815] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    2.730948] ALSA device list:
[    2.730949]   No soundcards found.
[    2.731177] oprofile: using NMI interrupt.
[    2.731457] IPVS: Registered protocols (TCP, AH, ESP)
[    2.731645] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[    2.731678] IPVS: ipvs loaded.
[    2.732016] Initializing XFRM netlink socket
[    2.732045] NET: Registered protocol family 17
[    2.732052] NET: Registered protocol family 15
[    2.732076] Using IPI No-Shortcut mode
[    2.824729] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.918677] ata3.01: configured for UDMA/100
[    2.925304] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5
[    2.932641] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    2.932659] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.932685] sd 2:0:1:0: [sda] Write Protect is off
[    2.932687] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.932737] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.932828] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.932854] sd 2:0:1:0: [sda] Write Protect is off
[    2.932856] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.932904] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.932907]  sda: sda1 sda2
[    3.005746] sd 2:0:1:0: [sda] Attached SCSI disk
[    3.101785] kjournald starting.  Commit interval 5 seconds
[    3.101804] EXT3-fs: mounted filesystem with ordered data mode.
[    3.101836] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    3.125701] Freeing unused kernel memory: 404k freed
[    3.741752] SELinux: 8192 avtab hash slots, 145595 rules.
[    3.841778] SELinux: 8192 avtab hash slots, 145595 rules.
[    4.020490] SELinux:  7 users, 9 roles, 2684 types, 95 bools, 1 sens, 256 cats
[    4.028803] SELinux:  73 classes, 145595 rules
[    4.043720] SELinux:  class kernel_service not defined in policy
[    4.052375] SELinux: the above unknown classes and permissions will be denied
[    4.060934] SELinux:  Completing initialization.
[    4.069411] SELinux:  Setting up existing superblocks.
[    4.107025] SELinux: initialized (dev sda1, type ext3), uses xattr
[    4.262397] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    4.270995] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    4.279530] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[    4.288267] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    4.296993] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[    4.305715] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.314409] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    4.323285] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    4.332188] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    4.341186] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    4.350053] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    4.358842] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    4.367571] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    4.376340] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.426230] type=1403 audit(1231459431.420:2): policy loaded auid=4294967295 ses=4294967295
[    5.116633] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.572098] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.655227] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   10.080513] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   10.336705] ------------[ cut here ]------------
[   10.354651] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   10.354651] Hardware name: MacBookPro2,2
[   10.354651] Modules linked in:
[   10.354651] Pid: 889, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   10.354651] Call Trace:
[   10.354651]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.354651]  [<c011b7ad>] ? resched_task+0x25/0x69
[   10.354651]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   10.354651]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[   10.354651]  [<c016e6cf>] ? get_page_from_freelist+0x2a6/0x3ed
[   10.354651]  [<c0169974>] ? find_get_page+0x22/0x86
[   10.354651]  [<c016ea87>] ? __alloc_pages_internal+0x9b/0x36a
[   10.354651]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.354651]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.354651]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.354651]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.354651]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.354651]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.354651]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.354651]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.354651]  [<c03e007b>] ? schedule+0x695/0x8f1
[   10.354651]  [<c03e3ee5>] ? do_page_fault+0x272/0x6f9
[   10.354651]  [<c011e70c>] ? set_next_entity+0xa7/0x113
[   10.354651]  [<c011eeb9>] ? pick_next_task_fair+0x73/0x7a
[   10.354651]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   10.354651]  [<c018a64d>] ? check_object+0x139/0x190
[   10.354651]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.354651]  [<c0240320>] ? trace_hardirqs_on_thunk+0xc/0x10
[   10.354651]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   10.354651]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.354651]  [<c03e2427>] error_code+0x77/0x7c
[   10.354651] ---[ end trace a1303c5fb15c2006 ]---
[   10.647515] ------------[ cut here ]------------
[   10.654832] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   10.656261] Hardware name: MacBookPro2,2
[   10.656261] Modules linked in:
[   10.656261] Pid: 893, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   10.656261] Call Trace:
[   10.656261]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.656261]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.656261]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.656261]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.656261]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.656261]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.656261]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.656261]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.656261]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.656261]  [<c011007b>] ? acpi_processor_ffh_cstate_enter+0x3/0x2c
[   10.656261]  [<c016a048>] ? filemap_fault+0x9/0x308
[   10.656261]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
[   10.656261]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   10.656261]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   10.656261]  [<c0179723>] __do_fault+0x40/0x345
[   10.656261]  [<c017b345>] handle_mm_fault+0x29e/0x606
[   10.656261]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   10.656261]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   10.656261]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   10.656261]  [<c018a64d>] ? check_object+0x139/0x190
[   10.656261]  [<c014129b>] ? getnstimeofday+0x56/0xdf
[   10.656261]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   10.656261]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
[   10.656261]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   10.656261]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
[   10.656261]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   10.656261]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   10.656261]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
[   10.656261]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   10.656261]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.656261]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.656261]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.656261]  [<c03e2427>] error_code+0x77/0x7c
[   10.656261] ---[ end trace a1303c5fb15c2007 ]---
[   10.910249] ------------[ cut here ]------------
[   10.916793] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   10.920003] Hardware name: MacBookPro2,2
[   10.920003] Modules linked in:
[   10.920003] Pid: 891, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   10.920003] Call Trace:
[   10.920003]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.920003]  [<c0180030>] ? move_page_tables+0x88/0x28b
[   10.920003]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   10.920003]  [<c018beb3>] ? kmem_cache_free+0xae/0xc2
[   10.920003]  [<c034872d>] ? __kfree_skb+0x73/0x76
[   10.920003]  [<c034872d>] ? __kfree_skb+0x73/0x76
[   10.920003]  [<c0348760>] ? kfree_skb+0x30/0x32
[   10.920003]  [<c03ab36c>] ? unix_dgram_sendmsg+0x437/0x47b
[   10.920003]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.920003]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.920003]  [<c017b345>] ? handle_mm_fault+0x29e/0x606
[   10.920003]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.920003]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.920003]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.920003]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.920003]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.920003]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.920003]  [<c0116eed>] ? __ticket_spin_trylock+0x4/0x21
[   10.920003]  [<c0243883>] _raw_spin_lock+0x53/0xf8
[   10.920003]  [<c018a64d>] ? check_object+0x139/0x190
[   10.920003]  [<c03e21f4>] _spin_lock+0xd/0xf
[   10.920003]  [<c023aa85>] _atomic_dec_and_lock+0x29/0x48
[   10.920003]  [<c019e26d>] iput+0x29/0x53
[   10.920003]  [<c019bea5>] dentry_iput+0x81/0x9c
[   10.920003]  [<c019bf74>] d_kill+0x32/0x4c
[   10.920003]  [<c019c663>] dput+0x101/0x10a
[   10.920003]  [<c018fed3>] __fput+0x13b/0x15c
[   10.920003]  [<c018ff12>] fput+0x1e/0x20
[   10.920003]  [<c018d67f>] filp_close+0x56/0x60
[   10.920003]  [<c018d6f8>] sys_close+0x6f/0xa9
[   10.920003]  [<c010329f>] sysenter_do_call+0x12/0x34
[   10.920003] ---[ end trace a1303c5fb15c2008 ]---
[   11.187174] ------------[ cut here ]------------
[   11.190008] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   11.196573] Hardware name: MacBookPro2,2
[   11.203397] Modules linked in:
[   11.209319] Pid: 923, comm: path_id Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   11.219223] Call Trace:
[   11.219223]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.219223]  [<c0230030>] ? elv_attr_store+0x15/0x5e
[   11.219223]  [<c011160a>] ? flush_tlb_page+0x47/0x6e
[   11.219223]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
[   11.219223]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.256355]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   11.256355]  [<c017a1b4>] ? do_wp_page+0x586/0x5eb
[   11.272445]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   11.272445]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.272445]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.272445]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.272445]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.304326]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.304326]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.304326]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.304326]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.304326]  [<c0196c85>] ? putname+0x29/0x34
[   11.304326]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   11.304326]  [<c018beb7>] ? kmem_cache_free+0xb2/0xc2
[   11.304326]  [<c0196c85>] ? putname+0x29/0x34
[   11.304326]  [<c0196c85>] putname+0x29/0x34
[   11.304326]  [<c0198701>] user_path_at+0x4a/0x67
[   11.304326]  [<c013a41e>] ? remove_wait_queue+0x35/0x39
[   11.304326]  [<c018feec>] ? __fput+0x154/0x15c
[   11.304326]  [<c018e048>] sys_chdir+0x23/0x64
[   11.304326]  [<c010329f>] sysenter_do_call+0x12/0x34
[   11.304326] ---[ end trace a1303c5fb15c2009 ]---
[   11.404868] ------------[ cut here ]------------
[   11.411491] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   11.412573] Hardware name: MacBookPro2,2
[   11.412573] Modules linked in:
[   11.412573] Pid: 966, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   11.412573] Call Trace:
[   11.412573]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.412573]  [<c0169974>] ? find_get_page+0x22/0x86
[   11.412573]  [<c0169cb5>] ? find_lock_page+0x18/0x4c
[   11.412573]  [<c016a0d0>] ? filemap_fault+0x91/0x308
[   11.412573]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.412573]  [<c0169c9a>] ? unlock_page+0x43/0x46
[   11.412573]  [<c01799f0>] ? __do_fault+0x30d/0x345
[   11.412573]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.412573]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.412573]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.412573]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.412573]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.412573]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.412573]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.412573]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.412573]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   11.412573]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.412573]  [<c0196cb5>] getname+0x25/0xbc
[   11.412573]  [<c01986d1>] user_path_at+0x1a/0x67
[   11.412573]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   11.412573]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   11.412573]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
[   11.412573]  [<c0191e60>] sys_readlinkat+0x2b/0x86
[   11.412573]  [<c0191ed3>] sys_readlink+0x18/0x1a
[   11.412573]  [<c010329f>] sysenter_do_call+0x12/0x34
[   11.412573] ---[ end trace a1303c5fb15c200a ]---
[   11.631708] ------------[ cut here ]------------
[   11.637944] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   11.640002] Hardware name: MacBookPro2,2
[   11.640002] Modules linked in:
[   11.640002] Pid: 960, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   11.640002] Call Trace:
[   11.640002]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.640002]  [<c0169974>] ? find_get_page+0x22/0x86
[   11.640002]  [<c0169cb5>] ? find_lock_page+0x18/0x4c
[   11.640002]  [<c016a0d0>] ? filemap_fault+0x91/0x308
[   11.640002]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.640002]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.640002]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.640002]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   11.640002]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.640002]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.640002]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.640002]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.640002]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.640002]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.640002]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   11.640002]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.640002]  [<c0196cb5>] getname+0x25/0xbc
[   11.640002]  [<c01986d1>] user_path_at+0x1a/0x67
[   11.640002]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
[   11.640002]  [<c0191e60>] sys_readlinkat+0x2b/0x86
[   11.640002]  [<c0191ed3>] sys_readlink+0x18/0x1a
[   11.640002]  [<c010329f>] sysenter_do_call+0x12/0x34
[   11.640002] ---[ end trace a1303c5fb15c200b ]---
[   11.859983] ------------[ cut here ]------------
[   11.863325] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   11.870937] Hardware name: MacBookPro2,2
[   11.878612] Modules linked in:
[   11.882417] Pid: 988, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   11.889932] Call Trace:
[   11.896866]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.901313]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.906787]  [<c01799f0>] ? __do_fault+0x30d/0x345
[   11.906787]  [<c0212f70>] ? avc_has_perm+0x3e/0x48
[   11.906787]  [<c018a64d>] ? check_object+0x139/0x190
[   11.932317]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.932317]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.932317]  [<c0217852>] ? selinux_inode_alloc_security+0x2e/0x73
[   11.932317]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.932317]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.932317]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.932317]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.932317]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.932317]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.932317]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.932317]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.932317]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   12.009738]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   12.009738]  [<c0196cb5>] ? getname+0x25/0xbc
[   12.009738]  [<c0196cb5>] getname+0x25/0xbc
[   12.009738]  [<c018d74b>] do_sys_open+0x19/0xbc
[   12.009738]  [<c018d83a>] sys_open+0x23/0x2b
[   12.009738]  [<c010329f>] sysenter_do_call+0x12/0x34
[   12.009738] ---[ end trace a1303c5fb15c200c ]---
[   12.065027] ------------[ cut here ]------------
[   12.070720] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   12.070720] Hardware name: MacBookPro2,2
[   12.070720] Modules linked in:
[   12.070720] Pid: 1018, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   12.070720] Call Trace:
[   12.070720]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.070720]  [<c0190029>] ? get_empty_filp+0x82/0x175
[   12.070720]  [<c018fd49>] ? file_free_rcu+0x35/0x38
[   12.070720]  [<c011160a>] ? flush_tlb_page+0x47/0x6e
[   12.070720]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
[   12.070720]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   12.070720]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   12.070720]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.070720]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.070720]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.070720]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.070720]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.070720]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.070720]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.070720]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.070720]  [<c03e007b>] ? schedule+0x695/0x8f1
[   12.070720]  [<c03e3ee5>] ? do_page_fault+0x272/0x6f9
[   12.070720]  [<c0190029>] ? get_empty_filp+0x82/0x175
[   12.070720]  [<c018fd49>] ? file_free_rcu+0x35/0x38
[   12.070720]  [<c018a64d>] ? check_object+0x139/0x190
[   12.070720]  [<c03e2423>] ? error_code+0x73/0x7c
[   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.070720]  [<c0240320>] ? trace_hardirqs_on_thunk+0xc/0x10
[   12.070720]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   12.070720]  [<c03e2423>] ? error_code+0x73/0x7c
[   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.070720]  [<c03e2427>] error_code+0x77/0x7c
[   12.070720] ---[ end trace a1303c5fb15c200d ]---
[   12.300395] ------------[ cut here ]------------
[   12.306909] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   12.310003] Hardware name: MacBookPro2,2
[   12.310003] Modules linked in:
[   12.310003] Pid: 999, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   12.310003] Call Trace:
[   12.310003]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.310003]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   12.310003]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   12.310003]  [<c016e6cf>] ? get_page_from_freelist+0x2a6/0x3ed
[   12.310003]  [<c0169974>] ? find_get_page+0x22/0x86
[   12.310003]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.310003]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.310003]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.310003]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.310003]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.310003]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.310003]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.310003]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.310003]  [<c03e00d8>] ? schedule+0x6f2/0x8f1
[   12.310003]  [<c013d32b>] ? down_read_trylock+0x17/0x20
[   12.310003]  [<c03e3f32>] do_page_fault+0x2bf/0x6f9
[   12.310003]  [<c011e70c>] ? set_next_entity+0xa7/0x113
[   12.310003]  [<c014129b>] ? getnstimeofday+0x56/0xdf
[   12.310003]  [<c023de7b>] ? rb_insert_color+0x9b/0xc0
[   12.310003]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   12.310003]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
[   12.310003]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   12.310003]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
[   12.310003]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   12.310003]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   12.310003]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
[   12.310003]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   12.310003]  [<c03e2423>] ? error_code+0x73/0x7c
[   12.310003]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.310003]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.310003]  [<c03e2427>] error_code+0x77/0x7c
[   12.310003] ---[ end trace a1303c5fb15c200e ]---
[   12.547900] ------------[ cut here ]------------
[   12.554293] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   12.555950] Hardware name: MacBookPro2,2
[   12.555950] Modules linked in:
[   12.555950] Pid: 998, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   12.555950] Call Trace:
[   12.555950]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.555950]  [<c018a64d>] ? check_object+0x139/0x190
[   12.601146]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   12.601146]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   12.601146]  [<c018bcfd>] ? kfree+0xd5/0xe9
[   12.601146]  [<c015c92f>] ? call_rcu+0x63/0x74
[   12.601146]  [<c018fd0e>] ? put_filp+0x47/0x4d
[   12.601146]  [<c0196c53>] ? release_open_intent+0x16/0x1f
[   12.601146]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.601146]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.601146]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.601146]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.601146]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.601146]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.601146]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.601146]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.601146] ---[ end trace a1303c5fb15c200f ]---
[   13.284938] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.291470] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   13.298252] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   13.304854] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   13.311515] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   13.318446] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   13.329311] ehci_hcd 0000:00:1d.7: debug port 1
[   13.336097] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   13.343004] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[   13.353762] uhci_hcd: USB Universal Host Controller Interface driver
[   13.370019] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   13.377209] usb usb1: configuration #1 chosen from 1 choice
[   13.384493] hub 1-0:1.0: USB hub found
[   13.391672] hub 1-0:1.0: 8 ports detected
[   13.399148] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   13.406480] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   13.413789] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   13.421231] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   13.428842] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[   13.436540] usb usb2: configuration #1 chosen from 1 choice
[   13.444197] hub 2-0:1.0: USB hub found
[   13.451552] hub 2-0:1.0: 2 ports detected
[   13.458975] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.466437] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   13.473771] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   13.481058] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   13.488498] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[   13.496018] usb usb3: configuration #1 chosen from 1 choice
[   13.503449] hub 3-0:1.0: USB hub found
[   13.510859] hub 3-0:1.0: 2 ports detected
[   13.518497] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   13.526175] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   13.533870] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   13.541559] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   13.549437] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[   13.557390] usb usb4: configuration #1 chosen from 1 choice
[   13.565294] hub 4-0:1.0: USB hub found
[   13.573097] hub 4-0:1.0: 2 ports detected
[   13.581087] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[   13.589132] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   13.597138] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   13.605162] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   13.613286] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[   13.621399] usb usb5: configuration #1 chosen from 1 choice
[   13.629380] hub 5-0:1.0: USB hub found
[   13.637200] hub 5-0:1.0: 2 ports detected
[   13.645307] applesmc: Apple MacBook Pro detected:
[   13.653097] applesmc:  - Model with accelerometer
[   13.660716] applesmc:  - Model with light sensors and backlight
[   13.668338] applesmc:  - Model with 12 temperature sensors
[   13.676681] applesmc: device has already been initialized (0xe0, 0x00).
[   13.684342] applesmc: device successfully initialized.
[   13.692489] applesmc: 2 fans found.
[   13.701817] input: applesmc as /class/input/input1
[   13.715662] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[   13.724496] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[   13.732983] Monitor-Mwait will be used to enter C-1 state
[   13.740617] Monitor-Mwait will be used to enter C-2 state
[   13.748040] Monitor-Mwait will be used to enter C-3 state
[   13.755584] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   13.763035] processor ACPI_CPU:00: registered as cooling_device0
[   13.770415] ACPI: Processor [CPU0] (supports 8 throttling states)
[   13.777506] Registered led device: smc::kbd_backlight
[   13.777564] applesmc: driver successfully loaded.
[   13.794571] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[   13.803173] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[   13.812001] power_supply ADP1: uevent
[   13.819503] power_supply ADP1: No power supply yet
[   13.820003] Marking TSC unstable due to TSC halts in idle
[   13.834468] power_supply ADP1: power_supply_changed
[   13.841867] ACPI: AC Adapter [ADP1] (on-line)
[   13.849641] power_supply ADP1: power_supply_changed_work
[   13.857179] power_supply ADP1: power_supply_update_gen_leds 1
[   13.864752] power_supply ADP1: uevent
[   13.872036] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   13.879354] power_supply ADP1: Static prop TYPE=Mains
[   13.886618] power_supply ADP1: 1 dynamic props
[   13.893837] power_supply ADP1: prop ONLINE=1
[   13.902140] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   13.909466] processor ACPI_CPU:01: registered as cooling_device1
[   13.916851] ACPI: Processor [CPU1] (supports 8 throttling states)
[   13.924395] input: Power Button (FF) as /class/input/input2
[   13.931737] usb 1-4: new high speed USB device using ehci_hcd and address 3
[   13.950201] ACPI: Power Button (FF) [PWRF]
[   13.958024] input: Lid Switch as /class/input/input3
[   13.968542] ACPI: Lid Switch [LID0]
[   13.976398] input: Power Button (CM) as /class/input/input4
[   14.002877] ACPI: Power Button (CM) [PWRB]
[   14.010648] input: Sleep Button (CM) as /class/input/input5
[   14.020939] ACPI: Sleep Button (CM) [SLPB]
[   14.074326] ath9k: 0.1
[   14.082114] vendor=8086 device=27d2
[   14.089785] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.097693] ath9k 0000:03:00.0: setting latency timer to 64
[   14.106683] usb 1-4: configuration #1 chosen from 1 choice
[   14.236207] wmaster0 (ath9k): not using net_device_ops yet
[   14.244537] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   14.259072] wlan0 (ath9k): not using net_device_ops yet
[   14.267523] Registered led device: ath9k-phy0:radio
[   14.275623] Registered led device: ath9k-phy0:assoc
[   14.283583] Registered led device: ath9k-phy0:tx
[   14.291543] Registered led device: ath9k-phy0:rx
[   14.299295] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81: mem=0xf87c0000, irq=17
[   14.388731] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   14.396836] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.476366] vendor=8086 device=2448
[   14.484231] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   14.535254] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   14.546047] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
[   14.555067] usbcore: registered new interface driver uvcvideo
[   14.561065] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[   14.581819] USB Video Class driver (v0.1.0)
[   14.598141] hda_codec: STAC922x, Apple subsys_id=106b1e00
[   14.652639] usb 2-2: new full speed USB device using uhci_hcd and address 2
[   14.663553] input: HDA Intel at 0x50400000 irq 22 Line In at Ext Rear Jack as /class/input/input6
[   14.675749] input: HDA Intel at 0x50400000 irq 22 HP Out at Ext Rear Jack as /class/input/input7
[   14.854162] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   14.868561] usb 2-2: configuration #1 chosen from 1 choice
[   14.888742] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input8
[   14.955922] apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input0
[   14.985518] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input9
[   15.027744] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
[   15.065440] appletouch: Geyser mode initialized.
[   15.087882] input: appletouch as /class/input/input10
[   15.102830] usbcore: registered new interface driver appletouch
[   15.119656] ieee1394: raw1394: /dev/raw1394 device initialized
[   15.300071] usb 4-2: new full speed USB device using uhci_hcd and address 2
[   15.481609] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.504556] usb 4-2: configuration #1 chosen from 1 choice
[   15.524400] generic-usb 0003:05AC:8240.0003: hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[   15.630952] nf_conntrack version 0.5.0 (16142 buckets, 64568 max)
[   15.643399] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   15.655794] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   15.668507] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   15.729891] arp_tables: (C) 2002 David S. Miller
[   15.822589] usb 5-1: new full speed USB device using uhci_hcd and address 2
[   15.847786] usbcore: registered new interface driver isight_firmware
[   15.895872] ipmi message handler version 39.2
[   15.925039] IPMI Watchdog: driver initialized
[   16.047443] usb 5-1: configuration #1 chosen from 1 choice
[   16.051353] usbhid 5-1:1.0: couldn't find an input interrupt endpoint
[   16.240682] Adding 2988360k swap on /dev/sda2.  Priority:-1 extents:1 across:2988360k 
[   16.430438] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe2ad87e]
[   16.675156] EXT3 FS on sda1, internal journal
[   19.771491] applesmc: light sensor data length set to 6
[   20.550550] ------------[ cut here ]------------
[   20.550554] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.550556] Hardware name: MacBookPro2,2
[   20.550558] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.550621] Pid: 0, comm: swapper Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.550623] Call Trace:
[   20.550630]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.550635]  [<c013e562>] ? sched_clock_cpu+0x137/0x146
[   20.550639]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.550642]  [<c013c4e7>] ? hrtimer_forward+0xf9/0x10f
[   20.550646]  [<c014129b>] ? getnstimeofday+0x56/0xdf
[   20.550650]  [<c01119f4>] ? lapic_next_event+0x18/0x1c
[   20.550653]  [<c0143380>] ? clockevents_program_event+0xe0/0xef
[   20.550659]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.550662]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.550665]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.550669]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.550672]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.550677]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.550680]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.550684]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.550687]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.550699]  [<f806c727>] ? acpi_idle_enter_bm+0x2df/0x36b [processor]
[   20.550703]  [<c0144b5a>] ? tick_nohz_restart_sched_tick+0x139/0x14b
[   20.550708]  [<c031e695>] cpuidle_idle_call+0x65/0x98
[   20.550711]  [<c01023b7>] cpu_idle+0x84/0xa5
[   20.550714]  [<c03d388f>] rest_init+0x53/0x55
[   20.550717] ---[ end trace a1303c5fb15c2010 ]---
[   20.551664] ------------[ cut here ]------------
[   20.551669] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.551673] Hardware name: MacBookPro2,2
[   20.551676] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.551785] Pid: 0, comm: swapper Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.551789] Call Trace:
[   20.551797]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.551805]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.551812]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[   20.551819]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.551828]  [<c02ce674>] ? scsi_eh_scmd_add+0x83/0x8c
[   20.551835]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.551842]  [<c02ce674>] ? scsi_eh_scmd_add+0x83/0x8c
[   20.551849]  [<c02ce6cf>] ? scsi_times_out+0x52/0x6c
[   20.551856]  [<c0235c66>] ? blk_rq_timed_out+0x11/0x4b
[   20.551863]  [<c0235ce3>] ? blk_abort_request+0x43/0x46
[   20.551870]  [<c02ebb5c>] ? ata_qc_schedule_eh+0x49/0x50
[   20.551877]  [<c02e1d9f>] ? ata_qc_complete+0x75/0x1a9
[   20.551884]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.551892]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.551899]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.551906]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.551914]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.551921]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.551928]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.551934]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.551954]  [<f806c727>] ? acpi_idle_enter_bm+0x2df/0x36b [processor]
[   20.551961]  [<c0144b5a>] ? tick_nohz_restart_sched_tick+0x139/0x14b
[   20.551969]  [<c031e695>] cpuidle_idle_call+0x65/0x98
[   20.551975]  [<c01023b7>] cpu_idle+0x84/0xa5
[   20.551982]  [<c03d388f>] rest_init+0x53/0x55
[   20.551986] ---[ end trace a1303c5fb15c2011 ]---
[   20.558509] ------------[ cut here ]------------
[   20.558512] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.558514] Hardware name: MacBookPro2,2
[   20.558516] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.558573] Pid: 2519, comm: hald-addon-macb Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.558575] Call Trace:
[   20.558580]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.558585]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   20.558588]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.558600]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   20.558600]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   20.558600]  [<c023c89f>] ? prio_tree_insert+0x18c/0x1ff
[   20.558602]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.558606]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.558610]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   20.558613]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.558617]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.558630]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.558630]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.558630]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.558631]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.558633] ---[ end trace a1303c5fb15c2012 ]---
[   20.623177] ------------[ cut here ]------------
[   20.623181] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.623184] Hardware name: MacBookPro2,2
[   20.623185] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.623245] Pid: 2519, comm: hald-addon-macb Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.623247] Call Trace:
[   20.623252]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.623257]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   20.623260]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.623264]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   20.623267]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   20.623272]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   20.623276]  [<c017e7d2>] ? vma_adjust+0x31a/0x378
[   20.623279]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.623283]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.623286]  [<c017f421>] ? mmap_region+0x17e/0x435
[   20.623289]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.623293]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.623296]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.623300]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.623304]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.623307]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.623309] ---[ end trace a1303c5fb15c2013 ]---
[   20.624217] ------------[ cut here ]------------
[   20.624220] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.624222] Hardware name: MacBookPro2,2
[   20.624224] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.624279] Pid: 2519, comm: hald-addon-macb Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.624281] Call Trace:
[   20.624285]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.624289]  [<c023fac6>] ? vsnprintf+0x866/0x8c5
[   20.624293]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.624296]  [<c01299ba>] ? release_console_sem+0x1b8/0x1e5
[   20.624300]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.624303]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.624307]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.624310]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.624314]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.624317]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.624320]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.624323]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.624328]  [<c017734f>] ? __inc_zone_state+0x1b/0x7b
[   20.624331]  [<c01773cc>] __inc_zone_page_state+0x1d/0x1f
[   20.624334]  [<c018168f>] page_add_new_anon_rmap+0x44/0x6a
[   20.624338]  [<c017b2a5>] handle_mm_fault+0x1fe/0x606
[   20.624343]  [<c02155a8>] ? selinux_socket_unix_stream_connect+0xa4/0xac
[   20.624346]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   20.624349]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   20.624352]  [<c03e20e4>] ? _read_unlock+0xd/0xf
[   20.624357]  [<c03454d3>] ? sock_def_readable+0x60/0x65
[   20.624362]  [<c03acb34>] ? unix_stream_connect+0x338/0x398
[   20.624365]  [<c0343d18>] ? sys_connect+0x65/0x82
[   20.624368]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.624371]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   20.624374]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   20.624379]  [<c01326c9>] ? do_sigaction+0x13d/0x14e
[   20.624382]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.624385]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   20.624388]  [<c03e2423>] ? error_code+0x73/0x7c
[   20.624391]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   20.624394]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   20.624397]  [<c03e2427>] error_code+0x77/0x7c
[   20.624400] ---[ end trace a1303c5fb15c2014 ]---
[   20.625285] ------------[ cut here ]------------
[   20.625288] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.625290] Hardware name: MacBookPro2,2
[   20.625292] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.625344] Pid: 2466, comm: hald Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.625346] Call Trace:
[   20.625349]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.625353]  [<c0213328>] ? selinux_socket_recvmsg+0x1a/0x1c
[   20.625357]  [<c0342ccb>] ? sock_aio_read+0x109/0x117
[   20.625361]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.625364]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.625367]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.625371]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.625374]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.625377]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.625381]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.625384]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.625386] ---[ end trace a1303c5fb15c2015 ]---
[   20.660553] ------------[ cut here ]------------
[   20.660556] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.660558] Hardware name: MacBookPro2,2
[   20.660560] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.660619] Pid: 2519, comm: hald-addon-macb Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.660621] Call Trace:
[   20.660626]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.660631]  [<c013cca6>] ? hrtimer_cancel+0x12/0x1d
[   20.660635]  [<c03e1285>] ? schedule_hrtimeout_range+0x10b/0x12a
[   20.660639]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660642]  [<c03e2148>] ? _spin_unlock_irqrestore+0x2d/0x3c
[   20.660647]  [<c013a41e>] ? remove_wait_queue+0x35/0x39
[   20.660651]  [<c019a87b>] ? poll_freewait+0x34/0x7d
[   20.660654]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.660658]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.660661]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   20.660665]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.660668]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.660672]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.660676]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.660679]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.660682]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.660687]  [<c016e758>] ? get_page_from_freelist+0x32f/0x3ed
[   20.660691]  [<c016ea87>] __alloc_pages_internal+0x9b/0x36a
[   20.660694]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660697]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660700]  [<c016ed6f>] get_zeroed_page+0x19/0x2b
[   20.660704]  [<c01c82f5>] sysfs_follow_link+0x22/0x13d
[   20.660708]  [<c01971a5>] __link_path_walk+0x459/0xc5a
[   20.660712]  [<c0215291>] ? selinux_file_alloc_security+0x2d/0x46
[   20.660715]  [<c0197b43>] path_walk+0x55/0xaa
[   20.660718]  [<c0197d66>] do_path_lookup+0x145/0x18d
[   20.660721]  [<c0197e50>] path_lookup_open+0x4b/0x7c
[   20.660724]  [<c01988d6>] do_filp_open+0xa8/0x6e8
[   20.660728]  [<c018bb89>] ? __slab_alloc+0x409/0x4a8
[   20.660731]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660734]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.660737]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.660739]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.660743]  [<c018d779>] do_sys_open+0x47/0xbc
[   20.660746]  [<c018d83a>] sys_open+0x23/0x2b
[   20.660749]  [<c010329f>] sysenter_do_call+0x12/0x34
[   20.660751] ---[ end trace a1303c5fb15c2016 ]---
[   20.662220] ------------[ cut here ]------------
[   20.662223] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.662225] Hardware name: MacBookPro2,2
[   20.662226] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.662280] Pid: 2423, comm: klogd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.662282] Call Trace:
[   20.662286]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.662290]  [<c03e0b94>] ? __mutex_lock_slowpath+0x25b/0x263
[   20.662293]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.662296]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.662298]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.662302]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   20.662306]  [<c01a1823>] ? mnt_drop_write+0x68/0xcc
[   20.662309]  [<c019e22a>] ? touch_atime+0xa5/0xbf
[   20.662313]  [<c019541e>] ? pipe_read+0x2f7/0x305
[   20.662316]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.662320]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.662323]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.662327]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.662330]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.662334]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.662337]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.662340]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.662342] ---[ end trace a1303c5fb15c2017 ]---
[   20.663258] ------------[ cut here ]------------
[   20.663260] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.663262] Hardware name: MacBookPro2,2
[   20.663264] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi evdev
[   20.663318] Pid: 2420, comm: dd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.663320] Call Trace:
[   20.663323]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.663327]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.663331]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[   20.663334]  [<c011bbac>] ? update_curr+0xae/0x189
[   20.663337]  [<c01206a1>] ? enqueue_entity+0x26c/0x274
[   20.663341]  [<c011b7ad>] ? resched_task+0x25/0x69
[   20.663344]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.663347]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.663351]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.663354]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.663358]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.663361]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.663364]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.663368]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.663371]  [<c03e007b>] ? schedule+0x695/0x8f1
[   20.663374]  [<c03e2111>] ? _spin_unlock_irq+0x14/0x1e
[   20.663378]  [<c0125c92>] finish_task_switch+0x37/0x8a
[   20.663381]  [<c03e026d>] schedule+0x887/0x8f1
[   20.663385]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   20.663388]  [<c0103210>] ? resume_userspace+0x14/0x28
[   20.663391]  [<c010344e>] work_resched+0x5/0x2d
[   20.663393] ---[ end trace a1303c5fb15c2018 ]---
[   20.845321] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
[   20.857262] Bluetooth: Core ver 2.14
[   20.857453] NET: Registered protocol family 31
[   20.857455] Bluetooth: HCI device and connection manager initialized
[   20.857458] Bluetooth: HCI socket layer initialized
[   20.888021] Bluetooth: L2CAP ver 2.11
[   20.888024] Bluetooth: L2CAP socket layer initialized
[   20.923756] Bluetooth: RFCOMM socket layer initialized
[   20.923774] Bluetooth: RFCOMM TTY layer initialized
[   20.923776] Bluetooth: RFCOMM ver 1.10
[   20.929141] Bluetooth: SCO (Voice Link) ver 0.6
[   20.929144] Bluetooth: SCO socket layer initialized
[   21.131910] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   21.131913] Bluetooth: BNEP filters: protocol multicast
[   21.162684] usb 5-1: USB disconnect, address 2
[   21.442611] usb 5-1: new full speed USB device using uhci_hcd and address 3
[   21.650582] usb 5-1: configuration #1 chosen from 1 choice
[   21.843958] Bluetooth: Generic Bluetooth USB driver ver 0.4
[   21.844233] usbcore: registered new interface driver btusb
[   23.000127] Clocksource tsc unstable (delta = -287147024 ns)
[   25.540092] type=1400 audit(1231459452.540:3): avc:  denied  { sys_module } for  pid=2655 comm="wpa_supplicant" capability=16 scontext=system_u:system_r:system_dbusd_t:s0 tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
[   25.557328] type=1300 audit(1231459452.540:3): arch=40000003 syscall=54 success=no exit=-19 a0=9 a1=8933 a2=bf8c5ffc a3=bf8c5ffc items=0 ppid=1 pid=2655 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="wpa_supplicant" exe="/sbin/wpa_supplicant" subj=system_u:system_r:system_dbusd_t:s0 key=(null)
[   28.491934] wlan0: authenticate with AP 00:1e:2a:00:67:f0
[   28.494478] wlan0: authenticated
[   28.494484] wlan0: associate with AP 00:1e:2a:00:67:f0
[   28.497063] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431 status=0 aid=3)
[   28.497070] wlan0: associated
[   32.982515] vendor=8086 device=27a1
[   32.982521] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   33.051858] Linux agpgart interface v0.103
[   33.171948] [drm] Initialized drm 1.1.0 20060810
[   33.229680] pci 0000:01:00.0: setting latency timer to 64
[   33.229967] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   33.649629] Xorg:2805 map pfn expected mapping type write-combining for 40000000-48000000, got uncached-minus
[   33.774038] [drm] Setting GART location based on new memory map
[   33.775456] [drm] Loading R500 Microcode
[   33.775515] [drm] Num pipes: 1
[   33.775530] [drm] writeback test succeeded in 1 usecs
[   38.154775] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   38.156080] input: justinmattock’s mouse #1 as /class/input/input11
[   38.200232] generic-bluetooth 0005:0000:0000.0004: input: BLUETOOTH HID v0.00 Mouse [justinmattock’s mouse #1] on 00:17:F2:B4:BC:F5


--------------000206020700080805030608--
