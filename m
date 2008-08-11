Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYHKUSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYHKUSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbYHKUSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:18:15 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41246 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbYHKUSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:18:14 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 10/17] checkpatch: reduce warnings for #include of asm/foo.h to check from arch/bar.c
Date: Mon, 11 Aug 2008 21:13:05 +0100
Message-Id: <1218485592-6679-11-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is much more likely that an architecture file will want to directly
include asm header files.  Reduce this WARNING to a CHECK when the referencing
file is in the arch directory.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0e5af8e..9e7e9d1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1942,12 +1942,17 @@ sub process {
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
 		if ($tree && $rawline =~ m{^.\s*\#\s*include\s*\<asm\/(.*)\.h\>}) {
-			my $checkfile = "include/linux/$1.h";
-			if (-f "$root/$checkfile" && $realfile ne $checkfile &&
+			my $file = "$1.h";
+			my $checkfile = "include/linux/$file";
+			if (-f "$root/$checkfile" &&
+			    $realfile ne $checkfile &&
 			    $1 ne 'irq')
 			{
-				WARN("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
-					$herecurr);
+				if ($realfile =~ m{^arch/}) {
+					CHK("Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+				} else {
+					WARN("Use #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+				}
 			}
 		}
 
-- 
1.6.0.rc1.258.g80295

