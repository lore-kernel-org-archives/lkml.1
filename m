Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbXLDNzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbXLDNzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbXLDNyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:54:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbXLDNya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:54:30 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 3/10] allow sched clock to be overridden by paravirt
Date: Tue,  4 Dec 2007 09:09:57 -0200
Message-Id: <11967666212496-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967666161585-git-send-email-gcosta@redhat.com>
References: <11967666042130-git-send-email-gcosta@redhat.com> <11967666111489-git-send-email-gcosta@redhat.com> <11967666161585-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns the sched_clock into native_sched_clock.
sched clock becomes a weak symbol, which can then give its
place to a paravirt definition.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/tsc_64.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 9c70af4..5158476 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -30,7 +30,7 @@ static unsigned long long cycles_2_ns(unsigned long long cyc)
 	return (cyc * cyc2ns_scale) >> NS_SCALE;
 }
 
-unsigned long long sched_clock(void)
+unsigned long long native_sched_clock(void)
 {
 	unsigned long a = 0;
 
@@ -44,6 +44,19 @@ unsigned long long sched_clock(void)
 	return cycles_2_ns(a);
 }
 
+/* We need to define a real function for sched_clock, to override the
+   weak default version */
+#ifdef CONFIG_PARAVIRT
+unsigned long long sched_clock(void)
+{
+	return paravirt_sched_clock();
+}
+#else
+unsigned long long
+sched_clock(void) __attribute__((alias("native_sched_clock")));
+#endif
+
+
 static int tsc_unstable;
 
 inline int check_tsc_unstable(void)
-- 
1.4.4.2

