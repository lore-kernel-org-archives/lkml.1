Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYJZFMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYJZFMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 01:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJZFMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 01:12:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43760 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYJZFMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 01:12:41 -0400
Date: Sun, 26 Oct 2008 05:12:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix allmodconfig breakage
Message-ID: <20081026051234.GN28946@ZenIV.linux.org.uk>
References: <20081025211107.GA20417@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025211107.GA20417@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	If you use KCONFIG_ALLCONFIG (even with empty file) you get
broken allmodconfig/allyesconfig; CONFIG_MODULES gets turned off,
with obvious massive fallout.

	Breakage had been introduced when conf_set_all_new_symbols()
got used for allmodconfig et.al.

	What happens is that sym_calc_value(modules_sym) done in
conf_read_simple() sets SYMBOL_VALID on both modules_sym and MODULES.
When we get to conf_set_all_new_symbols(), we set sym->def[S_DEF_USER]
on everything, but it has no effect on sym->curr for the symbols that
already have SYMBOL_VALID - these are stuck.

	Solution: use sym_clear_all_valid() in there.  Note that it
makes reevaluation of modules_sym redundant - sym_clear_all_valid()
will do that itself.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index b91cf24..830d9ea 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -852,8 +852,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	}
 
-	if (modules_sym)
-		sym_calc_value(modules_sym);
+	sym_clear_all_valid();
 
 	if (mode != def_random)
 		return;
