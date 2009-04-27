Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbZD0UWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbZD0UWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbZD0UWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:22:37 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53009 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbZD0UWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=lfQvrZb8SS/b+FkeGuAasTLLGurzLR3fWUMn8ipIgF/m9XbFgZ3gxs3H6ljh8c0Jgn
         yxK06yQXaE1JAE4BFt6RA4LNbpXh7xzj2OsXRpk+jfsx1eLZDwTQhNgPuGiX4pj7t/zb
         KDM7yz7vN0/ffbogkWWpk68Lhfonow0ZirfYQ=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH -tip:kill-the-BKL] remove the BKL: remove "BKL auto-drop" assumption from ext3_remount()
Date: Mon, 27 Apr 2009 22:22:28 +0200
Message-Id: <1240863748-13225-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090426163924.GD6236@elte.hu>
References: <20090426163924.GD6236@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ext3_remount()'s "schedule() drops the BKL automatically" assumption,
when ext3_mark_recovery_complete(), which can sleep, does not do that it can
lock up.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/ext3/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index dc905f9..5d61a7f 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2503,6 +2503,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 #ifdef CONFIG_QUOTA
 	int i;
 #endif
+	int bkl = kernel_locked();
 
 	/* Store the original options */
 	old_sb_flags = sb->s_flags;
@@ -2561,9 +2562,13 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			 * We have to unlock super so that we can wait for
 			 * transactions.
 			 */
+			if (bkl)
+				unlock_kernel();
 			unlock_super(sb);
 			ext3_mark_recovery_complete(sb, es);
 			lock_super(sb);
+			if (bkl)
+				lock_kernel();
 		} else {
 			__le32 ret;
 			if ((ret = EXT3_HAS_RO_COMPAT_FEATURE(sb,
-- 
1.6.0.4

