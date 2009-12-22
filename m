Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZLVNv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZLVNv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZLVNv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:51:26 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58083 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbZLVNv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:51:26 -0500
Date: Tue, 22 Dec 2009 14:51:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc1: NULL pointer dereference at wb_do_writeback()
Message-ID: <20091222135124.GR4489@kernel.dk>
References: <20091222024755.GA5725@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222024755.GA5725@orion>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22 2009, Alexander Beregalov wrote:
> Hi Jens
> 
> The kernel is v2.6.33-rc1-154-gf7b84a6ba with few patches from
> Frederic's reiserbkl/reiserfs/kill-bkl tree, seems unrelated.
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000001
> IP: [<c10aec3b>] wb_do_writeback+0x6b/0x1a0
> *pde = 00000000
> Oops: 0000 [#1]
> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
> Modules linked in: hwmon_vid sata_sil i2c_nforce2
> 
> Pid: 993, comm: <AB>lush-8: Not tainted 2.6.33-rc1-00160-gdaa84dd #1 NF7-S/NF7,NF7-V (nVidia-nForce2)/
> EIP: 0060:[<c10aec3b>] EFLAGS: 00010246 CPU: 0
> EIP is at wb_do_writeback+0x6b/0x1a0
> EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 00000000
> ESI: ffff94e5 EDI: f6ad024c EBP: f608bf70 ESP: f608bf38
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process <AB>lush-8: (pid: 993, ti=f608a000 task=f65914f0 task.ti=f608a000)
> Stack:
>  00000002 00000001 00000000 c10aebf0 00000000 00000000 f6ad01a4 00000f1b
> <0> 00000292 000001f4 ffff94e5 000001f4 ffff94e5 f6ad01a4 f608bf84 c10aedbb
> <0> f6ad0120 f6ad01a4 c107a010 f608bf9c c107a067 00000000 f70a9eec f6ad01a4
> Call Trace:
>  [<c10aebf0>] ? wb_do_writeback+0x20/0x1a0
>  [<c10aedbb>] ? bdi_writeback_task+0x4b/0x80
>  [<c107a010>] ? bdi_start_fn+0x0/0xb0
>  [<c107a067>] ? bdi_start_fn+0x57/0xb0
>  [<c107a010>] ? bdi_start_fn+0x0/0xb0
>  [<c103decc>] ? kthread+0x6c/0x80
>  [<c103de60>] ? kthread+0x0/0x80
>  [<c100303a>] ? kernel_thread_helper+0x6/0x1c
> Code: 00 c7 04 24 02 00 00 00 e8 53 1f fa ff 8b 1f 8b 03 0f 18 00 90 39 fb 74
> 1c 8b 55 e0 8b 42 0c 0f a3 43 10 19 d2 85 d2 75 77 8b 1b <8b> 13 0f 18 02 90 39
> df 75 ea 31 db 90 b9 48 ec 0a c1 ba 01 00
> EIP: [<c10aec3b>] wb_do_writeback+0x6b/0x1a0 SS:ESP 0068:f608bf38
> CR2: 0000000000000001
> ---[ end trace 6a300b1deaf502c3 ]---

Hmm, this looks really funky.

> wb_do_writeback+0x6b is 0x115b
> it is in get_next_work_item():
> %ebx = list_entry_rcu(work->list.next, struct bdi_work, list) = 1

Isn't it rather

        list_entry_rcu(bdi->work_list.next, ...)

and points at wb->bdi not being valid. Are you using any debugging
options in the kernel config?

Also, this:

Process <AB>lush-8: (pid: 993, ti=f608a000 task=f65914f0 task.ti=f608a000)

looks veeeery fishy, that should be flush-8. Looks like some memory
corruption possibly.

-- 
Jens Axboe

