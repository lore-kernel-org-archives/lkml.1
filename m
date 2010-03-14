Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0CNHtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 03:49:35 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:61869 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab0CNHt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 03:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=vpfGAjB8i+cw2YZ9hng6Lnn9ZHY1vaPQjUBAA+wHlVITdTvdo+URX7hgM0ATEyDIII
         O7bfspZwTss+fq5lZUar/AdEBvDaRvhno1QUApGpNobrgLQuONdMopjvViwTJ6sk0JTZ
         5dtegdFj7cf9YMS6fjJA2VvejsRPokuj8oF/w=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/5] firmware loader: do not allocate firmare id separately
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 13 Mar 2010 23:49:23 -0800
Message-ID: <20100314074923.27035.81487.stgit@localhost.localdomain>
In-Reply-To: <20100314074330.27035.38765.stgit@localhost.localdomain>
References: <20100314074330.27035.38765.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_id has the same life time as firmware_priv so it makes sense to move
it into firmware_priv structure instead of allocating separately.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/base/firmware_class.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 9b4bca0..06ff016 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -85,15 +85,14 @@ static int loading_timeout = 60;	/* In seconds */
 static DEFINE_MUTEX(fw_lock);
 
 struct firmware_priv {
-	char *fw_id;
 	struct completion completion;
 	struct firmware *fw;
 	unsigned long status;
 	struct page **pages;
 	int nr_pages;
 	int page_array_size;
-	const char *vdata;
 	struct timer_list timeout;
+	char fw_id[];
 };
 
 static void
@@ -149,7 +148,6 @@ static void fw_dev_release(struct device *dev)
 	for (i = 0; i < fw_priv->nr_pages; i++)
 		__free_page(fw_priv->pages[i]);
 	kfree(fw_priv->pages);
-	kfree(fw_priv->fw_id);
 	kfree(fw_priv);
 	kfree(dev);
 
@@ -417,8 +415,8 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 			      struct device *device)
 {
 	int retval;
-	struct firmware_priv *fw_priv = kzalloc(sizeof(*fw_priv),
-						GFP_KERNEL);
+	struct firmware_priv *fw_priv =
+		kzalloc(sizeof(*fw_priv) + strlen(fw_name) + 1 , GFP_KERNEL);
 	struct device *f_dev = kzalloc(sizeof(*f_dev), GFP_KERNEL);
 
 	*dev_p = NULL;
@@ -429,14 +427,8 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 		goto error_kfree;
 	}
 
+	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
-	fw_priv->fw_id = kstrdup(fw_name, GFP_KERNEL);
-	if (!fw_priv->fw_id) {
-		dev_err(device, "%s: Firmware name allocation failed\n",
-			__func__);
-		retval = -ENOMEM;
-		goto error_kfree;
-	}
 
 	fw_priv->timeout.function = firmware_class_timeout;
 	fw_priv->timeout.data = (u_long) fw_priv;

