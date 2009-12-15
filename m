Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbZLOEI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbZLOEI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759194AbZLOEIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:08:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534AbZLOEHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:30 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 16/20] Fix 32-bit mult_precise
Date: Mon, 14 Dec 2009 18:08:43 -1000
Message-Id: <1260850127-9766-17-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-16-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
 <1260850127-9766-9-git-send-email-zamsden@redhat.com>
 <1260850127-9766-10-git-send-email-zamsden@redhat.com>
 <1260850127-9766-11-git-send-email-zamsden@redhat.com>
 <1260850127-9766-12-git-send-email-zamsden@redhat.com>
 <1260850127-9766-13-git-send-email-zamsden@redhat.com>
 <1260850127-9766-14-git-send-email-zamsden@redhat.com>
 <1260850127-9766-15-git-send-email-zamsden@redhat.com>
 <1260850127-9766-16-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out it wasn't very precise; it needs to work on 64-bit values.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e2ba3e..792c895 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -803,15 +803,27 @@ static void compute_best_multiplier(unsigned long a, unsigned long b,
 	*s = shift;
 }
 
-static inline unsigned long mult_precise(unsigned long val, unsigned long mult,
-	int shift)
+static inline u64 mult_precise(u64 val, unsigned long mult, int shift)
 {
+#if (BITS_PER_LONG == 64)
 	unsigned long top, bot;
 
-	__asm__ ( "mul %3; shrd %1, %0" :
+	__asm__ ( "mulq %3; shrdq %1, %0" :
 		 "=&a" (bot), "=&d" (top) :
 		 "0" (mult), "rm" (val), "c" (shift));
 	return bot;
+#else
+	unsigned long ltop, lbot;
+	unsigned long htop, hbot;
+
+	__asm__ ( "mull %3; shrd %1, %0" :
+		 "=&a" (lbot), "=&d" (ltop) :
+		 "0" (mult), "rm" (long)(val), "c" (shift));
+	__asm__ ( "mull %3; shrd %1, %0" :
+		 "=&a" (hbot), "=&d" (htop) :
+		 "0" (mult), "rm" (long)(val >> 32), "c" (shift));
+	return (u64)lbot + ((u64)ltop + (u64)hbot) << 32;
+#endif
 }
 
 static inline u64 compute_ref_tsc(void)
-- 
1.6.5.2

