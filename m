Return-Path: <linux-kernel-owner+w=401wt.eu-S967435AbXG3RLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967435AbXG3RLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967085AbXG3RJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:09:49 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37207 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966971AbXG3RJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:09:48 -0400
Date: Mon, 30 Jul 2007 13:09:11 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/4] UML - Move userspace code to userspace file
Message-ID: <20070730170911.GA7687@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move some code from a kernelspace file to a userspace file where it
fits better.  This enables some tidying which is the subject of a
later patch.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/chan_kern.c |   48 -------------------------------------------
 arch/um/drivers/chan_user.c |   49 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 48 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/chan_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_kern.c	2007-07-27 11:34:20.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_kern.c	2007-07-27 11:35:30.000000000 -0400
@@ -89,54 +89,6 @@ static const struct chan_ops not_configg
 };
 #endif /* CONFIG_NOCONFIG_CHAN */
 
-void generic_close(int fd, void *unused)
-{
-	os_close_file(fd);
-}
-
-int generic_read(int fd, char *c_out, void *unused)
-{
-	int n;
-
-	n = os_read_file(fd, c_out, sizeof(*c_out));
-
-	if(n == -EAGAIN)
-		return 0;
-	else if(n == 0)
-		return -EIO;
-	return n;
-}
-
-/* XXX Trivial wrapper around os_write_file */
-
-int generic_write(int fd, const char *buf, int n, void *unused)
-{
-	return os_write_file(fd, buf, n);
-}
-
-int generic_window_size(int fd, void *unused, unsigned short *rows_out,
-			unsigned short *cols_out)
-{
-	int rows, cols;
-	int ret;
-
-	ret = os_window_size(fd, &rows, &cols);
-	if(ret < 0)
-		return ret;
-
-	ret = ((*rows_out != rows) || (*cols_out != cols));
-
-	*rows_out = rows;
-	*cols_out = cols;
-
-	return ret;
-}
-
-void generic_free(void *data)
-{
-	kfree(data);
-}
-
 static void tty_receive_char(struct tty_struct *tty, char ch)
 {
 	if(tty == NULL) return;
Index: linux-2.6.21-mm/arch/um/drivers/chan_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_user.c	2007-07-27 11:34:20.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_user.c	2007-07-27 11:42:55.000000000 -0400
@@ -19,6 +19,55 @@
 #include "os.h"
 #include "choose-mode.h"
 #include "mode.h"
+#include "um_malloc.h"
+
+void generic_close(int fd, void *unused)
+{
+	os_close_file(fd);
+}
+
+int generic_read(int fd, char *c_out, void *unused)
+{
+	int n;
+
+	n = os_read_file(fd, c_out, sizeof(*c_out));
+
+	if(n == -EAGAIN)
+		return 0;
+	else if(n == 0)
+		return -EIO;
+	return n;
+}
+
+/* XXX Trivial wrapper around os_write_file */
+
+int generic_write(int fd, const char *buf, int n, void *unused)
+{
+	return os_write_file(fd, buf, n);
+}
+
+int generic_window_size(int fd, void *unused, unsigned short *rows_out,
+			unsigned short *cols_out)
+{
+	int rows, cols;
+	int ret;
+
+	ret = os_window_size(fd, &rows, &cols);
+	if(ret < 0)
+		return ret;
+
+	ret = ((*rows_out != rows) || (*cols_out != cols));
+
+	*rows_out = rows;
+	*cols_out = cols;
+
+	return ret;
+}
+
+void generic_free(void *data)
+{
+	kfree(data);
+}
 
 int generic_console_write(int fd, const char *buf, int n)
 {
