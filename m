Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYASHu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYASHu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 02:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYASHuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 02:50:17 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41370 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYASHuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 02:50:14 -0500
Date: Fri, 18 Jan 2008 23:56:14 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] X86: disable X86_PAT really
In-reply-to: <20080119032849.GA16757@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, venkatesh.pallipadi@intel.com,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801182356.14843.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20080118123140.GI11044@elte.hu> <20080118210210.GB10717@elte.hu>
 <20080119032849.GA16757@redhat.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] X86: disable X86_PAT really

when X86_PAT is not selected, we don't need to do anything in reserve_mattr and free_mattr

also need to bail out if cpu not support PAT.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 1036134..b3cdee1 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -57,12 +57,9 @@ static int pat_known_cpu(void)
 
 void pat_init(void)
 {
+#ifdef CONFIG_X86_PAT
 	u64 pat;
 
-#ifndef CONFIG_X86_PAT
-	nopat(NULL);
-#endif
-
 	if (!smp_processor_id() && !pat_known_cpu())
 		return;
 
@@ -90,6 +87,7 @@ void pat_init(void)
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 	printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
 		smp_processor_id(), boot_pat_state, pat);
+#endif
 }
 
 #undef PAT
@@ -135,9 +133,13 @@ static DEFINE_SPINLOCK(mattr_lock); 	/* protects memattr list */
 
 int reserve_mattr(u64 start, u64 end, unsigned long attr, unsigned long *fattr)
 {
+#ifdef CONFIG_X86_PAT
 	struct memattr *ma = NULL, *ml;
 	int err = 0;
 
+	if (!pat_wc_enabled)
+		return 0;
+
 	if (fattr)
 		*fattr = attr;
 
@@ -191,13 +193,20 @@ int reserve_mattr(u64 start, u64 end, unsigned long attr, unsigned long *fattr)
 
 	spin_unlock(&mattr_lock);
 	return err;
+#else
+	return 0;
+#endif
 }
 
 int free_mattr(u64 start, u64 end, unsigned long attr)
 {
+#ifdef CONFIG_X86_PAT
 	struct memattr *ml;
 	int err = attr ? -EBUSY : 0;
 
+	if (!pat_wc_enabled)
+		return 0;
+
 	if (is_memory_any_valid(start, end))
 		return 0;
 
@@ -221,6 +230,9 @@ int free_mattr(u64 start, u64 end, unsigned long attr)
 			current->comm, current->pid,
 			start, end, cattr_name(attr));
 	return err;
+#else
+	return 0;
+#endif
 }
 
 /* /dev/mem interface. Use the previous mapping */
