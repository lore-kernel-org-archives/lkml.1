Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbZJWBAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbZJWBAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZJWBAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:00:05 -0400
Received: from kroah.org ([198.145.64.141]:39495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZJWA7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 20:59:37 -0400
Date: Thu, 22 Oct 2009 17:36:46 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Re: Linux 2.6.27.38
Message-ID: <20091023003646.GB23961@kroah.com>
References: <20091023003633.GA23961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023003633.GA23961@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index e063536..3be1470 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .37
+EXTRAVERSION = .38
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ee6be59..5f76f55 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -243,10 +243,7 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
  */
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
-	struct scsi_cmnd *cmd;
-	unsigned char *buf;
-
-	cmd = scsi_host_alloc_command(shost, gfp_mask);
+	struct scsi_cmnd *cmd = scsi_host_alloc_command(shost, gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -260,9 +257,15 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
 		if (cmd) {
+			void *buf, *prot;
+
 			buf = cmd->sense_buffer;
+			prot = cmd->prot_sdb;
+
 			memset(cmd, 0, sizeof(*cmd));
+
 			cmd->sense_buffer = buf;
+			cmd->prot_sdb = prot;
 		}
 	}
 
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 240aad1..657fc25 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -892,16 +892,16 @@ static void digi_rx_unthrottle(struct tty_struct *tty)
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 
-	/* turn throttle off */
-	priv->dp_throttled = 0;
-	priv->dp_throttle_restart = 0;
-
 	/* restart read chain */
 	if (priv->dp_throttle_restart) {
 		port->read_urb->dev = port->serial->dev;
 		ret = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	}
 
+	/* turn throttle off */
+	priv->dp_throttled = 0;
+	priv->dp_throttle_restart = 0;
+
 	spin_unlock_irqrestore(&priv->dp_port_lock, flags);
 
 	if (ret)
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 9fcc272..579796a 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -973,6 +973,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		if (retval > 0) {
 			/* quietly accept this device, but don't bind to a
 			   serial port as it's about to disappear */
+			serial->num_ports = 0;
 			goto exit;
 		}
 	}
