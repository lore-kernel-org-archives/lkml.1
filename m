Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbXJDJUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbXJDJUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbXJDJRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429AbXJDJRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:31 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Denis Cheng <crquan@gmail.com>, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/51] [GFS2] use an temp variable to reduce a spin_unlock
Date: Thu,  4 Oct 2007 09:49:02 +0100
Message-Id: <11914878063121-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878043598-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

this is more clear.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/plock.c b/fs/gfs2/locking/dlm/plock.c
index fba1f1d..1f7b038 100644
--- a/fs/gfs2/locking/dlm/plock.c
+++ b/fs/gfs2/locking/dlm/plock.c
@@ -346,15 +346,16 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
 
 static unsigned int dev_poll(struct file *file, poll_table *wait)
 {
+	unsigned int mask = 0;
+
 	poll_wait(file, &send_wq, wait);
 
 	spin_lock(&ops_lock);
-	if (!list_empty(&send_list)) {
-		spin_unlock(&ops_lock);
-		return POLLIN | POLLRDNORM;
-	}
+	if (!list_empty(&send_list))
+		mask = POLLIN | POLLRDNORM;
 	spin_unlock(&ops_lock);
-	return 0;
+
+	return mask;
 }
 
 static const struct file_operations dev_fops = {
-- 
1.5.1.2

