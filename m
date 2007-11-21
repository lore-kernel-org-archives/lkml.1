Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbXKUNz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbXKUNz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXKUNzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:55:14 -0500
Received: from sacred.ru ([62.205.161.221]:54812 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbXKUNzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:55:13 -0500
Message-ID: <474438B2.9010200@openvz.org>
Date: Wed, 21 Nov 2007 16:54:58 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH][IPC] Lost unlock and fput in mqueue.c on error path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 21 Nov 2007 16:54:58 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The error path in sys_mq_getsetattr() after the call to
audit_mq_getsetattr() is wrong - the info->lock is not
unlocked and the struct file *filp is not put.

Fix them both.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 0ce1ba6..7d1b8aa 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1144,8 +1144,10 @@ asmlinkage long sys_mq_getsetattr(mqd_t mqdes,
 	omqstat.mq_flags = filp->f_flags & O_NONBLOCK;
 	if (u_mqstat) {
 		ret = audit_mq_getsetattr(mqdes, &mqstat);
-		if (ret != 0)
-			goto out;
+		if (ret != 0) {
+			spin_unlock(&info->lock);
+			goto out_fput;
+		}
 		if (mqstat.mq_flags & O_NONBLOCK)
 			filp->f_flags |= O_NONBLOCK;
 		else
