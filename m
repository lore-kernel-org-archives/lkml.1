Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYCKAzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYCKAzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYCKAz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:55:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:40543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbYCKAz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:55:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/4] firmware: provide stubs for the FW_LOADER=n case
Date: Mon, 10 Mar 2008 17:55:13 -0700
Message-Id: <1205196914-17965-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080311004219.GA17890@suse.de>
References: <20080311004219.GA17890@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

libsas has a case where it uses the firmware loader to provide services,
but doesn't want to select it all the time.  This currently causes a
compile failure in libsas if FW_LOADER=n.  Fix this by providing error
stubs for the firmware loader API in the FW_LOADER=n case.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/firmware.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 33d8f20..4d10c73 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -10,7 +10,10 @@ struct firmware {
 	size_t size;
 	u8 *data;
 };
+
 struct device;
+
+#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(
@@ -19,4 +22,24 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 
 void release_firmware(const struct firmware *fw);
+#else
+static inline int request_firmware(const struct firmware **fw,
+				   const char *name,
+				   struct device *device)
+{
+	return -EINVAL;
+}
+static inline int request_firmware_nowait(
+	struct module *module, int uevent,
+	const char *name, struct device *device, void *context,
+	void (*cont)(const struct firmware *fw, void *context))
+{
+	return -EINVAL;
+}
+
+static inline void release_firmware(const struct firmware *fw)
+{
+}
+#endif
+
 #endif
-- 
1.5.4.3

