Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbXKLNS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbXKLNS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbXKLNSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:18:48 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:2482 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380AbXKLNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:18:47 -0500
Subject: [PATCH] module loader should not complain about unknown symbol
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Pavel Emelyanov <xemul@openvz.org>,
       Andi Kleen <andi@firstfloor.org>, Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 14:18:27 +0000
Message-Id: <1194877107.5656.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If module A depends on module B and module B has not yet finished its
init() the module loader may print a warning about an unknown symbol.

This happens if module B is still in state MODULE_STATE_COMING,
as module A runs into resolve_symbol() for a symbol from module B.
resolve_symbol() return 0 in that case and causes the warning.

---
Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2007-11-12 13:53:44.000000000 +0000
+++ linux-2.6/kernel/module.c	2007-11-12 13:54:33.000000000 +0000
@@ -1411,8 +1411,8 @@
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
 				break;
 
-			printk(KERN_WARNING "%s: Unknown symbol %s\n",
-			       mod->name, strtab + sym[i].st_name);
+			DEBUGP("%s: Unknown symbol %s\n", mod->name,
+			       strtab + sym[i].st_name);
 			ret = -ENOENT;
 			break;

