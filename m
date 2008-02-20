Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbYBTUUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbYBTUUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYBTUUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:20:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59347 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953AbYBTUUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:20:31 -0500
Date: Wed, 20 Feb 2008 20:11:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] amiserial: Prepare for locking relaxation in caller.
Message-ID: <20080220201101.6fff0c59@core>
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


Just wrap this one in a lock_kernel. As I understand it there is no M68K
SMP anyway.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/amiserial.c linux-2.6.25-rc2-mm1/drivers/char/amiserial.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/amiserial.c	2008-02-19 11:01:44.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/amiserial.c	2008-02-20 11:45:28.000000000 +0000
@@ -1074,6 +1074,7 @@
 	if (!retinfo)
 		return -EFAULT;
 	memset(&tmp, 0, sizeof(tmp));
+	lock_kernel();
 	tmp.type = state->type;
 	tmp.line = state->line;
 	tmp.port = state->port;
@@ -1084,6 +1085,7 @@
 	tmp.close_delay = state->close_delay;
 	tmp.closing_wait = state->closing_wait;
 	tmp.custom_divisor = state->custom_divisor;
+	unlock_kernel();
 	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
@@ -1099,13 +1101,17 @@
 
 	if (copy_from_user(&new_serial,new_info,sizeof(new_serial)))
 		return -EFAULT;
+		
+	lock_kernel();
 	state = info->state;
 	old_state = *state;
   
 	change_irq = new_serial.irq != state->irq;
 	change_port = (new_serial.port != state->port);
-	if(change_irq || change_port || (new_serial.xmit_fifo_size != state->xmit_fifo_size))
+	if(change_irq || change_port || (new_serial.xmit_fifo_size != state->xmit_fifo_size)) {
+	  unlock_kernel();
 	  return -EINVAL;
+	}
   
 	if (!serial_isroot()) {
 		if ((new_serial.baud_base != state->baud_base) ||
@@ -1122,8 +1128,10 @@
 		goto check_and_exit;
 	}
 
-	if (new_serial.baud_base < 9600)
+	if (new_serial.baud_base < 9600) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
 	/*
 	 * OK, past this point, all the error checking has been done.
@@ -1157,6 +1165,7 @@
 		}
 	} else
 		retval = startup(info);
+	unlock_kernel();
 	return retval;
 }
 
