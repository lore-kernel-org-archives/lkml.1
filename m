Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZAXIXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZAXIXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 03:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZAXIWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 03:22:55 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:57297 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZAXIWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 03:22:54 -0500
X-IronPort-AV: E=Sophos;i="4.37,317,1231131600"; 
   d="scan'208";a="37026804"
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] xen: unitialised return value in xenbus_write_transaction
X-Mercurial-Node: 03f51a1eb4a7e77d6488bc661bc47a020243b4f9
Message-Id: <03f51a1eb4a7e77d6488.1232785367@localhost.localdomain>
Date: Sat, 24 Jan 2009 08:22:47 +0000
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Adam Wendt <thelsdj@gmail.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
X-OriginalArrivalTime: 24 Jan 2009 08:22:53.0408 (UTC) FILETIME=[F3E82E00:01C97DFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of xenbus_write_transaction can be uninitialised in
the success case leading to the userspace xenstore utilities failing.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Adam Wendt <thelsdj@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 drivers/xen/xenfs/xenbus.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -r 7c66d3ac6805 -r 03f51a1eb4a7 drivers/xen/xenfs/xenbus.c
--- a/drivers/xen/xenfs/xenbus.c	Fri Jan 23 16:42:41 2009 +0000
+++ b/drivers/xen/xenfs/xenbus.c	Fri Jan 23 16:42:41 2009 +0000
@@ -291,7 +291,7 @@
 static int xenbus_write_transaction(unsigned msg_type,
 				    struct xenbus_file_priv *u)
 {
-	int rc, ret;
+	int rc;
 	void *reply;
 	struct xenbus_transaction_holder *trans = NULL;
 	LIST_HEAD(staging_q);
@@ -326,15 +326,14 @@
 	}
 
 	mutex_lock(&u->reply_mutex);
-	ret = queue_reply(&staging_q, &u->u.msg, sizeof(u->u.msg));
-	if (!ret)
-		ret = queue_reply(&staging_q, reply, u->u.msg.len);
-	if (!ret) {
+	rc = queue_reply(&staging_q, &u->u.msg, sizeof(u->u.msg));
+	if (!rc)
+		rc = queue_reply(&staging_q, reply, u->u.msg.len);
+	if (!rc) {
 		list_splice_tail(&staging_q, &u->read_buffers);
 		wake_up(&u->read_waitq);
 	} else {
 		queue_cleanup(&staging_q);
-		rc = ret;
 	}
 	mutex_unlock(&u->reply_mutex);
 
