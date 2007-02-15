Return-Path: <linux-kernel-owner+w=401wt.eu-S1030300AbXBORPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbXBORPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXBORPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:15:05 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:37167 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030300AbXBORPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:15:03 -0500
Date: Thu, 15 Feb 2007 12:07:13 -0500
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org, stable@vger.kernel.org
Cc: uml@ligatura.org, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] UML - Fix 2.6.20 hang
Message-ID: <20070215170713.GB5641@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A previous cleanup misused need_poll, which had a fairly broken
interface.  It implemented a growable array, changing the used
elements count itself, but leaving it up to the caller to fill in the
actual elements, including the entire array if the array had to be
reallocated.  This worked because the previous users were switching
between two such structures, and the elements were copied from the
inactive array to the active array after making sure the active array
had enough room.

maybe_sigio_broken was made to use need_poll, but it was operating on
a single array, so when the buffer was reallocated, the previous
contents were lost.

This patch makes need_poll implement more sane semantics.  It merely
assures that the array is of the proper size and that the contents are
preserved.  It is up to the caller to adjust the used elements count
and to ensure that the proper elements are resent.

This manifested itself as a hang in 2.6.20 as the uninitialized buffer
convinced UML that one of its own file descriptors didn't support
SIGIO and needed to be watched by poll in a separate thread.  The
result was an interrupt flood as control traffic over this descriptor
sparked interrupts, which resulted in more control traffic, ad nauseum.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/sigio.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

Index: linux-2.6.18-mm/arch/um/os-Linux/sigio.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/sigio.c	2007-02-08 16:48:00.000000000 -0500
+++ linux-2.6.18-mm/arch/um/os-Linux/sigio.c	2007-02-14 19:16:22.000000000 -0500
@@ -97,20 +97,22 @@ static int write_sigio_thread(void *unus
 
 static int need_poll(struct pollfds *polls, int n)
 {
-	if(n <= polls->size){
-		polls->used = n;
+	struct pollfd *new;
+
+	if(n <= polls->size)
 		return 0;
-	}
-	kfree(polls->poll);
-	polls->poll = um_kmalloc_atomic(n * sizeof(struct pollfd));
-	if(polls->poll == NULL){
+
+	new = um_kmalloc_atomic(n * sizeof(struct pollfd));
+	if(new == NULL){
 		printk("need_poll : failed to allocate new pollfds\n");
-		polls->size = 0;
-		polls->used = 0;
 		return -ENOMEM;
 	}
+
+	memcpy(new, polls->poll, polls->used * sizeof(struct pollfd));
+	kfree(polls->poll);
+
+	polls->poll = new;
 	polls->size = n;
-	polls->used = n;
 	return 0;
 }
 
@@ -171,15 +173,15 @@ int add_sigio_fd(int fd)
 			goto out;
 	}
 
-	n = current_poll.used + 1;
-	err = need_poll(&next_poll, n);
+	n = current_poll.used;
+	err = need_poll(&next_poll, n + 1);
 	if(err)
 		goto out;
 
-	for(i = 0; i < current_poll.used; i++)
-		next_poll.poll[i] = current_poll.poll[i];
-
-	next_poll.poll[n - 1] = *p;
+	memcpy(next_poll.poll, current_poll.poll,
+	       current_poll.used * sizeof(struct pollfd));
+	next_poll.poll[n] = *p;
+	next_poll.used = n + 1;
 	update_thread();
  out:
 	sigio_unlock();
@@ -214,6 +216,7 @@ int ignore_sigio_fd(int fd)
 		if(p->fd != fd)
 			next_poll.poll[n++] = *p;
 	}
+	next_poll.used = current_poll.used - 1;
 
 	update_thread();
  out:
@@ -331,10 +334,9 @@ void maybe_sigio_broken(int fd, int read
 
 	sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
-	if(err){
-		printk("maybe_sigio_broken - failed to add pollfd\n");
+	if(err)
 		goto out;
-	}
+
 	all_sigio_fds.poll[all_sigio_fds.used++] =
 		((struct pollfd) { .fd  	= fd,
 				   .events 	= read ? POLLIN : POLLOUT,
