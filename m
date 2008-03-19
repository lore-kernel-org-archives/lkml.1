Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbYCSUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbYCSUdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbYCSTjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbYCSThi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:38 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 11/79] [PATCH] always enable irqs when entering idle
Date: Wed, 19 Mar 2008 14:25:06 -0300
Message-Id: <1205947625472-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476212769-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This matches x86_64 behaviour, which is a superior one IMHO

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/process_32.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index ec05fb7..08c41ed 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -127,6 +127,7 @@ void default_idle(void)
 		local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
 	} else {
+		local_irq_enable();
 		/* loop is done by the caller */
 		cpu_relax();
 	}
@@ -142,6 +143,7 @@ EXPORT_SYMBOL(default_idle);
  */
 static void poll_idle(void)
 {
+	local_irq_enable();
 	cpu_relax();
 }
 
@@ -248,8 +250,11 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
-			__mwait(ax, cx);
-	}
+			__sti_mwait(ax, cx);
+		else
+			local_irq_enable();
+	} else
+		local_irq_enable();
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
-- 
1.5.0.6

