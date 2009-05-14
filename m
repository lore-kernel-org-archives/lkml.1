Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbZENXGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbZENXGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762266AbZENW6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:38 -0400
Received: from kroah.org ([198.145.64.141]:46019 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761634AbZENW6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:38 2009
Message-Id: <20090514225237.984186930@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-fsdevel@vger.kernel.org,
       linux-mm@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [patch 10/28] fs: fix page_mkwrite error cases in core code and btrfs
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 56a76f8275c379ed73c8a43cfa1dfa2f5e9cfa19 upstream


fs: fix page_mkwrite error cases in core code and btrfs

page_mkwrite is called with neither the page lock nor the ptl held.  This
means a page can be concurrently truncated or invalidated out from
underneath it.  Callers are supposed to prevent truncate races themselves,
however previously the only thing they can do in case they hit one is to
raise a SIGBUS.  A sigbus is wrong for the case that the page has been
invalidated or truncated within i_size (eg.  hole punched).  Callers may
also have to perform memory allocations in this path, where again, SIGBUS
would be wrong.

The previous patch ("mm: page_mkwrite change prototype to match fault")
made it possible to properly specify errors.  Convert the generic buffer.c
code and btrfs to return sane error values (in the case of page removed
from pagecache, VM_FAULT_NOPAGE will cause the fault handler to exit
without doing anything, and the fault will be retried properly).

This fixes core code, and converts btrfs as a template/example.  All other
filesystems defining their own page_mkwrite should be fixed in a similar
manner.

Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/buffer.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2409,7 +2409,7 @@ block_page_mkwrite(struct vm_area_struct
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long end;
 	loff_t size;
-	int ret = -EINVAL;
+	int ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
 
 	lock_page(page);
 	size = i_size_read(inode);
@@ -2429,10 +2429,14 @@ block_page_mkwrite(struct vm_area_struct
 	if (!ret)
 		ret = block_commit_write(page, 0, end);
 
-out_unlock:
-	if (ret)
-		ret = VM_FAULT_SIGBUS;
+	if (unlikely(ret)) {
+		if (ret == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else /* -ENOSPC, -EIO, etc */
+			ret = VM_FAULT_SIGBUS;
+	}
 
+out_unlock:
 	unlock_page(page);
 	return ret;
 }


