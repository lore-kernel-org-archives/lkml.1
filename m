Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbYJXBL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbYJXBL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJXBLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:11:46 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:23680 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750896AbYJXBLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:11:46 -0400
X-YMail-OSG: foh38wgVM1k0El5GevKS0FAeiXZ5VEuorYmDkU6SlKixYXVWJ12LUgGiv4fvHSJlgo5J8SjcFHAao9goZOvFEw6Y2IlQL1im_WbGvOpSr1TG_G5F9yrKyIwsB2WT4h7ZyM2G5B4QoqsmRDH8c7rGMi7WPV_eaS16x6j8dcA87S0Tb3biW_etvEEtlco-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [ConfigFS]: Added CONFIGFS_EATTR_OPS_RO() to remove unused
	store() function
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joel Becker <joel.becker@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 18:11:43 -0700
Message-Id: <1224810703.16558.19.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Added another change to the CONFIGFS_EATTR() macros I am using in
drivers/lio-core/configfs_macros.h:

When using __CONFIGFS_ATTR_RO(), I noticed that CONFIGFS_ATTR_OPS() was
getting the compiler warning about unused store() functions.  So I ended
up breaking out the 3 functions into three different macros..

Thanks!

--nab

>From 4cfb0287a2fc48bc414e3467edb8cdfc88c2fc72 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 23 Oct 2008 06:56:29 -0700
Subject: [PATCH] [ConfigFS]: Added CONFIGFS_EATTR_OPS_RO() to remove unused store() function

Added CONFIGFS_EATTR_OPS_RO() macro only defines show().  This patch also
breaks out the show()/store() and to_##_name() functions into their own
macros.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/configfs_macros.h |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/configfs_macros.h b/drivers/lio-core/configfs_macros.h
index 4dd3f1e..2185822 100644
--- a/drivers/lio-core/configfs_macros.h
+++ b/drivers/lio-core/configfs_macros.h
@@ -98,12 +98,14 @@ struct _name##_attribute {						\
  *		                      ^^_item^^^^^  ^^_item_member^^^
  * This macro expects the attributes to be named "struct <name>_attribute".
  */
-#define CONFIGFS_EATTR_OPS(_name, _item, _item_member)			\
+#define CONFIGFS_EATTR_OPS_TO_FUNC(_name, _item, _item_member)		\
 static struct _item *to_##_name(struct config_item *ci)			\
 {									\
 	return((ci) ? container_of(to_config_group(ci), struct _item,	\
 		_item_member) : NULL);					\
-}									\
+}
+
+#define CONFIGFS_EATTR_OPS_SHOW(_name, _item)				\
 static ssize_t _name##_attr_show(struct config_item *item,		\
 				 struct configfs_attribute *attr,	\
 				 char *page)				\
@@ -116,7 +118,9 @@ static ssize_t _name##_attr_show(struct config_item *item,		\
 	if (_name##_attr->show)						\
 		ret = _name##_attr->show(_item, page);			\
 	return ret;							\
-}									\
+}
+
+#define CONFIGFS_EATTR_OPS_STORE(_name, _item)				\
 static ssize_t _name##_attr_store(struct config_item *item,		\
 				  struct configfs_attribute *attr,	\
 				  const char *page, size_t count)	\
@@ -131,4 +135,13 @@ static ssize_t _name##_attr_store(struct config_item *item,		\
 	return ret;							\
 }
 
+#define CONFIGFS_EATTR_OPS(_name, _item, _item_member)			\
+CONFIGFS_EATTR_OPS_TO_FUNC(_name, _item, _item_member);			\
+CONFIGFS_EATTR_OPS_SHOW(_name, _item);					\
+CONFIGFS_EATTR_OPS_STORE(_name, _item);	
+
+#define CONFIGFS_EATTR_OPS_RO(_name, _item, _item_member)		\
+CONFIGFS_EATTR_OPS_TO_FUNC(_name, _item, _item_member);			\
+CONFIGFS_EATTR_OPS_SHOW(_name, _item);
+
 #endif /* _CONFIGFS_MACROS_H_ */
-- 
1.5.4.1



