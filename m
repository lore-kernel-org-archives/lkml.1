Return-Path: <linux-kernel-owner+w=401wt.eu-S2993127AbXDSHCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993127AbXDSHCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993124AbXDSHBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:01:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46349 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161340AbXDSHBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:01:25 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] bluetooth rfcomm: Convert to kthread API.
Date: Thu, 19 Apr 2007 00:55:49 -0600
Message-Id: <11769658043877-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

This patch starts krfcommd using kthread_run instead of a combination
of kernel_thread and daemonize making the code slightly simpler
and more maintainable.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/bluetooth/rfcomm/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 34f993a..baaad49 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -38,6 +38,7 @@
 #include <linux/net.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 #include <net/sock.h>
 #include <asm/uaccess.h>
@@ -1938,7 +1939,6 @@ static int rfcomm_run(void *unused)
 
 	atomic_inc(&running);
 
-	daemonize("krfcommd");
 	set_user_nice(current, -10);
 
 	BT_DBG("");
@@ -2058,7 +2058,7 @@ static int __init rfcomm_init(void)
 
 	hci_register_cb(&rfcomm_cb);
 
-	kernel_thread(rfcomm_run, NULL, CLONE_KERNEL);
+	kthread_run(rfcomm_run, NULL, "krfcommd");
 
 	if (class_create_file(bt_class, &class_attr_rfcomm_dlc) < 0)
 		BT_ERR("Failed to create RFCOMM info file");
-- 
1.5.0.g53756

