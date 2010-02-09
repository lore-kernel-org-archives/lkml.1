Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0BIBm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 20:42:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1887 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab0BIBm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 20:42:57 -0500
Subject: Re: [PATCH] scripts/checkpatch.pl: Dramatically improve #define
 parse times
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100208151550.15796cad.akpm@linux-foundation.org>
References: <1265167112.1945.184.camel@Joe-Laptop.home>
	 <20100208151550.15796cad.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 17:42:55 -0800
Message-ID: <1265679775.2135.74.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 15:15 -0800, Andrew Morton wrote:
> This patch triggers lots of warnings:

Yeah, I've played with it a bit more but Andy Whitcroft
is better able to do something about this.

This is what I've come up with, which doesn't fail your
example and gives the same output as current on a bunch
of collected patches, but it only handles:
	#define foo bar
not
	#define foo (bar)
	#define foo (bar * n)

Andy?

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3257d3d..940fe82 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -378,13 +378,13 @@ sub sanitise_line {
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
@@ -507,6 +507,12 @@ sub ctx_statement_block {
 			last;
 		}
 
+		# single line "#define foo" and "#define foo bar" at level 0 are complete
+		if ($level == 0 &&
+		    ($remainder =~ /^\s*#\s*define\s+\w+\s*$/ || $remainder =~ /^\s*#\s*define\s+\w+\s+\w+\s*$/)) {
+			last;
+		}
+
 		# An else is really a conditional as long as its not else if
 		if ($level == 0 && $coff_set == 0 &&
 				(!defined($p) || $p =~ /(?:\s|\}|\+)/) &&
@@ -2352,7 +2358,9 @@ sub process {
 				^\"|\"$
 			}x;
 			#print "REST<$rest> dstat<$dstat>\n";
-			if ($rest ne '') {
+			if ($rest =~ /^\s*define\s+\w+\s*$/ || $rest =~ /^\s*define\s+\w+\s+\w+\s*$/) {
+				;
+			} elsif ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
 				{



