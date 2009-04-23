Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbZDWTNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbZDWTNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758683AbZDWTMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:12:20 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61329 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZDWTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wa5p38re/gR3Qp9oFr0QkmRRCf4I5w1OrRX2qUw/Y0daLW/2nkIkkZYnf9jLkCfw7s
         JChiDGmZdTnlbqyoV6828ewXDkGtkoAQuvwECm04Y2v0WCSTw/QZ1PVV0O2nI9GCmaGb
         J3TnSNlmvfqIUvwqUAxyATh7XhbCMwZNlqKF4=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 2/5 -tip] cifs: umount_begin BKL pushdown
Date: Thu, 23 Apr 2009 21:12:02 +0200
Message-Id: <1240513925-5603-3-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1240513925-5603-2-git-send-email-abogani@texware.it>
References: <1240513925-5603-1-git-send-email-abogani@texware.it>
 <1240513925-5603-2-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/cifs/cifsfs.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 38491fd..9517ae1 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/smp_lock.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
 #define DECLARE_GLOBALS_HERE
@@ -525,18 +526,26 @@ static void cifs_umount_begin(struct super_block *sb)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsTconInfo *tcon;
 
-	if (cifs_sb == NULL)
+	lock_kernel();
+
+	if (cifs_sb == NULL) {
+		unlock_kernel();
 		return;
+	}
 
 	tcon = cifs_sb->tcon;
-	if (tcon == NULL)
+	if (tcon == NULL) {
+		unlock_kernel();
 		return;
+	}
 
 	read_lock(&cifs_tcp_ses_lock);
 	if (tcon->tc_count == 1)
 		tcon->tidStatus = CifsExiting;
 	read_unlock(&cifs_tcp_ses_lock);
 
+	unlock_kernel();
+
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {
-- 
1.6.0.4

