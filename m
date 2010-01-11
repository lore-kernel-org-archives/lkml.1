Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426Ab0AKVb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0AKVb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054Ab0AKVb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:31:27 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35385 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab0AKV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Dza4zv2YM5F4Vq/2aZJ9XmhCxR+A6YrXBeg5VjBLYuF88lP7AjSpsCtT+PjrdqKIdn
         DUQPdoBmPygYF/ExdRyPohDUtxfQk7sQApzpWnLrPJ2RaCFjaOQEppDM8usN/XMBE8wK
         MANskJIC9/pCL7dBsVx7H1Za33tsFU9jn8N0I=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 09/26] x86: Convert set_atomicity_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:39 +0100
Message-Id: <1263245216-14754-10-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-9-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep in preempt-rt to raw_spinlocks

See also 11f7e656720b244c062223529e9a8aafeb8d6076

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 55da0c5..46f40f0 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -570,7 +570,7 @@ static unsigned long set_mtrr_state(void)
 
 
 static unsigned long cr4;
-static DEFINE_SPINLOCK(set_atomicity_lock);
+static DEFINE_RAW_SPINLOCK(set_atomicity_lock);
 
 /*
  * Since we are disabling the cache don't allow any interrupts,
@@ -590,7 +590,7 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	 * changes to the way the kernel boots
 	 */
 
-	spin_lock(&set_atomicity_lock);
+	raw_spin_lock(&set_atomicity_lock);
 
 	/* Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
 	cr0 = read_cr0() | X86_CR0_CD;
@@ -627,7 +627,7 @@ static void post_set(void) __releases(set_atomicity_lock)
 	/* Restore value of CR4 */
 	if (cpu_has_pge)
 		write_cr4(cr4);
-	spin_unlock(&set_atomicity_lock);
+	raw_spin_unlock(&set_atomicity_lock);
 }
 
 static void generic_set_all(void)
-- 
1.6.5.2

