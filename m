Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYKHW4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYKHW4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYKHW4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:56:09 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:49196 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbYKHW4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:56:06 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h
Date: Sat,  8 Nov 2008 17:56:05 -0500
Message-Id: <1226184965-13502-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like every other release we have someone who updates vmlinux.lds.h and
adds C-visible symbols without VMLINUX_SYMBOL() around them.  So start
checking the file and only allow assignments that use one of the following
symbols on a side:
	.
	ALIGN(...)
	VMLINUX_SYMBOL(...)

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/checkpatch.pl |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f88bb3e..8e96b42 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2189,6 +2189,19 @@ sub process {
 			}
 		}
 
+# make sure symbols are always wrapped with VMLINUX_SYMBOL() ...
+# all assignments may have only one of the following with an assignment:
+#	.
+#	ALIGN(...)
+#	VMLINUX_SYMBOL(...)
+		if ($realfile =~ /vmlinux.lds.h$/) {
+			if ($line =~ /=/ &&
+			    !($line =~ /([.]|(ALIGN|VMLINUX_SYMBOL)[(][^=]*[)])\s*=\s*([.]|(ALIGN|VMLINUX_SYMBOL)[(][^=]*[)])/))
+			{
+				WARN("vmlinux.lds.h needs VMLINUX_SYMBOL() around C-visible symbols\n" . $herecurr);
+			}
+		}
+
 # check for redundant bracing round if etc
 		if ($line =~ /(^.*)\bif\b/ && $1 !~ /else\s*$/) {
 			my ($level, $endln, @chunks) =
-- 
1.6.0.3

