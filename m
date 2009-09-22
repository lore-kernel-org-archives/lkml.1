Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZIVCPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZIVCPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZIVCPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:15:12 -0400
Received: from fifo99.com ([67.223.236.141]:40492 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbZIVCOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:14:49 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 5/5] checkpatch: fix false EXPORT_SYMBOL warning
Date: Mon, 21 Sep 2009 19:14:51 -0700
Message-Id: <1253585691-10987-5-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
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

This change corrects this. It was caused because checkpatch doesn't check
more than one line above the "EXPORT_SYMBOL" for additional context (ie.
variable name, or initializer). Things are somewhat more complicated
because STATIC_LOCKDEP_MAP_INIT() doesn't accept the variable name that
is being initialized. I just added another check that checks two lines
above "EXPORT_SYMBOL" for the variable declaration.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 scripts/checkpatch.pl |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index fd4fe03..9996bfb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1629,7 +1629,7 @@ sub process {
 
 # check for initialisation to aggregates open brace on the next line
 		if (($prevline =~ /$Declare\s*$Ident\s*=\s*$/ || $prevline =~ /$Attribute\s*=\s*$/) &&
-		    $line =~ /^.\s*{/) {
+		     $line =~ /^.\s*{/) {
 			ERROR("that open brace { should be on the previous line\n" . $hereprev);
 		}
 
@@ -1665,7 +1665,9 @@ sub process {
 				^.LIST_HEAD\(\Q$name\E\)|
 				^.$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|
 				\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)
-			    )/x) {
+			    )/x && defined $lines[$linenr - 3] &&
+			    $lines[$linenr - 3] !~ /(?:\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[))/
+				) {
 				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 			}
 		}
-- 
1.5.6.3

