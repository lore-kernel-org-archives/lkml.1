Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYEaKkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYEaKkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYEaKkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:40:01 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:36370 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYEaKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=qxyLbxj7yUHIFyGxvNQ/ato1dqn0/sZIEtk0Po0PfZ3SO7/Z/jfCaZ+b9a9qFzoK0QIZ33WtBK6sgX3xqzOqEnXCzuIjdsypmIVfahznEdlkzaKTxhh80GWq3ZBMbtrQBmIyDA1KuXVfQ49VtY2DUWKR1auRny/8y6iq9URN+5o=
From: Bryan Wu <cooloney@kernel.org>
To: apw@uk.ibm.com, linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] checkpatch script: add Blackfin checks for HI/LO and SSYNC/CSYNC macros
Date: Sat, 31 May 2008 18:39:54 +0800
Message-Id: <1212230394-22384-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
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
index b6bbbcd..44ef399 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1126,6 +1126,18 @@ sub process {
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
 
@@ -1142,6 +1154,16 @@ sub process {
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
 		my ($stat, $cond);
 		if ($realcnt && $line =~ /.\s*\S/) {
-- 
1.5.5

