Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZHHPt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZHHPt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZHHPt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:49:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:59607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZHHPtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:49:20 -0400
Date: Sat, 8 Aug 2009 15:48:50 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090808094905.GA2954@localhost.localdomain>
References: <20090808094905.GA2954@localhost.localdomain>
Subject: [tip:x86/asm] x86: Introduce GDT_ENTRY_INIT(), fix APM
Message-ID: <tip-72c4d8530244264317a662de9a55cc47e6c8e9df@git.kernel.org>
Git-Commit-ID: 72c4d8530244264317a662de9a55cc47e6c8e9df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 15:48:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72c4d8530244264317a662de9a55cc47e6c8e9df
Gitweb:     http://git.kernel.org/tip/72c4d8530244264317a662de9a55cc47e6c8e9df
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 3 Aug 2009 08:47:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:47:12 +0200

x86: Introduce GDT_ENTRY_INIT(), fix APM

This crash:

[    0.891983] calling  cache_sysfs_init+0x0/0x1ee @ 1
[    0.897251] initcall cache_sysfs_init+0x0/0x1ee returned 0 after 405 usecs
[    0.904019] calling  mce_init_device+0x0/0x242 @ 1
[    0.909124] initcall mce_init_device+0x0/0x242 returned 0 after 347 usecs
[    0.915815] calling  apm_init+0x0/0x38d @ 1
[    0.919967] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[    0.926813] general protection fault: 0000 [#1]
[    0.927269] last sysfs file:
[    0.927269] Modules linked in:
[    0.927269]
[    0.927269] Pid: 271, comm: kapmd Not tainted (2.6.31-rc3-00100-gd520da1-dirty #311) System Product Name
[    0.927269] EIP: 00c0:[<000082b2>] EFLAGS: 00010002 CPU: 0
[    0.927269] EIP is at 0x82b2
[    0.927269] EAX: 0000530e EBX: 00000000 ECX: 00000102 EDX: 00000000
[    0.927269] ESI: 00000000 EDI: f6a4bf44 EBP: 67890000 ESP: f6a4beec
[    0.927269]  DS: 00c8 ES: 0000 FS: 0000 GS: 0000 SS: 0068
[    0.927269] Process kapmd (pid: 271, ti=f6a4a000 task=f7142280 task.ti=f6a4a000)
[    0.927269] Stack:
[    0.927269]  0000828d 02160000 00b88092 f6a4bf3c c102a63d 00000060 f6a4bf3c f6a4bf44
[    0.927269] <0> 0000007b 0000007b 00000000 00000000 00000000 00000000 560aae9e 00000000
[    0.927269] <0> 00000200 f705fd74 00000000 c102af70 f6a4bf60 c102a6ec 0000530e 00000000
[    0.927269] Call Trace:
[    0.927269]  [<c102a63d>] ? __apm_bios_call_simple+0x7d/0x110
[    0.927269]  [<c102af70>] ? apm+0x0/0x6a0
[    0.927269]  [<c102a6ec>] ? apm_bios_call_simple+0x1c/0x50
[    0.927269]  [<c102b3f5>] ? apm+0x485/0x6a0
[    0.927269]  [<c1038e7a>] ? finish_task_switch+0x2a/0xb0
[    0.927269]  [<c164a69e>] ? schedule+0x31e/0x480
[    0.927269]  [<c102af70>] ? apm+0x0/0x6a0
[    0.927269]  [<c102af70>] ? apm+0x0/0x6a0
[    0.927269]  [<c1052654>] ? kthread+0x74/0x80
[    0.927269]  [<c10525e0>] ? kthread+0x0/0x80
[    0.927269]  [<c101d627>] ? kernel_thread_helper+0x7/0x10
[    0.927269] Code:  Bad EIP value.
[    0.927269] EIP: [<000082b2>] 0x82b2 SS:ESP 0068:f6a4beec
[    0.927269] ---[ end trace a7919e7f17c0a725 ]---
[    0.927269] Kernel panic - not syncing: Fatal exception
[    0.927269] Pid: 271, comm: kapmd Tainted: G      D    2.6.31-rc3-00100-gd520da1-dirty #311

Is caused by an incorrect GDT_ENTRY_INIT() conversion in the apm
code, as noticed by hpa.

Reported-by: Ingo Molnar <mingo@elte.hu>
Noticed-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090808094905.GA2954@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8c9bc28..b5764a2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -106,7 +106,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	/* 16-bit code */
 	[GDT_ENTRY_APMBIOS_BASE+1]	= GDT_ENTRY_INIT(0x009a, 0, 0xffff),
 	/* data */
-	[GDT_ENTRY_APMBIOS_BASE+2]	= GDT_ENTRY_INIT(0x409a, 0, 0xffff),
+	[GDT_ENTRY_APMBIOS_BASE+2]	= GDT_ENTRY_INIT(0x4092, 0, 0xffff),
 
 	[GDT_ENTRY_ESPFIX_SS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
 	[GDT_ENTRY_PERCPU]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
