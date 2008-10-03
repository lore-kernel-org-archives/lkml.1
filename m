Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYJCImH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYJCImH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYJCIlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:41:55 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:33328 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYJCIly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:41:54 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [regression] Latest git has WARN_ON storm with e1000e driver
Date: Fri, 3 Oct 2008 10:41:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810031041.49350.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

I have e1000e compiled into my kernel and 

commit 717d438d1fde94decef874b9808379d1f4523453
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Oct 2 16:33:40 2008 -0700

    e1000e: debug contention on NVM SWFLAG


Causes a storm of 

[   15.600387] ------------[ cut here ]------------
[   15.600388] WARNING: at drivers/net/e1000e/ich8lan.c:399 
e1000_acquire_swflag_ich8lan+0xde/0xf0()
[   15.600389] Modules linked in:
[   15.600390] Pid: 1, comm: swapper Tainted: G        W 
2.6.27-rc8-00055-gb5ff7df #26
[   15.600391]  [<c01421cf>] warn_on_slowpath+0x5f/0xa0
[   15.600394]  [<c0464999>] __devinet_sysctl_register+0xc9/0x100
[   15.600396]  [<c015bf0e>] sched_clock_cpu+0xde/0x180
[   15.600399]  [<c015ae98>] down_trylock+0x28/0x40
[   15.600400]  [<c04df645>] _spin_unlock+0x5/0x20
[   15.600402]  [<c02944a4>] delay_tsc+0x84/0xb0
[   15.600404]  [<c031bd6e>] e1000_acquire_swflag_ich8lan+0xde/0xf0
[   15.600406]  [<c031b716>] e1000_read_flash_word_ich8lan+0x76/0xb0
[   15.600408]  [<c031c05b>] e1000_read_nvm_ich8lan+0x5b/0xf0
[   15.600410]  [<c031ecb4>] e1000e_read_pba_num+0x64/0x80
[   15.600412]  [<c04d2158>] e1000_probe+0xb98/0xc20
[   15.600414]  [<c02a4f0e>] pci_device_probe+0x5e/0x80
[   15.600416]  [<c030d416>] driver_probe_device+0x86/0x1a0
[   15.600418]  [<c04df373>] _spin_lock_irqsave+0x33/0x50
[   15.600420]  [<c030d5a1>] __driver_attach+0x71/0x80
[   15.600422]  [<c02a4e50>] pci_device_remove+0x0/0x40
[   15.600424]  [<c030cd44>] bus_for_each_dev+0x44/0x70
[   15.600426]  [<c02a4e50>] pci_device_remove+0x0/0x40
[   15.600427]  [<c030d2a6>] driver_attach+0x16/0x20
[   15.600430]  [<c030d530>] __driver_attach+0x0/0x80
[   15.600432]  [<c030c70f>] bus_add_driver+0x19f/0x220
[   15.600434]  [<c02a4e50>] pci_device_remove+0x0/0x40
[   15.600435]  [<c030d73c>] driver_register+0x5c/0x130
[   15.600437]  [<c06aa88f>] thinkpad_acpi_module_init+0x7b2/0x983
[   15.600439]  [<c06aaa60>] e1000_init_module+0x0/0x70
[   15.600441]  [<c02a5157>] __pci_register_driver+0x47/0x90
[   15.600443]  [<c06aaaa5>] e1000_init_module+0x45/0x70
[   15.600445]  [<c01012ea>] do_one_initcall+0x2a/0x190
[   15.600446]  [<c01defb4>] create_proc_entry+0x54/0xa0
[   15.600449]  [<c0175411>] register_irq_proc+0xc1/0xe0
[   15.600451]  [<c0175478>] init_irq_proc+0x48/0x60
[   15.600452]  [<c068e85d>] kernel_init+0x11a/0x17d
[   15.600454]  [<c068e743>] kernel_init+0x0/0x17d
[   15.600456]  [<c011d48b>] kernel_thread_helper+0x7/0x1c
[   15.600458]  =======================
[   15.600459] ---[ end trace 1caa30bae2a6fa92 ]---


This is caused by holding a spinlock (__driver_attach) and checking for 
preempt_count (e1000_acquire_swflag_ich8lan).

I suggest to revert this commit, since we cannot take a mutex while holding a 
spinlock.
The simple solution of replacing the mutex with a spinlock does not work, 
since we call msleep on several places in the code. Replacing all that code 
doesnt look like 2.6.27 material.

Christian

