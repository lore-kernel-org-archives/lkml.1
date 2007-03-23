Return-Path: <linux-kernel-owner+w=401wt.eu-S934250AbXCWAvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250AbXCWAvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934251AbXCWAvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:51:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22645 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934250AbXCWAvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:51:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=WHAVnSjL72zMU3qYdPPUp0bqKGTze61ERXbuTI7ZALnuEyLZnu5VNoSj8ZQBBM0H2
	2S4SCSW2SpX74/X7SyZuQ==
Message-ID: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
Date: Thu, 22 Mar 2007 17:51:11 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] cache pipe buf page address for non-highmem arch
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is really sad that we always call kmap and friends for every pipe
buffer page on 64-bit arch that doesn't use HIGHMEM, or on
configuration that doesn't turn on HIGHMEM.

The effect of calling kmap* is visible in the execution profile when
pipe code is being stressed.  It is especially true on amd's x86-64
platform where kmap() has to traverse through numa node index
calculation in order to convert struct page * to kernel virtual
address.  It is fairly pointless to perform that calculation repeatly
on system with no highmem (i.e., 64-bit arch like x86-64).  This patch
caches kernel pipe buffer page's kernel vaddr to speed up pipe buffer
mapping functions.

There is another suboptimal block in pipe_read() where wake_up is
called twice.  I think it was an oversight since in pipe_write(), it
looks like it is doing the right thing.

Signed-off-by: Ken Chen <kenchen@google.com>


--- linus-2.6.git/fs/pipe.c.orig	2007-03-01 12:41:06.000000000 -0800
+++ linus-2.6.git/fs/pipe.c	2007-03-22 16:28:03.000000000 -0700
@@ -20,6 +20,22 @@

 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
+#include <asm/kmap_types.h>
+
+#ifdef CONFIG_HIGHMEM
+#define pipe_kmap		kmap
+#define pipe_kmap_atomic	kmap_atomic
+#else	/* CONFIG_HIGHMEM */
+static inline void *pipe_kmap(struct page *page)
+{
+	return (void *) page->private;
+}
+static inline void *pipe_kmap_atomic(struct page *page, enum km_type type)
+{
+	pagefault_disable();
+	return pipe_kmap(page);
+}
+#endif

 /*
  * We use a start+len construction, which provides full use of the
@@ -169,10 +185,10 @@ void *generic_pipe_buf_map(struct pipe_i
 {
 	if (atomic) {
 		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
-		return kmap_atomic(buf->page, KM_USER0);
+		return pipe_kmap_atomic(buf->page, KM_USER0);
 	}

-	return kmap(buf->page);
+	return pipe_kmap(buf->page);
 }

 void generic_pipe_buf_unmap(struct pipe_inode_info *pipe,
@@ -316,6 +332,7 @@ redo:
 		if (do_wakeup) {
 			wake_up_interruptible_sync(&pipe->wait);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+			do_wakeup = 0;
 		}
 		pipe_wait(pipe);
 	}
@@ -423,6 +440,8 @@ redo1:
 					ret = ret ? : -ENOMEM;
 					break;
 				}
+				page->private = (unsigned long)
+							page_address(page);
 				pipe->tmp_page = page;
 			}
 			/* Always wake up, even if the copy fails. Otherwise
@@ -438,9 +457,9 @@ redo1:
 			iov_fault_in_pages_read(iov, chars);
 redo2:
 			if (atomic)
-				src = kmap_atomic(page, KM_USER0);
+				src = pipe_kmap_atomic(page, KM_USER0);
 			else
-				src = kmap(page);
+				src = pipe_kmap(page);

 			error = pipe_iov_copy_from_user(src, iov, chars,
 							atomic);
