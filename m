Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbYB1WLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbYB1WLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759581AbYB1WLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:11:06 -0500
Received: from c60.cesmail.net ([216.154.195.49]:18911 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759626AbYB1WLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:11:05 -0500
Subject: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only symbols
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 17:11:02 -0500
Message-Id: <1204236662.3612.6.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A change after 2.6.24 broke ndiswrapper by accidentally removing its
access to GPL-only symbols.  Revert that change and add comments about
the reasons why ndiswrapper and driverloader are treated in a special
way.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 kernel/module.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)


diff --git a/kernel/module.c b/kernel/module.c
index 901cd6a..a11f523 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1933,8 +1933,15 @@ static struct module *load_module(void __user *umod,
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
 
+	/*
+	 * ndiswrapper is under GPL by itself, but loads proprietary modules.
+	 * Don't use add_taint_module(), as it would prevent ndiswrapper from
+	 * using GPL-only symbols it needs.
+	 */
 	if (strcmp(mod->name, "ndiswrapper") == 0)
-		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+		add_taint(TAINT_PROPRIETARY_MODULE);
+
+	/* driverloader was caught wrongly pretending to be under GPL */
 	if (strcmp(mod->name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 

-- 
Regards,
Pavel Roskin
