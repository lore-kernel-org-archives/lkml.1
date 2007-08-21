Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbXHUW3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbXHUW3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 18:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXHUW3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 18:29:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39058 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXHUW3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 18:29:23 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] add some Blackfin specific checks to checkpatch.pl
Date: Tue, 21 Aug 2007 18:29:59 -0400
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, bryan.wu@analog.com, apw@shadowen.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211829.59975.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Check for a few common errors in Blackfin-specific code wrt MMR loading in
assembly and doing core/system syncs.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Bryan Wu <bryan.wu@analog.com>
CC: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dae7d30..ead9675 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -486,9 +486,29 @@ sub process {
 			WARN("line over 80 characters\n" . $herecurr);
 		}
 
+# Blackfin: use hi/lo macros
+		if ($line =~ /\.[lL][[:space:]]*=.*&[[:space:]]*0x[fF][fF][fF][fF]/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("use the LO() macro, not (... & 0xFFFF)\n" . $herevet);
+		}
+		if ($line =~ /\.[hH][[:space:]]*=.*>>[[:space:]]*16/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("use the HI() macro, not (... >> 16)\n" . $herevet);
+		}
+
 # check we are in a valid source file *.[hc] if not then ignore this hunk
 		next if ($realfile !~ /\.[hc]$/);
 
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
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
 		if ($line=~/^\+\s* \t\s*\S/ or $line=~/^\+\s*        \s*/) {
-- 
1.5.3.rc5
