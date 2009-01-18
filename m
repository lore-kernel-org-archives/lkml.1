Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbZARD3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbZARD3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 22:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbZARD3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 22:29:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989AbZARD3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 22:29:34 -0500
Date: Sun, 18 Jan 2009 04:26:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] pipe_rdwr_fasync: fix the error handling to prevent the
	leak/crash
Message-ID: <20090118032649.GA19301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the second fasync_helper() fails, pipe_rdwr_fasync() returns the error
but leaves the file on ->fasync_readers.

This was always wrong, but since 233e70f4228e78eb2f80dc6650f65d3ae3dbf17c
"saner FASYNC handling on file close" we have the new problem. Because in
this case setfl() doesn't set FASYNC bit, __fput() will not do ->fasync(0),
and we leak fasync_struct with ->fa_file pointing to the freed file.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/fs/pipe.c~PIPE_FASYNC	2009-01-12 23:07:47.000000000 +0100
+++ CUR/fs/pipe.c	2009-01-18 03:51:41.000000000 +0100
@@ -699,12 +699,13 @@ pipe_rdwr_fasync(int fd, struct file *fi
 	int retval;
 
 	mutex_lock(&inode->i_mutex);
-
 	retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
 
-	if (retval >= 0)
+	if (retval >= 0) {
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);
-
+		if (retval < 0) /* this can happen only if on == T */
+			fasync_helper(-1, filp, 0, &pipe->fasync_readers);
+	}
 	mutex_unlock(&inode->i_mutex);
 
 	if (retval < 0)

