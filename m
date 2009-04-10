Return-Path: <linux-kernel-owner+w=401wt.eu-S936790AbZDJQf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936790AbZDJQf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763663AbZDJQe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:34:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:6991 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934278AbZDJQe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=armIsxV1EcJOtMxEimIKQRf7iqDVNMUtcIulxZgGQN/8aA037gZiQ272h6uDxQrFuq
         iebmHwce9kP/EWshCktBcnsnkqtfOxt2/7LG75ZvDJRvxf6WIgRjLb05OVPBlQvlXW29
         ExRCLKBv07lpsRnSD844QX9yv23PAL723lzR8=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] remove the BKL: remove "BKL auto-drop" assumption from nfs3_rpc_wrapper()
Date: Fri, 10 Apr 2009 18:34:41 +0200
Message-Id: <1239381281-11282-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix nfs3_rpc_wrapper()'s "schedule() drops the BKL automatically" assumption,
when schedule_timeout_killable() does not do that it can lock up.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/nfs/nfs3proc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index d0cc5ce..d91047c 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -17,6 +17,7 @@
 #include <linux/nfs_page.h>
 #include <linux/lockd/bind.h>
 #include <linux/nfs_mount.h>
+#include <linux/smp_lock.h>
 
 #include "iostat.h"
 #include "internal.h"
@@ -28,11 +29,17 @@ static int
 nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 {
 	int res;
+	int bkl = kernel_locked();
+
 	do {
 		res = rpc_call_sync(clnt, msg, flags);
 		if (res != -EJUKEBOX)
 			break;
+		if (bkl)
+			unlock_kernel();
 		schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
+		if (bkl)
+			lock_kernel();
 		res = -ERESTARTSYS;
 	} while (!fatal_signal_pending(current));
 	return res;
-- 
1.6.0.4

