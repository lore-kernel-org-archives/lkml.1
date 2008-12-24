Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbYLXGQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbYLXGQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 01:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYLXGQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 01:16:27 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:55671 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYLXGQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 01:16:26 -0500
Message-Id: <200812240616.mBO6GGEe078727@www262.sakura.ne.jp>
Subject: [PATCH] Check return from argv_split() in do_coredump().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Dec 2008 15:16:16 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 23122008 #1347588, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_coredump() accesses helper_argv[0] without checking helper_argv != NULL.
Though, likely helper_argv != NULL.

Below versions have this problem.

  2.6.24.7
  2.6.25.20
  2.6.26.8
  2.6.27.10
  2.6.28-rc9
  mmotm 2008-12-22-16-14

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.28-rc9-mm1.orig/fs/exec.c
+++ linux-2.6.28-rc9-mm1/fs/exec.c
@@ -1809,10 +1809,15 @@ int do_coredump(long signr, int exit_cod
 	if ((!ispipe) && (core_limit < binfmt->min_coredump))
 		goto fail_unlock;
 
  	if (ispipe) {
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
+		if (!helper_argv) {
+			printk(KERN_WARNING "%s failed to allocate memory\n",
+			       __func__);
+			goto fail_unlock;
+		}
 		/* Terminate the string before the first option */
 		delimit = strchr(corename, ' ');
 		if (delimit)
 			*delimit = '\0';
 		delimit = strrchr(helper_argv[0], '/');
