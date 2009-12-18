Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbZLRSH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbZLRSH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbZLRSH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:07:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:47712 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbZLRSHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:07:23 -0500
Date: Fri, 18 Dec 2009 18:06:37 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <20091218154012.16960.5113.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091218154012.16960.5113.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix objdump version check in chkobjdump.awk for different formats.
Message-ID: <tip-8bee738bb1979c8bf7b42716b772522ab7d26b0c@git.kernel.org>
Git-Commit-ID: 8bee738bb1979c8bf7b42716b772522ab7d26b0c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bee738bb1979c8bf7b42716b772522ab7d26b0c
Gitweb:     http://git.kernel.org/tip/8bee738bb1979c8bf7b42716b772522ab7d26b0c
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 18 Dec 2009 10:40:13 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 18 Dec 2009 09:26:56 -0800

x86: Fix objdump version check in chkobjdump.awk for different formats.

Different version of objdump says its version in different way;

GNU objdump 2.16.1

or

GNU objdump version 2.19.51.0.14-1.fc11 20090722

This patch uses the first argument which starts with a number
as version string.

Changes in v2:
 - Remove unneeded increment.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <20091218154012.16960.5113.stgit@dhcp-100-2-132.bos.redhat.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/tools/chkobjdump.awk |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
index 5bbb5a3..fd1ab80 100644
--- a/arch/x86/tools/chkobjdump.awk
+++ b/arch/x86/tools/chkobjdump.awk
@@ -8,14 +8,24 @@ BEGIN {
 	od_sver = 19;
 }
 
-/^GNU/ {
-	split($3, ver, ".");
+/^GNU objdump/ {
+	verstr = ""
+	for (i = 3; i <= NF; i++)
+		if (match($(i), "^[0-9]")) {
+			verstr = $(i);
+			break;
+		}
+	if (verstr == "") {
+		printf("Warning: Failed to find objdump version number.\n");
+		exit 0;
+	}
+	split(verstr, ver, ".");
 	if (ver[1] > od_ver ||
 	    (ver[1] == od_ver && ver[2] >= od_sver)) {
 		exit 1;
 	} else {
 		printf("Warning: objdump version %s is older than %d.%d\n",
-		       $4, od_ver, od_sver);
+		       verstr, od_ver, od_sver);
 		print("Warning: Skipping posttest.");
 		# Logic is inverted, because we just skip test without error.
 		exit 0;
