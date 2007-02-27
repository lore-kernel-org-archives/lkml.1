Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbXB0XRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbXB0XRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXB0XRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:17:14 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:50857 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXB0XQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:16:43 -0500
Message-Id: <20070227231556.920277549@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:47 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 05/22] balance dirty pages from loop device
Content-Disposition: inline; filename=loopback_dirty_fix.patch
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
--- linux.orig/drivers/block/loop.c	2007-02-27 14:40:55.000000000 +0100
+++ linux/drivers/block/loop.c	2007-02-27 14:41:08.000000000 +0100
@@ -275,6 +275,8 @@ static int do_lo_send_aops(struct loop_d
 		pos += size;
 		unlock_page(page);
 		page_cache_release(page);
+		balance_dirty_pages_ratelimited(mapping);
+		cond_resched();
 	}
 	ret = 0;
 out:

--
