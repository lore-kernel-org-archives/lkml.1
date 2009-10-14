Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZJNISg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZJNISg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbZJNISf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:18:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901AbZJNISe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:18:34 -0400
Date: Wed, 14 Oct 2009 08:17:20 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091013201022.747817361@openvz.org>
References: <20091013201022.747817361@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Use apic noop driver
Message-ID: <tip-a933c61829509eb27083146dda392132baa0969a@git.kernel.org>
Git-Commit-ID: a933c61829509eb27083146dda392132baa0969a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 08:17:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a933c61829509eb27083146dda392132baa0969a
Gitweb:     http://git.kernel.org/tip/a933c61829509eb27083146dda392132baa0969a
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 14 Oct 2009 00:07:04 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 09:17:00 +0200

x86, apic: Use apic noop driver

In case if apic were disabled we may use the whole apic NOOP driver
instead of sparse poking the some functions in apic driver.

Also NOOP would catch any inappropriate apic operation calls (not
just read/write).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: yinghai@kernel.org
Cc: macro@linux-mips.org
LKML-Reference: <20091013201022.747817361@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 894aa97..61a5628 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -241,28 +241,12 @@ static int modern_apic(void)
 }
 
 /*
- * bare function to substitute write operation
- * and it's _that_ fast :)
- */
-static void native_apic_write_dummy(u32 reg, u32 v)
-{
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
-}
-
-static u32 native_apic_read_dummy(u32 reg)
-{
-	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
-	return 0;
-}
-
-/*
- * right after this call apic->write/read doesn't do anything
- * note that there is no restore operation it works one way
+ * right after this call apic become NOOP driven
+ * so apic->write/read doesn't do anything
  */
 void apic_disable(void)
 {
-	apic->read = native_apic_read_dummy;
-	apic->write = native_apic_write_dummy;
+	apic = &apic_noop;
 }
 
 void native_apic_wait_icr_idle(void)
