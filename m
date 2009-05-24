Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZEXCmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZEXCmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZEXCiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:05 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1425 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbZEXCiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:01 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] scripts/get_maintainer.pl - Warn on missing git or git repository
Date: Sat, 23 May 2009 19:37:35 -0700
Message-Id: <0ececbed9b6408124176a0e3b8fefdecdffc2633.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

support older versions of grep (use -E not -P)
no need to return data in routine recent_git_signoffs

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index e733e87..fe49122 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -443,11 +443,21 @@ sub recent_git_signoffs {
     my @lines = ();
 
     if (which("git") eq "") {
-	die("$P: git not found.  Add --nogit to options?\n");
+	warn("$P: git not found.  Add --nogit to options?\n");
+	return;
+    }
+    if (!(-d ".git")) {
+	warn("$P: .git repository not found.\n");
+	warn("Use a .git repository for better results.\n");
+	warn("ie: git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	return;
     }
 
     $cmd = "git log --since=${email_git_since} -- ${file}";
-    $cmd .= " | grep -Pi \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
+    $cmd .= " | grep -Ei \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
+    if (!$email_git_penguin_chiefs) {
+	$cmd .= " | grep -Ev \"${penguin_chiefs}\"";
+    }
     $cmd .= " | cut -f2- -d\":\"";
     $cmd .= " | sort | uniq -c | sort -rn";
 
@@ -486,7 +496,6 @@ sub recent_git_signoffs {
 	    push(@email_to, $line);
 	}
     }
-    return $output;
 }
 
 sub uniq {
-- 
1.6.3.1.10.g659a0.dirty

