Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0APJkG (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343Ab0APJkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:40:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:53477 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab0APJkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=loSKbbk7hBlNiyqCKDUWkCk2+hKDrXbxWgu9Jqd8fJzjVnwaElpwd9otVlBF9quAUl
         uVtwxCP0fT34s818ZZVJ+4cHSMhL7Hyl55jwLPVctJrcWga5tl7Kl9iabXwe9NLyTRrn
         XRlR9Le0ZQS2D/UjaPqLiw7c5Kp8hjhvTWdkg=
From: Luca Barbieri <luca@luca-barbieri.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH] Fix broken mmiotrace due to dr6 by reference change
Date: Sat, 16 Jan 2010 10:39:30 +0100
Message-Id: <1263634770-14578-1-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 62edab9056a6cf0c9207339c8892c923a5217e45 (from June 2009 but merged
in 2.6.33) changes notify_die to pass dr6 by reference.

However, it forgets to fix the check for DR_STEP in kmmio.c, breaking
mmiotrace. It also passes a wrong value to the post handler.

This simple fix makes mmiotrace work again.

Please send to Linus for inclusion in 2.6.33

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/mm/kmmio.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index c0f6198..536fb68 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -538,14 +538,15 @@ static int
 kmmio_die_notifier(struct notifier_block *nb, unsigned long val, void *args)
 {
 	struct die_args *arg = args;
+	unsigned long* dr6_p = (unsigned long *)ERR_PTR(arg->err);
 
-	if (val == DIE_DEBUG && (arg->err & DR_STEP))
-		if (post_kmmio_handler(arg->err, arg->regs) == 1) {
+	if (val == DIE_DEBUG && (*dr6_p & DR_STEP))
+		if (post_kmmio_handler(*dr6_p, arg->regs) == 1) {
 			/*
 			 * Reset the BS bit in dr6 (pointed by args->err) to
 			 * denote completion of processing
 			 */
-			(*(unsigned long *)ERR_PTR(arg->err)) &= ~DR_STEP;
+			*dr6_p &= ~DR_STEP;
 			return NOTIFY_STOP;
 		}
 
-- 
1.6.3.3

