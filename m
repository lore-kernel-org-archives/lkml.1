Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZBJTW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZBJTW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbZBJTE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:29 -0500
Received: from kroah.org ([198.145.64.141]:34037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754654AbZBJTEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:25 -0500
Date: Tue, 10 Feb 2009 11:01:39 -0800
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
       alan@lxorguk.ukuu.org.uk, Pavel Machek <pavel@suse.cz>,
       Paul Clements <paul.clements@steeleye.com>
Subject: [patch 52/53] nbd: do not allow two clients at the same time
Message-ID: <20090210190139.GA14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nbd-do-not-allow-two-clients-at-the-same-time.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Pavel Machek <pavel@suse.cz>

commit c91192d66d6cea7878b8542c9d9f1873971aba92 upstream.

Two nbd-clients at same time are bad idea, and cause WARN_ON from nbd in
2.6.28-rc7 from sysfs_add_one.  This simply prevents that from happening.

To reproduce:

 cat /dev/zero | head -c 10000000 > /tmp/delme.fstest.fs
 nbd-server 9100 -l /anyone.can.connect > /tmp/delme.fstest.fs &
 sleep 1
 nbd-client localhost 9100 /dev/nd0 &
 nbd-client localhost 9100 /dev/nd0 &

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/nbd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -406,6 +406,7 @@ static int nbd_do_it(struct nbd_device *
 	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
 	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		lo->pid = 0;
 		return ret;
 	}
 
@@ -413,6 +414,7 @@ static int nbd_do_it(struct nbd_device *
 		nbd_end_request(req);
 
 	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	lo->pid = 0;
 	return 0;
 }
 
@@ -648,6 +650,8 @@ static int nbd_ioctl(struct block_device
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
 	case NBD_DO_IT:
+		if (lo->pid)
+			return -EBUSY;
 		if (!lo->file)
 			return -EINVAL;
 		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);

