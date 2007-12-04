Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXLDUfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXLDUfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXLDUfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:35:36 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:36224 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXLDUff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:35:35 -0500
Message-ID: <4755BA14.8060706@grupopie.com>
Date: Tue, 04 Dec 2007 20:35:32 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [-mm PATCH] kallsyms should prefer non weak symbols
Content-Type: multipart/mixed;
 boundary="------------080302070401040104060003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080302070401040104060003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


When resolving symbol names from addresses with aliased symbol names, 
kallsyms_lookup always returns the first symbol, even if it is a weak 
symbol.

This patch changes this by sorting the symbols with the weak symbols 
last before feeding them to the kernel. This way the kernel runtime 
isn't changed at all, only the kallsyms build system is changed.

Another side effect is that the symbols get sorted by address, too. So, 
even if future binutils version have some bug in "nm" that makes it fail 
to correctly sort symbols by address, the kernel won't be affected by this.


From: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

-- 
Paulo Marques - www.grupopie.com

"There cannot be a crisis today; my schedule is already full."

--------------080302070401040104060003
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

--- ./scripts/kallsyms.c.orig	2007-10-30 18:51:28.000000000 +0000
+++ ./scripts/kallsyms.c	2007-10-30 19:07:58.000000000 +0000
@@ -34,7 +34,7 @@
 
 struct sym_entry {
 	unsigned long long addr;
-	unsigned int len;
+	unsigned int len, start_pos;
 	unsigned char *sym;
 };
 
@@ -202,8 +202,10 @@ static void read_map(FILE *in)
 				exit (1);
 			}
 		}
-		if (read_symbol(in, &table[table_cnt]) == 0)
+		if (read_symbol(in, &table[table_cnt]) == 0) {
+			table[table_cnt].start_pos = table_cnt;
 			table_cnt++;
+		}
 	}
 }
 
@@ -507,6 +509,35 @@ static void optimize_token_table(void)
 }
 
 
+static int compare_symbols(const void *a, const void *b)
+{
+	struct sym_entry *sa, *sb;
+	int wa, wb;
+
+	sa = (struct sym_entry *) a;
+	sb = (struct sym_entry *) b;
+
+	// sort by address first
+	if (sa->addr > sb->addr)
+		return 1;
+	if (sa->addr < sb->addr)
+		return -1;
+
+	// sort by "weakness" type
+	wa = (sa->sym[0] == 'w') || (sa->sym[0] == 'W');
+	wb = (sb->sym[0] == 'w') || (sb->sym[0] == 'W');
+	if (wa != wb)
+		return wa - wb;
+
+	// sort by initial order, so that other symbols are left undisturbed
+	return sa->start_pos - sb->start_pos;
+}
+
+static void sort_symbols(void)
+{
+	qsort(table, table_cnt, sizeof(struct sym_entry), compare_symbols);
+}
+
 int main(int argc, char **argv)
 {
 	if (argc >= 2) {
@@ -527,6 +558,7 @@ int main(int argc, char **argv)
 		usage();
 
 	read_map(stdin);
+	sort_symbols();
 	optimize_token_table();
 	write_src();
 


--------------080302070401040104060003--
