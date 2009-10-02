Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZJBQM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZJBQM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZJBQM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:12:26 -0400
Received: from asmtpout014.mac.com ([17.148.16.89]:60646 "EHLO
	asmtpout014.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbZJBQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:12:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Cc: lenrek@me.com
Message-id: <0DA1DE03-4131-4257-B476-03A776A9B4A6@me.com>
From: lenrek@me.com
To: linux-kernel@vger.kernel.org
In-reply-to: <4AC61D4E.4040000@microgate.com>
Subject: Re: [PATCH] drivers/char/pcmcia/synclink_cs.c: BKL pushdown?
Date: Sat, 03 Oct 2009 01:12:12 +0900
References: <060E5EC8-93F4-4AF1-889F-04A13378CB8D@me.com>
 <20091002124945.1814a2c3@lxorguk.ukuu.org.uk> <4AC5FE11.9060500@microgate.com>
 <0358338D-E697-4D44-96A8-E7107D50F77E@me.com> <4AC61D4E.4040000@microgate.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2009/10/03, at 0:33, Paul Fulghum wrote:

> lenrek@me.com wrote:
>> How about the BKL calls in synclinkmp.c, synclink.c, and  
>> synclink_gt.c?
>> Can they be safely eliminated?
>
> I looked those over and yes, the BKL can be removed
> from those as well. All 4 synclink drivers are mostly
> variations on the same code.
>
> It looks like the lock_kernel calls were blindly pushed down
> for safety during the initial transition, but all of the
> functions covered either use device specific locking or
> do not require locking.

Many thanks.  I enclose a patch against 2.6.31.1
which eliminates the BKL calls from the synclink drivers.


diff -ur linux-2.6.31.1/drivers/char/synclink.c linux/drivers/char/ 
synclink.c
--- linux-2.6.31.1/drivers/char/synclink.c	2009-09-25  
00:45:25.000000000 +0900
+++ linux/drivers/char/synclink.c	2009-10-03 00:35:31.000000000 +0900
@@ -2950,9 +2950,8 @@
  		    return -EIO;
  	}

-	lock_kernel();
  	ret = mgsl_ioctl_common(info, cmd, arg);
-	unlock_kernel();
+
  	return ret;
  }

@@ -3162,7 +3161,6 @@
  	 * Note: use tight timings here to satisfy the NIST-PCTS.
  	 */

-	lock_kernel();
  	if ( info->params.data_rate ) {
  	       	char_time = info->timeout/(32 * 5);
  		if (!char_time)
@@ -3192,7 +3190,6 @@
  				break;
  		}
  	}
-	unlock_kernel();

  exit:
  	if (debug_level >= DEBUG_LEVEL_INFO)
diff -ur linux-2.6.31.1/drivers/char/synclink_gt.c linux/drivers/char/ 
synclink_gt.c
--- linux-2.6.31.1/drivers/char/synclink_gt.c	2009-09-25  
00:45:25.000000000 +0900
+++ linux/drivers/char/synclink_gt.c	2009-10-03 00:35:57.000000000 +0900
@@ -928,8 +928,6 @@
  	 * Note: use tight timings here to satisfy the NIST-PCTS.
  	 */

-	lock_kernel();
-
  	if (info->params.data_rate) {
  	       	char_time = info->timeout/(32 * 5);
  		if (!char_time)
@@ -947,7 +945,6 @@
  		if (timeout && time_after(jiffies, orig_jiffies + timeout))
  			break;
  	}
-	unlock_kernel();

  exit:
  	DBGINFO(("%s wait_until_sent exit\n", info->device_name));
@@ -1073,7 +1070,6 @@
  		    return -EIO;
  	}

-	lock_kernel();

  	switch (cmd) {
  	case MGSL_IOCGPARAMS:
@@ -1143,7 +1139,7 @@
  	default:
  		ret = -ENOIOCTLCMD;
  	}
-	unlock_kernel();
+
  	return ret;
  }

diff -ur linux-2.6.31.1/drivers/char/synclinkmp.c linux/drivers/char/ 
synclinkmp.c
--- linux-2.6.31.1/drivers/char/synclinkmp.c	2009-09-25  
00:45:25.000000000 +0900
+++ linux/drivers/char/synclinkmp.c	2009-10-03 00:38:16.000000000 +0900
@@ -1062,7 +1062,6 @@
  	if (sanity_check(info, tty->name, "wait_until_sent"))
  		return;

-	lock_kernel();

  	if (!(info->port.flags & ASYNC_INITIALIZED))
  		goto exit;
@@ -1106,7 +1105,6 @@
  	}

  exit:
-	unlock_kernel();
  	if (debug_level >= DEBUG_LEVEL_INFO)
  		printk("%s(%d):%s wait_until_sent() exit\n",
  			 __FILE__,__LINE__, info->device_name );
@@ -1122,7 +1120,6 @@
  	if (sanity_check(info, tty->name, "write_room"))
  		return 0;

-	lock_kernel();
  	if (info->params.mode == MGSL_MODE_HDLC) {
  		ret = (info->tx_active) ? 0 : HDLC_MAX_FRAME_SIZE;
  	} else {
@@ -1130,7 +1127,6 @@
  		if (ret < 0)
  			ret = 0;
  	}
-	unlock_kernel();

  	if (debug_level >= DEBUG_LEVEL_INFO)
  		printk("%s(%d):%s write_room()=%d\n",
@@ -1251,7 +1247,7 @@
   *
   * Return Value:	0 if success, otherwise error code
   */
-static int do_ioctl(struct tty_struct *tty, struct file *file,
+static int ioctl(struct tty_struct *tty, struct file *file,
  		 unsigned int cmd, unsigned long arg)
  {
  	SLMP_INFO *info = tty->driver_data;
@@ -1341,16 +1337,6 @@
  	return 0;
  }

-static int ioctl(struct tty_struct *tty, struct file *file,
-		 unsigned int cmd, unsigned long arg)
-{
-	int ret;
-	lock_kernel();
-	ret = do_ioctl(tty, file, cmd, arg);
-	unlock_kernel();
-	return ret;
-}
-
  /*
   * /proc fs routines....
   */

