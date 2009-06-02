Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZFBAwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZFBAwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZFBAwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:52:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:45632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbZFBAwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:52:09 -0400
Date: Tue, 2 Jun 2009 00:51:30 GMT
From: tip-bot for Jiri Slaby <jirislaby@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, jirislaby@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, jirislaby@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
References: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
Subject: [tip:irq/numa] x86, apic: Restore irqs on fail paths
Message-ID: <tip-3d58829b0510244596079c1d2f1762c53aef2e97@git.kernel.org>
Git-Commit-ID: 3d58829b0510244596079c1d2f1762c53aef2e97
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 00:51:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d58829b0510244596079c1d2f1762c53aef2e97
Gitweb:     http://git.kernel.org/tip/3d58829b0510244596079c1d2f1762c53aef2e97
Author:     Jiri Slaby <jirislaby@gmail.com>
AuthorDate: Thu, 28 May 2009 09:54:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 02:48:59 +0200

x86, apic: Restore irqs on fail paths

lapic_resume forgets to restore interrupts on fail paths.
Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/kernel/apic/apic.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b0fd264..e82488d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2027,7 +2027,7 @@ static int lapic_resume(struct sys_device *dev)
 	unsigned int l, h;
 	unsigned long flags;
 	int maxlvt;
-	int ret;
+	int ret = 0;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	if (!apic_pm_state.active)
@@ -2038,14 +2038,15 @@ static int lapic_resume(struct sys_device *dev)
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
 			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto restore;
 		}
 
 		ret = save_IO_APIC_setup(ioapic_entries);
 		if (ret) {
 			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
 			free_ioapic_entries(ioapic_entries);
-			return ret;
+			goto restore;
 		}
 
 		mask_IO_APIC_setup(ioapic_entries);
@@ -2097,10 +2098,10 @@ static int lapic_resume(struct sys_device *dev)
 		restore_IO_APIC_setup(ioapic_entries);
 		free_ioapic_entries(ioapic_entries);
 	}
-
+restore:
 	local_irq_restore(flags);
 
-	return 0;
+	return ret;
 }
 
 /*
