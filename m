Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYDRNKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYDRNKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYDRNJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:09:54 -0400
Received: from tornado.reub.net ([59.167.255.179]:37261 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYDRNJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:09:51 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2008 09:09:51 EDT
X-DKIM: Sendmail DKIM Filter v2.5.2 tornado.reub.net B57BD129ACB
Message-ID: <48089BDE.6040100@reub.net>
Date: Fri, 18 Apr 2008 23:02:22 +1000
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0.0.15pre (Windows/20080417)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: StackProtector Oopses - Re: 2.6.25-mm1
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
In-Reply-To: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18/04/2008 6:47 PM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/ 

The GCC stackprotector option is a no-go for me, and causes 100% repeatable 
fatal oopses on boot with my x86_64 box.

This is not new to 2.6.25-mm1 - but was also present in 2.6.24-rc8-mm2 
(2.6.24-rc8-mm1 was good, but this option didn't exist then).

It seems that enabling the stackprotector option:

tornado boot # diff -u config-2.6.25-mm1 config-2.6.25-mm1.old
--- config-2.6.25-mm1   2008-04-18 22:40:15.000000000 +1000
+++ config-2.6.25-mm1.old       2008-04-18 20:09:38.000000000 +1000
@@ -1,7 +1,7 @@
  #
  # Automatically generated make config: don't edit
  # Linux kernel version: 2.6.25-mm1
-# Fri Apr 18 22:25:04 2008
+# Fri Apr 18 19:57:17 2008
  #
  CONFIG_64BIT=y
  # CONFIG_X86_32 is not set
@@ -256,7 +256,8 @@
  CONFIG_X86_PAT=y
  # CONFIG_EFI is not set
  CONFIG_SECCOMP=y
-# CONFIG_CC_STACKPROTECTOR is not set
+CONFIG_CC_STACKPROTECTOR_ALL=y
+CONFIG_CC_STACKPROTECTOR=y
  # CONFIG_HZ_100 is not set
  # CONFIG_HZ_250 is not set
  CONFIG_HZ_300=y

is enough to prevent my system booting, viz:

input: Belkin Components Belkin OmniView KVM Switch as 
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.1/3-1.1:1.0/input/input2
input: USB HID v1.00 Keyboard [Belkin Components Belkin OmniView KVM Switch] on 
usb-0000:00:1d.1-1.1
input: Belkin Components Belkin OmniView KVM Switch as 
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.1/3-1.1:1.1/input/input3
input: USB HID v1.00 Mouse [Belkin Components Belkin OmniView KVM Switch] on 
usb-0000:00:1d.1-1.1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
Testing -fstack-protector-all feature
------------[ cut here ]------------
WARNING: at ™š:-2145164734 0x0()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-mm1 #1

Call Trace:
  [<ffffffff802362a9>] warn_on_slowpath+0x67/0x98
  [<ffffffff802f31da>] ? proc_register+0x104/0x1b0
  [<ffffffff80237e2a>] ? printk+0x79/0x94
  [<ffffffff804f1d05>] ? register_netdevice_notifier+0xed/0x1c9
  [<ffffffff8023da80>] ? insert_resource+0x3c/0x117
  [<ffffffff8023630d>] ? __stack_chk_test+0x33/0x7b
  [<ffffffff80740ff0>] ? kernel_init+0x16d/0x30d
  [<ffffffff8020c7b8>] ? child_rip+0xa/0x12
  [<ffffffff80740e83>] ? kernel_init+0x0/0x30d
  [<ffffffff8020c7ae>] ? child_rip+0x0/0x12

---[ end trace 8d584356702633c0 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<0000000000000000>]
PGD 0
Oops: 0010 [1] SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W 2.6.25-mm1 #1
RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
RSP: 0000:ffff8100bf05de88  EFLAGS: 00010296
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000200
RBP: ffff8100bf05de90 R08: 0000000000000000 R09: ffff8100000bcce0
R10: 0720072007200720 R11: 0720072007200720 R12: 0000000000000000
R13: ffffffff80787530 R14: 0000000000000000 R15: ffffffff8067fd3c
FS:  0000000000000000(0000) GS:ffffffff80721000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff8100bf05c000, task ffff8100bf060000)
Stack:  0000000000000000 ffff8100bf05deb0 ffffffff8023630d 0000000000000000
  0000000090e2a955 ffff8100bf05df40 ffffffff80740ff0 aa55aa0000000000
  aa55aa55aa55aa55 0000000000000003 55aa55aa55aa55aa 55aa55aa55aa55aa
Call Trace:
  [<ffffffff8023630d>] __stack_chk_test+0x33/0x7b
  [<ffffffff80740ff0>] kernel_init+0x16d/0x30d
  [<ffffffff8020c7b8>] child_rip+0xa/0x12
  [<ffffffff80740e83>] ? kernel_init+0x0/0x30d
  [<ffffffff8020c7ae>] ? child_rip+0x0/0x12


Code:  Bad RIP value.
RIP  [<0000000000000000>]
  RSP <ffff8100bf05de88>
CR2: 0000000000000000
---[ end trace 8d584356702633c0 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D W 2.6.25-mm1 #1

Call Trace:
  [<ffffffff80236716>] panic+0xb2/0x187
  [<ffffffff802547c7>] ? blocking_notifier_call_chain+0x24/0x42
  [<ffffffff8023a5b7>] do_exit+0x772/0x7eb
  [<ffffffff8020cd1f>] oops_end+0x9a/0x9f
  [<ffffffff80224349>] do_page_fault+0x61d/0x7c4
  [<ffffffff802f31da>] ? proc_register+0x104/0x1b0
  [<ffffffff805a51f9>] error_exit+0x0/0x51
  [<ffffffff8023630d>] ? __stack_chk_test+0x33/0x7b
  [<ffffffff80740ff0>] ? kernel_init+0x16d/0x30d
  [<ffffffff8020c7b8>] ? child_rip+0xa/0x12
  [<ffffffff80740e83>] ? kernel_init+0x0/0x30d
  [<ffffffff8020c7ae>] ? child_rip+0x0/0x12

Rebooting in 30 seconds..
----------

gcc version 4.2.3 (Gentoo 4.2.3 p1.0)

I have put the config and full dmesg of 2.6.25-mm1 both working and not working, 
up at http://www.reub.net/files/kernel/2.6.25-mm1/

It is the exact same oops with 2.6.24-rc8-mm1.

Reuben

