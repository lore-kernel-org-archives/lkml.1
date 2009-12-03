Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZLCNvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZLCNvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbZLCNvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:51:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:52974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZLCNvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:51:06 -0500
Date: Thu, 3 Dec 2009 14:51:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Gunn <bgunn@solekai.com>
Subject: [RESEND] [PATCH] Bluetooth: implement raw output for hidp 
Message-ID: <alpine.LNX.2.00.0912031450400.3755@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implment raw output callback which is used by hidraw to send raw data to 
the underlying device.

Without this patch, the userspace hidraw-based applications can't send 
output reports to HID bluetooth devices.

Reported-and-tested-by: Brian Gunn <bgunn@solekai.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 
 net/bluetooth/hidp/core.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 49d8495..5697500 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -280,6 +280,13 @@ static int hidp_send_report(struct hidp_session *session, struct hid_report *rep
 	return hidp_queue_report(session, buf, rsize);
 }
 
+static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count)
+{
+	if (hidp_queue_report(hid->driver_data, data, count))
+		return -ENOMEM;
+	return count;
+}
+
 static void hidp_idle_timeout(unsigned long arg)
 {
 	struct hidp_session *session = (struct hidp_session *) arg;
@@ -785,6 +792,8 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->dev.parent = hidp_get_device(session);
 	hid->ll_driver = &hidp_hid_driver;
 
+	hid->hid_output_raw_report = hidp_output_raw_report;
+
 	err = hid_add_device(hid);
 	if (err < 0)
 		goto failed;
