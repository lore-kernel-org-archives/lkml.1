Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbXFSQQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbXFSQQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXFSQQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:16:01 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:34269 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754742AbXFSQQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:16:00 -0400
Message-ID: <4678013C.5090402@grupopie.com>
Date: Tue, 19 Jun 2007 17:15:56 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] remove usage of memmem from scripts/kallsyms.c
Content-Type: multipart/mixed;
 boundary="------------060006060405060707080204"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060006060405060707080204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


The only in-kernel user of "memmem" is scripts/kallsyms.c and it only 
uses it to find tokens that are 2 bytes in size. It is trivial to 
replace it with a simple function that finds 2-byte tokens.

This should help users from systems that don't have the memmem GNU 
extension available.

Signed-off-by: Paulo Marques <pmarques@grupopie.com>

-- 
Paulo Marques - www.grupopie.com

"667: The neighbor of the beast."


--------------060006060405060707080204
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

--- ./scripts/kallsyms.c.orig	2007-06-08 12:55:49.000000000 +0100
+++ ./scripts/kallsyms.c	2007-06-08 13:19:52.000000000 +0100
@@ -378,6 +378,17 @@ static void build_initial_tok_table(void
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
@@ -391,7 +402,7 @@ static void compress_symbols(unsigned ch
 		p1 = table[i].sym;
 
 		/* find the token on the symbol */
-		p2 = memmem(p1, len, str, 2);
+		p2 = find_token(p1, len, str);
 		if (!p2) continue;
 
 		/* decrease the counts for this symbol's tokens */
@@ -410,7 +421,7 @@ static void compress_symbols(unsigned ch
 			if (size < 2) break;
 
 			/* find the token on the symbol */
-			p2 = memmem(p1, size, str, 2);
+			p2 = find_token(p1, size, str);
 
 		} while (p2);
 

--------------060006060405060707080204--
