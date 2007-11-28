Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbXK1MUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbXK1MUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXK1MUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:20:30 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:19357 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753313AbXK1MUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:20:30 -0500
Date: Wed, 28 Nov 2007 21:20:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>, zippel@linux-m68k.org,
       Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: Make KCONFIG_ALLCONFIG work with randconfig.
Message-ID: <20071128122011.GB29552@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>, zippel@linux-m68k.org,
	Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian mentioned a few weeks ago that KCONFIG_ALLCONFIG is the way to
go to ensure that things like allyes/allmod/allnoconfig work with a
constrained set of symbols, with the implication that this holds
true for randconfig as well.

While allyes/mod/noconfigs do seem to work fine with KCONFIG_ALLCONFIG
provisions, randconfig tramples all over the provided values at perhaps
not surprisingly, random.

Debugging this a bit, there seemed to be two issues:

	- SYMBOL_DEF and SYMBOL_DEF_USER overlap, which made
	  def_sym->flags the same regardless of whether we came from an
	  KCONFIG_ALLCONFIG path or not.

	- clobbering of the fixed value in conf_choice() by way of
	  random() def assignment.

While I don't pretend to have any idea what I'm doing in Kconfig,
changing SYMBOL_DEF_USER to reuse the SYMBOL_DEF3 bit (and thereby
separating it from SYMBOL_DEF) in addition to checking the def_sym flag
before randomly assigning a new value ended up fixing things up.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 scripts/kconfig/conf.c |    9 ++++++++-
 scripts/kconfig/expr.h |    3 +--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index a38787a..61a61df 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -374,7 +374,14 @@ static int conf_choice(struct menu *menu)
 				continue;
 			break;
 		case set_random:
-			def = (random() % cnt) + 1;
+			/*
+			 * Defined symbols need to be honoured even in
+			 * the randomization case, or else symbols set
+			 * via the KCONFIG_ALLCONFIG path are clobbered.
+			 *				- PFM.
+			 */
+			if (!(def_sym->flags & SYMBOL_DEF))
+				def = (random() % cnt) + 1;
 		case set_default:
 		case set_yes:
 		case set_mod:
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index a195986..f5b4873 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -95,9 +95,8 @@ struct symbol {
 #define SYMBOL_CHECKED		0x2000
 #define SYMBOL_WARNED		0x8000
 #define SYMBOL_DEF		0x10000
-#define SYMBOL_DEF_USER		0x10000
 #define SYMBOL_DEF_AUTO		0x20000
-#define SYMBOL_DEF3		0x40000
+#define SYMBOL_DEF_USER		0x40000
 #define SYMBOL_DEF4		0x80000
 
 #define SYMBOL_MAXLENGTH	256
