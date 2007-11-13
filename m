Return-Path: <linux-kernel-owner+w=401wt.eu-S1762084AbXKMTOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbXKMTOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760533AbXKMTOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:14:03 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:50688 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbXKMTOA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:14:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJ+GOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 14:13:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Kallsyms Should Prefer Non Weak Symbols
Message-ID: <20071113191355.GA1125@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:11:59 up 10 days, 17 min,  6 users,  load average: 0.17, 0.35,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> kallsyms returns the first symbol encountered, even though it is weak,
> when it should in fact return sys_ni_syscall.
> Is it a concern for anyone else out there ? Would it make sense to fix
> it ?

I don't know if it is a concern, but if we're going to fix it, we should
probably do it in "scripts/kallsyms" by providing a list that is already
sorted according to "address, weakness".

This way the run-time kernel keeps the current behavior, without any
overhead. Something along the lines of the attached patch (just compile
tested).

However, this is an area where we've had problems in the past with some
architectures giving different results between passes, and then any change
to the symbol order might make the problem worse and make the build process
fail with a "Inconsistent kallsyms data" error message.

So, if someone wants to use this, it should go through -mm for a while,
first.

It applies on top of 2.6.24-rc2-git3.

From: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 scripts/kallsyms.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/scripts/kallsyms.c
===================================================================
--- linux-2.6-lttng.orig/scripts/kallsyms.c	2007-10-31 21:38:36.000000000 -0400
+++ linux-2.6-lttng/scripts/kallsyms.c	2007-10-31 22:29:28.000000000 -0400
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
+	/* sort by address first */
+	if (sa->addr > sb->addr)
+		return 1;
+	if (sa->addr < sb->addr)
+		return -1;
+
+	/* sort by "weakness" type */
+	wa = (sa->sym[0] == 'w') || (sa->sym[0] == 'W');
+	wb = (sb->sym[0] == 'w') || (sb->sym[0] == 'W');
+	if (wa != wb)
+		return wa - wb;
+
+	/* sort by initial order, so that other symbols are left undisturbed */
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
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
