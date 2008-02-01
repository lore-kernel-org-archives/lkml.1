Return-Path: <linux-kernel-owner+w=401wt.eu-S1762055AbYBAMTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055AbYBAMTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbYBAMS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:18:57 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33740 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755810AbYBAMS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:18:56 -0500
Message-ID: <401868346.26085@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 1 Feb 2008 20:18:47 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] clear PAGECACHE_TAG_DIRTY for truncated pages
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JKur1-0001Dh-Ol@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `truncated' page in block_write_full_page()/nobh_writepage() may
stick for a long time.  For example, ext2_rmdir() will set i_size to
0, and then the dir inode and its pages may hang around because of
being referenced by some process.

To produce this situation:

In terminal 1:
                $ mkdir hi; cd hi
                $ sleep 1h; cd ..
In terminal 2:
                $ rmdir hi

The dir 'hi' is deleted in terminal 2 while still being referenced by
the shell(as working dir) in terminal 1.  The deleted inode 'hi' with
its dirty-and-truncated page will stay for 1 hour, during which the
pdflush will retry the page _at least_ once every 5s.

So clear PAGECACHE_TAG_DIRTY to prevent pdflush from retrying on it.

Tested-by: Joerg Platte <jplatte@naasa.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/buffer.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

--- linux-mm.orig/fs/buffer.c
+++ linux-mm/fs/buffer.c
@@ -2631,7 +2631,13 @@ int nobh_writepage(struct page *page, ge
 		if (page->mapping->a_ops->invalidatepage)
 			page->mapping->a_ops->invalidatepage(page, offset);
 #endif
+		/*
+		 * Clear PAGECACHE_TAG_DIRTY to stop pdflush from retrying.
+		 * Read block_write_full_page() for more details.
+		 */
+		set_page_writeback(page);
 		unlock_page(page);
+		end_page_writeback(page);
 		return 0; /* don't care */
 	}
 
@@ -2826,7 +2832,17 @@ int block_write_full_page(struct page *p
 		 * freeable here, so the page does not leak.
 		 */
 		do_invalidatepage(page, 0);
+		/*
+		 * Clear PAGECACHE_TAG_DIRTY to stop pdflush from retrying.
+		 *
+		 * Some truncated pages may hang around for long time.
+		 * For example, ext2_rmdir() will set i_size to 0, and then
+		 * keep the pages as long as the dir is still referenced(as
+		 * the working dir of some process).
+		 */
+		set_page_writeback(page);
 		unlock_page(page);
+		end_page_writeback(page);
 		return 0; /* don't care */
 	}
 

