Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbXJ3TtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbXJ3TtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXJ3TtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:49:15 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:37516 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752456AbXJ3TtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:49:14 -0400
Message-ID: <47278AB5.5060308@grupopie.com>
Date: Tue, 30 Oct 2007 19:49:09 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: Re: kallsyms __print_symbol prints first weak symbol encountered
References: <20071030174902.GA6513@Krystal>
In-Reply-To: <20071030174902.GA6513@Krystal>
Content-Type: multipart/mixed;
 boundary="------------010104020008020108000701"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010104020008020108000701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mathieu Desnoyers wrote:
> Hi,

Hi,

> [...]
> kallsyms returns the first symbol encountered, even though it is weak,
> when it should in fact return sys_ni_syscall.
> 
> Is it a concern for anyone else out there ? Would it make sense to fix
> it ?

I don't know if it is a concern, but if we're going to fix it, we should
probably do it in "scripts/kallsyms" by providing a list that is already
sorted according to "address, weakness".

This way the run-time kernel keeps the current behavior, without any 
overhead. Something along the lines of the attached patch (just compile 
tested).

However, this is an area where we've had problems in the past with some 
architectures giving different results between passes, and then any 
change to the symbol order might make the problem worse and make the 
build process fail with a "Inconsistent kallsyms data" error message.

So, if someone wants to use this, it should go through -mm for a while, 
first.

-- 
Paulo Marques - www.grupopie.com

"All I ask is a chance to prove that money can't make me happy."

--------------010104020008020108000701
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
 


--------------010104020008020108000701--
