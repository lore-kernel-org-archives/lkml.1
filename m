Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYAOMtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYAOMtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYAOMsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:21 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47880 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751340AbYAOMsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:07 -0500
Message-ID: <400401290.17576@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124758.559626681@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:39 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] writeback: clear PAGECACHE_TAG_DIRTY for truncated page in block_write_full_page()
Content-Disposition: inline; filename=ext2-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `truncated' page in block_write_full_page() may stick for a long time.
E.g. ext2_rmdir() will set i_size to 0, and then the dir inode may hang around
because of being referenced by someone.

So clear PAGECACHE_TAG_DIRTY to prevent pdflush from retrying and iowaiting on
it.

Tested-by: Joerg Platte <jplatte@naasa.net>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
fs/buffer.c |    2 ++
 1 files changed, 2 insertions(+)

Index: linux/fs/buffer.c
===================================================================
--- linux.orig/fs/buffer.c
+++ linux/fs/buffer.c
@@ -2820,7 +2820,9 @@ int block_write_full_page(struct page *p
 		 * freeable here, so the page does not leak.
 		 */
 		do_invalidatepage(page, 0);
+		set_page_writeback(page);
 		unlock_page(page);
+		end_page_writeback(page);
 		return 0; /* don't care */
 	}
 

-- 
