Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXLEDPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXLEDPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbXLEDPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:15:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbXLEDO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:14:59 -0500
Date: Tue, 4 Dec 2007 19:14:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
Message-Id: <20071204191421.1c8b6771.akpm@linux-foundation.org>
In-Reply-To: <4755BA14.8060706@grupopie.com>
References: <4755BA14.8060706@grupopie.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 20:35:32 +0000 Paulo Marques <pmarques@grupopie.com> wrote:

> When resolving symbol names from addresses with aliased symbol names, 
> kallsyms_lookup always returns the first symbol, even if it is a weak 
> symbol.
> 
> This patch changes this by sorting the symbols with the weak symbols 
> last before feeding them to the kernel. This way the kernel runtime 
> isn't changed at all, only the kallsyms build system is changed.
> 
> Another side effect is that the symbols get sorted by address, too. So, 
> even if future binutils version have some bug in "nm" that makes it fail 
> to correctly sort symbols by address, the kernel won't be affected by this.

Incremental patch:




From: Andrew Morton <akpm@linux-foundation.org>

Fix checkpatch warnings:

ERROR: do not use C99 // comments
#72: FILE: scripts/kallsyms.c:516:
+	// sort by address first

ERROR: do not use C99 // comments
#78: FILE: scripts/kallsyms.c:522:
+	// sort by "weakness" type

ERROR: do not use C99 // comments
#84: FILE: scripts/kallsyms.c:528:
+	// sort by initial order, so that other symbols are left undisturbed

total: 3 errors, 0 warnings, 61 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

And a few coding-style things which checkpatch missed.

And fix up constificiation to remove typecasting.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paulo Marques <pmarques@grupopie.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN scripts/kallsyms.c~kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes
+++ a/scripts/kallsyms.c
@@ -31,14 +31,13 @@
 
 #define KSYM_NAME_LEN		128
 
-
 struct sym_entry {
 	unsigned long long addr;
-	unsigned int len, start_pos;
+	unsigned int len;
+	unsigned int start_pos;
 	unsigned char *sym;
 };
 
-
 static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
 static unsigned long long _text, _stext, _etext, _sinittext, _einittext;
@@ -504,28 +503,28 @@ static void optimize_token_table(void)
 	optimize_result();
 }
 
-
 static int compare_symbols(const void *a, const void *b)
 {
-	struct sym_entry *sa, *sb;
+	const struct sym_entry *sa;
+	const struct sym_entry *sb;
 	int wa, wb;
 
-	sa = (struct sym_entry *) a;
-	sb = (struct sym_entry *) b;
+	sa = a;
+	sb = b;
 
-	// sort by address first
+	/* sort by address first */
 	if (sa->addr > sb->addr)
 		return 1;
 	if (sa->addr < sb->addr)
 		return -1;
 
-	// sort by "weakness" type
+	/* sort by "weakness" type */
 	wa = (sa->sym[0] == 'w') || (sa->sym[0] == 'W');
 	wb = (sb->sym[0] == 'w') || (sb->sym[0] == 'W');
 	if (wa != wb)
 		return wa - wb;
 
-	// sort by initial order, so that other symbols are left undisturbed
+	/* sort by initial order, so that other symbols are left undisturbed */
 	return sa->start_pos - sb->start_pos;
 }
 
_

