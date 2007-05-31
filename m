Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbXEaNkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbXEaNkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXEaNkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:40:43 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:53202
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751824AbXEaNkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:40:42 -0400
Date: Thu, 31 May 2007 15:42:26 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: [PATCH] use mutex instead of semaphore in tty_io.c
Message-ID: <20070531134226.GO14284@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070425154934.GP6798@traven> <20070425191359.GA13241@infradead.org> <20070425194633.GA3280@traven> <20070425194550.GA18914@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425194550.GA18914@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/tty_io.c: Use spinlock instead of a (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 7a32df5..ff27587 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -137,7 +137,7 @@ EXPORT_SYMBOL(tty_mutex);
 extern struct tty_driver *ptm_driver;	/* Unix98 pty masters; for /dev/ptmx */
 extern int pty_limit;		/* Config limit on Unix98 ptys */
 static DEFINE_IDR(allocated_ptys);
-static DECLARE_MUTEX(allocated_ptys_lock);
+static DEFINE_SPINLOCK(allocated_ptys_lock);
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
@@ -2471,9 +2471,9 @@ static void release_dev(struct file * filp)
 #ifdef CONFIG_UNIX98_PTYS
 	/* Make this pty number available for reallocation */
 	if (devpts) {
-		down(&allocated_ptys_lock);
+		spin_lock(&allocated_ptys_lock);
 		idr_remove(&allocated_ptys, idx);
-		up(&allocated_ptys_lock);
+		spin_unlock(&allocated_ptys_lock);
 	}
 #endif
 
@@ -2639,24 +2639,24 @@ static int ptmx_open(struct inode * inode, struct file * filp)
 	nonseekable_open(inode, filp);
 
 	/* find a device that is not in use. */
-	down(&allocated_ptys_lock);
-	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
-		up(&allocated_ptys_lock);
+	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL))
 		return -ENOMEM;
-	}
+
+	spin_lock(&allocated_ptys_lock);
+
 	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
 	if (idr_ret < 0) {
-		up(&allocated_ptys_lock);
+		spin_unlock(&allocated_ptys_lock);
 		if (idr_ret == -EAGAIN)
 			return -ENOMEM;
 		return -EIO;
 	}
 	if (index >= pty_limit) {
 		idr_remove(&allocated_ptys, index);
-		up(&allocated_ptys_lock);
+		spin_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
-	up(&allocated_ptys_lock);
+	spin_unlock(&allocated_ptys_lock);
 
 	mutex_lock(&tty_mutex);
 	retval = init_dev(ptm_driver, index, &tty);
@@ -2681,9 +2681,9 @@ out1:
 	release_dev(filp);
 	return retval;
 out:
-	down(&allocated_ptys_lock);
+	spin_lock(&allocated_ptys_lock);
 	idr_remove(&allocated_ptys, index);
-	up(&allocated_ptys_lock);
+	spin_unlock(&allocated_ptys_lock);
 	return retval;
 }
 #endif

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     The assumption that what currently exists must necessarily
      exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
