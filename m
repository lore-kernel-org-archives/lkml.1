Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab0BDR1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:27:52 -0500
Received: from kroah.org ([198.145.64.141]:34891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933339Ab0BDRWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:20 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:20 2010
Message-Id: <20100204171520.349985167@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Mackall <mpm@selenic.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [57/74] random: drop weird m_time/a_time manipulation
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Mackall <mpm@selenic.com>

commit a996996dd75a9086b12d1cb4010f26e1748993f0 upstream.

No other driver does anything remotely like this that I know of except
for the tty drivers, and I can't see any reason for random/urandom to do
it. In fact, it's a (trivial, harmless) timing information leak. And
obviously, it generates power- and flash-cycle wasting I/O, especially
if combined with something like hwrngd. Also, it breaks ubifs's
expectations.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/random.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1051,12 +1051,6 @@ random_read(struct file *file, char __us
 				/* like a named pipe */
 	}
 
-	/*
-	 * If we gave the user some bytes, update the access time.
-	 */
-	if (count)
-		file_accessed(file);
-
 	return (count ? count : retval);
 }
 
@@ -1116,8 +1110,6 @@ static ssize_t random_write(struct file
 	if (ret)
 		return ret;
 
-	inode->i_mtime = current_fs_time(inode->i_sb);
-	mark_inode_dirty(inode);
 	return (ssize_t)count;
 }
 


