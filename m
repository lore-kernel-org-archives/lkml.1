Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbYA3KXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbYA3KXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759600AbYA3KU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:20:57 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:20635 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548AbYA3KU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:20:56 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61207061"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org
Cc: Robin Getz <robin.getz@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] [Kallsyms] Blackfin: Allow kernel symbols in L1 to be found
Date: Wed, 30 Jan 2008 18:20:53 +0800
Message-Id: <1201688453-1763-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 kernel/kallsyms.c  |    6 +++++-
 scripts/kallsyms.c |   10 +++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 7dadc71..714bd5b 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -63,7 +63,11 @@ static inline int is_kernel_extratext(unsigned long addr)
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
+	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
+#if defined(CONFIG_BLACKFIN)
+             || (addr >= (unsigned long)_stext_l1 && addr <= (unsigned long)_etext_l1)
+#endif
+	)
 		return 1;
 	return in_gate_area_no_task(addr);
 }
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 1f11d84..8775981 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -12,6 +12,8 @@
  * (25/Aug/2004) Paulo Marques <pmarques@grupopie.com>
  *      Changed the compression method from stem compression to "table lookup"
  *      compression
+ * (10/Jul/2006) Robin Getz <rgetz@blackfin.uclinux.org>
+ *      Add _stext_l1, _etext_l1 for the L1 memory section in Blackfin.
  *
  *      Table compression uses all the unused char codes on the symbols and
  *  maps these to the most used substrings (tokens). For instance, it might
@@ -42,6 +44,7 @@ struct sym_entry {
 static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
 static unsigned long long _text, _stext, _etext, _sinittext, _einittext, _sextratext, _eextratext;
+static unsigned long long _stext_l1, _etext_l1;
 static int all_symbols = 0;
 static char symbol_prefix_char = '\0';
 
@@ -103,6 +106,10 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 		_sextratext = s->addr;
 	else if (strcmp(sym, "_eextratext") == 0)
 		_eextratext = s->addr;
+	else if (strcmp(sym, "_stext_l1" ) == 0)
+		_stext_l1 = s->addr;
+	else if (strcmp(sym, "_etext_l1" ) == 0)
+		_etext_l1 = s->addr;
 	else if (toupper(stype) == 'A')
 	{
 		/* Keep these useful absolute symbols */
@@ -166,7 +173,8 @@ static int symbol_valid(struct sym_entry *s)
 	if (!all_symbols) {
 		if ((s->addr < _stext || s->addr > _etext)
 		    && (s->addr < _sinittext || s->addr > _einittext)
-		    && (s->addr < _sextratext || s->addr > _eextratext))
+		    && (s->addr < _sextratext || s->addr > _eextratext)
+		    && (s->addr < _stext_l1 || s->addr > _etext_l1))
 			return 0;
 		/* Corner case.  Discard any symbols with the same value as
 		 * _etext _einittext or _eextratext; they can move between pass
-- 
1.5.3.4
