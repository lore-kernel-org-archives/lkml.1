Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbXKBQBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbXKBQBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbXKBQBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:01:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32799 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755472AbXKBQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:01:38 -0400
Date: Fri, 2 Nov 2007 16:02:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tty - fix tty network driver interactions with
 TCGET/TCSET calls
Message-ID: <20071102160252.6660e482@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We conciously make a change here - we permit mode and speed setting to be
done in things like SLIP mode. There isn't actually a technical reason to
disallow this. It's usually a silly thing to do but we can do it and
soemone might wish to do so.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/net/hamradio/6pack.c linux-2.6.24-rc1/drivers/net/hamradio/6pack.c
--- linux.vanilla-2.6.24-rc1/drivers/net/hamradio/6pack.c	2007-11-01 11:41:56.000000000 +0000
+++ linux-2.6.24-rc1/drivers/net/hamradio/6pack.c	2007-11-02 12:09:17.000000000 +0000
@@ -762,26 +762,20 @@
 
 		if (copy_from_user(&addr,
 		                   (void __user *) arg, AX25_ADDR_LEN)) {
-			err = -EFAULT;
-			break;
-		}
+				err = -EFAULT;
+				break;
+			}
 
-		netif_tx_lock_bh(dev);
-		memcpy(dev->dev_addr, &addr, AX25_ADDR_LEN);
-		netif_tx_unlock_bh(dev);
+			netif_tx_lock_bh(dev);
+			memcpy(dev->dev_addr, &addr, AX25_ADDR_LEN);
+			netif_tx_unlock_bh(dev);
 
-		err = 0;
-		break;
-	}
-
-	/* Allow stty to read, but not set, the serial port */
-	case TCGETS:
-	case TCGETA:
-		err = n_tty_ioctl(tty, (struct file *) file, cmd, arg);
-		break;
+			err = 0;
+			break;
+		}
 
 	default:
-		err = -ENOIOCTLCMD;
+		err = tty_mode_ioctl(tty, file, cmd, arg);
 	}
 
 	sp_put(sp);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/net/irda/irtty-sir.c linux-2.6.24-rc1/drivers/net/irda/irtty-sir.c
--- linux.vanilla-2.6.24-rc1/drivers/net/irda/irtty-sir.c	2007-11-01 11:41:56.000000000 +0000
+++ linux-2.6.24-rc1/drivers/net/irda/irtty-sir.c	2007-11-02 12:16:13.837586480 +0000
@@ -434,11 +434,6 @@
 	IRDA_ASSERT(dev != NULL, return -1;);
 
 	switch (cmd) {
-	case TCGETS:
-	case TCGETA:
-		err = n_tty_ioctl(tty, file, cmd, arg);
-		break;
-
 	case IRTTY_IOCTDONGLE:
 		/* this call blocks for completion */
 		err = sirdev_set_dongle(dev, (IRDA_DONGLE) arg);
@@ -454,7 +449,7 @@
 			err = -EFAULT;
 		break;
 	default:
-		err = -ENOIOCTLCMD;
+		err = tty_mode_ioctl(tty, file, cmd, arg);
 		break;
 	}
 	return err;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/net/ppp_async.c linux-2.6.24-rc1/drivers/net/ppp_async.c
--- linux.vanilla-2.6.24-rc1/drivers/net/ppp_async.c	2007-11-01 11:41:18.000000000 +0000
+++ linux-2.6.24-rc1/drivers/net/ppp_async.c	2007-11-01 22:29:06.574077296 +0000
@@ -309,16 +309,11 @@
 		err = 0;
 		break;
 
-	case TCGETS:
-	case TCGETA:
-		err = n_tty_ioctl(tty, file, cmd, arg);
-		break;
-
 	case TCFLSH:
 		/* flush our buffers and the serial port's buffer */
 		if (arg == TCIOFLUSH || arg == TCOFLUSH)
 			ppp_async_flush_output(ap);
-		err = n_tty_ioctl(tty, file, cmd, arg);
+		err = tty_perform_flush(tty, arg);
 		break;
 
 	case FIONREAD:
