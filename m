Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbXGTDh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbXGTDh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbXGTDht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:37:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:1693 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbXGTDhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:37:47 -0400
Message-Id: <200707200337.l6K3bjDr053658@www262.sakura.ne.jp>
Subject: [PATCH] parse_table() earlier check.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Jul 2007 12:37:45 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

/* The part parse_table() does */

for ( ; table->ctl_name || table->procname; table++) {
        if (!table->ctl_name)
                continue;
        if (n == table->ctl_name) {
                return do_sysctl_strategy();
        }
}
return -ENOTDIR;

/* is equivalent to */

for ( ; table->ctl_name || table->procname; table++) {
        if (n == table->ctl_name && n) {
                return do_sysctl_strategy();
        }
}
return -ENOTDIR;

/* is equivalent to */

if (n) {
        for ( ; table->ctl_name || table->procname; table++) {
                if (n == table->ctl_name) {
                        return do_sysctl_strategy();
                }
        }
}
return -ENOTDIR;

/* and here is a patch. I think this change is harmless. */

-----
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

 sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -ur linux-2.6.22-orig/kernel/sysctl.c linux-2.6.22/kernel/sysctl.c
--- linux-2.6.22-orig/kernel/sysctl.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/kernel/sysctl.c	2007-07-20 12:23:17.000000000 +0900
@@ -1190,9 +1190,9 @@
 		return -ENOTDIR;
 	if (get_user(n, name))
 		return -EFAULT;
+	if (!n)
+		return -ENOTDIR;
 	for ( ; table->ctl_name || table->procname; table++) {
-		if (!table->ctl_name)
-			continue;
 		if (n == table->ctl_name) {
 			int error;
 			if (table->child) {
