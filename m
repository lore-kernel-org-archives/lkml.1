Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbXG3Kgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbXG3Kgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 06:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXG3Kgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 06:36:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:18488 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbXG3Kgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 06:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=cDEIZxwJNoUYmU+sVlHIqy0QSchEHBMsvtffKqgfY8JmOvvtMcz7ota6C18+2qveR20zGRKAPtPnyVJGL4KH5cfrgbdb8SE1KokkggjR3ueTz9TpiYMA34Hl/m7jM/vVMub6WUHnzzJW+u3AC/3gMFFRuhA7Y7k9A3Ftlbc+JN0=
Message-ID: <46ADBF2C.6060902@gmail.com>
Date: Mon, 30 Jul 2007 19:36:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: ATA scsi driver misbehavior under kdump capture kernel
References: <46AA82D6.mailxB9W1BQ61V@eag09.americas.sgi.com>
In-Reply-To: <46AA82D6.mailxB9W1BQ61V@eag09.americas.sgi.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------060608020202000601080804"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060608020202000601080804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello, Cliff.

Cliff Wickman wrote:
> I've run into a problem with the ATA SCSI disk driver when running in a
> kdump dump-capture kernel.
> 
> I'm running on 2-processor x86_64 box.  It has 2 scsi disks, /dev/sda and
> /dev/sdb
> 
> My kernel is 2.6.22, and built to be a dump capturing kernel loaded by kexec.
> When I boot this kernel by itself, it finds both sda and sdb.
> 
> But when it is loaded by kexec and booted on a panic it only finds sda.
> 
> Any ideas from those familiar with the ATA driver?
> 
> 
> -Cliff Wickman
>  SGI
> 
> 
> I put some printk's into it and get this:
> 
> Standalone:
> 
>                                                    [nv_adma_error_handler]
> cpw: ata_host_register probe port 1 (error_handler:ffffffff81348625)
> cpw: ata_host_register call ata_port_probe
> cpw: ata_host_register call ata_port_schedule
> cpw: ata_host_register call ata_port_wait_eh
> cpw: ata_port_wait_eh entered
> cpw: ata_port_wait_eh, preparing to wait
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> cpw: ata_dev_configure entered
> cpw: ata_dev_configure testing class
> cpw: ata_dev_configure class is ATA_DEV_ATA
> ata2.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
> ata2.00: 390721968 sectors, multi 16: LBA48
> cpw: ata_dev_configure exiting
> cpw: ata_dev_configure entered
> cpw: ata_dev_configure testing class
> cpw: ata_dev_configure class is ATA_DEV_ATA
> cpw: ata_dev_configure exiting
> cpw: ata_dev_set_mode printing:
> ata2.00: configured for UDMA/133
> cpw: ata_port_wait_eh, finished wait
> cpw: ata_port_wait_eh exiting
> cpw: ata_host_register done with probe port 1
> 
> 
> When loaded with kexec and booted on a panic:
> 
> cpw: ata_host_register probe port 1 (error_handler:ffffffff81348625)
> cpw: ata_host_register call ata_port_probe
> cpw: ata_host_register call ata_port_schedule
> cpw: ata_host_register call ata_port_wait_eh
> cpw: ata_port_wait_eh entered
> cpw: ata_port_wait_eh, preparing to wait
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> cpw: ata_port_wait_eh, finished wait
> cpw: ata_port_wait_eh exiting
> cpw: ata_host_register done with probe port 1

Hmmm.. PHY is up but for some reason libata thought there was no device
there.  Can you try the attached patch and report the result?

-- 
tejun

--------------060608020202000601080804
Content-Type: text/x-patch;
 name="detect-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="detect-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6001aae..4bc042d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -732,6 +732,9 @@ ata_dev_try_classify(struct ata_port *ap, unsigned int device, u8 *r_err)
 	if (r_err)
 		*r_err = err;
 
+	ata_port_printk(ap, KERN_ERR, "XXX: try_classif dev%d e=%02x %02x:%02x:%02x\n",
+			device, err, tf.lbal, tf.lbam, tf.lbah);
+
 	/* see if device passed diags: if master then continue and warn later */
 	if (err == 0 && device == 0)
 		/* diagnostic fail : do nothing _YET_ */
@@ -3006,8 +3009,10 @@ int ata_wait_ready(struct ata_port *ap, unsigned long deadline)
 
 		if (!(status & ATA_BUSY))
 			return 0;
-		if (!ata_port_online(ap) && status == 0xff)
+		if (!ata_port_online(ap) && status == 0xff) {
+			ata_port_printk(ap, KERN_ERR, "XXX: wait_ready status=0xff\n");
 			return -ENODEV;
+		}
 		if (time_after(now, deadline))
 			return -EBUSY;
 
@@ -3037,8 +3042,10 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 	if (dev0) {
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
-			if (rc != -ENODEV)
+			if (rc != -ENODEV) {
+				ata_port_printk(ap, KERN_ERR, "XXX: post_reset dev0 rc=%d\n", rc);
 				return rc;
+			}
 			ret = rc;
 		}
 	}
@@ -3067,8 +3074,10 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
-			if (rc != -ENODEV)
+			if (rc != -ENODEV) {
+				printk("XXX: post_reset dev1 rc=%d\n", rc);
 				return rc;
+			}
 			ret = rc;
 		}
 	}
@@ -3113,8 +3122,11 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 	 * the bus shows 0xFF because the odd clown forgets the D7
 	 * pulldown resistor.
 	 */
-	if (ata_check_status(ap) == 0xFF)
+	if (ata_check_status(ap) == 0xFF) {
+		ata_port_printk(ap, KERN_ERR, "XXX: status=0xFF altstatus=0x%x\n",
+				ata_altstatus(ap));
 		return -ENODEV;
+	}
 
 	return ata_bus_post_reset(ap, devmask, deadline);
 }
@@ -3402,6 +3414,8 @@ int ata_std_softreset(struct ata_port *ap, unsigned int *classes,
 	if (slave_possible && ata_devchk(ap, 1))
 		devmask |= (1 << 1);
 
+	ata_port_printk(ap, KERN_ERR, "XXX: devmask=0x%x\n", devmask);
+
 	/* select device 0 again */
 	ap->ops->dev_select(ap, 0);
 

--------------060608020202000601080804--
