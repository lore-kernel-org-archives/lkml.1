Return-Path: <linux-kernel-owner+w=401wt.eu-S934279AbYBTUez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbYBTUez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934336AbYBTUdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:33:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35605 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762832AbYBTUdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:33:46 -0500
Date: Wed, 20 Feb 2008 20:24:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rocket: Prepare for BKL pushdown
Message-ID: <20080220202405.4f151c36@core>
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

Wrap the ioctl code in lock_kernel calls

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/rocket.c linux-2.6.25-rc2-mm1/drivers/char/rocket.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/rocket.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/rocket.c	2008-02-20 11:48:44.000000000 +0000
@@ -1432,29 +1432,38 @@
 {
 	struct r_port *info = (struct r_port *) tty->driver_data;
 	void __user *argp = (void __user *)arg;
+	int ret = 0;
 
 	if (cmd != RCKP_GET_PORTS && rocket_paranoia_check(info, "rp_ioctl"))
 		return -ENXIO;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case RCKP_GET_STRUCT:
 		if (copy_to_user(argp, info, sizeof (struct r_port)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		break;
 	case RCKP_GET_CONFIG:
-		return get_config(info, argp);
+		ret = get_config(info, argp);
+		break;
 	case RCKP_SET_CONFIG:
-		return set_config(info, argp);
+		ret = set_config(info, argp);
+		break;
 	case RCKP_GET_PORTS:
-		return get_ports(info, argp);
+		ret = get_ports(info, argp);
+		break;
 	case RCKP_RESET_RM2:
-		return reset_rm2(info, argp);
+		ret = reset_rm2(info, argp);
+		break;
 	case RCKP_GET_VERSION:
-		return get_version(info, argp);
+		ret = get_version(info, argp);
+		break;
 	default:
-		return -ENOIOCTLCMD;
+		ret = -ENOIOCTLCMD;
 	}
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 static void rp_send_xchar(struct tty_struct *tty, char ch)
