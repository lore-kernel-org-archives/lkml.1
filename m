Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbZENXEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbZENXEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762231AbZENW6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:33 -0400
Received: from kroah.org ([198.145.64.141]:45963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762217AbZENW6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:37 2009
Message-Id: <20090514225237.289438642@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:32 -0700
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
       alan@lxorguk.ukuu.org.uk, Jeff Mahoney <jeffm@suse.com>
Subject: [patch 06/28] dup2: Fix return value with oldfd == newfd and invalid fd
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=dup2-fix-return-value-with-oldfd-newfd-and-invalid-fd.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 2b79bc4f7ebbd5af3c8b867968f9f15602d5f802 upstream.

The return value of dup2 when oldfd == newfd and the fd isn't valid is
not getting properly sign extended.  We end up with 4294967287 instead
of -EBADF.

I've reproduced this on SLE11 (2.6.27.21), openSUSE Factory
(2.6.29-rc5), and Ubuntu 9.04 (2.6.28).

This patch uses a signed int for the error value so it is properly
extended.

Commit 6c5d0512a091480c9f981162227fdb1c9d70e555 introduced this
regression.

Reported-by: Jiri Dluhos <jdluhos@novell.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fcntl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -117,11 +117,13 @@ SYSCALL_DEFINE2(dup2, unsigned int, oldf
 {
 	if (unlikely(newfd == oldfd)) { /* corner case */
 		struct files_struct *files = current->files;
+		int retval = oldfd;
+
 		rcu_read_lock();
 		if (!fcheck_files(files, oldfd))
-			oldfd = -EBADF;
+			retval = -EBADF;
 		rcu_read_unlock();
-		return oldfd;
+		return retval;
 	}
 	return sys_dup3(oldfd, newfd, 0);
 }


