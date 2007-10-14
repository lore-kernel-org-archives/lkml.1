Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXJNHZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXJNHZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 03:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXJNHZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 03:25:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXJNHZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 03:25:27 -0400
Date: Sun, 14 Oct 2007 09:25:23 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 1/2] hdaps: fix locking
Message-ID: <20071014072523.GB2766@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple of fixes for the hdaps driver. I have kind of been
blocking out the bug traces caused by these (the 2nd patch, actually)
thinking that it's one of those transient / churn things... but it's
getting annoying now because I think it turns off lockdep. After this
patch it no longer produces warnings, but I don't actually know if it
does the right thing (because I don't really know what the driver
does or how to test it anyway!).

---

hdaps was using incorrect mutex_trylock return code.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
Index: linux-2.6/drivers/hwmon/hdaps.c
===================================================================
--- linux-2.6.orig/drivers/hwmon/hdaps.c
+++ linux-2.6/drivers/hwmon/hdaps.c
@@ -328,22 +328,20 @@ static void hdaps_mousedev_poll(unsigned
 	int x, y;
 
 	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
-	if (mutex_trylock(&hdaps_mtx)) {
-		mod_timer(&hdaps_timer,jiffies + HDAPS_POLL_PERIOD);
-		return;
-	}
+	if (!mutex_trylock(&hdaps_mtx))
+		goto out;
 
 	if (__hdaps_read_pair(HDAPS_PORT_XPOS, HDAPS_PORT_YPOS, &x, &y))
-		goto out;
+		goto out_lock;
 
 	input_report_abs(hdaps_idev, ABS_X, x - rest_x);
 	input_report_abs(hdaps_idev, ABS_Y, y - rest_y);
 	input_sync(hdaps_idev);
 
-	mod_timer(&hdaps_timer, jiffies + HDAPS_POLL_PERIOD);
-
-out:
+out_lock:
 	mutex_unlock(&hdaps_mtx);
+out:
+	mod_timer(&hdaps_timer, jiffies + HDAPS_POLL_PERIOD);
 }
 
 
