Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYCCAFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYCCAFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYCCAEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:04:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:1452 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYCCAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qpoTm+QlaTHwQa079vb43OdlhUSpnPStmUTjn4kSQqSHa3xLVmICgVL8DDBqGgJ66donW0l5d74t1WXo2tKkJ1z1u6ZNEmgdNrPa7gbAVgQK8Iw9OL5c6sj3/ZQU9sOH86atGXBbGHRIYTQzmL9BxQlCnPMYB4Q4eZouoemoP7A=
Date: Mon, 3 Mar 2008 02:43:08 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org
Subject: [PATCH RFC] introduce pm_call() macro to get rid of most #ifdef
	CONFIG_PM
Message-ID: <20080302234308.GA10116@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently drivers handle CONFIG_PM this way:

#ifdef CONFIG_PM
drv_suspend() {}
drv_resume() {}
#else
#define drv_suspend NULL
#define drv_resume NULL
#endif

struct driver drv = {
	.suspend = drv_suspend,
	.resume = drv_resume,
};

With this patch, the code above converts into:

drv_suspend() {}
drv_resume() {}

struct driver drv = {
	.suspend = pm_call(drv_suspend),
	.resume = pm_call(drv_resume),
};

GCC will optimize away suspend/resume calls if they're really
not used.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 include/linux/pm.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 015b735..6e0b9c2 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -114,6 +114,13 @@ typedef struct pm_message {
 	int event;
 } pm_message_t;
 
+#ifdef CONFIG_PM
+#define pm_call(x) (x)
+#else
+/* avoid `defined but not used' warning */
+#define pm_call(x) ((x) - 1 ? NULL : NULL)
+#endif /* CONFIG_PM */
+
 /*
  * Several driver power state transitions are externally visible, affecting
  * the state of pending I/O queues and (for drivers that touch hardware)
-- 
1.5.4.3
