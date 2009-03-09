Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZCIP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZCIP7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbZCIP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:59:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36997 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbZCIP7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:59:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-aio <linux-aio@kvack.org>, michael.kerrisk@gmail.com
Cc: zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] man-pages: add documentation about the memlock implications of io_setup
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 09 Mar 2009 11:59:20 -0400
In-Reply-To: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 09 Mar 2009 11:49:57 -0400")
Message-ID: <x49zlfud6w7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch, against man-pages-3.19, adds verbiage surrounding the newly
proposed accounting of pinned aio completion ring pages against the
memlock rlimit.  It also fixes up a few references to aio_context_t
(which should be io_context_t).  Sorry for conflating the two, I can
break it apart if needed.

Cheers,
Jeff

diff -up man-pages-3.19/man2/io_cancel.2.orig man-pages-3.19/man2/io_cancel.2
--- man-pages-3.19/man2/io_cancel.2.orig	2009-03-08 11:57:50.000000000 -0400
+++ man-pages-3.19/man2/io_cancel.2	2009-03-08 11:58:01.000000000 -0400
@@ -32,7 +32,7 @@ io_cancel \- cancel an outstanding async
 .\"#include <linux/aio.h>
 .sp
 .\" .HP 16
-.BI "int io_cancel(aio_context_t " ctx_id ", struct iocb *" iocb ,
+.BI "int io_cancel(io_context_t " ctx_id ", struct iocb *" iocb ,
 .BI "              struct io_event *" result );
 .\" .ad
 .\" .hy
diff -up man-pages-3.19/man2/io_destroy.2.orig man-pages-3.19/man2/io_destroy.2
--- man-pages-3.19/man2/io_destroy.2.orig	2009-03-08 11:58:08.000000000 -0400
+++ man-pages-3.19/man2/io_destroy.2	2009-03-08 11:58:16.000000000 -0400
@@ -31,7 +31,7 @@ io_destroy \- destroy an asynchronous I/
 .\" #include <linux/aio.h>
 .sp
 .\" .HP 17
-.BI "int io_destroy(aio_context_t " ctx );
+.BI "int io_destroy(io_context_t " ctx );
 .\" .ad
 .\" .hy
 .sp
diff -up man-pages-3.19/man2/io_setup.2.orig man-pages-3.19/man2/io_setup.2
--- man-pages-3.19/man2/io_setup.2.orig	2009-03-08 11:53:39.000000000 -0400
+++ man-pages-3.19/man2/io_setup.2	2009-03-08 11:57:09.000000000 -0400
@@ -31,7 +31,7 @@ io_setup \- create an asynchronous I/O c
 .\" #include <linux/aio.h>
 .sp
 .\" .HP 15
-.BI "int io_setup(unsigned " nr_events ", aio_context_t *" ctxp );
+.BI "int io_setup(unsigned " nr_events ", io_context_t *" ctxp );
 .\" .ad
 .\" .hy
 .sp
@@ -45,7 +45,9 @@ at least \fInr_events\fP.
 \fIctxp\fP must not point to an AIO context that already exists, and must
 be initialized to 0 prior to the call.
 On successful creation of the AIO context, \fI*ctxp\fP is filled in
-with the resulting handle.
+with the resulting handle.  Memory is reserved by the kernel for the completion
+ring and, because this memory is pinned, it will be charged against the
+process's memlock rlimit.
 .SH "RETURN VALUE"
 On success,
 .BR io_setup ()
@@ -54,7 +56,8 @@ For the failure return, see NOTES.
 .SH "ERRORS"
 .TP
 .B EAGAIN
-The specified \fInr_events\fP exceeds the user's limit of available events.
+The specified \fInr_events\fP exceeds the process's limit of available events.
+Try increasing the memlock rlimit for the process.
 .TP
 .B EFAULT
 An invalid pointer is passed for \fIctxp\fP.
diff -up man-pages-3.19/man2/io_submit.2.orig man-pages-3.19/man2/io_submit.2
--- man-pages-3.19/man2/io_submit.2.orig	2009-03-08 11:58:26.000000000 -0400
+++ man-pages-3.19/man2/io_submit.2	2009-03-08 11:58:34.000000000 -0400
@@ -31,7 +31,7 @@ io_submit \- submit asynchronous I/O blo
 .\" #include <linux/aio.h>
 .sp
 .\" .HP 16
-.BI "int io_submit(aio_context_t " ctx_id ", long " nr \
+.BI "int io_submit(io_context_t " ctx_id ", long " nr \
 ", struct iocb **" iocbpp );
 .\" .ad
 .\" .hy
@@ -63,7 +63,7 @@ The file descriptor specified in the fir
 One of the data structures points to invalid data.
 .TP
 .B EINVAL
-The \fIaio_context\fP specified by \fIctx_id\fP is invalid.
+The \fIio_context\fP specified by \fIctx_id\fP is invalid.
 \fInr\fP is less than 0.
 The \fIiocb\fP at *iocbpp[0] is not properly initialized,
 or the operation specified is invalid for the file descriptor
diff -up man-pages-3.19/man7/capabilities.7.orig man-pages-3.19/man7/capabilities.7
--- man-pages-3.19/man7/capabilities.7.orig	2009-03-08 11:52:56.000000000 -0400
+++ man-pages-3.19/man7/capabilities.7	2009-03-08 11:53:14.000000000 -0400
@@ -129,7 +129,8 @@ Lock memory
 .RB ( mlock (2),
 .BR mlockall (2),
 .BR mmap (2),
-.BR shmctl (2)).
+.BR shmctl (2),
+.BR io_setup (2)).
 .TP
 .B CAP_IPC_OWNER
 Bypass permission checks for operations on System V IPC objects.
