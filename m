Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbZACQsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbZACQsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbZACQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:47:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46630 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbZACQr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:47:56 -0500
Date: Sat, 3 Jan 2009 17:45:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       bfields@fieldses.org, xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20090103164544.GA17282@redhat.com>
References: <20081229041352.6bbdf57c@tpl> <20090102184232.GH28946@ZenIV.linux.org.uk> <20090102190902.GA25969@redhat.com> <20090102195446.GJ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102195446.GJ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02, Al Viro wrote:
>
> FWIW, it's still bloody tempting to try.  How about hlist from struct file
> through fasync_struct?  Possibly with reference from fasync_struct back
> to the queue it's on, while we are at it - would make fasync_helper simpler...

Well, don't ask me ;) I don't know whether this change is good or bad...

Let's forget about files with several fasync_struct's, suppose we have a
pointer ->f_xxx to fasync_struct in struct file. Now __fput() can check
f_xxx != NULL and call ->fasync() if true. But how can we ensure that
(->f_flags & FASYNC) matches (->f_xxx != NULL) ? Looks like we should
kill FASYNC and uglify the code which sets/gets ->f_flags, for example
do_fcntl(F_GETFL) should do

	case F_GETFL:
		err = filp->f_flags | (filp->f_xxx ? FASYNC : 0)

And what if some strange driver doesn't use the "standard" fasync_helper/
kill_fasync helpers?


Offtopic, but while we are here...

	pipe_rdwr_fasync:

		retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);

		if (retval >= 0)
			retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);

Suppose that on == 1 and the first fasync_helper(fasync_readers) succeeds,
but the second fasync_helper(fasync_writers) fails. We return the error and
this file doesn't get FASYNC, but still it is placed on ->fasync_readers.
This looks just wrong, we return the error to the user-space, but the file
owner can receive the notifications from ->fasync_readers.

And. Don't we leak fasync_struct in this case? With the recent changes,
pipe_rdwr_release() does not call pipe_rdwr_fasync(on => 0) unconditionally.
Instead, __fput() does this, but depending on ->f_flags & FASYNC.

IOW, perhaps we need something like the patch below?

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -702,9 +702,11 @@ pipe_rdwr_fasync(int fd, struct file *fi
 
 	retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
 
-	if (retval >= 0)
+	if (retval >= 0) {
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);
-
+		if (retval < 0) /* can only happen if on == true */
+			fasync_helper(-1, filp, 0, &pipe->fasync_readers);
+	}
 	mutex_unlock(&inode->i_mutex);
 
 	if (retval < 0)


And why pipe_xxx_fasync() take ->i_mutex around fasync_helper() ?
Afaics, nothing bad can happen if pipe_xxx_fasync() races with, say,
pipe_read().

Oleg.

