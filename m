Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYLGScp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYLGScp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYLGSbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:05 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55706 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYLGSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:04 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 05/13] checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h
Date: Sun,  7 Dec 2008 18:30:42 +0000
Message-Id: <1228674650-24392-6-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Seems like every other release we have someone who updates vmlinux.lds.h and
adds C-visible symbols without VMLINUX_SYMBOL() around them.  So start
checking the file and reject assignments which have plain symbols on either
side.

[apw@canonical.com: soften the check, add tests]
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5c7fd1a..705a043 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2224,6 +2224,15 @@ sub process {
 			}
 		}
 
+# make sure symbols are always wrapped with VMLINUX_SYMBOL() ...
+# all assignments may have only one of the following with an assignment:
+#	.
+#	ALIGN(...)
+#	VMLINUX_SYMBOL(...)
+		if ($realfile eq 'vmlinux.lds.h' && $line =~ /(?:(?:^|\s)$Ident\s*=|=\s*$Ident(?:\s|$))/) {
+			WARN("vmlinux.lds.h needs VMLINUX_SYMBOL() around C-visible symbols\n" . $herecurr);
+		}
+
 # check for redundant bracing round if etc
 		if ($line =~ /(^.*)\bif\b/ && $1 !~ /else\s*$/) {
 			my ($level, $endln, @chunks) =
-- 
1.6.0.4.911.gc990

