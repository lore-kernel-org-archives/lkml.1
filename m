Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZLRPaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZLRPaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZLRPay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:30:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbZLRPax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:30:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH x86/urgent] x86: Fix objdump version check in chkobjdump.awk
	for different formats.
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Dec 2009 10:34:42 -0500
Message-ID: <20091218153442.16571.41882.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <4B2ACC11.3020209@zytor.com>
References: <4B2ACC11.3020209@zytor.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different version of objdump says its version in different way;

GNU objdump 2.16.1

or

GNU objdump version 2.19.51.0.14-1.fc11 20090722

This patch uses the first argument which starts with a number
as version string.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/tools/chkobjdump.awk |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
index 5bbb5a3..250dc79 100644
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
+			verstr = $(i++);
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
