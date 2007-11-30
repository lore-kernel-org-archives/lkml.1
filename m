Return-Path: <linux-kernel-owner+w=401wt.eu-S934534AbXK3P1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbXK3P1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbXK3P10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:27:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54321 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944AbXK3P1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:27:25 -0500
Date: Fri, 30 Nov 2007 15:23:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, jeff@garzik.org,
       akpm@osdl.org
Subject: [PATCH] libata: Fix early use of port printk. (Was Re:
 ata4294967295: failed to start port (errno=-19))
Message-ID: <20071130152316.32e2effa@the-village.bc.nu>
In-Reply-To: <Pine.SOC.4.64.0711301433130.13468@math.ut.ee>
References: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>
	<20071128200716.14eccfdd@the-village.bc.nu>
	<Pine.SOC.4.64.0711301433130.13468@math.ut.ee>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 14:34:11 +0200 (EET)
Meelis Roos <mroos@linux.ee> wrote:

> > Can you stick a stack trace in at that point ? That would help diagnose
> > it a great deal quicker.
> 
> Finally done - found out hard way that BUG() is too bad and 
> dump_st5ack() suits me better.

Thanks. This should fix the real cause, and also allow for port start to
fail politely with -ENODEV.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/ata/libata-core.c linux-2.6.24-rc2-mm1/drivers/ata/libata-core.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/ata/libata-core.c	2007-11-16 17:55:11.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/ata/libata-core.c	2007-11-30 14:31:56.093473744 +0000
@@ -6999,12 +7014,11 @@
 		if (ap->ops->port_start) {
 			rc = ap->ops->port_start(ap);
 			if (rc) {
-				ata_port_printk(ap, KERN_ERR, "failed to "
-						"start port (errno=%d)\n", rc);
+				if (rc != -ENODEV)
+					dev_printk(KERN_ERR, host->dev, "failed to start port %d (errno=%d)\n", i, rc);
 				goto err_out;
 			}
 		}
-
 		ata_eh_freeze_port(ap);
 	}
 


--
"Twenty-five million records of children's names and addresses have
 disappeared. Given the amount of data that the Government are collecting, no
 doubt including whether the children have been bad or good, and that it is
 six weeks before Christmas, it is blindingly obvious who has taken them."
                               -- Desmond Swayne MP



