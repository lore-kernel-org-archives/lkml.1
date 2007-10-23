Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbXJWL4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbXJWL4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 07:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXJWL40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 07:56:26 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36491 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751601AbXJWL4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 07:56:25 -0400
Message-ID: <393140585.27414@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 23 Oct 2007 19:56:20 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Mahoney <jeffm@suse.com>, reiserfs-dev@namesys.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] reiserfs: don't drop PG_dirty when releasing
	sub-page-sized dirty file
Message-ID: <20071023115620.GA5678@mail.ustc.edu.cn>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221258.11384.maximlevitsky@gmail.com> <393051953.24752@ustc.edu.cn> <200710221421.21439.maximlevitsky@gmail.com> <393126119.26275@ustc.edu.cn> <1193134027.7406.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193134027.7406.1.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 12:07:07PM +0200, Peter Zijlstra wrote:
> [ adding reiserfs devs to the CC ]

Thank you.

This fix is kind of crude - even when it fixed Maxim's problem, and
survived my stress testing of a lot of patching and kernel compiling.
I'd be glad to see better solutions.

Fengguang
---

reiserfs: don't drop PG_dirty when releasing sub-page-sized dirty file

This is not a new problem in 2.6.23-git17.
2.6.22/2.6.23 is buggy in the same way.

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

Cc: Maxim Levitsky <maximlevitsky@gmail.com>                                                                           
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/reiserfs/stree.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.24-git17.orig/fs/reiserfs/stree.c
+++ linux-2.6.24-git17/fs/reiserfs/stree.c
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

