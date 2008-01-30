Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbYA3Rsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbYA3Rsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYA3Rso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:48:44 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:23909 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYA3Rsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:48:43 -0500
X-IronPort-AV: E=Sophos;i="4.25,278,1199682000"; 
   d="scan'208";a="47658167"
Subject: [PATCH 1/1 try #2] [Kallsyms] Blackfin: Allow kernel symbols in L1
	to be found
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       Robin Getz <robin.getz@analog.com>
In-Reply-To: <47A05CBA.2030903@grupopie.com>
References: <1201688453-1763-1-git-send-email-bryan.wu@analog.com>
	 <47A05CBA.2030903@grupopie.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 31 Jan 2008 01:48:34 +0800
Message-Id: <1201715314.6530.0.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 30 Jan 2008 17:48:41.0973 (UTC) FILETIME=[5A1E1A50:01C86368]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 027addca9ed40f16b4238a92ca6b871ca301c139 Mon Sep 17 00:00:00 2001
From: Robin Getz <robin.getz@analog.com>
Date: Thu, 31 Jan 2008 01:21:25 +0800
Subject: [PATCH] [Kallsyms] Blackfin: Allow kernel symbols in L1 to be found

Add _stext_l1, _etext_l1 for the L1 memory section in Blackfin.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 kernel/kallsyms.c  |    6 +++++-
 scripts/kallsyms.c |    8 +++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

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
index 1f11d84..5271db7 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -42,6 +42,7 @@ struct sym_entry {
 static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
 static unsigned long long _text, _stext, _etext, _sinittext, _einittext, _sextratext, _eextratext;
+static unsigned long long _stext_l1, _etext_l1;
 static int all_symbols = 0;
 static char symbol_prefix_char = '\0';
 
@@ -103,6 +104,10 @@ static int read_symbol(FILE *in, struct sym_entry *s)
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
@@ -166,7 +171,8 @@ static int symbol_valid(struct sym_entry *s)
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

