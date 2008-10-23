Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYJWLIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYJWLIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYJWLG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:06:58 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50747 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYJWLGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:55 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 7/9] checkpatch: comment ends inside strings is most likely not an open comment
Date: Thu, 23 Oct 2008 12:06:37 +0100
Message-Id: <1224759999-21389-8-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
In-Reply-To: <1224759999-21389-1-git-send-email-apw@shadowen.org>
References: <1224759999-21389-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are detecting whether a comment is open when we start a hunk
we check for the first comment edge in the hunk and assume its inverse.
However if the hunk contains something like below, then we will assume
that a comment was open.  Update this heuristic to see if the comment edge is
obviously within double quotes and ignore it if so:

	foo(" */);

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c73fd44..5acc48a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -367,7 +367,7 @@ sub sanitise_line {
 			}
 		}
 
-		#print "SQ:$sanitise_quote\n";
+		#print "c<$c> SQ<$sanitise_quote>\n";
 		if ($off != 0 && $sanitise_quote eq '*/' && $c ne "\t") {
 			substr($res, $off, 1, $;);
 		} elsif ($off != 0 && $sanitise_quote && $c ne "\t") {
@@ -1103,8 +1103,11 @@ sub process {
 				$cnt--;
 				#print "RAW<$rawlines[$ln - 1]>\n";
 				last if (!defined $rawlines[$ln - 1]);
-				($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
-				last if (defined $edge);
+				if ($rawlines[$ln - 1] =~ m@(/\*|\*/)@ &&
+				    $rawlines[$ln - 1] !~ m@"[^"]*(?:/\*|\*/)[^"]*"@) {
+					($edge) = $1;
+					last;
+				}
 			}
 			if (defined $edge && $edge eq '*/') {
 				$in_comment = 1;
-- 
1.6.0.2.711.gf1ba4

