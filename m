Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbXKTS3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbXKTS3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758695AbXKTS0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60254 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761473AbXKTS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:32 -0500
Date: Tue, 20 Nov 2007 10:23:34 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, maximlevitsky@gmail.com, peterz@infradead.org,
       jeffm@suse.com, wfg@mail.ustc.edu.cn, chris.mason@oracle.com
Subject: [patch 11/29] reiserfs: dont drop PG_dirty when releasing
	sub-page-sized dirty file
Message-ID: <20071120182334.GL28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="reiserfs-don-t-drop-pg_dirty-when-releasing-sub-page-sized-dirty-file.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

patch c06a018fa5362fa9ed0768bd747c0fab26bc8849 in mainline.

This is not a new problem in 2.6.23-git17.  2.6.22/2.6.23 is buggy in the
same way.

Reiserfs could accumulate dirty sub-page-size files until umount time. 
They cannot be synced to disk by pdflush routines or explicit `sync'
commands.  Only `umount' can do the trick.

The direct cause is: the dirty page's PG_dirty is wrongly _cleared_.
Call trace:
	 [<ffffffff8027e920>] cancel_dirty_page+0xd0/0xf0
	 [<ffffffff8816d470>] :reiserfs:reiserfs_cut_from_item+0x660/0x710
	 [<ffffffff8816d791>] :reiserfs:reiserfs_do_truncate+0x271/0x530
	 [<ffffffff8815872d>] :reiserfs:reiserfs_truncate_file+0xfd/0x3b0
	 [<ffffffff8815d3d0>] :reiserfs:reiserfs_file_release+0x1e0/0x340
	 [<ffffffff802a187c>] __fput+0xcc/0x1b0
	 [<ffffffff802a1ba6>] fput+0x16/0x20
	 [<ffffffff8029e676>] filp_close+0x56/0x90
	 [<ffffffff8029fe0d>] sys_close+0xad/0x110
	 [<ffffffff8020c41e>] system_call+0x7e/0x83

Fix the bug by removing the cancel_dirty_page() call. Tests show that
it causes no bad behaviors on various write sizes.

=== for the patient ===
Here are more detailed demonstrations of the problem.

1) the page has both PG_dirty(D)/PAGECACHE_TAG_DIRTY(d) after being written to;
   and then only PAGECACHE_TAG_DIRTY(d) remains after the file is closed.

------------------------------ screen 0 ------------------------------
[T0] root /home/wfg# cat > /test/tiny
[T1] hi
[T2] root /home/wfg#

------------------------------ screen 1 ------------------------------
[T1] root /home/wfg# echo /test/tiny > /proc/filecache
[T1] root /home/wfg# cat /proc/filecache
     # file /test/tiny
     # flags R:referenced A:active M:mmap U:uptodate D:dirty W:writeback O:owner B:buffer d:dirty w:writeback
     # idx   len     state   refcnt
     0       1       ___UD__Bd_      2
[T2] root /home/wfg# cat /proc/filecache
     # file /test/tiny
     # flags R:referenced A:active M:mmap U:uptodate D:dirty W:writeback O:owner B:buffer d:dirty w:writeback
     # idx   len     state   refcnt
     0       1       ___U___Bd_      2

2) note the non-zero 'cancelled_write_bytes' after /tmp/hi is copied.

------------------------------ screen 0 ------------------------------
[T0] root /home/wfg# echo hi > /tmp/hi
[T1] root /home/wfg# cp /tmp/hi /dev/stdin /test
[T2] hi
[T3] root /home/wfg#

------------------------------ screen 1 ------------------------------
[T1] root /proc/4397# cd /proc/`pidof cp`
[T1] root /proc/4713# cat io
     rchar: 8396
     wchar: 3
     syscr: 20
     syscw: 1
     read_bytes: 0
     write_bytes: 20480
     cancelled_write_bytes: 4096
[T2] root /proc/4713# cat io
     rchar: 8399
     wchar: 6
     syscr: 21
     syscw: 2
     read_bytes: 0
     write_bytes: 24576
     cancelled_write_bytes: 4096

//Question: the 'write_bytes' is a bit more than expected ;-)

Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Reviewed-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/stree.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1458,9 +1458,6 @@ static void unmap_buffers(struct page *p
 				}
 				bh = next;
 			} while (bh != head);
-			if (PAGE_SIZE == bh->b_size) {
-				cancel_dirty_page(page, PAGE_CACHE_SIZE);
-			}
 		}
 	}
 }

-- 
