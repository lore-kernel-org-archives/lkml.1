Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbZAVWXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbZAVWXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZAVWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:22:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:17901 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbZAVWWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:22:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,308,1231142400"; 
   d="scan'208";a="659386051"
Date: Thu, 22 Jan 2009 14:22:50 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Avuton Olrich <avuton@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due to dc1e35c
Message-ID: <20090122222250.GI28352@linux-os.sc.intel.com>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com> <20090119215736.GE31356@linux-os.sc.intel.com> <4974F9A8.7060107@zytor.com> <87bpu1dyl6.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpu1dyl6.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 09:20:37PM -0800, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> >
> > We should, or if this block is reversible, we should probably just
> > undo it (the reason people put this block in places is because of,
> > ahem, inferior operating systems having bugs.)
> 
> Even if it's undone it would be still a good idea to make the cpuid
> code bulletproof, just in case someone writes a broken emulator or similar.

Ok. Here is the patch for this aswell. Thanks.

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch] x86: check for the presence of cpuid xsave leaf

Avuton Olrich reported early boot crashes with v2.6.28 and
bisected it down to dc1e35c6e95e8923cf1d3510438b63c600fee1e2
("x86, xsave: enable xsave/xrstor on cpus with xsave support").

Root cause of this showed that bios has enabled the "Max CPUID Value Limit:"
option which confuses the kernel by showing xsave capability without
the cpuid xsave leaf.

Peter fixed the impact of bios limiting the cpuid limit by checking
for the limit bit set in the MSR_IA32_MISC_ENABLE is set and clearing it.

Andi suggests to make xsave code also bulletproof, just incase if someone
writes a  broken simulator.

Check for the presence of CPUID_XSAVE_LEAF before enabling it.

Reported-and-bisected-by: Avuton Olrich <avuton@gmail.com>
Tested-by: Avuton Olrich <avuton@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 08e9a1a..96bb62f 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -27,7 +27,7 @@ extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern struct xsave_struct *init_xstate_buf;
 
-extern void xsave_cntxt_init(void);
+extern int xsave_cntxt_init(void);
 extern void xsave_init(void);
 extern int init_fpu(struct task_struct *child);
 extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index b0f61f0..2e2e8b1 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -65,10 +65,8 @@ void __cpuinit init_thread_xstate(void)
 		return;
 	}
 
-	if (cpu_has_xsave) {
-		xsave_cntxt_init();
+	if (!xsave_cntxt_init())
 		return;
-	}
 
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2b54fe0..5384a3b 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -307,14 +307,25 @@ static void __init setup_xstate_init(void)
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
 }
 
+#define CPUID_XSAVE_LEAF	0xd
+
 /*
  * Enable and initialize the xsave feature.
  */
-void __ref xsave_cntxt_init(void)
+int __ref xsave_cntxt_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
-	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	if (!cpu_has_xsave)
+		return -1;
+
+	if (boot_cpu_data.cpuid_level < CPUID_XSAVE_LEAF) {
+		printk(KERN_ERR "cpuid xsave leaf 0xd not supported\n");
+		setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+		return -1;
+	}
+
+	cpuid_count(CPUID_XSAVE_LEAF, 0, &eax, &ebx, &ecx, &edx);
 	pcntxt_mask = eax + ((u64)edx << 32);
 
 	if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
@@ -342,4 +353,5 @@ void __ref xsave_cntxt_init(void)
 	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv 0x%llx, "
 	       "cntxt size 0x%x\n",
 	       pcntxt_mask, xstate_size);
+	return 0;
 }
