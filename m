Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYITK6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYITK6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYITK6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:58:46 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:51967 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYITK6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kxlrXJTQ5G2daHuJaU1Y8p5OkTYwVmUYByuucZCtyMHVZHQyTs9xcnVNdoeuS2wj9z
         acyRjypFUc04lsLZIWMwFcuD+NEAiV8iyIQcms7+sA3cFaptnzkXxjcci56N8ZKRPPkI
         SR6oLCwLGA0UTH0tN7U2dLVxHyXGU4lglyyQM=
From: Andrea Righi <righi.andrea@gmail.com>
To: robert.richter@amd.com, akpm@linux-foundation.org
Cc: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] oprofile: BUG: using smp_processor_id() in preemptible code
Date: Sat, 20 Sep 2008 12:58:40 +0200
Message-Id: <1221908320-7183-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add local_irq_save() / local_irq_restore() before setting per cpu variable
switch_index, to avoid the following BUG:

[  449.166827] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/6998
[  449.166848] caller is op_nmi_init+0xf0/0x2b0 [oprofile]
[  449.166855] Pid: 6998, comm: modprobe Not tainted 2.6.27-rc5-mm1 #29
[  449.166860] Call Trace:
[  449.166872]  [<ffffffff80362d67>] debug_smp_processor_id+0xd7/0xe0
[  449.166887]  [<ffffffffa00181c0>] op_nmi_init+0xf0/0x2b0 [oprofile]
[  449.166902]  [<ffffffffa0018000>] oprofile_init+0x0/0x60 [oprofile]
[  449.166915]  [<ffffffffa00180a9>] oprofile_arch_init+0x9/0x30 [oprofile]
[  449.166928]  [<ffffffffa001801e>] oprofile_init+0x1e/0x60 [oprofile]
[  449.166937]  [<ffffffff8020903b>] _stext+0x3b/0x160
[  449.166946]  [<ffffffff80477985>] __mutex_unlock_slowpath+0xe5/0x190
[  449.166955]  [<ffffffff80262c1a>] trace_hardirqs_on_caller+0xca/0x140
[  449.166965]  [<ffffffff8026f7fc>] sys_init_module+0xdc/0x210
[  449.166972]  [<ffffffff8020b7cb>] system_call_fastpath+0x16/0x1b

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 arch/x86/oprofile/nmi_int.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index d4c2f2d..2e63357 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -520,6 +520,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	__u8 vendor = boot_cpu_data.x86_vendor;
 	__u8 family = boot_cpu_data.x86;
 	char *cpu_type;
+	unsigned long flags;
 	int ret = 0;
 
 	if (!cpu_has_apic)
@@ -580,7 +581,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	register_cpu_notifier(&oprofile_cpu_nb);
 #endif
 	/* default values, can be overwritten by model */
+	local_irq_save(flags);
 	__get_cpu_var(switch_index) = 0;
+	local_irq_restore(flags);
 	ops->create_files = nmi_create_files;
 	ops->setup = nmi_setup;
 	ops->shutdown = nmi_shutdown;
-- 
1.5.4.3

