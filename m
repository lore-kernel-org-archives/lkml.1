Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0CFKtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 05:49:39 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49582 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab0CFKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 05:49:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=iLsJPtuCbLdCBTMz9UF4yre1wrfdWxPTNhG5Pf8+cUSFLLR0HiCk5SN7C52gOrBZPr
         Wugj7z4eesYMeadXtLwEAvO87blnFmBSiTobvy/cIa+fmaqM1EiI4kpFNaTKKEtgjdp5
         ogN33DMR+n7gphLYRMZoOLD6QLFBKoA8/+c1U=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Serge Hallyn <serue@us.ibm.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH] sysfs/file: move NULL checks to where they make sense and can occur
Date: Fri,  5 Mar 2010 07:46:00 -0300
Message-Id: <2fcd155e7b67ba2d41de0a5a0751b3091bf849d8.1267785770.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.1.164.gbe2f
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... avoiding checking for NULL 2 times in a row when we already have a page.

It decreases code size:
text    data     bss     dec     hex filename
4246      48    4136    8430    20ee fs/sysfs/file-BEFORE.o
4214      48    4136    8398    20ce fs/sysfs/file-AFTER.o

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 fs/sysfs/file.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index dc30d9e..962b190 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -79,10 +79,11 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	int ret = 0;
 	ssize_t count;
 
-	if (!buffer->page)
-		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
-	if (!buffer->page)
-		return -ENOMEM;
+	if (!buffer->page) {
+		buffer->page = (char *)get_zeroed_page(GFP_KERNEL);
+		if (!buffer->page)
+			return -ENOMEM;
+	}
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active_two(attr_sd))
@@ -167,10 +168,11 @@ fill_write_buffer(struct sysfs_buffer * buffer, const char __user * buf, size_t
 {
 	int error;
 
-	if (!buffer->page)
+	if (!buffer->page) {
 		buffer->page = (char *)get_zeroed_page(GFP_KERNEL);
-	if (!buffer->page)
-		return -ENOMEM;
+		if (!buffer->page)
+			return -ENOMEM;
+	}
 
 	if (count >= PAGE_SIZE)
 		count = PAGE_SIZE - 1;
-- 
1.7.0.1.164.gbe2f

