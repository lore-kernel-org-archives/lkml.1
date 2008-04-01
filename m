Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYDAPpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYDAPpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbYDAPom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:44:42 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:21993 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYDAPol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:44:41 -0400
Date: Tue, 1 Apr 2008 17:42:21 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] x86: optimize find_first_bit for small bitmaps
Message-ID: <20080401154221.GB26062@mailshack.com>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com> <20080401154126.GA26062@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401154126.GA26062@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 01 Apr 2008 17:44:22 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.78; VDF: 7.0.3.103; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: optimize find_first_bit for small bitmaps

Avoid a call to find_first_bit if the bitmap size is know at
compile time and small enough to fit in a single long integer.
Modeled after an optimization in the original x86_64-specific
code.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---
 include/linux/bitops.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 355d67b..48bde60 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -127,6 +127,20 @@ extern unsigned long __find_first_bit(const unsigned long *addr,
 static __always_inline unsigned long
 find_first_bit(const unsigned long *addr, unsigned long size)
 {
+	/* Avoid a function call if the bitmap size is a constant */
+	/* and not bigger than BITS_PER_LONG. */
+
+	/* insert a sentinel so that __ffs returns size if there */
+	/* are no set bits in the bitmap */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG))
+		return __ffs((*addr) | (1ul << size));
+
+	/* the result of __ffs(0) is undefined, so it needs to be */
+	/* handled separately */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
+		return ((*addr) == 0) ? BITS_PER_LONG : __ffs(*addr);
+
+	/* size is not constant or too big */
 	return __find_first_bit(addr, size);
 }
 
@@ -143,6 +157,21 @@ extern unsigned long __find_first_zero_bit(const unsigned long *addr,
 static __always_inline unsigned long
 find_first_zero_bit(const unsigned long *addr, unsigned long size)
 {
+	/* Avoid a function call if the bitmap size is a constant */
+	/* and not bigger than BITS_PER_LONG. */
+
+	/* insert a sentinel so that __ffs returns size if there */
+	/* are no set bits in the bitmap */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+		return __ffs(~(*addr) | (1ul << size));
+	}
+
+	/* the result of __ffs(0) is undefined, so it needs to be */
+	/* handled separately */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
+		return (~(*addr) == 0) ? BITS_PER_LONG : __ffs(~(*addr));
+
+	/* size is not constant or too big */
 	return __find_first_zero_bit(addr, size);
 }
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
-- 
1.5.2.5


