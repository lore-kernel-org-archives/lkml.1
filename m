Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZHZMc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZHZMc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbZHZMc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:32:57 -0400
Received: from ozlabs.org ([203.10.76.45]:42713 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbZHZMc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:32:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] module: fix BUG_ON() for powerpc (and other function descriptor archs)
Date: Wed, 26 Aug 2009 22:02:54 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908262202.54457.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rarely-used symbol_put_addr() needs to use dereference_function_descriptor
on powerpc.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au.

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -909,16 +909,18 @@ void __symbol_put(const char *symbol)
 }
 EXPORT_SYMBOL(__symbol_put);
 
+/* Note this assumes addr is a function, which it currently always is. */
 void symbol_put_addr(void *addr)
 {
 	struct module *modaddr;
+	unsigned long a = (unsigned long)dereference_function_descriptor(addr);
 
-	if (core_kernel_text((unsigned long)addr))
+	if (core_kernel_text(a))
 		return;
 
 	/* module_text_address is safe here: we're supposed to have reference
 	 * to module from symbol_get, so it can't go away. */
-	modaddr = __module_text_address((unsigned long)addr);
+	modaddr = __module_text_address(a);
 	BUG_ON(!modaddr);
 	module_put(modaddr);
 }
