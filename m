Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXCFSIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXCFSIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965968AbXCFSID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:08:03 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:39606 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965461AbXCFSGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:06:17 -0500
Message-Id: <20070306180554.927768351@szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 Mar 2007 19:04:49 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 6/8] balance dirty pages from loop device
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
