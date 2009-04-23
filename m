Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbZDWHt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbZDWHt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZDWHc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:32:57 -0400
Received: from sous-sol.org ([216.99.217.87]:50809 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757143AbZDWHc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:32:56 -0400
Message-Id: <20090423072851.819899120@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Tony Battersby <tonyb@cybernetics.com>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 074/100] SCSI: sg: fix races with ioctl(SG_IO)
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=scsi-sg-fix-races-with-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tony Battersby <tonyb@cybernetics.com>

upstream commit: a2dd3b4cea335713b58996bb07b3abcde1175f47

sg_io_owned needs to be set before the command is sent to the midlevel;
otherwise, a quickly-completing command may cause a different CPU
to see "srp->done == 1 && !srp->sg_io_owned", which would lead to
incorrect behavior.

Check srp->done and set srp->orphan while holding rq_list_lock to
prevent races with sg_rq_end_io().

There is no need to check sfp->closed from read/write/ioctl/poll/etc.
since the kernel guarantees that this won't happen.

The usefulness of sg_srp_done() was questionable before; now it is
definitely not needed.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/scsi/sg.c |   39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -189,7 +189,7 @@ static ssize_t sg_new_read(Sg_fd * sfp, 
 			   Sg_request * srp);
 static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
 			const char __user *buf, size_t count, int blocking,
-			int read_only, Sg_request **o_srp);
+			int read_only, int sg_io_owned, Sg_request **o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
 static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
@@ -561,7 +561,8 @@ sg_write(struct file *filp, const char _
 		return -EFAULT;
 	blocking = !(filp->f_flags & O_NONBLOCK);
 	if (old_hdr.reply_len < 0)
-		return sg_new_write(sfp, filp, buf, count, blocking, 0, NULL);
+		return sg_new_write(sfp, filp, buf, count,
+				    blocking, 0, 0, NULL);
 	if (count < (SZ_SG_HEADER + 6))
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
@@ -642,7 +643,7 @@ sg_write(struct file *filp, const char _
 
 static ssize_t
 sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
-		 size_t count, int blocking, int read_only,
+		 size_t count, int blocking, int read_only, int sg_io_owned,
 		 Sg_request **o_srp)
 {
 	int k;
@@ -662,6 +663,7 @@ sg_new_write(Sg_fd *sfp, struct file *fi
 		SCSI_LOG_TIMEOUT(1, printk("sg_new_write: queue full\n"));
 		return -EDOM;
 	}
+	srp->sg_io_owned = sg_io_owned;
 	hp = &srp->header;
 	if (__copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
 		sg_remove_request(sfp, srp);
@@ -766,18 +768,6 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 }
 
 static int
-sg_srp_done(Sg_request *srp, Sg_fd *sfp)
-{
-	unsigned long iflags;
-	int done;
-
-	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	done = srp->done;
-	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return done;
-}
-
-static int
 sg_ioctl(struct inode *inode, struct file *filp,
 	 unsigned int cmd_in, unsigned long arg)
 {
@@ -809,27 +799,26 @@ sg_ioctl(struct inode *inode, struct fil
 				return -EFAULT;
 			result =
 			    sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
-					 blocking, read_only, &srp);
+					 blocking, read_only, 1, &srp);
 			if (result < 0)
 				return result;
-			srp->sg_io_owned = 1;
 			while (1) {
 				result = 0;	/* following macro to beat race condition */
 				__wait_event_interruptible(sfp->read_wait,
-					(sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),
-							   result);
+					(srp->done || sdp->detached),
+					result);
 				if (sdp->detached)
 					return -ENODEV;
-				if (sfp->closed)
-					return 0;	/* request packet dropped already */
-				if (0 == result)
+				write_lock_irq(&sfp->rq_list_lock);
+				if (srp->done) {
+					srp->done = 2;
+					write_unlock_irq(&sfp->rq_list_lock);
 					break;
+				}
 				srp->orphan = 1;
+				write_unlock_irq(&sfp->rq_list_lock);
 				return result;	/* -ERESTARTSYS because signal hit process */
 			}
-			write_lock_irqsave(&sfp->rq_list_lock, iflags);
-			srp->done = 2;
-			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
 			return (result < 0) ? result : 0;
 		}

