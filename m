Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbYDYK2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbYDYK2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbYDYK2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:28:42 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36952 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbYDYK2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:28:41 -0400
X-IronPort-AV: E=Sophos;i="4.25,707,1199682000"; 
   d="scan'208";a="52531679"
From: Bryan Wu <cooloney@kernel.org>
To: pmarques@grupopie.com, linux-kernel@vger.kernel.org
Cc: Robin Getz <robin.getz@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] kallsyms: Allow kernel symbols in L1 to be found in Blackfin architecture
Date: Fri, 25 Apr 2008 18:28:18 +0800
Message-Id: <1209119299-27894-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209119299-27894-1-git-send-email-cooloney@kernel.org>
References: <1209119299-27894-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Add _stext_l1, _etext_l1 for the L1 memory section in Blackfin.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 kernel/kallsyms.c  |    6 +++++-
 scripts/kallsyms.c |    8 +++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index f091d13..456d1f6 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -55,7 +55,11 @@ static inline int is_kernel_inittext(unsigned long addr)
 
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
index c912137..0f7269f 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -41,6 +41,7 @@ struct sym_entry {
 static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
 static unsigned long long _text, _stext, _etext, _sinittext, _einittext;
+static unsigned long long _stext_l1, _etext_l1;
 static int all_symbols = 0;
 static char symbol_prefix_char = '\0';
 
@@ -98,6 +99,10 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 		_sinittext = s->addr;
 	else if (strcmp(sym, "_einittext") == 0)
 		_einittext = s->addr;
+	 else if (strcmp(sym, "_stext_l1" ) == 0)
+		_stext_l1 = s->addr;
+	else if (strcmp(sym, "_etext_l1" ) == 0)
+		_etext_l1 = s->addr;
 	else if (toupper(stype) == 'A')
 	{
 		/* Keep these useful absolute symbols */
@@ -160,7 +165,8 @@ static int symbol_valid(struct sym_entry *s)
 	 * and inittext sections are discarded */
 	if (!all_symbols) {
 		if ((s->addr < _stext || s->addr > _etext)
-		    && (s->addr < _sinittext || s->addr > _einittext))
+		    && (s->addr < _sinittext || s->addr > _einittext)
+		    && (s->addr < _stext_l1 || s->addr > _etext_l1))
 			return 0;
 		/* Corner case.  Discard any symbols with the same value as
 		 * _etext _einittext; they can move between pass 1 and 2 when
-- 
1.5.5
