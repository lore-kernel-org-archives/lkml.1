Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbXCXV7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbXCXV7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 17:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXCXV7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 17:59:12 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:33007 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXCXV7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 17:59:10 -0400
To: akpm@linux-foundation.org
CC: dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Sat, 24 Mar 2007 22:55:29 +0100)
Subject: [patch 3/3] balance dirty pages from loop device
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HVEGF-0006d2-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 24 Mar 2007 22:58:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The function do_lo_send_aops() should call
balance_dirty_pages_ratelimited() after each page similarly to
generic_file_buffered_write().

Without this, writing the loop device directly (not through a
filesystem) is very slow, and also slows the whole system down,
because nr_dirty is constantly over the limit.

Beware: this patch without the fix to balance_dirty_pages() makes a
loopback mounted filesystem prone to deadlock.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/drivers/block/loop.c
===================================================================
--- linux.orig/drivers/block/loop.c	2007-03-24 21:00:40.000000000 +0100
+++ linux/drivers/block/loop.c	2007-03-24 22:07:06.000000000 +0100
@@ -275,6 +275,8 @@ static int do_lo_send_aops(struct loop_d
 		pos += size;
 		unlock_page(page);
 		page_cache_release(page);
+		balance_dirty_pages_ratelimited(mapping);
+		cond_resched();
 	}
 	ret = 0;
 out:
