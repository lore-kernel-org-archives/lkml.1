Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0BNW1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 17:27:46 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:41242 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0BNW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 17:27:45 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 14 Feb 2010 14:27:44 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, stephane.thiell@cea.fr
Subject: [patch/rfc] Make poll/select report error (POLLNVAL and EBADF) for
 unsupported files
Message-ID: <alpine.DEB.2.00.1002141403240.18795@makko.or.mcafeemobile.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently poll and select consider a non poll-supported file as one with 
full event mask set, instead of reporting proper error to the caller.
This behavior can fool the caller of proper functionality being returned, 
while instead no valid event was processed/read from the device.
This came out linked to this bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=15272

IMHO, it'd be more adequate to report proper error code, for files that do 
not support f_op->poll(), but then I am also not sure how much breakage 
can this bring to existing (already broken "in just the right way") 
applications.
Untested, discussion-only, patch.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/select.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6.mod/fs/select.c
===================================================================
--- linux-2.6.mod.orig/fs/select.c	2010-02-14 14:06:12.000000000 -0800
+++ linux-2.6.mod/fs/select.c	2010-02-14 14:16:09.000000000 -0800
@@ -447,12 +447,13 @@ int do_select(int n, fd_set_bits *fds, s
 					continue;
 				file = fget_light(i, &fput_needed);
 				if (file) {
-					f_op = file->f_op;
-					mask = DEFAULT_POLLMASK;
-					if (f_op && f_op->poll) {
-						wait_key_set(wait, in, out, bit);
-						mask = (*f_op->poll)(file, wait);
+					if (unlikely((f_op = file->f_op) == NULL ||
+						     f_op->poll == NULL)) {
+						retval = -EBADF;
+						goto error_exit;
 					}
+					wait_key_set(wait, in, out, bit);
+					mask = (*f_op->poll)(file, wait);
 					fput_light(file, fput_needed);
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
@@ -501,7 +502,7 @@ int do_select(int n, fd_set_bits *fds, s
 					   to, slack))
 			timed_out = 1;
 	}
-
+error_exit:
 	poll_freewait(&table);
 
 	return retval;
@@ -720,15 +721,14 @@ static inline unsigned int do_pollfd(str
 		file = fget_light(fd, &fput_needed);
 		mask = POLLNVAL;
 		if (file != NULL) {
-			mask = DEFAULT_POLLMASK;
 			if (file->f_op && file->f_op->poll) {
 				if (pwait)
 					pwait->key = pollfd->events |
 							POLLERR | POLLHUP;
 				mask = file->f_op->poll(file, pwait);
+				/* Mask out unneeded events. */
+				mask &= pollfd->events | POLLERR | POLLHUP;
 			}
-			/* Mask out unneeded events. */
-			mask &= pollfd->events | POLLERR | POLLHUP;
 			fput_light(file, fput_needed);
 		}
 	}

