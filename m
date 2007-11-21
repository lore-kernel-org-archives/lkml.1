Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbXKUKXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbXKUKXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbXKUKXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:23:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbXKUKXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:23:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 4/5] x86: desc_empty
In-Reply-To: Roland McGrath's message of  Wednesday, 21 November 2007 02:19:28 -0800 <20071121101928.A08CF26F8BE@magilla.localdomain>
References: <20071121101928.A08CF26F8BE@magilla.localdomain>
X-Zippy-Says: Loni Anderson's hair should be LEGALIZED!!
Message-Id: <20071121102302.E5E6C26F8BE@magilla.localdomain>
Date: Wed, 21 Nov 2007 02:23:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This replaces the desc_empty macro with an inline.  It now handles
easily any of the four different types used between 32/64 code to
refer to these 8 bytes.  It's identical in both asm-x86/processor_64.h
and asm-x86/processor_32.h, so if these files ever get merged this
function can be in the common code.

This also removes the desc_equal macro because nothing uses it.

Signed-off-by: Roland McGrath <roland@redhat.com>

diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 13976b0..34e8063 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -30,11 +30,12 @@ struct desc_struct {
 	unsigned long a,b;
 };
 
-#define desc_empty(desc) \
-		(!((desc)->a | (desc)->b))
+static inline int desc_empty(const void *ptr)
+{
+	const u32 *desc = ptr;
+	return !(desc[0] | desc[1]);
+}
 
-#define desc_equal(desc1, desc2) \
-		(((desc1)->a == (desc2)->a) && ((desc1)->b == (desc2)->b))
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index e4f1997..2dd739a 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -32,11 +32,11 @@
 #define VIP_MASK	0x00100000	/* virtual interrupt pending */
 #define ID_MASK		0x00200000
 
-#define desc_empty(desc) \
-               (!((desc)->a | (desc)->b))
-
-#define desc_equal(desc1, desc2) \
-               (((desc1)->a == (desc2)->a) && ((desc1)->b == (desc2)->b))
+static inline int desc_empty(const void *ptr)
+{
+	const u32 *desc = ptr;
+	return !(desc[0] | desc[1]);
+}
 
 /*
  * Default implementation of macro that returns current
