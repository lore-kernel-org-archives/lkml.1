Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab0BCDSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:18:36 -0500
Received: from mail.perches.com ([173.55.12.10]:1827 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab0BCDSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:18:33 -0500
Subject: [PATCH] scripts/checkpatch.pl: Dramatically improve #define parse
 times
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 19:18:32 -0800
Message-ID: <1265167112.1945.184.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#define macros currently take a _very_ long time to parse because
the macro is being searched for multiple statements and unnecessary
searching is being done when comments are replaced with unprintable
characters.

For instance:

Without this patch:
$ time perl ./scripts/checkpatch.pl -f include/linux/mfd/wm831x/irq.h > /dev/null

real	3m43.229s
user	3m42.254s
sys	0m0.332s

With this patch: 
$ time perl ./scripts/checkpatch.pl -f include/linux/mfd/wm831x/irq.h > /dev/null

real	0m1.372s
user	0m1.348s
sys	0m0.020s

A 160:1 improvement.

I don't know if this is correct, but it seems to work for me.

Maybe there's some reason why C comments aren't replaced with
spaces but get unprintable characters.

Changes:

Replace comments with spaces.
Do not call ctx_statement_block unless necessary
Add a check to see if the macro could have multiple statements
either with a \ line continuation or a ";".  This doesn't work with
comma separated statements.
Miscellaneous its -> it's typo corrections.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3257d3d..70747c8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -373,18 +373,18 @@ sub sanitise_line {
 	for ($off = 1; $off < length($line); $off++) {
 		$c = substr($line, $off, 1);
 
-		# Comments we are wacking completly including the begin
+		# Comments we are whacking completely including the begin
 		# and end, all to $;.
 		if ($sanitise_quote eq '' && substr($line, $off, 2) eq '/*') {
 			$sanitise_quote = '*/';
 
-			substr($res, $off, 2, "$;$;");
+			substr($res, $off, 2, "  ");
 			$off++;
 			next;
 		}
 		if ($sanitise_quote eq '*/' && substr($line, $off, 2) eq '*/') {
 			$sanitise_quote = '';
-			substr($res, $off, 2, "$;$;");
+			substr($res, $off, 2, "  ");
 			$off++;
 			next;
 		}
@@ -417,9 +417,9 @@ sub sanitise_line {
 
 		#print "c<$c> SQ<$sanitise_quote>\n";
 		if ($off != 0 && $sanitise_quote eq '*/' && $c ne "\t") {
-			substr($res, $off, 1, $;);
+			substr($res, $off, 1, ' ');
 		} elsif ($off != 0 && $sanitise_quote eq '//' && $c ne "\t") {
-			substr($res, $off, 1, $;);
+			substr($res, $off, 1, ' ');
 		} elsif ($off != 0 && $sanitise_quote && $c ne "\t") {
 			substr($res, $off, 1, 'X');
 		} else {
@@ -507,7 +507,7 @@ sub ctx_statement_block {
 			last;
 		}
 
-		# An else is really a conditional as long as its not else if
+		# An else is really a conditional as long as it's not else if
 		if ($level == 0 && $coff_set == 0 &&
 				(!defined($p) || $p =~ /(?:\s|\}|\+)/) &&
 				$remainder =~ /^(else)(?:\s|{)/ &&
@@ -1432,7 +1432,9 @@ sub process {
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
-		if ($realcnt && $line =~ /.\s*\S/) {
+		my $test = $line =~ /\+\s*(\S)/;
+		my $firstchar = $1;
+		if ($realcnt && $test && $firstchar ne "\#") {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
@@ -1880,7 +1882,7 @@ sub process {
 			# cpp #elif statement condition may start with a (
 			} elsif ($ctx =~ /^.\s*\#\s*elif\s*$/) {
 
-			# If this whole things ends with a type its most
+			# If this whole things ends with a type it's most
 			# likely a typedef for a function.
 			} elsif ($ctx =~ /$Type$/) {
 
@@ -2280,10 +2282,11 @@ sub process {
 		}
 
 # multi-statement macros should be enclosed in a do while loop, grab the
-# first statement and ensure its the whole macro if its not enclosed
+# first statement and ensure it's the whole macro if it's not enclosed
 # in a known good container
 		if ($realfile !~ m@/vmlinux.lds.h$@ &&
-		    $line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
+		    $line =~ /^.\s*\#\s*define\s*$Ident(\()?/ &&
+		    ($line =~ /;/ || $line =~ /\\$/)) {
 			my $ln = $linenr;
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);


