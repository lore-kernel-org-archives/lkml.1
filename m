Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbZJPSkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbZJPSkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZJPSkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:40:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53131 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbZJPSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:40:06 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 6/7] checkpatch: fix false EXPORT_SYMBOL warning
Date: Fri, 16 Oct 2009 19:39:31 +0100
Message-Id: <1255718372-22805-7-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255718372-22805-1-git-send-email-apw@canonical.com>
References: <1255718372-22805-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo reported that the following lines triggered a false warning,

static struct lock_class_key rcu_lock_key;
struct lockdep_map rcu_lock_map =
        STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
EXPORT_SYMBOL_GPL(rcu_lock_map);

from kernel/rcutree.c , and the false warning looked like this,

WARNING: EXPORT_SYMBOL(foo); should immediately follow its
function/variable
+EXPORT_SYMBOL_GPL(rcu_lock_map);

We actually should be checking the statement before the EXPORT_* for a
mention of the exported object, and complain where it is not there.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reported-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   48 +++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ba105a8..07678c1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1145,6 +1145,7 @@ sub process {
 	# suppression flags
 	my %suppress_ifbraces;
 	my %suppress_whiletrailers;
+	my %suppress_export;
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -1253,6 +1254,7 @@ sub process {
 
 			%suppress_ifbraces = ();
 			%suppress_whiletrailers = ();
+			%suppress_export = ();
 			next;
 
 # track the line number as we move through the hunk, note that
@@ -1428,13 +1430,22 @@ sub process {
 		}
 
 # Check for potential 'bare' types
-		my ($stat, $cond, $line_nr_next, $remain_next, $off_next);
+		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
+		    $realline_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
 
+			# Find the real next line.
+			$realline_next = $line_nr_next;
+			if (defined $realline_next &&
+			    (!defined $lines[$realline_next - 1] ||
+			     substr($lines[$realline_next - 1], $off_next) =~ /^\s*$/)) {
+				$realline_next++;
+			}
+
 			my $s = $stat;
 			$s =~ s/{.*$//s;
 
@@ -1695,21 +1706,40 @@ sub process {
 		$line =~ s@//.*@@;
 		$opline =~ s@//.*@@;
 
-#EXPORT_SYMBOL should immediately follow its function closing }.
-		if (($line =~ /EXPORT_SYMBOL.*\((.*)\)/) ||
-		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+# EXPORT_SYMBOL should immediately follow the thing it is exporting, consider
+# the whole statement.
+#print "APW <$lines[$realline_next - 1]>\n";
+		if (defined $realline_next &&
+		    exists $lines[$realline_next - 1] &&
+		    !defined $suppress_export{$realline_next} &&
+		    ($lines[$realline_next - 1] =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
+		     $lines[$realline_next - 1] =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
 			my $name = $1;
-			if ($prevline !~ /(?:
-				^.}|
+			if ($stat !~ /(?:
+				\n.}\s*$|
 				^.DEFINE_$Ident\(\Q$name\E\)|
 				^.DECLARE_$Ident\(\Q$name\E\)|
 				^.LIST_HEAD\(\Q$name\E\)|
-				^.$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|
-				\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)
+				^.(?:$Storage\s+)?$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|
+				\b\Q$name\E(?:\s+$Attribute)*\s*(?:;|=|\[|\()
 			    )/x) {
-				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
+#print "FOO A<$lines[$realline_next - 1]> stat<$stat> name<$name>\n";
+				$suppress_export{$realline_next} = 2;
+			} else {
+				$suppress_export{$realline_next} = 1;
 			}
 		}
+		if (!defined $suppress_export{$linenr} &&
+		    $prevline =~ /^.\s*$/ &&
+                    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
+		     $line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+#print "FOO B <$lines[$linenr - 1]>\n";
+			$suppress_export{$linenr} = 2;
+		}
+		if (defined $suppress_export{$linenr} &&
+		    $suppress_export{$linenr} == 2) {
+			WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
+		}
 
 # check for external initialisers.
 		if ($line =~ /^.$Type\s*$Ident\s*(?:\s+$Modifier)*\s*=\s*(0|NULL|false)\s*;/) {
-- 
1.6.3.3

