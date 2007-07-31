Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbXGaSBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbXGaSBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbXGaSAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:00:54 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:4671 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762325AbXGaSAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:00:53 -0400
X-Greylist: delayed 2959 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 14:00:51 EDT
Subject: [PATCH] balance_dirty_pages - exit loop when no more pages
	available
From: richard kennedy <richard@rsk.demon.co.uk>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 31 Jul 2007 18:11:30 +0100
Message-Id: <1185901890.3133.33.camel@castor.rsk.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

exit loop in balance_dirty_pages when no more pages available to write

On a bdi that has very little traffic balance_dirty_pages can loop
needlessly waiting until do_writepages has written enough pages.

do_writepages will return encountered_congestion==0 && nr_to_write > 0 
when it has completed a pass but did not find enough pages available to
write. balance_dirty_pages ignores this and keeps looping until a total
of chunk pages was written. 

this patch adds an extra exit condition to break out of the loop in this
case. 

I've tested this on my amd64 desktop, and I also have a version of this
patch that includes a printk and a test case that occasionally does
trigger this condition.  

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

------
--- linux-2.6.22.1/mm/page-writeback.c.orig	2007-07-30 16:36:09.000000000 +0100
+++ linux-2.6.22.1/mm/page-writeback.c	2007-07-31 16:26:43.000000000 +0100
@@ -250,6 +250,8 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
+			if (!wbc.encountered_congestion && wbc.nr_to_write > 0)
+				break;	/* didn't find enough to do */
 		}
 		congestion_wait(WRITE, HZ/10);
 	}


