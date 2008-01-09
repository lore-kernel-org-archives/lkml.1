Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYAIRlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYAIRlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYAIRlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:41:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52578 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbYAIRlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:41:23 -0500
Date: Wed, 9 Jan 2008 09:44:59 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.13
Message-ID: <20080109174459.GB11284@kroah.com>
References: <20080109174434.GA11284@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109174434.GA11284@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 96c3f02..55edf2f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 23
-EXTRAVERSION = .12
+EXTRAVERSION = .13
 NAME = Arr Matey! A Hairy Bilge Rat!
 
 # *DOCUMENTATION*
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index d9a9ec7..bfd8828 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1276,23 +1276,31 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 
 	data->vrm = vid_which_vrm();
 	superio_enter(sio_data->sioreg);
-	/* Set VID input sensibility if needed. In theory the BIOS should
-	   have set it, but in practice it's not always the case. */
-	en_vrm10 = superio_inb(sio_data->sioreg, SIO_REG_EN_VRM10);
-	if ((en_vrm10 & 0x08) && data->vrm != 100) {
-		dev_warn(dev, "Setting VID input voltage to TTL\n");
-		superio_outb(sio_data->sioreg, SIO_REG_EN_VRM10,
-			     en_vrm10 & ~0x08);
-	} else if (!(en_vrm10 & 0x08) && data->vrm == 100) {
-		dev_warn(dev, "Setting VID input voltage to VRM10\n");
-		superio_outb(sio_data->sioreg, SIO_REG_EN_VRM10,
-			     en_vrm10 | 0x08);
-	}
 	/* Read VID value */
 	superio_select(sio_data->sioreg, W83627EHF_LD_HWM);
-	if (superio_inb(sio_data->sioreg, SIO_REG_VID_CTRL) & 0x80)
+	if (superio_inb(sio_data->sioreg, SIO_REG_VID_CTRL) & 0x80) {
+		/* Set VID input sensibility if needed. In theory the BIOS
+		   should have set it, but in practice it's not always the
+		   case. We only do it for the W83627EHF/EHG because the
+		   W83627DHG is more complex in this respect. */
+		if (sio_data->kind == w83627ehf) {
+			en_vrm10 = superio_inb(sio_data->sioreg,
+					       SIO_REG_EN_VRM10);
+			if ((en_vrm10 & 0x08) && data->vrm == 90) {
+				dev_warn(dev, "Setting VID input voltage to "
+					 "TTL\n");
+				superio_outb(sio_data->sioreg, SIO_REG_EN_VRM10,
+					     en_vrm10 & ~0x08);
+			} else if (!(en_vrm10 & 0x08) && data->vrm == 100) {
+				dev_warn(dev, "Setting VID input voltage to "
+					 "VRM10\n");
+				superio_outb(sio_data->sioreg, SIO_REG_EN_VRM10,
+					     en_vrm10 | 0x08);
+			}
+		}
+
 		data->vid = superio_inb(sio_data->sioreg, SIO_REG_VID_DATA) & 0x3f;
-	else {
+	} else {
 		dev_info(dev, "VID pins in output mode, CPU VID not "
 			 "available\n");
 		data->vid = 0x3f;
