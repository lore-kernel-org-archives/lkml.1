Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYIPQcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYIPQcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYIPQcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:32:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYIPQce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:32:34 -0400
Message-ID: <48CFDF82.3000704@zytor.com>
Date: Tue, 16 Sep 2008 09:32:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux@sandersweb.net
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Don't use NOPL on 32-bit cpu's because not all systems
 support it.
References: <200809161159.15870.linux@sandersweb.net>
In-Reply-To: <200809161159.15870.linux@sandersweb.net>
Content-Type: multipart/mixed;
 boundary="------------060507030907050308070101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060507030907050308070101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Sanders wrote:
> From: David Sanders <linux@sandersweb.net>
> 
> Currently in alternative.c NOPLs are introduced based on the synthetic
> cpu feature X86_FEATURE_NOPL.  However, some systems (like Virtual PC 2007)
> appear to support it but then will not boot 50% of the time because of
> the NOPLs (when paravirtualization support is built into kernel).
> This patch standardizes the treatment of NOPL to be like
> include/asm-x86/nops.h which only uses NOPLs on 64-bit processors.
> 

Oh good grief.

VPC is apparently so broken that these instructions work *some* of the 
time, which may include the first time, but not later.  That is an 
impressive level of cockup.

Given that, we should either just rip this code out, or detect VPC 
(how?).  The latter option can be done post-.27, of course; if so, we 
should just force the bit off for now rather than doing it in the 
alternatives code.  The only reason for doing the latter at all would be 
to mitigate the overhead of paravirt_ops and other dynamic patch sites.

It would also be the least impact for .27, I believe.

	-hpa

--------------060507030907050308070101
Content-Type: text/x-patch;
 name="0001-x86-completely-disable-NOPL-on-32-bits.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-x86-completely-disable-NOPL-on-32-bits.patch"

>From 62e240f4f79d0473c91b12cbc1254f85bffee14b Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Tue, 16 Sep 2008 09:29:40 -0700
Subject: [PATCH] x86: completely disable NOPL on 32 bits

Completely disable NOPL on 32 bits.  It turns out that Microsoft
Virtual PC is so broken it can't even reliably *fail* in the presence
of NOPL.

This leaves the infrastructure in place but disables it
unconditionally.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/common.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8aab851..4e456bd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -344,31 +344,15 @@ static void __init early_cpu_detect(void)
 
 /*
  * The NOPL instruction is supposed to exist on all CPUs with
- * family >= 6, unfortunately, that's not true in practice because
+ * family >= 6; unfortunately, that's not true in practice because
  * of early VIA chips and (more importantly) broken virtualizers that
- * are not easy to detect.  Hence, probe for it based on first
- * principles.
+ * are not easy to detect.  In the latter case it doesn't even *fail*
+ * reliably, so probing for it doesn't even work.  Disable it completely
+ * unless we can find a reliable way to detect all the broken cases.
  */
 static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 {
-	const u32 nopl_signature = 0x888c53b1; /* Random number */
-	u32 has_nopl = nopl_signature;
-
 	clear_cpu_cap(c, X86_FEATURE_NOPL);
-	if (c->x86 >= 6) {
-		asm volatile("\n"
-			     "1:      .byte 0x0f,0x1f,0xc0\n" /* nopl %eax */
-			     "2:\n"
-			     "        .section .fixup,\"ax\"\n"
-			     "3:      xor %0,%0\n"
-			     "        jmp 2b\n"
-			     "        .previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : "+a" (has_nopl));
-
-		if (has_nopl == nopl_signature)
-			set_cpu_cap(c, X86_FEATURE_NOPL);
-	}
 }
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
-- 
1.6.0.1


--------------060507030907050308070101--
