Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab0BPWp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:45:28 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43838 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab0BPWpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:45:25 -0500
From: Serge Hallyn <serue@us.ibm.com>
To: serue@us.ibm.com
Cc: Greg KH <greg@kroah.com>, rsc@swtch.com,
       Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>
Subject: [PATCH 4/8] p9auth: add CAP_GRANT_ID to authorize use of /dev/caphash
Date: Tue, 16 Feb 2010 16:44:57 -0600
Message-Id: <1266360301-30081-4-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Granting userid capabilities to another task is a dangerous
privilege.  Don't just let file permissions authorize it.
Define CAP_GRANT_ID as a new capability needed to write to
/dev/caphash.

For one thing this lets us start a factotum server early on
in init, then have init drop CAP_GRANT_ID from its bounding
set so the rest of the system cannot regain it.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
cc: rsc@swtch.com
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: ericvh@gmail.com
Cc: devel@linuxdriverproject.org
Cc: linux-kernel@vger.kernel.org
Cc: Ron Minnich <rminnich@gmail.com>
---
 drivers/staging/p9auth/p9auth.c |    4 ++++
 include/linux/capability.h      |    6 +++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index 8f70daa..fb27459 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -201,6 +201,10 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 			retval = -EINVAL;
 			goto out;
 		}
+		if (!capable(CAP_GRANT_ID)) {
+			retval = -EPERM;
+			goto out;
+		}
 		printk(KERN_INFO "Capability being written to /dev/caphash : \n");
 		hexdump(user_buf, count);
 		memcpy(node_ptr->data, user_buf, count);
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 39e5ff5..ba2cbfe 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -355,7 +355,11 @@ struct cpu_vfs_cap_data {
 
 #define CAP_MAC_ADMIN        33
 
-#define CAP_LAST_CAP         CAP_MAC_ADMIN
+/* Allow granting setuid capabilities through p9auth /dev/caphash */
+
+#define CAP_GRANT_ID         34
+
+#define CAP_LAST_CAP         CAP_GRANT_ID
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
-- 
1.6.1

