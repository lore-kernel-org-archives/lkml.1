Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbZAaDDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbZAaDDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbZAaCra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:30 -0500
Received: from kroah.org ([198.145.64.141]:55287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756679AbZAaCrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:19 -0500
Date: Fri, 30 Jan 2009 18:42:40 -0800
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
       alan@lxorguk.ukuu.org.uk, Pete Zaitcev <zaitcev@redhat.com>
Subject: [patch 13/43] USB: usbmon: Implement compat_ioctl
Message-ID: <20090131024240.GN12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-usbmon-implement-compat_ioctl.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pete Zaitcev <zaitcev@redhat.com>

commit 7abce6bedc118eb39fe177c2c26be5d008505c14 upstream.

Running a 32-bit usbmon(8) on 2.6.28-rc9 produces the following:
ioctl32(usbmon:28563): Unknown cmd fd(3) cmd(400c9206){t:ffffff92;sz:12} arg(ffd3f458) on /dev/usbmon0

It happens because the compatibility mode was implemented for 2.6.18
and not updated for the fsops.compat_ioctl API.

This patch relocates the pieces from under #ifdef CONFIG_COMPAT into
compat_ioctl with no other changes except one new whitespace.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/mon/mon_bin.c |  105 ++++++++++++++++++++++++++++------------------
 1 file changed, 66 insertions(+), 39 deletions(-)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -37,6 +37,7 @@
 #define MON_IOCX_GET   _IOW(MON_IOC_MAGIC, 6, struct mon_bin_get)
 #define MON_IOCX_MFETCH _IOWR(MON_IOC_MAGIC, 7, struct mon_bin_mfetch)
 #define MON_IOCH_MFLUSH _IO(MON_IOC_MAGIC, 8)
+
 #ifdef CONFIG_COMPAT
 #define MON_IOCX_GET32 _IOW(MON_IOC_MAGIC, 6, struct mon_bin_get32)
 #define MON_IOCX_MFETCH32 _IOWR(MON_IOC_MAGIC, 7, struct mon_bin_mfetch32)
@@ -921,21 +922,6 @@ static int mon_bin_ioctl(struct inode *i
 		}
 		break;
 
-#ifdef CONFIG_COMPAT
-	case MON_IOCX_GET32: {
-		struct mon_bin_get32 getb;
-
-		if (copy_from_user(&getb, (void __user *)arg,
-					    sizeof(struct mon_bin_get32)))
-			return -EFAULT;
-
-		ret = mon_bin_get_event(file, rp,
-		    compat_ptr(getb.hdr32), compat_ptr(getb.data32),
-		    getb.alloc32);
-		}
-		break;
-#endif
-
 	case MON_IOCX_MFETCH:
 		{
 		struct mon_bin_mfetch mfetch;
@@ -962,7 +948,57 @@ static int mon_bin_ioctl(struct inode *i
 		}
 		break;
 
+	case MON_IOCG_STATS: {
+		struct mon_bin_stats __user *sp;
+		unsigned int nevents;
+		unsigned int ndropped;
+
+		spin_lock_irqsave(&rp->b_lock, flags);
+		ndropped = rp->cnt_lost;
+		rp->cnt_lost = 0;
+		spin_unlock_irqrestore(&rp->b_lock, flags);
+		nevents = mon_bin_queued(rp);
+
+		sp = (struct mon_bin_stats __user *)arg;
+		if (put_user(rp->cnt_lost, &sp->dropped))
+			return -EFAULT;
+		if (put_user(nevents, &sp->queued))
+			return -EFAULT;
+
+		}
+		break;
+
+	default:
+		return -ENOTTY;
+	}
+
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
+static long mon_bin_compat_ioctl(struct file *file,
+    unsigned int cmd, unsigned long arg)
+{
+	struct mon_reader_bin *rp = file->private_data;
+	int ret;
+
+	switch (cmd) {
+
+	case MON_IOCX_GET32: {
+		struct mon_bin_get32 getb;
+
+		if (copy_from_user(&getb, (void __user *)arg,
+					    sizeof(struct mon_bin_get32)))
+			return -EFAULT;
+
+		ret = mon_bin_get_event(file, rp,
+		    compat_ptr(getb.hdr32), compat_ptr(getb.data32),
+		    getb.alloc32);
+		if (ret < 0)
+			return ret;
+		}
+		return 0;
+
 	case MON_IOCX_MFETCH32:
 		{
 		struct mon_bin_mfetch32 mfetch;
@@ -986,37 +1022,25 @@ static int mon_bin_ioctl(struct inode *i
 			return ret;
 		if (put_user(ret, &uptr->nfetch32))
 			return -EFAULT;
-		ret = 0;
 		}
-		break;
-#endif
-
-	case MON_IOCG_STATS: {
-		struct mon_bin_stats __user *sp;
-		unsigned int nevents;
-		unsigned int ndropped;
-
-		spin_lock_irqsave(&rp->b_lock, flags);
-		ndropped = rp->cnt_lost;
-		rp->cnt_lost = 0;
-		spin_unlock_irqrestore(&rp->b_lock, flags);
-		nevents = mon_bin_queued(rp);
+		return 0;
 
-		sp = (struct mon_bin_stats __user *)arg;
-		if (put_user(rp->cnt_lost, &sp->dropped))
-			return -EFAULT;
-		if (put_user(nevents, &sp->queued))
-			return -EFAULT;
+	case MON_IOCG_STATS:
+		return mon_bin_ioctl(NULL, file, cmd,
+					    (unsigned long) compat_ptr(arg));
 
-		}
-		break;
+	case MON_IOCQ_URB_LEN:
+	case MON_IOCQ_RING_SIZE:
+	case MON_IOCT_RING_SIZE:
+	case MON_IOCH_MFLUSH:
+		return mon_bin_ioctl(NULL, file, cmd, arg);
 
 	default:
-		return -ENOTTY;
+		;
 	}
-
-	return ret;
+	return -ENOTTY;
 }
+#endif /* CONFIG_COMPAT */
 
 static unsigned int
 mon_bin_poll(struct file *file, struct poll_table_struct *wait)
@@ -1094,6 +1118,9 @@ static const struct file_operations mon_
 	/* .write =	mon_text_write, */
 	.poll =		mon_bin_poll,
 	.ioctl =	mon_bin_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	mon_bin_compat_ioctl,
+#endif
 	.release =	mon_bin_release,
 	.mmap =		mon_bin_mmap,
 };

