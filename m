Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYDXDCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYDXDCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYDXDCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:02:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:31261 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbYDXDCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=VvIKApbjw4oADboONzDg/lRig7Vx7iQJ/747mqbUjzMDXBkHTyWH4j/Q1WXT/dH6uNT+KZoNZL8CLEeQZaBrmEU9waL04GDWrD99/rEyW/Xf1i+6tCwLlVmI2VmLICfHo5zn6/wFzTzmqZeEbIfnfiogpkh2wkwL09eZ5QjBKv8=
Message-ID: <480FF821.9050208@gmail.com>
Date: Thu, 24 Apr 2008 12:01:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: v2.6.25: WARNING: at kernel/lockdep.c:2437	__lock_acquire+0xc69/0xfa0()
References: <19f34abd0804200329j3308b081vc0732c3ec5c0b721@mail.gmail.com> <1208782090.7115.179.camel@twins>
In-Reply-To: <1208782090.7115.179.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------070608030503030504060900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070608030503030504060900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Peter Zijlstra wrote:
> On Sun, 2008-04-20 at 12:29 +0200, Vegard Nossum wrote:
>> Hi,
>>
>> This appears in clean v2.6.25:
>>
>> ------------[ cut here ]------------
>> WARNING: at kernel/lockdep.c:2437 __lock_acquire+0xc69/0xfa0()
>> Pid: 1002, comm: scsi_eh_4 Not tainted 2.6.25 #379
>>  [<c011bb5c>] warn_on_slowpath+0x3c/0x50
>>  [<c013b0f9>] ? __lock_acquire+0x219/0xfa0
>>  [<c013b0f9>] ? __lock_acquire+0x219/0xfa0
>>  [<c012c2c8>] ? __kernel_text_address+0x8/0x20
>>  [<c0104fce>] ? dump_trace+0xce/0x120
>>  [<c010a56c>] ? save_stack_trace+0x1c/0x40
>>  [<c0138659>] ? save_trace+0x39/0xa0
>>  [<c013a3d1>] ? mark_lock+0x61/0x540
>>  [<c013bb49>] __lock_acquire+0xc69/0xfa0
>>  [<c012b46a>] ? __cancel_work_timer+0x5a/0x140
>>  [<c01082ac>] ? native_sched_clock+0x5c/0xb0
>>  [<c013beee>] lock_acquire+0x6e/0x90
>>  [<c02a8e23>] ? ata_scsi_error+0x33/0x6a0
>>  [<c02e4946>] _spin_lock_irqsave+0x26/0x60
>>  [<c02a8e23>] ? ata_scsi_error+0x33/0x6a0
>>  [<c02a4ee0>] ? ata_bmdma_error_handler+0x0/0x50
>>  [<c02a8e23>] ata_scsi_error+0x33/0x6a0
>>  [<c02e249a>] ? schedule+0x27a/0x410
>>  [<c0256dd1>] ? __scsi_iterate_devices+0x51/0x70
>>  [<c025c681>] ? scsi_run_host_queues+0x21/0x30
>>  [<c025ae5e>] scsi_error_handler+0x9e/0x4e0
>>  [<c02e249a>] ? schedule+0x27a/0x410
>>  [<c025adc0>] ? scsi_error_handler+0x0/0x4e0
>>  [<c012dd86>] kthread+0x36/0x60
>>  [<c012dd50>] ? kthread+0x0/0x60
>>  [<c0104c27>] kernel_thread_helper+0x7/0x10
>>  =======================
>> ---[ end trace 5e5d737e76fd4940 ]---
> 
> Indeed, quite easy to reproduce:
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 81a4e4a..33901ef 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2434,6 +2434,13 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>  	 * the hash, not class->key.
>  	 */
>  	id = class - lock_classes;
> +	if (id >= MAX_LOCKDEP_KEYS) {
> +		spinlock_t *slock = container_of(lock, spinlock_t, dep_map);
> +
> +		printk(KERN_EMERG "magic: %x\n", slock->magic);
> +		printk(KERN_EMERG "class: %p\n", class);
> +		printk(KERN_EMERG "id: %u\n", id);
> +	}
>  	if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
>  		return 0;
>  
> 
> 
> gives me:
> 
> ata3: PATA max PIO4 cmd 0x1e8 ctl 0x3ee irq 11
> magic: c050cf60
> class: c7c20e54
> id: 2265185251
> ------------[ cut here ]------------
> WARNING: at /mnt/md0/src/linux-2.6-2/kernel/lockdep.c:2444
> __lock_acquire+0x57b/0xfd0()
> 
> 
> Looks like someone is stomping on the spinlock or just passing us
> garbage.

Does the attached patch help?

-- 
tejun

--------------070608030503030504060900
Content-Type: text/x-patch;
 name="legacy-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="legacy-fix.patch"

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 7af4b29..f7ba234 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1037,6 +1037,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 			return 0;
 		}
 	}
+	ata_host_detach(host);
 fail:
 	platform_device_unregister(pdev);
 	return ret;

--------------070608030503030504060900--
