Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbYFLMLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbYFLMLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbYFLMJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:09:34 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4587 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760695AbYFLMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:09:32 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 23/23] checkpatch: possible modifiers -- handle multiple modifiers and trailing
Date: Thu, 12 Jun 2008 13:06:02 +0100
Message-Id: <1213272362-19457-24-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for multiple modifiers such as:

	int __one __two foo;

Also handle trailing known modifiers when defecting modifiers:

	int __one foo __read_mostly;

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9c20916..8a3b0fd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -859,8 +859,10 @@ sub possible {
 
 		} elsif ($possible =~ /\s/) {
 			$possible =~ s/\s*$Type\s*//g;
-			warn "MODIFIER: $possible ($line)\n" if ($dbg_possible);
-			push(@modifierList, $possible);
+			for my $modifier (split(' ', $possible)) {
+				warn "MODIFIER: $modifier ($possible) ($line)\n" if ($dbg_possible);
+				push(@modifierList, $modifier);
+			}
 
 		} else {
 			warn "POSSIBLE: $possible ($line)\n" if ($dbg_possible);
@@ -1186,7 +1188,7 @@ sub process {
 			} elsif ($s =~ /^.\s*$Ident\s*\(/s) {
 
 			# declarations always start with types
-			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?((?:\s*$Ident)+)\b(?:\s+$Sparse)?\s*\**\s*(?:$Ident|\(\*[^\)]*\))\s*(?:;|=|,|\()/s) {
+			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?((?:\s*$Ident)+?)\b(?:\s+$Sparse)?\s*\**\s*(?:$Ident|\(\*[^\)]*\))(?:\s*$Modifier)?\s*(?:;|=|,|\()/s) {
 				my $type = $1;
 				$type =~ s/\s+/ /g;
 				possible($type, "A:" . $s);
-- 
1.5.6.rc0.140.ga9675

