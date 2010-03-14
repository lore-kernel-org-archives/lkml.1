Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0CNHtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 03:49:40 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:56002 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab0CNHtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 03:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=E0D5W/NLaX7FcAWnLt6uG9Zhn6uoSXkxHSNI9NRC9xWspzoo63GSrC48IYiZP+WWxi
         NHp4Pckm62bNyKwdKVd5QVWo8UKzpZ24wOrU5LA3HxBPwLWTKYt4fMkx1+ZtDUt6kiZJ
         xa2KjIZdG7jbg9yVGUOSuQXiN40B4tEOSZs+E=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3/5] firmware loader: split out builtin firmware handling
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 13 Mar 2010 23:49:18 -0800
Message-ID: <20100314074918.27035.80164.stgit@localhost.localdomain>
In-Reply-To: <20100314074330.27035.38765.stgit@localhost.localdomain>
References: <20100314074330.27035.38765.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split builtin firmware handling into separate functions to clean up the
main body of code.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/base/firmware_class.c |   81 +++++++++++++++++++++++++++--------------
 1 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 5f9d906..9b4bca0 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -26,6 +26,52 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
+/* Builtin firmware support */
+
+#ifdef CONFIG_FW_LOADER
+
+extern struct builtin_fw __start_builtin_fw[];
+extern struct builtin_fw __end_builtin_fw[];
+
+static bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
+{
+	struct builtin_fw *b_fw;
+
+	for (b_fw = __start_builtin_fw; b_fw != __end_builtin_fw; b_fw++) {
+		if (strcmp(name, b_fw->name) == 0) {
+			fw->size = b_fw->size;
+			fw->data = b_fw->data;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool fw_is_builtin_firmware(const struct firmware *fw)
+{
+	struct builtin_fw *b_fw;
+
+	for (b_fw = __start_builtin_fw; b_fw != __end_builtin_fw; b_fw++)
+		if (fw->data == b_fw->data)
+			return true;
+
+	return false;
+}
+
+#else /* Module case - no builtin firmware support */
+
+static inline bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
+{
+	return false;
+}
+
+static inline bool fw_is_builtin_firmware(const struct firmware *fw)
+{
+	return false;
+}
+#endif
+
 enum {
 	FW_STATUS_LOADING,
 	FW_STATUS_DONE,
@@ -50,14 +96,6 @@ struct firmware_priv {
 	struct timer_list timeout;
 };
 
-#ifdef CONFIG_FW_LOADER
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
-#else /* Module case. Avoid ifdefs later; it'll all optimise out */
-static struct builtin_fw *__start_builtin_fw;
-static struct builtin_fw *__end_builtin_fw;
-#endif
-
 static void
 fw_load_abort(struct firmware_priv *fw_priv)
 {
@@ -473,7 +511,6 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
-	struct builtin_fw *builtin;
 	int retval;
 
 	if (!firmware_p)
@@ -487,14 +524,9 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 	}
 
-	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
-	     builtin++) {
-		if (strcmp(name, builtin->name))
-			continue;
-		dev_info(device, "firmware: using built-in firmware %s\n",
-			 name);
-		firmware->size = builtin->size;
-		firmware->data = builtin->data;
+	if (fw_get_builtin_firmware(firmware, name)) {
+		dev_info(device,
+			 "firmware: using built-in firmware %s\n", name);
 		return 0;
 	}
 
@@ -565,19 +597,12 @@ request_firmware(const struct firmware **firmware_p, const char *name,
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
  **/
-void
-release_firmware(const struct firmware *fw)
+void release_firmware(const struct firmware *fw)
 {
-	struct builtin_fw *builtin;
-
 	if (fw) {
-		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
-		     builtin++) {
-			if (fw->data == builtin->data)
-				goto free_fw;
-		}
-		vfree(fw->data);
-	free_fw:
+		if (!fw_is_builtin_firmware(fw))
+			vfree(fw->data);
+
 		kfree(fw);
 	}
 }

