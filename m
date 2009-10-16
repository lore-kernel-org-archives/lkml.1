Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZJPSj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZJPSj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZJPSjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:39:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52999 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbZJPSjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:39:54 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/7] checkpatch: possible types -- prevent illegal modifiers being added
Date: Fri, 16 Oct 2009 19:39:26 +0100
Message-Id: <1255718372-22805-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255718372-22805-1-git-send-email-apw@canonical.com>
References: <1255718372-22805-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent known non types being detected as modifiers.  Ensure we do not
look at any type which starts with a keyword.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 87bbb8b..b43e309 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -997,23 +997,25 @@ sub annotate_values {
 
 sub possible {
 	my ($possible, $line) = @_;
-
-	print "CHECK<$possible> ($line)\n" if ($dbg_possible > 2);
-	if ($possible !~ /(?:
+	my $notPermitted = qr{(?:
 		^(?:
 			$Modifier|
 			$Storage|
 			$Type|
-			DEFINE_\S+|
+			DEFINE_\S+
+		)$|
+		^(?:
 			goto|
 			return|
 			case|
 			else|
 			asm|__asm__|
 			do
-		)$|
+		)(?:\s|$)|
 		^(?:typedef|struct|enum)\b
-	    )/x) {
+	    )}x;
+	warn "CHECK<$possible> ($line)\n" if ($dbg_possible > 2);
+	if ($possible !~ $notPermitted) {
 		# Check for modifiers.
 		$possible =~ s/\s*$Storage\s*//g;
 		$possible =~ s/\s*$Sparse\s*//g;
@@ -1022,8 +1024,10 @@ sub possible {
 		} elsif ($possible =~ /\s/) {
 			$possible =~ s/\s*$Type\s*//g;
 			for my $modifier (split(' ', $possible)) {
-				warn "MODIFIER: $modifier ($possible) ($line)\n" if ($dbg_possible);
-				push(@modifierList, $modifier);
+				if ($modifier !~ $notPermitted) {
+					warn "MODIFIER: $modifier ($possible) ($line)\n" if ($dbg_possible);
+					push(@modifierList, $modifier);
+				}
 			}
 
 		} else {
-- 
1.6.3.3

