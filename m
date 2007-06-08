Return-Path: <linux-kernel-owner+w=401wt.eu-S938296AbXFHM1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938296AbXFHM1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933187AbXFHM1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:27:39 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:46119 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935906AbXFHM1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:27:39 -0400
Message-ID: <46694B39.6070304@grupopie.com>
Date: Fri, 08 Jun 2007 13:27:37 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch/rfc] implement memmem() locally in kallsyms.c
References: <200706070116.32042.vapier@gentoo.org>
In-Reply-To: <200706070116.32042.vapier@gentoo.org>
Content-Type: multipart/mixed;
 boundary="------------080404010700090109010904"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080404010700090109010904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Frysinger wrote:
> This patch basically copies the gnulib version of memmem() into
> scripts/kallsyms.c.  While a useful function, it isn't in POSIX so some
> systems (like Darwin) choose to omit it.  How do others feel ?

Well, the only use of memmem in scripts/kallsyms.c is to find tokens of 
size 2, so we can use a simplified version instead (and probably get 
better code in the process).

How about the attached patch instead?

If you approve it, I'll post it appropriately for inclusion in -mm.

-- 
Paulo Marques - www.grupopie.com

"God is real, unless declared integer."

--------------080404010700090109010904
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
 

--------------080404010700090109010904--
