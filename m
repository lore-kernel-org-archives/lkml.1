Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655Ab0BERXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:23:51 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:36460 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932950Ab0BERXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:23:48 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Bastien Nocera <hadess@hadess.net>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn\, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<1264783166.29532.5302.camel@localhost.localdomain>
	<87iqakifm8.fsf@troilus.org>
	<1264860663.29532.7887.camel@localhost.localdomain>
	<871vh1gpaz.fsf_-_@troilus.org>
	<1265293390.31341.156.camel@localhost.localdomain>
Date: Fri, 05 Feb 2010 12:23:43 -0500
In-Reply-To: <1265293390.31341.156.camel@localhost.localdomain> (Marcel
	Holtmann's message of "Thu, 04 Feb 2010 06:23:10 -0800")
Message-ID: <87vdebfvfk.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann writes:

> looks good to me. I just prefer that you do the allocation of the report
> descriptor before the HID object:

An updated patch is below.  Sorry for the delay -- inclement weather
here got in the way of testing this as quickly as I would have liked.

>From e245ef87247f5e257db40c412af7991c9af375ab Mon Sep 17 00:00:00 2001
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 5 Feb 2010 12:21:38 -0500
Subject: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.

The report descriptor is read by user space (via the Service
Discovery Protocol), so it is only available during the ioctl
to connect.  However, the probe function that needs the
descriptor might not be called until a specific module is
loaded.  Keep a copy of the descriptor so it is available for
later use.

Signed-off-by: Michael Poole <mdpoole@troilus.org>
---
 net/bluetooth/hidp/core.c |   49 ++++++++++++++++++++++-----------------------
 net/bluetooth/hidp/hidp.h |    4 ++-
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index dde4c60..2928e44 100644
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
-
-	session->req = NULL;
 
-	return 0;
+	return hid_parse_report(session->hid, session->rd_data,
+			session->rd_size);
 }
 
 static int hidp_start(struct hid_device *hid)
@@ -793,12 +773,24 @@ static int hidp_setup_hid(struct hidp_session *session,
 	bdaddr_t src, dst;
 	int err;
 
+	session->rd_data = kzalloc(req->rd_size, GFP_KERNEL);
+	if (!session->rd_data)
+		return -ENOMEM;
+
+	if (copy_from_user(session->rd_data, req->rd_data, req->rd_size)) {
+		err = -EFAULT;
+		goto fault;
+	}
+	session->rd_size = req->rd_size;
+
 	hid = hid_allocate_device();
-	if (IS_ERR(hid))
-		return PTR_ERR(hid);
+	if (IS_ERR(hid)) {
+		err = PTR_ERR(hid);
+		goto fault;
+	}
 
 	session->hid = hid;
-	session->req = req;
+
 	hid->driver_data = session;
 
 	baswap(&src, &bt_sk(session->ctrl_sock->sk)->src);
@@ -829,6 +821,10 @@ failed:
 	hid_destroy_device(hid);
 	session->hid = NULL;
 
+fault:
+	kfree(session->rd_data);
+	session->rd_data = NULL;
+
 	return err;
 }
 
@@ -923,6 +919,9 @@ unlink:
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