@@ -329,7 +324,8 @@
 		break;
 
 	default:
-		err = -ENOIOCTLCMD;
+		/* Try the various mode ioctls */
+		err = tty_mode_ioctl(tty, file, cmd, arg);
 	}
 
 	ap_put(ap);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/net/ppp_synctty.c linux-2.6.24-rc1/drivers/net/ppp_synctty.c
--- linux.vanilla-2.6.24-rc1/drivers/net/ppp_synctty.c	2007-11-01 11:41:18.000000000 +0000
+++ linux-2.6.24-rc1/drivers/net/ppp_synctty.c	2007-11-02 12:07:18.873913320 +0000
@@ -349,16 +349,11 @@
 		err = 0;
 		break;
 
-	case TCGETS:
-	case TCGETA:
-		err = n_tty_ioctl(tty, file, cmd, arg);
-		break;
-
 	case TCFLSH:
 		/* flush our buffers and the serial port's buffer */
 		if (arg == TCIOFLUSH || arg == TCOFLUSH)
 			ppp_sync_flush_output(ap);
-		err = n_tty_ioctl(tty, file, cmd, arg);
+		err = tty_perform_flush(tty, arg);
 		break;
 
 	case FIONREAD:
@@ -369,7 +364,8 @@
 		break;
 
 	default:
-		err = -ENOIOCTLCMD;
+		err = tty_mode_ioctl(tty, file, cmd, arg);
+		break;
 	}
 
 	sp_put(ap);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/net/slip.c linux-2.6.24-rc1/drivers/net/slip.c
--- linux.vanilla-2.6.24-rc1/drivers/net/slip.c	2007-11-01 11:41:56.000000000 +0000
+++ linux-2.6.24-rc1/drivers/net/slip.c	2007-11-02 12:08:18.000000000 +0000
@@ -1218,14 +1218,8 @@
 		return 0;
 	/* VSV changes end */
 #endif
-
-	/* Allow stty to read, but not set, the serial port */
-	case TCGETS:
-	case TCGETA:
-		return n_tty_ioctl(tty, file, cmd, arg);
-
 	default:
-		return -ENOIOCTLCMD;
+		return tty_mode_ioctl(tty, file, cmd, arg);
 	}
 }
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/net/wan/x25_asy.c linux-2.6.24-rc1/drivers/net/wan/x25_asy.c
--- linux.vanilla-2.6.24-rc1/drivers/net/wan/x25_asy.c	2007-11-01 11:41:18.000000000 +0000
+++ linux-2.6.24-rc1/drivers/net/wan/x25_asy.c	2007-11-02 12:14:34.000000000 +0000
@@ -719,12 +719,8 @@
 		return 0;
 	case SIOCSIFHWADDR:
 		return -EINVAL;
-	/* Allow stty to read, but not set, the serial port */
-	case TCGETS:
-	case TCGETA:
-		return n_tty_ioctl(tty, file, cmd, arg);
 	default:
-		return -ENOIOCTLCMD;
+		return tty_mode_ioctl(tty, file, cmd, arg);
 	}
 }
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/net/wireless/strip.c linux-2.6.24-rc1/drivers/net/wireless/strip.c
--- linux.vanilla-2.6.24-rc1/drivers/net/wireless/strip.c	2007-11-01 11:41:56.000000000 +0000
+++ linux-2.6.24-rc1/drivers/net/wireless/strip.c	2007-11-02 12:14:08.434650624 +0000
@@ -2735,16 +2735,8 @@
 			return -EFAULT;
 		return set_mac_address(strip_info, &addr);
 	}
-	/*
-	 * Allow stty to read, but not set, the serial port
-	 */
-
-	case TCGETS:
-	case TCGETA:
-		return n_tty_ioctl(tty, file, cmd, arg);
-		break;
 	default:
-		return -ENOIOCTLCMD;
+		return tty_mode_ioctl(tty, file, cmd, arg);
 		break;
 	}
 	return 0;
