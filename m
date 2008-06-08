Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYFHRUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYFHRUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYFHRT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:19:56 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41473 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbYFHRT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:19:28 -0400
Date: Sun, 8 Jun 2008 21:20:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] do_generic_file_read: s/EINTR/EIO/ if lock_page_killable() fails
Message-ID: <20080608172043.GA10389@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If lock_page_killable() fails because the task was killed by SIGKILL or
any other fatal signal, do_generic_file_read() returns -EIO.

This seems to be OK, because in fact the userspace won't see this error,
the task will dequeue SIGKILL and exit.

However, /sbin/init is different, it will dequeue SIGKILL, ignore it, and
return to the user-space with the bogus -EIO.

Change the code to return the error code from lock_page_killable(), -EINTR.
This doesn't fix the bug, but perhaps makes sense anyway. Imho, with this
change the code looks a bit more logical, and the "good" init should handle
the spurious EINTR or short read.

Afaics we can also change lock_page_killable() to return -ERESTARTNOINTR,
but this can't prevent the short reads.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/mm/filemap.c~3_INIT_READ	2008-05-18 15:44:19.000000000 +0400
+++ 26-rc2/mm/filemap.c	2008-06-08 19:23:51.000000000 +0400
@@ -1000,8 +1000,9 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		if (lock_page_killable(page))
-			goto readpage_eio;
+		error = lock_page_killable(page);
+		if (unlikely(error))
+			goto readpage_error;
 
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
@@ -1029,8 +1030,9 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			if (lock_page_killable(page))
-				goto readpage_eio;
+			error = lock_page_killable(page);
+			if (unlikely(error))
+				goto readpage_error;
 			if (!PageUptodate(page)) {
 				if (page->mapping == NULL) {
 					/*
@@ -1042,15 +1044,14 @@ readpage:
 				}
 				unlock_page(page);
 				shrink_readahead_size_eio(filp, ra);
-				goto readpage_eio;
+				error = -EIO;
+				goto readpage_error;
 			}
 			unlock_page(page);
 		}
 
 		goto page_ok;
 
-readpage_eio:
-		error = -EIO;
 readpage_error:
 		/* UHHUH! A synchronous read error occurred. Report it */
 		desc->error = error;

