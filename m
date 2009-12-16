Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbZLPVyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbZLPVyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZLPVyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:54:21 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55495 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbZLPVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kUTxyobDIDb0bkYJaBRplAdlTfvL2JIX9sq9sKBSgHfF0gcJh7Y9M3+3J3JJEFROW2
         pK6f+Hg3sKY9sC7Tfo71em+jthM38bPVctLPQS6DHK0+FKDfEuI1VswynSMmc/tjhj4g
         +8hyGHLRv0msGWXbHKVE85yNUt2+aMuj17VAs=
Date: Wed, 16 Dec 2009 22:54:11 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 16 (amd64_edac)
Message-ID: <20091216215411.GA27228@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20091216183212.118c5e14.sfr@canb.auug.org.au>
 <20091216092424.5f87214c.randy.dunlap@oracle.com>
 <4B2919BD.40001@zytor.com>
 <20091216174524.GH11618@aftab>
 <4B2928AC.3020807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B2928AC.3020807@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:36:28AM -0800, H. Peter Anvin wrote:
> On 12/16/2009 09:45 AM, Borislav Petkov wrote:
> >>>
> >>> Should EDAC_AMD64 also depend on SMP?
> >>
> >> That seems absurd... more likely msrs_free/msrs_alloc should not be
> >> SMP-specific, or stubs need to be provided.
> > 
> > see <arch/x86/lib/Makefile>:
> > 
> > obj-$(CONFIG_SMP) := msr.o
> > 
> 
> Yes, because the stubs live as inlines in arch/x86/include/asm/msr.h.
> 
> This needs to be fixed ASAP.

Well, how about something in the likes of below:

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 16 Dec 2009 22:49:18 +0100
Subject: [PATCH] x86, msr: fix CONFIG_SMP=n build

Randy Dunlap reported the following build error:

"When CONFIG_SMP=n, CONFIG_X86_MSR=m:

ERROR: "msrs_free" [drivers/edac/amd64_edac_mod.ko] undefined!
ERROR: "msrs_alloc" [drivers/edac/amd64_edac_mod.ko] undefined!"

This is due to the fact that <arch/x86/lib/msr.c> is conditioned on
CONFIG_SMP and in the UP case we have only the stubs in the header. Pull
CONFIG_SMP into the aforementioned file and make msrs_{alloc,free} build
unconditionally.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/lib/Makefile |    4 +---
 arch/x86/lib/msr.c    |   44 ++++++++++++++++++++++++--------------------
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 45b20e4..1a0e470 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -14,15 +14,13 @@ $(obj)/inat.o: $(obj)/inat-tables.c
 
 clean-files := inat-tables.c
 
-obj-$(CONFIG_SMP) := msr.o
-
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_KPROBES) += insn.o inat.o
 
-obj-y += msr-reg.o msr-reg-export.o
+obj-y += msr.o msr-reg.o msr-reg-export.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 8728341..542fbb4 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -10,6 +10,7 @@ struct msr_info {
 	int err;
 };
 
+#ifdef CONFIG_SMP
 static void __rdmsr_on_cpu(void *info)
 {
 	struct msr_info *rv = info;
@@ -118,26 +119,6 @@ void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
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
@@ -234,3 +215,26 @@ int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
 	return err ? err : rv.err;
 }
 EXPORT_SYMBOL(wrmsr_safe_regs_on_cpu);
+#endif /* CONFIG_SMP */
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
+
+
-- 
1.6.5


-- 
Regards/Gruss,
    Boris.
