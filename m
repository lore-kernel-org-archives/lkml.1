Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbYBTUV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbYBTUV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbYBTUVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:21:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59350 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbYBTUVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:21:47 -0500
Date: Wed, 20 Feb 2008 20:12:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cyclades: Prepare for relaxed locking in callers
Message-ID: <20080220201216.40d70747@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically wrap it in lock_kernel where it is hard to prove the locking is
ok. 

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/cyclades.c linux-2.6.25-rc2-mm1/drivers/char/cyclades.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/cyclades.c	2008-02-19 11:01:43.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/cyclades.c	2008-02-20 11:45:28.000000000 +0000
@@ -3464,6 +3464,8 @@
 	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
 		return -ENODEV;
 
+	lock_kernel();
+	
 	card = info->card;
 	channel = info->line - card->first_line;
 	if (!IS_CYC_Z(*card)) {
@@ -3506,10 +3508,12 @@
 				((lstatus & C_RS_CTS) ? TIOCM_CTS : 0);
 		} else {
 			result = 0;
+			unlock_kernel();
 			return -ENODEV;
 		}
 
 	}
+	unlock_kernel();
 	return result;
 }				/* cy_tiomget */
 
@@ -3880,6 +3884,7 @@
 	printk(KERN_DEBUG "cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n",
 		info->line, cmd, arg);
 #endif
+	lock_kernel();
 
 	switch (cmd) {
 	case CYGETMON:
@@ -3988,47 +3993,47 @@
 		p_cuser = argp;
 		ret_val = put_user(cnow.cts, &p_cuser->cts);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.dsr, &p_cuser->dsr);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.rng, &p_cuser->rng);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.dcd, &p_cuser->dcd);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.rx, &p_cuser->rx);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.tx, &p_cuser->tx);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.frame, &p_cuser->frame);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.overrun, &p_cuser->overrun);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.parity, &p_cuser->parity);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.brk, &p_cuser->brk);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.buf_overrun, &p_cuser->buf_overrun);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = 0;
 		break;
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
+	unlock_kernel();
 
 #ifdef CY_DEBUG_OTHER
 	printk(KERN_DEBUG "cyc:cy_ioctl done\n");
 #endif
-
 	return ret_val;
 }				/* cy_ioctl */
 
