Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbZETSlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbZETSlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZETSlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:41:44 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:34108 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbZETSln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:41:43 -0400
Date: Wed, 20 May 2009 11:41:17 -0700
From: "Larry H." <research@subreption.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
Subject: [patch 1/5] Apply the PG_sensitive flag to the tty API
Message-ID: <20090520184117.GA10756@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deploys the use of the PG_sensitive page allocator flag
within the tty API, in the buffer management, input event handling
and input auditing code.

This should provide an additional safety layer against tty buffers
leaking information including passwords and other likely sensitive
input.

Again, you might refer to the paper by Jim Chow et. al on reducing
data resilience through secure deallocation. It explicitly mentions
this case, as well as other scenarios [1].

	[1] http://www.stanford.edu/~blp/papers/shredding.html

Signed-off-by: Larry H. <research@subreption.com>

---
 drivers/char/tty_audit.c  |    6 +++---
 drivers/char/tty_buffer.c |    2 +-
 drivers/char/tty_io.c     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/char/tty_audit.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_audit.c
+++ linux-2.6/drivers/char/tty_audit.c
@@ -28,13 +28,13 @@ static struct tty_audit_buf *tty_audit_b
 {
 	struct tty_audit_buf *buf;
 
-	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL | GFP_SENSITIVE);
 	if (!buf)
 		goto err;
 	if (PAGE_SIZE != N_TTY_BUF_SIZE)
-		buf->data = kmalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
+		buf->data = kmalloc(N_TTY_BUF_SIZE, GFP_KERNEL | GFP_SENSITIVE);
 	else
-		buf->data = (unsigned char *)__get_free_page(GFP_KERNEL);
+		buf->data = (unsigned char *)__get_free_page(GFP_KERNEL | GFP_SENSITIVE);
 	if (!buf->data)
 		goto err_buf;
 	atomic_set(&buf->count, 1);
Index: linux-2.6/drivers/char/tty_buffer.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_buffer.c
+++ linux-2.6/drivers/char/tty_buffer.c
@@ -60,7 +60,7 @@ static struct tty_buffer *tty_buffer_all
 
 	if (tty->buf.memory_used + size > 65536)
 		return NULL;
-	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
+	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC | GFP_SENSITIVE);
 	if (p == NULL)
 		return NULL;
 	p->used = 0;
Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c
+++ linux-2.6/drivers/char/tty_io.c
@@ -1031,7 +1031,7 @@ static inline ssize_t do_tty_write(
 		if (chunk < 1024)
 			chunk = 1024;
 
-		buf_chunk = kmalloc(chunk, GFP_KERNEL);
+		buf_chunk = kmalloc(chunk, GFP_KERNEL | GFP_SENSITIVE);
 		if (!buf_chunk) {
 			ret = -ENOMEM;
 			goto out;
