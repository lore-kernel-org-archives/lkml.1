Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZALLCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZALLCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZALLBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:01:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41720 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZALLBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:01:53 -0500
Date: Mon, 12 Jan 2009 12:04:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Paul.Clements@steeleye.com,
       Andrew Morton <akpm@osdl.org>
Subject: do not allow two nbd-clients at same time
Message-ID: <20090112110322.GA2001@elf.ucw.cz>
References: <20081208213542.GA10134@elf.ucw.cz> <20081208225758.GA2872@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208225758.GA2872@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two nbd-clients at same time are bad idea, and cause WARN_ON from nbd
in 2.6.28-rc7 from sysfs_add_one. This simply prevents that from
happening.

To reproduce:

 cat /dev/zero | head -c 10000000 > /tmp/delme.fstest.fs
 nbd-server 9100 -l /anyone.can.connect > /tmp/delme.fstest.fs &
 sleep 1
 nbd-client localhost 9100 /dev/nd0 &
 nbd-client localhost 9100 /dev/nd0 &

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 78e22d7..0da741e 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -413,6 +410,7 @@ static int nbd_do_it(struct nbd_device *
 		nbd_end_request(req);
 
 	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	lo->pid = 0;
 	return 0;
 }
 
@@ -627,5 +626,7 @@ static int nbd_ioctl(struct block_device
 		return 0;
 	case NBD_DO_IT:
+		if (lo->pid)
+			return -EBUSY;
 		if (!lo->file)
 			return -EINVAL;
 		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
