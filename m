Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYJCP2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYJCP2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYJCP0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:09 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57526 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJCP0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:01 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 09/13] checkpatch: DEFINE_ macros are real definitions for exports
Date: Fri,  3 Oct 2008 16:25:50 +0100
Message-Id: <1223047554-31111-10-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we want to confirm an export is directly after its definition we need
to allow for DEFINE_ style macros.  Add these to the execeptions.  Refactor
the exceptions.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 54dfa2b..a675f06 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1573,13 +1573,14 @@ sub process {
 		if (($line =~ /EXPORT_SYMBOL.*\((.*)\)/) ||
 		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
 			my $name = $1;
-			if (($prevline !~ /^}/) &&
-			   ($prevline !~ /^\+}/) &&
-			   ($prevline !~ /^ }/) &&
-			   ($prevline !~ /^.DECLARE_$Ident\(\Q$name\E\)/) &&
-			   ($prevline !~ /^.LIST_HEAD\(\Q$name\E\)/) &&
-			   ($prevline !~ /^.$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(/) &&
-			   ($prevline !~ /\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)/)) {
+			if ($prevline !~ /(?:
+				^.}|
+				^.DEFINE_$Ident\(\Q$name\E\)|
+				^.DECLARE_$Ident\(\Q$name\E\)|
+				^.LIST_HEAD\(\Q$name\E\)|
+				^.$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|
+				\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)
+			    )/x) {
 				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 			}
 		}
-- 
1.6.0.1.451.gc8d31

