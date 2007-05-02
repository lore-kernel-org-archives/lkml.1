Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXEBPqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXEBPqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXEBPqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:46:35 -0400
Received: from newmail.sw.starentnetworks.com ([12.33.234.78]:33150 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbXEBPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:46:34 -0400
X-Greylist: delayed 1768 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 11:46:34 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17976.43884.191895.235227@zeus.sw.starentnetworks.com>
Date: Wed, 2 May 2007 11:17:00 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: linux-kernel@vger.kernel.org
Subject: do_tty_write() can block even with O_NONBLOCK?
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have two processes with the same tty open, one opens blocking and
one opens nonblocking.

If the blocking process blocks doing a write (due to flow control,
just going to fast, etc...) the nonblocking process will also block
when it writes until the blocking process unblocks.

This seems to occur because do_tty_write() isn't checking for
O_NONBLOCK when taking the tty's write mutex.


Signed-off-by: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>

===== drivers/char/tty_io.c 1.237 vs edited =====
--- 1.237/drivers/char/tty_io.c	2007-03-18 16:40:06 -04:00
+++ edited/drivers/char/tty_io.c	2007-05-01 10:53:27 -04:00
@@ -1690,9 +1690,13 @@
 	ssize_t ret = 0, written = 0;
 	unsigned int chunk;
 	
-	/* FIXME: O_NDELAY ... */
-	if (mutex_lock_interruptible(&tty->atomic_write_lock)) {
-		return -ERESTARTSYS;
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&tty->atomic_write_lock))
+			return -EAGAIN;
+	}
+	else {
+		if (mutex_lock_interruptible(&tty->atomic_write_lock))
+			return -ERESTARTSYS;
 	}
 
 	/*

