Return-Path: <linux-kernel-owner+w=401wt.eu-S1765712AbZD3RUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765712AbZD3RUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764610AbZD3RHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:47 -0400
Received: from kroah.org ([198.145.64.141]:56378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764524AbZD3RHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:42 2009
Message-Id: <20090430165742.755990282@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
       Mark Fasheh <mfasheh@suse.com>, Jens Axboe <jens.axboe@oracle.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 30/88] splice: fix deadlock in splicing to file
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0049-splice-fix-deadlock-in-splicing-to-file.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

upstream commit: 7bfac9ecf0585962fe13584f5cf526d8c8e76f17

There's a possible deadlock in generic_file_splice_write(),
splice_from_pipe() and ocfs2_file_splice_write():

 - task A calls generic_file_splice_write()
 - this calls inode_double_lock(), which locks i_mutex on both
   pipe->inode and target inode
 - ordering depends on inode pointers, can happen that pipe->inode is
   locked first
 - __splice_from_pipe() needs more data, calls pipe_wait()
 - this releases lock on pipe->inode, goes to interruptible sleep
 - task B calls generic_file_splice_write(), similarly to the first
 - this locks pipe->inode, then tries to lock inode, but that is
   already held by task A
 - task A is interrupted, it tries to lock pipe->inode, but fails, as
   it is already held by task B
 - ABBA deadlock

Fix this by explicitly ordering locks: the outer lock must be on
target inode and the inner lock (which is later unlocked and relocked)
must be on pipe->inode.  This is OK, pipe inodes and target inodes
form two nonoverlapping sets, generic_file_splice_write() and friends
are not called with a target which is a pipe.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Mark Fasheh <mfasheh@suse.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ocfs2/file.c |    8 ++++++--
 fs/splice.c     |   25 ++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1943,7 +1943,7 @@ static ssize_t ocfs2_file_splice_write(s
 		   out->f_path.dentry->d_name.len,
 		   out->f_path.dentry->d_name.name);
 
-	inode_double_lock(inode, pipe->inode);
+	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
 
 	ret = ocfs2_rw_lock(inode, 1);
 	if (ret < 0) {
@@ -1958,12 +1958,16 @@ static ssize_t ocfs2_file_splice_write(s
 		goto out_unlock;
 	}
 
+	if (pipe->inode)
+		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
 	ret = generic_file_splice_write_nolock(pipe, out, ppos, len, flags);
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
 
 out_unlock:
 	ocfs2_rw_unlock(inode, 1);
 out:
-	inode_double_unlock(inode, pipe->inode);
+	mutex_unlock(&inode->i_mutex);
 
 	mlog_exit(ret);
 	return ret;
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -735,10 +735,19 @@ ssize_t splice_from_pipe(struct pipe_ino
 	 * ->write_end. Most of the time, these expect i_mutex to
 	 * be held. Since this may result in an ABBA deadlock with
 	 * pipe->inode, we have to order lock acquiry here.
+	 *
+	 * Outer lock must be inode->i_mutex, as pipe_wait() will
+	 * release and reacquire pipe->inode->i_mutex, AND inode must
+	 * never be a pipe.
 	 */
-	inode_double_lock(inode, pipe->inode);
+	WARN_ON(S_ISFIFO(inode->i_mode));
+	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
+	if (pipe->inode)
+		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
 	ret = __splice_from_pipe(pipe, &sd, actor);
-	inode_double_unlock(inode, pipe->inode);
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+	mutex_unlock(&inode->i_mutex);
 
 	return ret;
 }
@@ -829,11 +838,17 @@ generic_file_splice_write(struct pipe_in
 	};
 	ssize_t ret;
 
-	inode_double_lock(inode, pipe->inode);
+	WARN_ON(S_ISFIFO(inode->i_mode));
+	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
 	ret = file_remove_suid(out);
-	if (likely(!ret))
+	if (likely(!ret)) {
+		if (pipe->inode)
+			mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
 		ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
-	inode_double_unlock(inode, pipe->inode);
+		if (pipe->inode)
+			mutex_unlock(&pipe->inode->i_mutex);
+	}
+	mutex_unlock(&inode->i_mutex);
 	if (ret > 0) {
 		unsigned long nr_pages;
 


