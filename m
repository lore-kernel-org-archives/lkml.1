Return-Path: <linux-kernel-owner+w=401wt.eu-S965218AbXBYXSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218AbXBYXSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965225AbXBYXSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:18:34 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44217 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965218AbXBYXSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:18:33 -0500
Date: Mon, 26 Feb 2007 00:18:33 +0100
From: Adrian Bunk <bunk@stusta.de>
To: zippel@linux-m68k.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kconfig: abort configuration with recursive dependencies
Message-ID: <20070225231833.GC29575@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A recursive kconfig dependency is a bug that has to be fixed, and that 
might currently not be noted until booting the built kernel.

Currently, the warning that a recursive dependency was detected scrolls 
away during "make oldconfig", and often people don't notice until they 
booted the kernel and note something like "Why is there no IPV6 support?".

This patch therefore lets the configuration fail if kconfig found a 
recursive dependency.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-mm2/scripts/kconfig/symbol.c.old	2007-02-25 19:27:07.000000000 +0100
+++ linux-2.6.20-mm2/scripts/kconfig/symbol.c	2007-02-25 19:30:32.000000000 +0100
@@ -792,7 +792,7 @@
 	struct property *prop;
 
 	if (sym->flags & SYMBOL_CHECK) {
-		printf("Warning! Found recursive dependency: %s", sym->name);
+		printf("Error: Found recursive dependency: %s", sym->name);
 		return sym;
 	}
 	if (sym->flags & SYMBOL_CHECKED)
@@ -820,7 +820,7 @@
 		printf(" %s", sym->name);
 		if (sym2 == sym) {
 			printf("\n");
-			sym2 = NULL;
+			exit(1);
 		}
 	}
 	sym->flags &= ~SYMBOL_CHECK;

