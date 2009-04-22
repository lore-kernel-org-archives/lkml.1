Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZDVPr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZDVPr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZDVPrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:47:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45248 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZDVPrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:47:18 -0400
Subject: [RFC] __ffs64()
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 22 Apr 2009 16:46:32 +0100
Message-Id: <1240415192.29604.90.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to add a new bitop, __ffs64() which I need in order to fix a
bug in GFS2. The question is, where should it go?

On 64 bit arches, __ffs64() would be a synonym for __ffs(), but on 32
bit arches it degenerates to a conditional plus a call to __ffs(). I'm
assuming that there would not be a lot of point in optimising this
operation on 32 bit arches even if such an instruction was available, so
that I should do something like the below patch.

Does that seem reasonable, or should I give it a separate header file
under asm-generic/bitops/ like some of the similar operations? It looks
like I'd have to touch a lot of other files if I were to go that route,

Steve.

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 6182913..d15255f 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -112,6 +112,23 @@ static inline unsigned fls_long(unsigned long l)
 	return fls64(l);
 }
 
+/**
+ * __ffs64 - find first set bit in a 64 bit word
+ * @word: The 64 bit word
+ *
+ * On 64 bit arches this is a synomyn for __ffs
+ */
+static inline unsigned long __ffs64(u64 word)
+{
+#if BITS_PER_LONG == 32
+	if (((u32)word) == 0UL)
+		return __ffs((u32)(word >> 32)) + 32;
+#elif BITS_PER_LONG != 64
+#error BITS_PER_LONG not 32 or 64
+#endif
+	return __ffs((unsigned long)word);
+}
+
 #ifdef __KERNEL__
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 


