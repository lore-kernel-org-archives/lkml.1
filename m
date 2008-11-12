Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYKLNiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYKLNiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYKLNf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:35:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45176 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYKLNfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:35:48 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 7/8] x86: Make nmi_shootdown_cpus() available on !SMP and !X86_LOCAL_APIC
Date: Wed, 12 Nov 2008 11:34:43 -0200
Message-Id: <1226496884-24628-8-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
References: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The X86_LOCAL_APIC #ifdef was for kdump. For !SMP, the function simply
does nothing.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/reboot.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 82fa28f..d0c9c77 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -524,7 +524,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 #endif
 
 
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
+#if defined(CONFIG_SMP)
 
 /* This keeps a track of which one is crashing cpu. */
 static int crashing_cpu;
@@ -573,6 +573,12 @@ static struct notifier_block crash_nmi_nb = {
 	.notifier_call = crash_nmi_callback,
 };
 
+/* Halt all other CPUs, calling the specified function on each of them
+ *
+ * This function can be used to halt all other CPUs on crash
+ * or emergency reboot time. The function passed as parameter
+ * will be called inside a NMI handler on all CPUs.
+ */
 void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
 	unsigned long msecs;
@@ -601,4 +607,9 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	/* Leave the nmi callback set */
 }
+#else /* !CONFIG_SMP */
+void nmi_shootdown_cpus(nmi_shootdown_cb callback)
+{
+	/* No other CPUs to shoot down */
+}
 #endif
-- 
1.5.5.GIT

