Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYHaNwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYHaNwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYHaNvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:51:54 -0400
Received: from mx1.wp.pl ([212.77.101.5]:63089 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548AbYHaNvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:51:54 -0400
Date: Sun, 31 Aug 2008 15:58:28 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH] x86: amd k6-2 mtrr not detected fix
Message-Id: <20080831155828.d7dd0a76.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [obP1]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

The AMD K6-2 cpus have 2 mtrr registers 
which are not detected by the latest Linux
kernel.
The mtrr capability is not reported through
the cpuid on these cpus. This fools early
detection function [mtrr_bp_init()] as the
mtrr capability bit is set later in
the init_amd() function.
Fix it by setting the K6 mtrr capability bit
just before the check in mtrr_bp_init().
The added condition is copied from the init_amd().

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

It seems that the same problem affects Cyrix and
Centaur/VIA cpus. Can some x86 guy inspect the
mtrr initialization code ?

 arch/x86/kernel/cpu/mtrr/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 58ac5d3..4bef914 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1612,6 +1612,12 @@ void __init mtrr_bp_init(void)
 	} else {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_AMD:
+			if (boot_cpu_data.x86_model == 13 ||
+			    boot_cpu_data.x86_model == 9 ||
+			    (boot_cpu_data.x86_model == 8 &&
+			     boot_cpu_data.x86_mask >= 8))
+				set_cpu_cap(&boot_cpu_data,
+					    X86_FEATURE_K6_MTRR);
 			if (cpu_has_k6_mtrr) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
 				mtrr_if = mtrr_ops[X86_VENDOR_AMD];
-- 
1.5.2.2

