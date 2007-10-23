Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbXJWKSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbXJWKSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXJWKSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:18:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:26557 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbXJWKSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=F9oZj2fRuhqOG7V9cMDY6vJY/fJyZxZB7ny1ddOqtBMjagz48fOSb54f0oaSRBDjOEEKU+0EpiZ6s1sL/qdLdMgBnZkZmNwzXcLfRuCkS/968ExDpw/8cwF8qN3X8GHy0ZHVxeyf5zt9hykLPkrnP7uUNiPy4b2Nx0nfONVuMPo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH] reiserfs: don't drop PG_dirty when releasing sub-page-sized dirty file
Date: Tue, 23 Oct 2007 12:17:51 +0200
User-Agent: KMail/1.9.6
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221421.21439.maximlevitsky@gmail.com> <393126119.26275@ustc.edu.cn>
In-Reply-To: <393126119.26275@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710231217.52147.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007 09:55:14 Fengguang Wu wrote:
> This is not a new problem in 2.6.23-git17.
> 2.6.22/2.6.23 is buggy in the same way.
> 
> Reiserfs could leave newly created sub-page-size files in dirty state
> for ever.  They cannot be synced to disk by pdflush routines or
> explicit `sync' commands.  Only `umount' can do the trick.
> 
> The direct cause is: the dirty page's PG_dirty is wrongly _cleared_.
> Call trace:
> 	 [<ffffffff8027e920>] cancel_dirty_page+0xd0/0xf0
> 	 [<ffffffff8816d470>] :reiserfs:reiserfs_cut_from_item+0x660/0x710
> 	 [<ffffffff8816d791>] :reiserfs:reiserfs_do_truncate+0x271/0x530
> 	 [<ffffffff8815872d>] :reiserfs:reiserfs_truncate_file+0xfd/0x3b0
> 	 [<ffffffff8815d3d0>] :reiserfs:reiserfs_file_release+0x1e0/0x340
> 	 [<ffffffff802a187c>] __fput+0xcc/0x1b0
> 	 [<ffffffff802a1ba6>] fput+0x16/0x20
> 	 [<ffffffff8029e676>] filp_close+0x56/0x90
> 	 [<ffffffff8029fe0d>] sys_close+0xad/0x110
> 	 [<ffffffff8020c41e>] system_call+0x7e/0x83
> 
> Fix the bug by removing the cancel_dirty_page() call. Tests show that
> it causes no bad behaviors on various write sizes.
> 
> 
> === for the patient ===
> Here are more detailed demonstrations of the problem.
> 
> 1) the page has both PG_dirty(D)/PAGECACHE_TAG_DIRTY(d) after being written to;
>    and then only PAGECACHE_TAG_DIRTY(d) remains after the file is closed.
> 
> ------------------------------ screen 0 ------------------------------
> [T0] root /home/wfg# cat > /test/tiny
> [T1] hi
> [T2] root /home/wfg#
> 
> ------------------------------ screen 1 ------------------------------
> [T1] root /home/wfg# echo /test/tiny > /proc/filecache
> [T1] root /home/wfg# cat /proc/filecache
>      # file /test/tiny
>      # flags R:referenced A:active M:mmap U:uptodate D:dirty W:writeback O:owner B:buffer d:dirty w:writeback
>      # idx   len     state   refcnt
>      0       1       ___UD__Bd_      2
> [T2] root /home/wfg# cat /proc/filecache
>      # file /test/tiny
>      # flags R:referenced A:active M:mmap U:uptodate D:dirty W:writeback O:owner B:buffer d:dirty w:writeback
>      # idx   len     state   refcnt
>      0       1       ___U___Bd_      2
> 
> 2) note the non-zero 'cancelled_write_bytes' after /tmp/hi is copied.
> 
> ------------------------------ screen 0 ------------------------------
> [T0] root /home/wfg# echo hi > /tmp/hi
> [T1] root /home/wfg# cp /tmp/hi /dev/stdin /test
> [T2] hi
> [T3] root /home/wfg#
> 
> ------------------------------ screen 1 ------------------------------
> [T1] root /proc/4397# cd /proc/`pidof cp`
> [T1] root /proc/4713# cat io
>      rchar: 8396
>      wchar: 3
>      syscr: 20
>      syscw: 1
>      read_bytes: 0
>      write_bytes: 20480
>      cancelled_write_bytes: 4096
> [T2] root /proc/4713# cat io
>      rchar: 8399
>      wchar: 6
>      syscr: 21
>      syscw: 2
>      read_bytes: 0
>      write_bytes: 24576
>      cancelled_write_bytes: 4096
> 
> //Question: the 'write_bytes' is a bit more than expected ;-)
> 
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>                                                                           
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  fs/reiserfs/stree.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- linux-2.6.24-git17.orig/fs/reiserfs/stree.c
> +++ linux-2.6.24-git17/fs/reiserfs/stree.c
> @@ -1458,9 +1458,6 @@ static void unmap_buffers(struct page *p
>  				}
>  				bh = next;
>  			} while (bh != head);
> -			if (PAGE_SIZE == bh->b_size) {
> -				cancel_dirty_page(page, PAGE_CACHE_SIZE);
> -			}
>  		}
>  	}
>  }
> 
> 

One thing to say... Works perfectly!
Big thanks for fixing that bug.


Best regards,
	Maxim Levitsky
