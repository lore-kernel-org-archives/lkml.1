Return-Path: <linux-kernel-owner+w=401wt.eu-S2993001AbXDYTnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993001AbXDYTnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992988AbXDYTnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:43:46 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:34562
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992993AbXDYTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:43:39 -0400
Date: Wed, 25 Apr 2007 21:46:33 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in tty_io.c
Message-ID: <20070425194633.GA3280@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
References: <20070425154934.GP6798@traven> <20070425191359.GA13241@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425191359.GA13241@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Apr 25, 2007 at 08:13:59PM +0100 Christoph Hellwig ha dit:

> On Wed, Apr 25, 2007 at 05:49:34PM +0200, Matthias Kaehlcke wrote:
> > drivers/char/tty_io.c uses a semaphore as mutex. use the mutex API
> > instead of the (binary) semaphore
> 
> This looks like it should be a spinlock:
> 
> > -		down(&allocated_ptys_lock);
> > +		mutex_lock(&allocated_ptys_lock);
> >  		idr_remove(&allocated_ptys, idx);
> > -		up(&allocated_ptys_lock);
> > +		mutex_unlock(&allocated_ptys_lock);
> 
> idr_remove is a quick operation that doesn't sleep.
> 
> > @@ -2639,24 +2639,24 @@ static int ptmx_open(struct inode * inode, struct file * filp)
> >  	nonseekable_open(inode, filp);
> >  
> >  	/* find a device that is not in use. */
> > -	down(&allocated_ptys_lock);
> > +	mutex_lock(&allocated_ptys_lock);
> >  	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
> > -		up(&allocated_ptys_lock);
> 
> The idr_pre_get should be moved out of the lock, that's the whole
> point for it's existance..
> 
> > +		mutex_unlock(&allocated_ptys_lock);
> >  		return -ENOMEM;
> >  	}
> >  	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
> >  	if (idr_ret < 0) {
> > -		up(&allocated_ptys_lock);
> > +		mutex_unlock(&allocated_ptys_lock);
> >  		if (idr_ret == -EAGAIN)
> >  			return -ENOMEM;
> >  		return -EIO;
> >  	}
> >  	if (index >= pty_limit) {
> >  		idr_remove(&allocated_ptys, index);
> > -		up(&allocated_ptys_lock);
> > +		mutex_unlock(&allocated_ptys_lock);
> >  		return -EIO;
> >  	}
> > -	up(&allocated_ptys_lock);
> > +	mutex_unlock(&allocated_ptys_lock);
> 
> And idr_get_new is another quick, non-blocking operation.

thanks for your remarks. is the following patch what you are
proposing?

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

             You must have a plan. If you don't have a plan,
               you'll become part of somebody else's plan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
