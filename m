Return-Path: <linux-kernel-owner+w=401wt.eu-S1763337AbZENXKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763337AbZENXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761162AbZENW65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:57 -0400
Received: from kroah.org ([198.145.64.141]:46179 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762245AbZENW6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:40 2009
Message-Id: <20090514225240.749224877@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:52 -0700
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
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 26/28] splice: remove i_mutex locking in splice_from_pipe()
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=splice-remove-i_mutex-locking-in-splice_from_pipe.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <miklos@szeredi.hu>

commit 2933970b960223076d6affcf7a77e2bc546b8102 upstream.

splice_from_pipe() is only called from two places:

  - generic_splice_sendpage()
  - splice_write_null()

Neither of these require i_mutex to be taken on the destination inode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -782,7 +782,7 @@ EXPORT_SYMBOL(__splice_from_pipe);
  * @actor:	handler that splices the data
  *
  * Description:
- *    See __splice_from_pipe. This function locks the input and output inodes,
+ *    See __splice_from_pipe. This function locks the pipe inode,
  *    otherwise it's identical to __splice_from_pipe().
  *
  */
@@ -791,7 +791,6 @@ ssize_t splice_from_pipe(struct pipe_ino
 			 splice_actor *actor)
 {
 	ssize_t ret;
-	struct inode *inode = out->f_mapping->host;
 	struct splice_desc sd = {
 		.total_len = len,
 		.flags = flags,
@@ -799,24 +798,11 @@ ssize_t splice_from_pipe(struct pipe_ino
 		.u.file = out,
 	};
 
-	/*
-	 * The actor worker might be calling ->prepare_write and
-	 * ->commit_write. Most of the time, these expect i_mutex to
-	 * be held. Since this may result in an ABBA deadlock with
-	 * pipe->inode, we have to order lock acquiry here.
-	 *
-	 * Outer lock must be inode->i_mutex, as pipe_wait() will
-	 * release and reacquire pipe->inode->i_mutex, AND inode must
-	 * never be a pipe.
-	 */
-	WARN_ON(S_ISFIFO(inode->i_mode));
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
 	if (pipe->inode)
-		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
+		mutex_lock(&pipe->inode->i_mutex);
 	ret = __splice_from_pipe(pipe, &sd, actor);
 	if (pipe->inode)
 		mutex_unlock(&pipe->inode->i_mutex);
-	mutex_unlock(&inode->i_mutex);
 
 	return ret;
 }


