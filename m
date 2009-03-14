Return-Path: <linux-kernel-owner+w=401wt.eu-S1761717AbZCNBvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbZCNBvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZCNBVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:40 -0400
Received: from kroah.org ([198.145.64.141]:35623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754761AbZCNBVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:43 2009
Message-Id: <20090314011043.790685951@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:01 -0700
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
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: [patch 084/114] pipe_rdwr_fasync: fix the error handling to prevent the leak/crash
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit e5bc49ba7439b9726006d031d440cba96819f0f8 upstream.

If the second fasync_helper() fails, pipe_rdwr_fasync() returns the error
but leaves the file on ->fasync_readers.

This was always wrong, but since 233e70f4228e78eb2f80dc6650f65d3ae3dbf17c
"saner FASYNC handling on file close" we have the new problem.  Because in
this case setfl() doesn't set FASYNC bit, __fput() will not do
->fasync(0), and we leak fasync_struct with ->fa_file pointing to the
freed file.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/pipe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -699,12 +699,12 @@ pipe_rdwr_fasync(int fd, struct file *fi
 	int retval;
 
 	mutex_lock(&inode->i_mutex);
-
 	retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
-
-	if (retval >= 0)
+	if (retval >= 0) {
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);
-
+		if (retval < 0) /* this can happen only if on == T */
+			fasync_helper(-1, filp, 0, &pipe->fasync_readers);
+	}
 	mutex_unlock(&inode->i_mutex);
 
 	if (retval < 0)


