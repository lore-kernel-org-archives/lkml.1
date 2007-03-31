Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbXCaHji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbXCaHji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 03:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXCaHji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 03:39:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39600 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbXCaHjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 03:39:37 -0400
Date: Sat, 31 Mar 2007 09:40:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kconfig/kbuild: fix dependency problem
Message-ID: <20070331074021.GB11383@uranus.ravnborg.org>
References: <460BA292.76E4.0078.0@novell.com> <20070331064228.GA11023@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331064228.GA11023@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From bbc89026f3e5d9e437ce4cd26d3013fe226103e2 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@neptun.ravnborg.org>
Date: Sat, 31 Mar 2007 09:34:46 +0200
Subject: [PATCH] kconfig/kbuild: fix dependency problem

Commit 2e3646e51b2d6415549b310655df63e7e0d7a080 changed the way
the split config tree is built, but failed to also adjust fixdep
accordingly - if changing a config option from or to m, files
referencing the respective CONFIG_..._MODULE (but not the
corresponding CONFIG_...) didn't get rebuilt.

This happens because tristate symbol has three values represented
by different CONFIG_ symbols:

=n => CONFIG_SYMBOL undefined
=y => CONFIG_SYMBOL equals 1
=m => CONFIG_SYMBOL_MODULE equals 1

But conf_split_config did not support the _MODULE syntax
and therefore no include/config/symbol/module.h file was
generated/touched when changing a symbol to/from m.
Thus make did nt pick up the change and rebuild failed.

This patch teaches conf_split_config to support the
_MODULE variant.

This fixes a problem reported by Randy Dunlap <randy.dunlap@oracle.com>.
arch/i386/kernel/apm.o revealed this bug.
Original fix was posted by:  "Jan Beulich" <jbeulich@novell.com>
which inspired this better fix.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index ff6b39b..4137961 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -646,6 +646,12 @@ int conf_split_config(void)
 		*d = '\0';
 		if (touch_file(path))
 			return 1;
+		/* For tristate symbols we need to touch symbol/module.h too */
+		if (sym->type == S_TRISTATE) {
+			strcat(path, "/module");
+			if (touch_file(path))
+				return 1;
+		}
 	}
 	if (chdir("../.."))
 		return 1;
-- 
1.5.1.rc3.gaa453

