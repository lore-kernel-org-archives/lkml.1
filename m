Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYCaPMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYCaPMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYCaPMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:12:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:49495 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYCaPMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=pGVbsk3EF3ANRMblzQnp1y+1tB5SHNn1YU+7YMOy0Mdvs6ocXt1hkw1U83uBdhb7xZM4LbBoHQuxjmTOKkqMjMTzwXfagwWBQgCfa06QhFsp3hYAUXCwWwXhqZBZCuGVZfqKbZKEK9w0t74vGVeGCJ558PLaobwhwlGue8ZkA+g=
Date: Mon, 31 Mar 2008 23:10:01 +0800 (CST)
Message-Id: <20080331.231001.18971784.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] arch/um/os-Linux/start_up.c: various improvements.
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch

 - lets ptrace_child become void
 - adds checking for the return value of change_sig
 - moves errors info into stderr instead of stdout.


Cc: jdike@addtoit.com
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
 arch/um/os-Linux/start_up.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index b616e15..997d019 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -25,15 +25,15 @@
 #include "registers.h"
 #include "skas_ptrace.h"
 
-static int ptrace_child(void)
+static void ptrace_child(void)
 {
 	int ret;
 	/* Calling os_getpid because some libcs cached getpid incorrectly */
 	int pid = os_getpid(), ppid = getppid();
 	int sc_result;
 
-	change_sig(SIGWINCH, 0);
-	if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
+	if (change_sig(SIGWINCH, 0) < 0 ||
+	    ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
 		perror("ptrace");
 		kill(pid, SIGKILL);
 	}
@@ -75,9 +75,8 @@ static void fatal(char *fmt, ...)
 	va_list list;
 
 	va_start(list, fmt);
-	vprintf(fmt, list);
+	vfprintf(stderr, fmt, list);
 	va_end(list);
-	fflush(stdout);
 
 	exit(1);
 }
@@ -87,9 +86,8 @@ static void non_fatal(char *fmt, ...)
 	va_list list;
 
 	va_start(list, fmt);
-	vprintf(fmt, list);
+	vfprintf(stderr, fmt, list);
 	va_end(list);
-	fflush(stdout);
 }
 
 static int start_ptraced_child(void)
@@ -495,7 +493,7 @@ int __init parse_iomem(char *str, int *add)
 	driver = str;
 	file = strchr(str,',');
 	if (file == NULL) {
-		printf("parse_iomem : failed to parse iomem\n");
+		fprintf(stderr, "parse_iomem : failed to parse iomem\n");
 		goto out;
 	}
 	*file = '\0';
-- 
1.5.2.4

