Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbYHOItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbYHOItj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYHOItb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:49:31 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:30720 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYHOIta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:49:30 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="73536748"
From: Bryan Wu <cooloney@kernel.org>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] checkpatch script: add Blackfin checks for HI/LO and SSYNC/CSYNC macros
Date: Fri, 15 Aug 2008 16:32:40 +0800
Message-Id: <1218789160-9565-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc67793..eb764b0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1200,6 +1200,18 @@ sub process {
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
 # check we are in a valid source file *.[hc] if not then ignore this hunk
 		next if ($realfile !~ /\.[hc]$/);
 
@@ -1216,6 +1228,16 @@ sub process {
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
 		my ($stat, $cond, $line_nr_next, $remain_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
-- 
1.5.6
