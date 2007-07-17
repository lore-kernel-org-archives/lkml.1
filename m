Return-Path: <linux-kernel-owner+w=401wt.eu-S933975AbXGQOSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbXGQOSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXGQOIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:18 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55810 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbXGQOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:51 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Paulo Marques <pmarques@grupopie.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 30/33] kallsyms: remove usage of memmem and _GNU_SOURCE from scripts/kallsyms.c
Date: Tue, 17 Jul 2007 16:08:59 +0200
Message-Id: <11846813453096-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813451376-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <11846813442541-git-send-email-sam@ravnborg.org> <11846813443988-git-send-email-sam@ravnborg.org> <1184681345321-git-send-email-sam@ravnborg.org> <11846813451376-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paulo Marques <pmarques@grupopie.com>

The only in-kernel user of "memmem" is scripts/kallsyms.c and it only
uses it to find tokens that are 2 bytes in size. It is trivial to
replace it with a simple function that finds 2-byte tokens.

This should help users from systems that don't have the memmem GNU
extension available.

Signed-off-by: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kallsyms.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 8b809b2..caf4c86 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -24,8 +24,6 @@
  *
  */
 
-#define _GNU_SOURCE
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -378,6 +376,17 @@ static void build_initial_tok_table(void)
 	table_cnt = pos;
 }
 
+static void *find_token(unsigned char *str, int len, unsigned char *token)
+{
+	int i;
+
+	for (i = 0; i < len - 1; i++) {
+		if (str[i] == token[0] && str[i+1] == token[1])
+			return &str[i];
+	}
+	return NULL;
+}
+
 /* replace a given token in all the valid symbols. Use the sampled symbols
  * to update the counts */
 static void compress_symbols(unsigned char *str, int idx)
@@ -391,7 +400,7 @@ static void compress_symbols(unsigned char *str, int idx)
 		p1 = table[i].sym;
 
 		/* find the token on the symbol */
-		p2 = memmem(p1, len, str, 2);
+		p2 = find_token(p1, len, str);
 		if (!p2) continue;
 
 		/* decrease the counts for this symbol's tokens */
@@ -410,7 +419,7 @@ static void compress_symbols(unsigned char *str, int idx)
 			if (size < 2) break;
 
 			/* find the token on the symbol */
-			p2 = memmem(p1, size, str, 2);
+			p2 = find_token(p1, size, str);
 
 		} while (p2);
 
-- 
1.5.0.6

