Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZDWNQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZDWNQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbZDWNQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:16:35 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35796 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbZDWNQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aZKIuVMNM0IJMg0Z20SQT+R2mX0bb0hlx1Fqo2pJ5NAVc33MYLqn3VJ0lmcmZeoSH1
         pNh7kVefR11LOYk6OBf/DoIKpdoadwA/Or34ednRsTUlQrWtmH5sK+7pUguu0TkRKIZQ
         Um/RsxzxExk5yl9p+vsaVKxSpc+FrFGkKMwfk=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH -tip] remove the BKL: remove "BKL auto-drop" assumption from ext3_remount()
Date: Thu, 23 Apr 2009 15:16:26 +0200
Message-Id: <1240492586-6654-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ext3_remount()'s "schedule() drops the BKL automatically" assumption,
when ext3_mark_recovery_complete(), which can sleep, does not do that it can
lock up.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/ext3/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index dc905f9..3fa457a 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2561,9 +2561,11 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			 * We have to unlock super so that we can wait for
 			 * transactions.
 			 */
+			unlock_kernel();
 			unlock_super(sb);
 			ext3_mark_recovery_complete(sb, es);
 			lock_super(sb);
+			lock_kernel();
 		} else {
 			__le32 ret;
 			if ((ret = EXT3_HAS_RO_COMPAT_FEATURE(sb,
-- 
1.6.0.4

