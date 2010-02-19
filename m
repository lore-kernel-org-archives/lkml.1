Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0BSRBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:34 -0500
Received: from kroah.org ([198.145.64.141]:57768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab0BSRBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:10 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:53 2010
Message-Id: <20100219163253.005061445@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Marcus Meissner <meissner@suse.de>
Subject: [80/93] USB: usbfs: properly clean up the as structure on error paths
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit ddeee0b2eec2a51b0712b04de4b39e7bec892a53 upstream.

I notice that the processcompl_compat() function seems to be leaking the
'struct async *as' in the error paths.

I think that the calling convention is fundamentally buggered. The
caller is the one that did the "reap_as()" to get the as thing, the
caller should be the one to free it too.

Freeing it in the caller also means that it very clearly always gets
freed, and avoids the need for any "free in the error case too".

From: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Marcus Meissner <meissner@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1334,14 +1334,11 @@ static int processcompl(struct async *as
 		}
 	}
 
-	free_async(as);
-
 	if (put_user(addr, (void __user * __user *)arg))
 		return -EFAULT;
 	return 0;
 
 err_out:
-	free_async(as);
 	return -EFAULT;
 }
 
@@ -1371,8 +1368,11 @@ static struct async *reap_as(struct dev_
 static int proc_reapurb(struct dev_state *ps, void __user *arg)
 {
 	struct async *as = reap_as(ps);
-	if (as)
-		return processcompl(as, (void __user * __user *)arg);
+	if (as) {
+		int retval = processcompl(as, (void __user * __user *)arg);
+		free_async(as);
+		return retval;
+	}
 	if (signal_pending(current))
 		return -EINTR;
 	return -EIO;
@@ -1380,11 +1380,16 @@ static int proc_reapurb(struct dev_state
 
 static int proc_reapurbnonblock(struct dev_state *ps, void __user *arg)
 {
+	int retval;
 	struct async *as;
 
-	if (!(as = async_getcompleted(ps)))
-		return -EAGAIN;
-	return processcompl(as, (void __user * __user *)arg);
+	as = async_getcompleted(ps);
+	retval = -EAGAIN;
+	if (as) {
+		retval = processcompl(as, (void __user * __user *)arg);
+		free_async(as);
+	}
+	return retval;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1457,7 +1462,6 @@ static int processcompl_compat(struct as
 		}
 	}
 
-	free_async(as);
 	if (put_user(ptr_to_compat(addr), (u32 __user *)arg))
 		return -EFAULT;
 	return 0;
@@ -1466,8 +1470,11 @@ static int processcompl_compat(struct as
 static int proc_reapurb_compat(struct dev_state *ps, void __user *arg)
 {
 	struct async *as = reap_as(ps);
-	if (as)
-		return processcompl_compat(as, (void __user * __user *)arg);
+	if (as) {
+		int retval = processcompl_compat(as, (void __user * __user *)arg);
+		free_async(as);
+		return retval;
+	}
 	if (signal_pending(current))
 		return -EINTR;
 	return -EIO;
@@ -1475,11 +1482,16 @@ static int proc_reapurb_compat(struct de
 
 static int proc_reapurbnonblock_compat(struct dev_state *ps, void __user *arg)
 {
+	int retval;
 	struct async *as;
 
-	if (!(as = async_getcompleted(ps)))
-		return -EAGAIN;
-	return processcompl_compat(as, (void __user * __user *)arg);
+	retval = -EAGAIN;
+	as = async_getcompleted(ps);
+	if (as) {
+		retval = processcompl_compat(as, (void __user * __user *)arg);
+		free_async(as);
+	}
+	return retval;
 }
 
 #endif


