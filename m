Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0CJVSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:18:14 -0500
Received: from mail.perches.com ([173.55.12.10]:1624 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab0CJVSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:18:10 -0500
Subject: [PATCH] scripts/checkpatch.pl: Change long line warning to 105
 chars
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 13:18:09 -0800
Message-ID: <1268255889.24209.21.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus.

Could you pick up this patch directly please?

Andrew Morton doesn't want to as he believes using >80
column lines not nice, and Andy Whitcroft doesn't seem
to have much time to work on checkpatch these days.

Either this or perhaps just remove the >80 column test
altogether.

Thanks

-------------------------------------

Made the length test a variable for easier bike shedding.

Also add --strict tests for lines longer than 80 chars and
more than 6 leading tabs.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a4d7434..2c5f30c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -30,6 +30,10 @@ my $root;
 my %debug;
 my $help = 0;
 
+# Code style warnings
+my $style_long_line = 105;
+my $style_max_leading_tabs = 6;
+
 sub help {
 	my ($exitcode) = @_;
 
@@ -1385,13 +1389,21 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
-		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
+#Line too long
+		if ($line =~ /^\+/ &&
+		    $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    $line !~ /^\+\s*$logFunctions\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
-		    $length > 80)
-		{
-			WARN("line over 80 characters\n" . $herecurr);
+		    $line !~ /^\+\s*$logFunctions\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/) {
+			if ($length > $style_long_line) {
+				WARN("line over $style_long_line characters\n" . $herecurr);
+			} elsif ($length > 80) {
+				CHK("line over 80 characters\n" . $herecurr);
+			}
+		}
+
+#too many leading tabs - deep leading indent
+		if ($line =~ /^\+\t{$style_max_leading_tabs,}(?!(.*,$|.*\);$))/) {
+			CHK("Too many leading tabs.  Consider restructuring code\n" . $herecurr);
 		}
 
 # check for spaces before a quoted newline



