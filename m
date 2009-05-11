Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZEKPH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZEKPH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZEKPHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:07:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:45535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZEKPHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:07:07 -0400
Date: Mon, 11 May 2009 15:06:33 GMT
From: tip-bot for Ian Campbell <Ian.Campbell@eu.citrix.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ian.campbell@citrix.com, Jeremy.Fitzhardinge@citrix.com,
       tglx@linutronix.de, Ian.Campbell@eu.citrix.com, mingo@elte.hu,
       xen-devel@lists.xensource.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, Jeremy.Fitzhardinge@citrix.com,
       tglx@linutronix.de, Ian.Campbell@eu.citrix.com, mingo@elte.hu,
       xen-devel@lists.xensource.com
In-Reply-To: <1241797927.15972.51.camel@zakaz.uk.xensource.com>
References: <1241797927.15972.51.camel@zakaz.uk.xensource.com>
Subject: [tip:x86/xen] x86: use flush_tlb_others to implement flush_tlb_all, fix
Message-ID: <tip-c3f10fbccdb558dbc0652487502bbd7150231945@git.kernel.org>
Git-Commit-ID: c3f10fbccdb558dbc0652487502bbd7150231945
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 15:06:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3f10fbccdb558dbc0652487502bbd7150231945
Gitweb:     http://git.kernel.org/tip/c3f10fbccdb558dbc0652487502bbd7150231945
Author:     Ian Campbell <Ian.Campbell@eu.citrix.com>
AuthorDate: Fri, 8 May 2009 16:52:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 17:03:02 +0200

x86: use flush_tlb_others to implement flush_tlb_all, fix

"use the flush_tlb_others() call to implement flush_tlb_all()"
causes:
         BUG: spinlock bad magic on CPU#0, swapper/0
          lock: c05b7588, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
         Pid: 0, comm: swapper Not tainted 2.6.30-rc3-x86_32p-xen0-tip-01797-g3db7847 #1054
         Call Trace:
          [<c023e656>] spin_bug+0x96/0xf0
          [<c023e90f>] _raw_spin_lock+0x6f/0x150

It can be called before the core_initcalls are run. Explicitly call
init_smp_flush early on.

Also there is no need for init_smp_flush to be __cpuinit.

[ Impact: fix boot crash/warning ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Xen-devel <xen-devel@lists.xensource.com>
Acked-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
LKML-Reference: <1241797927.15972.51.camel@zakaz.uk.xensource.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/tlbflush.h |    2 ++
 arch/x86/kernel/setup.c         |    2 ++
 arch/x86/mm/tlb.c               |    3 +--
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 16a5c84..2a4848d 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -129,6 +129,8 @@ static inline void reset_lazy_tlbstate(void)
 
 #define local_flush_tlb() __flush_tlb()
 
+extern int init_smp_flush(void);
+
 extern void flush_tlb_all(void);
 extern void flush_tlb_current_task(void);
 extern void flush_tlb_mm(struct mm_struct *);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..bde4baf 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -984,6 +984,8 @@ void __init setup_arch(char **cmdline_p)
 
 	e820_setup_gap();
 
+	init_smp_flush();
+
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
 	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index e69bdad..0f030fb 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -229,7 +229,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
-static int __cpuinit init_smp_flush(void)
+int __init init_smp_flush(void)
 {
 	int i;
 
@@ -238,7 +238,6 @@ static int __cpuinit init_smp_flush(void)
 
 	return 0;
 }
-core_initcall(init_smp_flush);
 
 void flush_tlb_current_task(void)
 {
