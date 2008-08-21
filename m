Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYHUULQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYHUULQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYHUULA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:11:00 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:28019 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYHUUK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VH8OEf14twyfthzxgmfJpWWMcDXAjJLpeBXZfK1IEuFWaGgIfHVj8cCBGoQq6cUJJJ
         42aHf+kXvnHFOlws5FxLoirU/SJiag0KCdgig+Dthfi+hSU20gJKiI26JaPh/wyB5AYL
         8JNLwD0y9OqYkdXxXb0fFG5OU6OW9mktnJAZc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Alex Nixon <alex.nixon@citrix.com>
Subject: [PATCH] x86: fix probe_nr_irqs for xen
Date: Thu, 21 Aug 2008 13:10:09 -0700
Message-Id: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

otherwise Xen is _completely_ unusable with 5 or more VCPUs.
( when !CONFIG_HAVE_SPARSE_IRQ)

based on Alex's patch

also add +1 offset after redir_entries

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alex Nixon <alex.nixon@citrix.com>

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3625,16 +3625,21 @@ int __init probe_nr_irqs(void)
 {
 	int idx;
 	int nr = 0;
+#ifndef CONFIG_XEN
+	int nr_min = 32;
+#else
+	int nr_min = NR_IRQS;
+#endif
 
 	for (idx = 0; idx < nr_ioapics; idx++)
-		nr += io_apic_get_redir_entries(idx);
+		nr += io_apic_get_redir_entries(idx) + 1;
 
 	/* double it for hotplug and msi and nmi */
 	nr <<= 1;
 
 	/* something wrong ? */
-	if (nr < 32)
-		nr = 32;
+	if (nr < nr_min)
+		nr = nr_min;
 
 	return nr;
 }
