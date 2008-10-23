Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYJWLJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYJWLJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYJWLG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:06:58 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50744 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYJWLGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:55 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 6/9] checkpatch: detect multiple bitfield declarations
Date: Thu, 23 Oct 2008 12:06:36 +0100
Message-Id: <1224759999-21389-7-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
In-Reply-To: <1224759999-21389-1-git-send-email-apw@shadowen.org>
References: <1224759999-21389-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect the colons (:) which make up secondary bitfield declarations
and apply binary colon checks.  For example the following is common
idiom:

	int foo:1,
	    bar:1;

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 90f78ef..c73fd44 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -844,11 +844,11 @@ sub annotate_values {
 			$type = 'V';
 			$av_pending = 'V';
 
-		} elsif ($cur =~ /^($Ident\s*):/) {
-			if ($type eq 'E') {
-				$av_pend_colon = 'L';
-			} elsif ($type eq 'T') {
+		} elsif ($cur =~ /^($Ident\s*):(?:\s*\d+\s*(,|=|;))?/) {
+			if (defined $2 && $type eq 'C' || $type eq 'T') {
 				$av_pend_colon = 'B';
+			} elsif ($type eq 'E') {
+				$av_pend_colon = 'L';
 			}
 			print "IDENT_COLON($1,$type>$av_pend_colon)\n" if ($dbg_values > 1);
 			$type = 'V';
@@ -866,6 +866,10 @@ sub annotate_values {
 			$type = 'E';
 			$av_pend_colon = 'O';
 
+		} elsif ($cur =~/^(,)/) {
+			print "COMMA($1)\n" if ($dbg_values > 1);
+			$type = 'C';
+
 		} elsif ($cur =~ /^(\?)/o) {
 			print "QUESTION($1)\n" if ($dbg_values > 1);
 			$type = 'N';
@@ -881,7 +885,7 @@ sub annotate_values {
 			}
 			$av_pend_colon = 'O';
 
-		} elsif ($cur =~ /^(;|\[)/o) {
+		} elsif ($cur =~ /^(\[)/o) {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
-- 
1.6.0.2.711.gf1ba4

