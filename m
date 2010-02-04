Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab0BDM0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 07:26:17 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43426 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757910Ab0BDM0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 07:26:16 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Marcel Holtmann <marcel@holtmann.org>, Bastien Nocera <hadess@hadess.net>
Cc: Jiri Kosina <jkosina@suse.cz>, "Gunn\, Brian" <bgunn@solekai.com>,
       Ping <pinglinux@gmail.com>, linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<1264783166.29532.5302.camel@localhost.localdomain>
	<87iqakifm8.fsf@troilus.org>
	<1264860663.29532.7887.camel@localhost.localdomain>
Date: Thu, 04 Feb 2010 07:26:12 -0500
In-Reply-To: <1264860663.29532.7887.camel@localhost.localdomain> (Bastien
	Nocera's message of "Sat, 30 Jan 2010 14:11:03 +0000")
Message-ID: <871vh1gpaz.fsf_-_@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien and Marcel,

This patch works for me.  Bastien, does it also fix it for you?

Michael Poole

>From f8aeb64ac2d42f5fae080c00a287fdbd8304ffa2 Mon Sep 17 00:00:00 2001
From: Michael Poole <mdpoole@troilus.org>
Date: Wed, 3 Feb 2010 21:49:48 -0500
Subject: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.

The report descriptor is read by user space (via the Service
Discovery Protocol), so it is only available during the ioctl
to connect.  However, the probe function that needs the
descriptor might not be called until a specific module is
loaded.  Keep a copy of the descriptor so it is available for
later use.

Signed-off-by: Michael Poole <mdpoole@troilus.org>
---
 net/bluetooth/hidp/core.c |   42 +++++++++++++++++++-----------------------
 net/bluetooth/hidp/hidp.h |    4 +++-
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index dde4c60..af4a448 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -701,29 +701,9 @@ static void hidp_close(struct hid_device *hid)
 static int hidp_parse(struct hid_device *hid)
 {
 	struct hidp_session *session = hid->driver_data;
-	struct hidp_connadd_req *req = session->req;
-	unsigned char *buf;
-	int ret;
-
-	buf = kmalloc(req->rd_size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, req->rd_data, req->rd_size)) {
-		kfree(buf);
-		return -EFAULT;
-	}
-
-	ret = hid_parse_report(session->hid, buf, req->rd_size);
-
-	kfree(buf);
-
-	if (ret)
-		return ret;
 
-	session->req = NULL;
-
-	return 0;
+	return hid_parse_report(session->hid, session->rd_data,
+			session->rd_size);
 }
 
 static int hidp_start(struct hid_device *hid)
@@ -798,7 +778,17 @@ static int hidp_setup_hid(struct hidp_session *session,
 		return PTR_ERR(hid);
 
 	session->hid = hid;
-	session->req = req;
+	session->rd_size = req->rd_size;
+	session->rd_data = kzalloc(session->rd_size, GFP_KERNEL);
+	if (!session->rd_data) {
+		err = -ENOMEM;
+		goto failed;
+	}
+	if (copy_from_user(session->rd_data, req->rd_data, session->rd_size)) {
+		err = -EFAULT;
+		goto failed;
+	}
+
 	hid->driver_data = session;
 
 	baswap(&src, &bt_sk(session->ctrl_sock->sk)->src);
@@ -829,6 +819,9 @@ failed:
 	hid_destroy_device(hid);
 	session->hid = NULL;
 
+	kfree(session->rd_data);
+	session->rd_data = NULL;
+
 	return err;
 }
 
@@ -923,6 +916,9 @@ unlink:
 		session->hid = NULL;
 	}
 
+	kfree(session->rd_data);
+	session->rd_data = NULL;
+
 purge:
 	skb_queue_purge(&session->ctrl_transmit);
 	skb_queue_purge(&session->intr_transmit);
diff --git a/net/bluetooth/hidp/hidp.h b/net/bluetooth/hidp/hidp.h
index faf3d74..a4e215d 100644
--- a/net/bluetooth/hidp/hidp.h
+++ b/net/bluetooth/hidp/hidp.h
@@ -154,7 +154,9 @@ struct hidp_session {
 	struct sk_buff_head ctrl_transmit;
 	struct sk_buff_head intr_transmit;
 
-	struct hidp_connadd_req *req;
+	/* Report descriptor */
+	__u8 *rd_data;
+	uint rd_size;
 };
 
 static inline void hidp_schedule(struct hidp_session *session)
-- 
1.6.5.6
