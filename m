Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839Ab0AEPWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0AEPWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821Ab0AEPWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:22:22 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:52112 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab0AEPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:22:20 -0500
Date: Tue, 5 Jan 2010 16:22:15 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] sparc: copy_from_user() should not return -EFAULT
Message-ID: <20100105152215.GD5480@osiris.boeblingen.de.ibm.com>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
 <20100104174308.0790757c@infradead.org>
 <20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
 <201001051347.21309.arnd@arndb.de>
 <20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
 <20100105053117.6a7c3377@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105053117.6a7c3377@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] sparc: copy_from_user() should not return -EFAULT

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Callers of copy_from_user() expect it to return the number of bytes
it could not copy. In no case it is supposed to return -EFAULT.

In case of a detected buffer overflow just return the requested
length. In addition one could think of a memset that would clear
the size of the target object.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/sparc/include/asm/uaccess_32.h |    2 +-
 arch/sparc/include/asm/uaccess_64.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/uaccess_32.h
+++ b/arch/sparc/include/asm/uaccess_32.h
@@ -274,7 +274,7 @@ static inline unsigned long copy_from_us
 
 	if (unlikely(sz != -1 && sz < n)) {
 		copy_from_user_overflow();
-		return -EFAULT;
+		return n;
 	}
 
 	if (n && __access_ok((unsigned long) from, n))
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -221,8 +221,8 @@ extern unsigned long copy_from_user_fixu
 static inline unsigned long __must_check
 copy_from_user(void *to, const void __user *from, unsigned long size)
 {
-	unsigned long ret = (unsigned long) -EFAULT;
 	int sz = __compiletime_object_size(to);
+	unsigned long ret = size;
 
 	if (likely(sz == -1 || sz >= size)) {
 		ret = ___copy_from_user(to, from, size);
