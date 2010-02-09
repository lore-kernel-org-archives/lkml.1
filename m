Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab0BIP4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:56:45 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:29065 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab0BIP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:56:17 -0500
X-IronPort-AV: E=Sophos;i="4.49,436,1262581200"; 
   d="scan'208";a="83432802"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 1/3] x86: drop unnecessary kernel_eflags variable from 64 bit.
Date: Tue,  9 Feb 2010 15:56:07 +0000
Message-Id: <1265730969-30145-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265730969-30145-1-git-send-email-ian.campbell@citrix.com>
References: <1265730969-30145-1-git-send-email-ian.campbell@citrix.com>
X-OriginalArrivalTime: 09 Feb 2010 15:56:15.0751 (UTC) FILETIME=[69271170:01CAA9A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For no reason that I can determine 64 bit x86 saves the current eflags
in cpu_init purely for use in ret_from_fork. The equivalent 32 bit
code simply hard codes 0x0202 as the new EFLAGS which seems safer than
relying on a potentially arbitrary EFLAGS saved during cpu_init.

Original i386 changeset
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47a5c6fa0e204a2b63309c648bb2fde36836c826
Original x86_64 changset
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=658fdbef66e5e9be79b457edc2cbbb3add840aa9

The only comment in the later indicates that it is following the
former, but not why it differs in this way.

This change makes 64 bit use the same mechanism to setup the initial
EFLAGS on fork. Note that 64 bit resets EFLAGS before calling
schedule_tail() as opposed to 32 bit which calls schedule_tail()
first. Therefore the correct value for EFLAGS has opposite IF
bit. This will be fixed in a subsequent patch.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/cpu/common.c |    4 ----
 arch/x86/kernel/entry_64.S   |    2 +-
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..ab766b2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1040,8 +1040,6 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-unsigned long kernel_eflags;
-
 /*
  * Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
@@ -1189,8 +1187,6 @@ void __cpuinit cpu_init(void)
 
 	fpu_init();
 
-	raw_local_save_flags(kernel_eflags);
-
 	if (is_uv_system())
 		uv_cpu_init();
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0697ff1..18e4c59 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -398,7 +398,7 @@ ENTRY(ret_from_fork)
 
 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	push kernel_eflags(%rip)
+	push $0x0002
 	CFI_ADJUST_CFA_OFFSET 8
 	popf					# reset kernel eflags
 	CFI_ADJUST_CFA_OFFSET -8
-- 
1.5.6.5

