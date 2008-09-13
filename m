Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYIMK4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYIMK4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYIMKzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:55:54 -0400
Received: from mx1.wp.pl ([212.77.101.5]:63147 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbYIMKzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:55:53 -0400
Date: Sat, 13 Sep 2008 12:56:06 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH] x86: better CPU identification without the CPUID
Message-Id: <20080913125606.d655bdcf.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [YRP0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

cpus without the CPUID instruction are identified
as general 386 or 486 while some cpus (mostly made
by Cyrix) provide c_identify function which identify
correctly older cpus using cpu specific registers).

Cyrix cpus are even worse as 5x86 and 6x68 have
the CPUID instruction disabled. The CPUID is
enabled by the c_identify() but the c_identify
is only called when the CPUID is available.

Fix this by calling the c_identify() for all known
cpu families if there is no the CPUID instruction

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

I have tested it on Cyrix Cx486DX2 cpu.

I suspect that coma_bug field and mtrr support is not
set correctly for the Cyrix 6x86 family. I have not a cpu from
the Cyrix 6x68 family to test. 

The code path is (+ where the patch code is added)

if (have_cpuid_p()) {

}
+ } else {
...
+ }

so it does not affect cpus with the CPUID instruction.

Regards,
Krzysztof

diff -urp linux-mm/arch/x86/kernel/cpu/common.c linux-486/arch/x86/kernel/cpu/common.c
--- linux-mm/arch/x86/kernel/cpu/common.c	2008-09-05 23:38:20.295563396 +0200
+++ linux-486/arch/x86/kernel/cpu/common.c	2008-09-12 22:53:27.062265329 +0200
@@ -444,6 +444,17 @@ static void __cpuinit generic_identify(s
 
 		init_scattered_cpuid_features(c);
 		detect_nopl(c);
+	} else {
+		int i;
+		for (i = 0; i < X86_VENDOR_NUM; i++)
+			if (cpu_devs[i] && cpu_devs[i]->c_identify) {
+				c->x86_vendor_id[0] = 0;
+				cpu_devs[i]->c_identify(c);
+				if (c->x86_vendor_id[0]) {
+					get_cpu_vendor(c, 0);
+					break;
+				}
+			}
 	}
 }
 
