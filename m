Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0BIP4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:56:20 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:24969 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0BIP4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:56:18 -0500
X-IronPort-AV: E=Sophos;i="4.49,436,1262581200"; 
   d="scan'208";a="83432804"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 2/3] x86: make 64 bit ret_from_fork a little more similar to 32 bit
Date: Tue,  9 Feb 2010 15:56:08 +0000
Message-Id: <1265730969-30145-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265730969-30145-1-git-send-email-ian.campbell@citrix.com>
References: <1265730969-30145-1-git-send-email-ian.campbell@citrix.com>
X-OriginalArrivalTime: 09 Feb 2010 15:56:16.0829 (UTC) FILETIME=[69CB8ED0:01CAA9A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64 bit version resets EFLAGS before calling schedule_tail() and
therefore leaves EFLAGS.IF clear. 32 bit resets EFLAGS after calling
schedule_tail() and therefore leaves EFLAGS.IF set. I don't think
there is any practical difference between the two approaches since
interrupts are actually reenabled within schedule_tail
(schedule_tail->finish_task_switch->finish_lock_switch->raw_spin_unlock_irq->...->local_irq_enable)
so arbitrarily pick the 32 bit version and make 64 bit look like that.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/entry_64.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 18e4c59..b771c2f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -398,13 +398,13 @@ ENTRY(ret_from_fork)
 
 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	push $0x0002
+	call schedule_tail			# rdi: 'prev' task parameter
+
+	push $0x0202
 	CFI_ADJUST_CFA_OFFSET 8
 	popf					# reset kernel eflags
 	CFI_ADJUST_CFA_OFFSET -8
 
-	call schedule_tail			# rdi: 'prev' task parameter
-
 	GET_THREAD_INFO(%rcx)
 
 	RESTORE_REST
-- 
1.5.6.5

