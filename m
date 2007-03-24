Return-Path: <linux-kernel-owner+w=401wt.eu-S2992644AbXCXAsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992644AbXCXAsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992646AbXCXAsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:48:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992644AbXCXAsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:48:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fzf+rFJhJfA9mWBFkE0Qt7eVZTH0sTKEs05xEtirdUTq6YlAri0h9imIGJqAFe5nZ
	2734Tar6AvglTn0erclkg==
Message-ID: <b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com>
Date: Fri, 23 Mar 2007 17:48:29 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070322170122.ee2589a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
	 <20070322170122.ee2589a1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> If we're going to do this then we should also implement pipe_kunmap_atomic().
> Relying upon kunmap_atomic() internals like this is weird-looking, and is fragile
> against future changes to kunmap_atomic().

OK, I added the matching pipe_kunmap variants.  Now that we have the
matching pair, I made further optimization to make both pipe_kmap and
pipe_kmap_atomic the same because pipe_kmap does not hold any critical
resource that can't sleep.  There is no reason to make them different.

Full patch and changelog:


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

diff --git a/fs/pipe.c b/fs/pipe.c
index ebafde7..4cd1d68 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -21,6 +21,21 @@ #include <linux/audit.h>
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>

+#ifdef CONFIG_HIGHMEM
+#define pipe_kmap		kmap
+#define pipe_kmap_atomic	kmap_atomic
+#define pipe_kunmap		kunmap
+#define pipe_kunmap_atomic	kunmap_atomic
+#else	/* CONFIG_HIGHMEM */
+static inline void *pipe_kmap(struct page *page)
+{
+	return (void *) page->private;
+}
+#define pipe_kmap_atomic(page, type)	pipe_kmap(page)
+#define pipe_kunmap(page)		do { } while (0)
+#define pipe_kunmap_atomic(page, type)	do { } while (0)
+#endif
+
 /*
  * We use a start+len construction, which provides full use of the
  * allocated memory.
@@ -169,10 +184,10 @@ void *generic_pipe_buf_map(struct pipe_i
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
@@ -180,9 +195,9 @@ void generic_pipe_buf_unmap(struct pipe_
 {
 	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
 		buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
-		kunmap_atomic(map_data, KM_USER0);
+		pipe_kunmap_atomic(map_data, KM_USER0);
 	} else
-		kunmap(buf->page);
+		pipe_kunmap(buf->page);
 }

 int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
@@ -316,6 +331,7 @@ redo:
 		if (do_wakeup) {
 			wake_up_interruptible_sync(&pipe->wait);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+			do_wakeup = 0;
 		}
 		pipe_wait(pipe);
 	}
@@ -423,6 +439,8 @@ redo1:
 					ret = ret ? : -ENOMEM;
 					break;
 				}
+				page->private = (unsigned long)
+							page_address(page);
 				pipe->tmp_page = page;
 			}
 			/* Always wake up, even if the copy fails. Otherwise
@@ -438,16 +456,16 @@ redo1:
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
 			if (atomic)
-				kunmap_atomic(src, KM_USER0);
+				pipe_kunmap_atomic(src, KM_USER0);
 			else
-				kunmap(page);
+				pipe_kunmap(page);

 			if (unlikely(error)) {
 				if (atomic) {
