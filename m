Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbZLPVv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbZLPVv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZLPVvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:51:24 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:36783 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZLPVvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:51:23 -0500
Date: Wed, 16 Dec 2009 13:51:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] x86 msrs: alloc/free for CONFIG_SMP=n
Message-Id: <20091216135119.e283e525.randy.dunlap@oracle.com>
In-Reply-To: <4B2928AC.3020807@zytor.com>
References: <20091216183212.118c5e14.sfr@canb.auug.org.au>
	<20091216092424.5f87214c.randy.dunlap@oracle.com>
	<4B2919BD.40001@zytor.com>
	<20091216174524.GH11618@aftab>
	<4B2928AC.3020807@zytor.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B295650.013B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Rearrange arch/x86/lib/msr.c so that alloc/free are built and
usable when CONFIG_SMP=n.  Fixes build of amd64_edac.

ERROR: "msrs_free" [drivers/edac/amd64_edac_mod.ko] undefined!
ERROR: "msrs_alloc" [drivers/edac/amd64_edac_mod.ko] undefined!

---
 arch/x86/lib/Makefile |    2 -
 arch/x86/lib/msr.c    |   42 ++++++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 21 deletions(-)

--- linux-next-20091216.orig/arch/x86/lib/Makefile
+++ linux-next-20091216/arch/x86/lib/Makefile
@@ -14,7 +14,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
 
 clean-files := inat-tables.c
 
-obj-$(CONFIG_SMP) := msr.o
+obj-$(CONFIG_X86_MSR) := msr.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
--- linux-next-20091216.orig/arch/x86/lib/msr.c
+++ linux-next-20091216/arch/x86/lib/msr.c
@@ -10,6 +10,7 @@ struct msr_info {
 	int err;
 };
 
+#ifdef CONFIG_SMP
 static void __rdmsr_on_cpu(void *info)
 {
 	struct msr_info *rv = info;
@@ -118,26 +119,6 @@ void wrmsr_on_cpus(const struct cpumask 
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
-struct msr *msrs_alloc(void)
-{
-	struct msr *msrs = NULL;
-
-	msrs = alloc_percpu(struct msr);
-	if (!msrs) {
-		pr_warning("%s: error allocating msrs\n", __func__);
-		return NULL;
-	}
-
-	return msrs;
-}
-EXPORT_SYMBOL(msrs_alloc);
-
-void msrs_free(struct msr *msrs)
-{
-	free_percpu(msrs);
-}
-EXPORT_SYMBOL(msrs_free);
-
 /* These "safe" variants are slower and should be used when the target MSR
    may not actually exist. */
 static void __rdmsr_safe_on_cpu(void *info)
@@ -234,3 +215,24 @@ int wrmsr_safe_regs_on_cpu(unsigned int 
 	return err ? err : rv.err;
 }
 EXPORT_SYMBOL(wrmsr_safe_regs_on_cpu);
+#endif
+
+struct msr *msrs_alloc(void)
+{
+	struct msr *msrs = NULL;
+
+	msrs = alloc_percpu(struct msr);
+	if (!msrs) {
+		pr_warning("%s: error allocating msrs\n", __func__);
+		return NULL;
+	}
+
+	return msrs;
+}
+EXPORT_SYMBOL(msrs_alloc);
+
+void msrs_free(struct msr *msrs)
+{
+	free_percpu(msrs);
+}
+EXPORT_SYMBOL(msrs_free);
