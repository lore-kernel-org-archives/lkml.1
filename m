Return-Path: <linux-kernel-owner+w=401wt.eu-S965737AbXAYJck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbXAYJck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965741AbXAYJck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:32:40 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:60913 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965737AbXAYJcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:32:39 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 25 Jan 2007 04:32:12 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, dhowells@redhat.com
Subject: [PATCH] Add a rounddown_pow_of_two() macro to log2.h.
Message-ID: <Pine.LNX.4.64.0701250426400.7715@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  In the same way that include/linux/log2.h defines the
roundup_pow_of_two() macro, define the rounddown_pow_of_two() macro so
peopls can stop re-implementing this operation using a loop.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  compile tested on x86 using "make allyesconfig", but there wasn't
much chance of the build failing anyway since the patch only adds the
macro definition, it doesn't change any existing code to use it.
those patches will be submitted later, bit by bit.

diff --git a/include/linux/log2.h b/include/linux/log2.h
index d02e1a5..6cf7081 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -52,6 +63,15 @@ unsigned long __roundup_pow_of_two(unsigned long n)
 	return 1UL << fls_long(n - 1);
 }

+/*
+ * round down to nearest power of two
+ */
+static inline __attribute__((const))
+unsigned long __rounddown_pow_of_two(unsigned long n)
+{
+	return 1UL << (fls_long(n) - 1);
+}
+
 /**
  * ilog2 - log of base 2 of 32-bit or a 64-bit unsigned value
  * @n - parameter
@@ -154,4 +174,20 @@ unsigned long __roundup_pow_of_two(unsigned long n)
 	__roundup_pow_of_two(n)			\
  )

+/**
+ * rounddown_pow_of_two - round the given value down to nearest power of two
+ * @n - parameter
+ *
+ * round the given value down to the nearest power of two
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define rounddown_pow_of_two(n)			\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n == 1) ? 0 :			\
+		(1UL << ilog2(n)) :		\
+	__rounddown_pow_of_two(n)		\
+ )
+
 #endif /* _LINUX_LOG2_H */

-- 
==============================================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Kernel_Janitor%27s_Todo_List
==============================================================================================
