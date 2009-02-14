Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbZBNB23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbZBNB23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763335AbZBNBQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:01 -0500
Received: from kroah.org ([198.145.64.141]:50137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763261AbZBNBQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:00 -0500
Date: Fri, 13 Feb 2009 17:12:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paul Clements <paul.clements@steeleye.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: [patch 02/48] nbd: fix I/O hang on disconnected nbds
Message-ID: <20090214011223.GC17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nbd-fix-i-o-hang-on-disconnected-nbds.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Clements <paul.clements@steeleye.com>

commit 4d48a542b42747c36a5937447d9c3de7c897ea50 upstream.

Fix a problem that causes I/O to a disconnected (or partially initialized)
nbd device to hang indefinitely.  To reproduce:

# ioctl NBD_SET_SIZE_BLOCKS /dev/nbd23 514048
# dd if=/dev/nbd23 of=/dev/null bs=4096 count=1

...hangs...

This can also occur when an nbd device loses its nbd-client/server
connection.  Although we clear the queue of any outstanding I/Os after the
client/server connection fails, any additional I/Os that get queued later
will hang.

This bug may also be the problem reported in this bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=12277

Testing would need to be performed to determine if the two issues are the
same.

This problem was introduced by the new request handling thread code ("NBD:
allow nbd to be used locally", 3/2008), which entered into mainline around
2.6.25.

The fix, which is fairly simple, is to restore the check for lo->sock
being NULL in do_nbd_request.  This causes I/O to an uninitialized nbd to
immediately fail with an I/O error, as it did prior to the introduction of
this bug.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Reported-by: Jon Nelson <jnelson-kernel-bugzilla@jamponi.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/nbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -549,6 +549,15 @@ static void do_nbd_request(struct reques
 
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

