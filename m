Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbZDIKAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbZDIKAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760388AbZDIJ76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:59:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36564 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584AbZDIJ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:59:56 -0400
Message-ID: <49DDC70E.2000602@jp.fujitsu.com>
Date: Thu, 09 Apr 2009 18:59:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
References: <20090407506.675031434@firstfloor.org> <20090407150656.43E161D046D@basil.firstfloor.org> <49DC5D11.4060505@jp.fujitsu.com> <87eiw3a29h.fsf@basil.nowhere.org> <49DD80B4.5060301@jp.fujitsu.com> <20090409071413.GD14687@one.firstfloor.org>
In-Reply-To: <20090409071413.GD14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Apr 09, 2009 at 01:59:32PM +0900, Hidetoshi Seto wrote:
>>>> I guess it would make much sense if we stop mixing RIP and EIP and rename
>>>> the mce_get_rip() to mce_get_eip(), and the rip_msr to eip_msr too.
>>> Ok fair enough.  I admit the code was always a bit dubious.
>>>
>>>> And then it would be acceptable if we print RIP with "!INEXACT!" annotation
>>>> instead of printing precise EIP in case of RIPV=0 but EIPV=1.
>>> Please send a patch to do all that.
>> I will.
>>
>> A trivial question is if you unified 32/64bit mce codes, would you
>> like to print only "IP %02x:<%016Lx>", or "RIP ..." and "EIP ..." ?
> 
> I would prefer to pt in RIP in both cases, simply because i fear breaking
> parsers. I think the 32bit users will survive if their instruction
> pointer is reported as "RIP" too.

I see.  I also supposed it will be an issue on parsers.

In the end, since still this is 64bit code, I decided to keep using "RIP"
as the name of 64bit register.
I found there are two main factor in my trouble:

 1) There are no short description for mce_get_rip()
    I thought the purpose of the function is getting "Return/Restart IP"
    because it worked only if RIPV(Restart IP Valid) bit is set.

 2) The following initialization let me wrong:
      rip_msr = MSR_IA32_MCG_EIP;
    I imagined that the "r" is typo or there are special meaning in the "r".

Following is a proposal version. Maybe dividing it into 2 pieces, function
improvement and MSR definition, would be a good idea.

Comments are welcomed.


Thanks,
H.Seto


[PATCH] x86: MCE: Improve mce_get_rip v2

The mce_get_rip() is a function to get the address of instruction
at the time of the machine check.  Usually the address is stored
on the stack, but it may not always valid.
We can trust the value if MCG_STATUS_RIPV is set, because it means
we can restart the program from the address.

This patch adds new logics:

 - Return rip/cs on the stack if MCG_STATUS_EIPV is set.
   Even the RIPV is not set, EIPV means the address is directly
   associated with the error.
 - Remain m->cs even if accurate RIP is available in rip_msr.

Strictly speaking, in processor with Intel 64 support there are no
MSR named IA32_MCG_EIP, but an alias MSR named IA32_MCG_RIP.
Add definitions for MSRs in the 64bit processor, following the
specification.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/msr-index.h    |   28 +++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/mcheck/mce_64.c |   20 ++++++++++++--------
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ec41fc1..f5cf25f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -244,7 +244,7 @@
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
 
-/* P4/Xeon+ specific */
+/* Extended Machine Check State MSRs (P4/Xeon+ specific) */
 #define MSR_IA32_MCG_EAX		0x00000180
 #define MSR_IA32_MCG_EBX		0x00000181
 #define MSR_IA32_MCG_ECX		0x00000182
@@ -257,6 +257,32 @@
 #define MSR_IA32_MCG_EIP		0x00000189
 #define MSR_IA32_MCG_RESERVED		0x0000018a
 
+/* Extended Machine Check State MSRs (in processors with 64bit support) */
+#define MSR_IA32_MCG_RAX		0x00000180
+#define MSR_IA32_MCG_RBX		0x00000181
+#define MSR_IA32_MCG_RCX		0x00000182
+#define MSR_IA32_MCG_RDX		0x00000183
+#define MSR_IA32_MCG_RSI		0x00000184
+#define MSR_IA32_MCG_RDI		0x00000185
+#define MSR_IA32_MCG_RBP		0x00000186
+#define MSR_IA32_MCG_RSP		0x00000187
+#define MSR_IA32_MCG_RFLAGS		0x00000188
+#define MSR_IA32_MCG_RIP		0x00000189
+#define MSR_IA32_MCG_MISC		0x0000018a
+#define MSR_IA32_MCG_RESERVED1		0x0000018b
+#define MSR_IA32_MCG_RESERVED2		0x0000018c
+#define MSR_IA32_MCG_RESERVED3		0x0000018d
+#define MSR_IA32_MCG_RESERVED4		0x0000018e
+#define MSR_IA32_MCG_RESERVED5		0x0000018f
+#define MSR_IA32_MCG_R8			0x00000190
+#define MSR_IA32_MCG_R9			0x00000191
+#define MSR_IA32_MCG_R10		0x00000192
+#define MSR_IA32_MCG_R11		0x00000193
+#define MSR_IA32_MCG_R12		0x00000194
+#define MSR_IA32_MCG_R13		0x00000195
+#define MSR_IA32_MCG_R14		0x00000196
+#define MSR_IA32_MCG_R15		0x00000197
+
 /* Pentium IV performance counter MSRs */
 #define MSR_P4_BPU_PERFCTR0		0x00000300
 #define MSR_P4_BPU_PERFCTR1		0x00000301
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 95b81eb..374ef6d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -173,21 +173,22 @@ int mce_available(struct cpuinfo_x86 *c)
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
 
+/*
+ * Get the address of instruction at the time of the machine check error.
+ */
 static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 {
-	if (regs && (m->mcgstatus & MCG_STATUS_RIPV)) {
+	/* Use value on the stack if it is meaningful. */
+	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV | MCG_STATUS_EIPV))) {
 		m->ip = regs->ip;
 		m->cs = regs->cs;
 	} else {
 		m->ip = 0;
 		m->cs = 0;
 	}
-	if (rip_msr) {
-		/* Assume the RIP in the MSR is exact. Is this true? */
-		m->mcgstatus |= MCG_STATUS_EIPV;
+	/* Use accurate value if available. */
+	if (rip_msr)
 		rdmsrl(rip_msr, m->ip);
-		m->cs = 0;
-	}
 }
 
 /*
@@ -569,9 +570,12 @@ static int mce_cap_init(void)
 		memset(bank, 0xff, banks * sizeof(u64));
 	}
 
-	/* Use accurate RIP reporting if available. */
+	/*
+	 * Use Extended Machine Check State Register to get accurate state of
+	 * the RIP register at the time of the machine check if available.
+	 */
 	if ((cap & (1<<9)) && ((cap >> 16) & 0xff) >= 9)
-		rip_msr = MSR_IA32_MCG_EIP;
+		rip_msr = MSR_IA32_MCG_RIP;
 
 	return 0;
 }
-- 
1.6.2.2

