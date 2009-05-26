Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbZEZXhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbZEZXhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZEZXh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:37:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35287 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbZEZXh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:37:28 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bryan Wu <cooloney@kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] checkpatch: add some common Blackfin checks
Date: Tue, 26 May 2009 19:37:29 -0400
Message-Id: <1243381049-10359-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add checks for Blackfin-specific issues that seem to crop up from time to
time.  In particular, we have helper macros to break a 32bit address into
the hi/lo parts, and we want to make sure people use the csync/ssync
variant that includes fun anomaly workarounds.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
CC: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2d5ece7..2b1852c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1336,6 +1336,18 @@ sub process {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
+# Blackfin: use hi/lo macros
+		if ($realfile =~ m@arch/blackfin/.*\.S$@) {
+			if ($line =~ /\.[lL][[:space:]]*=.*&[[:space:]]*0x[fF][fF][fF][fF]/) {
+				my $herevet = "$here\n" . cat_vet($line) . "\n";
+				ERROR("use the LO() macro, not (... & 0xFFFF)\n" . $herevet);
+			}
+			if ($line =~ /\.[hH][[:space:]]*=.*>>[[:space:]]*16/) {
+				my $herevet = "$here\n" . cat_vet($line) . "\n";
+				ERROR("use the HI() macro, not (... >> 16)\n" . $herevet);
+			}
+		}
+
 # check we are in a valid source file C or perl if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|pl)$/);
 
@@ -1355,6 +1367,16 @@ sub process {
 			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
 		}
 
+# Blackfin: don't use __builtin_bfin_[cs]sync
+		if ($line =~ /__builtin_bfin_csync/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("use the CSYNC() macro in asm/blackfin.h\n" . $herevet);
+		}
+		if ($line =~ /__builtin_bfin_ssync/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
+		}
+
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
-- 
1.6.3.1

