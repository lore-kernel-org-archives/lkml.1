Return-Path: <linux-kernel-owner+w=401wt.eu-S933561AbXLNN2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbXLNN2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbXLNN17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:27:59 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3281 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752439AbXLNN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:27:58 -0500
Date: Fri, 14 Dec 2007 21:27:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071214132755.GA18309@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

[PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off

The description of CONFIG_BUG clearly states that both BUG and
WARN_ON may be skipped.  However, our actual implementation still
checks the condition on WARN_ON if it's used as part of an if
statement or such.

This patch makes it return 0 after evaluating the expression
if CONFIG_BUG is disabled.  This is consistent with the spirit
of the CONFIG_BUG option.

The same change is made to WARN_ON_ONCE.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index d56fedb..3e74278 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -43,6 +43,16 @@ struct bug_entry {
 })
 #endif
 
+#define WARN_ON_ONCE(condition)	({				\
+	static int __warned;					\
+	int __ret_warn_once = !!(condition);			\
+								\
+	if (unlikely(__ret_warn_once))				\
+		if (WARN_ON(!__warned)) 			\
+			__warned = 1;				\
+	unlikely(__ret_warn_once);				\
+})
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG()
@@ -53,22 +63,11 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
+#define WARN_ON(condition) ((condition), 0)
 #endif
 
-#define WARN_ON_ONCE(condition)	({				\
-	static int __warned;					\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once))				\
-		if (WARN_ON(!__warned)) 			\
-			__warned = 1;				\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_ON_ONCE(condition) ((condition), 0)
+#endif
 
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
