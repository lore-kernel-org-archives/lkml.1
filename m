Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbZBISWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbZBISWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZBISW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:22:29 -0500
Received: from p02c12o148.mxlogic.net ([208.65.145.81]:39280 "EHLO
	p02c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbZBISW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:22:28 -0500
Message-ID: <4990743F.1070409@steeleye.com>
Date: Mon, 09 Feb 2009 13:21:51 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel list <linux-kernel@vger.kernel.org>,
       jnelson-kernel-bugzilla@jamponi.net
Subject: [PATCH 1/1] NBD: fix I/O hang on disconnected nbds
Content-Type: multipart/mixed;
 boundary="------------030208040506030309030302"
X-OriginalArrivalTime: 09 Feb 2009 18:21:51.0384 (UTC) FILETIME=[47382180:01C98AE3]
X-Spam: [F=0.2000000000; S=0.200(2009020301)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [207.43.68.209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030208040506030309030302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes a problem that causes I/O to a disconnected
(or partially initialized) nbd device to hang indefinitely. To reproduce:

# ioctl NBD_SET_SIZE_BLOCKS /dev/nbd23 514048
# dd if=/dev/nbd23 of=/dev/null bs=4096 count=1

...hangs...

This can also occur when an nbd device loses its nbd-client/server
connection. Although we clear the queue of any outstanding I/Os after 
the client/server connection fails, any additional I/Os that get queued 
later will hang.

This bug may also be the problem reported in this bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=12277

Testing would need to be performed to determine if the two issues are 
the same.

This problem was introduced by the new request handling thread code
("NBD: allow nbd to be used locally", 3/2008), which entered into 
mainline around 2.6.25.

The fix, which is fairly simple, is to restore the check for lo->sock
being NULL in do_nbd_request. This causes I/O to an uninitialized nbd to
immediately fail with an I/O error, as it did prior to the introduction 
of this bug.

--
Paul

--------------030208040506030309030302
Content-Type: text/x-diff;
 name="nbd-io-hang.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nbd-io-hang.diff"

This patch fixes a problem that causes I/O to a disconnected
(or partially initialized) nbd device to hang indefinitely. To reproduce:

# ioctl NBD_SET_SIZE_BLOCKS /dev/nbd23 514048
# dd if=/dev/nbd23 of=/dev/null bs=4096 count=1

...hangs...

This can also occur when an nbd device loses its nbd-client/server
connection. Although we clear the queue of any outstanding I/Os after the
client/server connection fails, any additional I/Os that get queued later
will hang.

This bug may also be the problem reported in this bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=12277

Testing would need to be performed to determine if the two issues are the same.

This problem was introduced by the new request handling thread code
("NBD: allow nbd to be used locally", 3/2008), which entered into
mainline around 2.6.25.

The fix, which is fairly simple, is to restore the check for lo->sock
being NULL in do_nbd_request. This causes I/O to an uninitialized nbd to
immediately fail with an I/O error, as it did prior to the introduction of
this bug.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---

 nbd.c |    9 +++++++++
 1 files changed, 9 insertions(+)

--- ./drivers/block/nbd.c.PRISTINE	2009-02-09 12:41:09.000000000 -0500
+++ ./drivers/block/nbd.c	2009-02-09 12:41:19.000000000 -0500
@@ -547,6 +547,15 @@ static void do_nbd_request(struct reques
 
 		BUG_ON(lo->magic != LO_MAGIC);
 
+		if (unlikely(!lo->sock)) {
+			printk(KERN_ERR "%s: Attempted send on closed socket\n",
+				lo->disk->disk_name);
+			req->errors++;
+			nbd_end_request(req);
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
 		spin_lock_irq(&lo->queue_lock);
 		list_add_tail(&req->queuelist, &lo->waiting_queue);
 		spin_unlock_irq(&lo->queue_lock);

--------------030208040506030309030302--
