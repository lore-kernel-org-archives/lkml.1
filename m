Return-Path: <linux-kernel-owner+w=401wt.eu-S934845AbZJJUwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845AbZJJUwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934837AbZJJUwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:52:12 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.34]:59047 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934799AbZJJUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:52:10 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH 2/5] Add setter/getter interface for kmsg_redirect
Date: Sat, 10 Oct 2009 22:51:07 +0200
Message-Id: <1255207870-24496-3-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to use kmsg_redirect in code when CONFIG_VT_CONSOLE is not set and to avoid
code like

        #ifdef CONFIG_VT_CONSOLE
                kmsg_redirect = foo;
        #endif

we add a function pair vt_get_kmsg_redirect()/vt_set_kmsg_redirect() that just
returns or sets that variable, but is defined to do nothing in case CONFIG_VT_CONSOLE
is not set.


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 drivers/char/vt.c  |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/vt.h |   18 ++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index c3b1a86..01c4a1c 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2428,6 +2428,43 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
+/**
+ * vt_get_kmsg_redirect() - Returns the virtual console number for kernel
+ *                          messages
+ *
+ * By default, the kernel messages are always printed on the current virtual
+ * console. However, the user may modify that default with the
+ * TIOCL_SETKMSGREDIRECT ioctl call.
+ *
+ * This funciton returns the virtual console number where kernel messages are
+ * redirected to. 0 means no redirection (i.e. always printed on the currently
+ * active console).
+ *
+ * When the kernel is compiled without CONFIG_VT_CONSOLE, this function also
+ * returns 0.
+ */
+int vt_get_kmsg_redirect(void)
+{
+	return kmsg_redirect;
+}
+
+/**
+ * vt_set_kmsg_redirect() - Sets the virtual console number for kernel messages
+ * @vt:		The number of the virtual terminal.
+ *
+ * See also: vt_get_kmsg_redirect().
+ *
+ * This function allows to modify the virtual console for kernel messages from
+ * kernel code. Calling vt_set_kmsg_redirect(0) restores the default.
+ *
+ * When the kernel is compiled without CONFIG_VT_CONSOLE, this function does
+ * nothing.
+ */
+void vt_set_kmsg_redirect(int vt)
+{
+	kmsg_redirect = vt;
+}
+
 /*
  *	Console on virtual terminal
  *
diff --git a/include/linux/vt.h b/include/linux/vt.h
index 7afca0d..fa87e2a 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -84,4 +84,22 @@ struct vt_setactivate {
 
 #define VT_SETACTIVATE	0x560F	/* Activate and set the mode of a console */
 
+#ifdef CONFIG_VT_CONSOLE
+
+extern void vt_set_kmsg_redirect(int vt);
+extern int  vt_get_kmsg_redirect(void);
+
+#else /* CONFIG_VT_CONSOLE */
+
+static inline void vt_set_kmsg_redirect(int vt)
+{
+}
+
+static inline int vt_get_kmsg_redirect(void)
+{
+    return 0;
+}
+
+#endif /* CONFIG_VT_CONSOLE */
+
 #endif /* _LINUX_VT_H */
-- 
1.6.3.3

