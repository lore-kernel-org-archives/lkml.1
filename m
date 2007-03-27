Return-Path: <linux-kernel-owner+w=401wt.eu-S934066AbXC0RsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbXC0RsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934068AbXC0RsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:48:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4395 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934066AbXC0RsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:48:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=kYoFLDCYdYPh2xoh6ylbYwzsgx2BDALC0TBc43j6ygg2a7WSBk+/oOS0NwUU2rq8c
	KfpHClmJ2xOczWOZNiq8A==
Message-ID: <b040c32a0703271047vba81938q538d182c9c984f42@mail.gmail.com>
Date: Tue, 27 Mar 2007 10:47:54 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070326201552.b8ad7dda.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
	 <20070322170122.ee2589a1.akpm@linux-foundation.org>
	 <b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com>
	 <20070326201552.b8ad7dda.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> LTP's vmsplice01 triggers the below:
>
> Unable to handle kernel NULL pointer dereference at 0000000000000130 RIP:
>  [<ffffffff8029e1b6>] pipe_to_file+0x1f3/0x2a6

Ouch, generic_pipe_buf_map() and unmap is used by both pipe and
splice, I better constrain all changes within fs/pipe.c because from
splice path, the page->private is not initialized.

Double ouch for missing test that code path.  Here is an updated
patch, tested with LTP and FIO.  I will write more test cases to make
sure all code path are covered.


diff --git a/fs/pipe.c b/fs/pipe.c
index ebafde7..4b55452 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -21,6 +21,21 @@
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
@@ -185,6 +200,27 @@ void generic_pipe_buf_unmap
 		kunmap(buf->page);
 }

+static void *pipe_buf_map(struct pipe_inode_info *pipe,
+			   struct pipe_buffer *buf, int atomic)
+{
+	if (atomic) {
+		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
+		return pipe_kmap_atomic(buf->page, KM_USER0);
+	}
+
+	return pipe_kmap(buf->page);
+}
+
+static void pipe_buf_unmap(struct pipe_inode_info *pipe,
+			    struct pipe_buffer *buf, void *map_data)
+{
+	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
+		buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
+		pipe_kunmap_atomic(map_data, KM_USER0);
+	} else
+		pipe_kunmap(buf->page);
+}
+
 int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
 			   struct pipe_buffer *buf)
 {
@@ -210,8 +246,8 @@ int generic_pipe_buf_pin

 static const struct pipe_buf_operations anon_pipe_buf_ops = {
 	.can_merge = 1,
-	.map = generic_pipe_buf_map,
-	.unmap = generic_pipe_buf_unmap,
+	.map = pipe_buf_map,
+	.unmap = pipe_buf_unmap,
 	.pin = generic_pipe_buf_pin,
 	.release = anon_pipe_buf_release,
 	.steal = generic_pipe_buf_steal,
@@ -316,6 +352,7 @@ redo:
 		if (do_wakeup) {
 			wake_up_interruptible_sync(&pipe->wait);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+			do_wakeup = 0;
 		}
 		pipe_wait(pipe);
 	}
@@ -423,6 +460,8 @@ redo1:
 					ret = ret ? : -ENOMEM;
 					break;
 				}
+				page->private = (unsigned long)
+							page_address(page);
 				pipe->tmp_page = page;
 			}
 			/* Always wake up, even if the copy fails. Otherwise
@@ -438,16 +477,16 @@ redo1:
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
