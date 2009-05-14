Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbZENXKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbZENXKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbZENW64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:56 -0400
Received: from kroah.org ([198.145.64.141]:46189 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762295AbZENW6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:41 2009
Message-Id: <20090514225240.923018470@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:53 -0700
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
Subject: [patch 27/28] splice: fix i_mutex locking in generic_splice_write()
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=splice-fix-i_mutex-locking-in-generic_splice_write.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <miklos@szeredi.hu>

commit eb443e5a25d43996deb62b9bcee1a4ce5dea2ead upstream.

Rearrange locking of i_mutex on destination so it's only held while
buffers are copied with the pipe_to_file() actor, and not while
waiting for more data on the pipe.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -893,17 +893,29 @@ generic_file_splice_write(struct pipe_in
 	};
 	ssize_t ret;
 
-	WARN_ON(S_ISFIFO(inode->i_mode));
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
-	ret = file_remove_suid(out);
-	if (likely(!ret)) {
-		if (pipe->inode)
-			mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
-		ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
-		if (pipe->inode)
-			mutex_unlock(&pipe->inode->i_mutex);
-	}
-	mutex_unlock(&inode->i_mutex);
+	if (pipe->inode)
+		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
+
+	splice_from_pipe_begin(&sd);
+	do {
+		ret = splice_from_pipe_next(pipe, &sd);
+		if (ret <= 0)
+			break;
+
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		ret = file_remove_suid(out);
+		if (!ret)
+			ret = splice_from_pipe_feed(pipe, &sd, pipe_to_file);
+		mutex_unlock(&inode->i_mutex);
+	} while (ret > 0);
+	splice_from_pipe_end(pipe, &sd);
+
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+
+	if (sd.num_spliced)
+		ret = sd.num_spliced;
+
 	if (ret > 0) {
 		unsigned long nr_pages;
 


