Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYG2QLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYG2QLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYG2QLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:11:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:40503 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYG2QLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:11:09 -0400
Subject: Re: [PATCH] typhoon: use request_firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Dillow <dave@thedillows.org>
Cc: LKML <linux-kernel@vger.kernel.org>, becker@scyld.com,
       davidpmclean@yahoo.com, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1217295498.28682.16.camel@obelisk.thedillows.org>
References: <1217170232.3537.6.camel@jaswinder.satnam>
	 <1217209400.22789.47.camel@obelisk.thedillows.org>
	 <1217215009.2970.7.camel@jaswinder.satnam>
	 <1217248585.22789.58.camel@obelisk.thedillows.org>
	 <1217253260.17632.6.camel@jaswinder.satnam>
	 <1217295498.28682.16.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset=utf8
Date: Tue, 29 Jul 2008 21:39:46 +0530
Message-Id: <1217347786.2885.11.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Mon, 2008-07-28 at 21:38 -0400, David Dillow wrote:
> > +
> > +	/* firmware */
> > +	u8			*tp_fw_image;
> >  };
> 
> Now you keep one copy per NIC, which doubles the memory usage. Just use
> static struct firmware *typhoon_fw;
> 

OK, Fixed.

> > +static int typhoon_init_firmware(struct typhoon *tp)
> > +{
> > +	const struct firmware *fw;
> > +	const char fw_name[] = "3com/typhoon.bin";
> 
> If you use the #define and the global static, you can get rid of the
> above. Just use the define in place of fw_name below:
> 

OK, Fixed.

> > +	tp->tp_fw_image = vmalloc(fw->size);
> > +	if (!tp->tp_fw_image) {
> > +		err = -ENOMEM;
> > +		printk(KERN_ERR "%s: \"%s\" Failed %d\n",
> > +		       tp->name, fw_name, err);
> > +		goto out;
> > +	}
> 
> Then you can get rid of the double allocation and memcpy. Just put the
> call to release_firmware() in typhoon_cleanup().
> 

OK, Fixed.

> > +	err = typhoon_init_firmware(tp);
> > +	if (err)
> > +		goto out_irq;
> > +
> 
> This should move to either typhoon_init() or typhoon_init_one(). Putting
> it in typhoon_init() means we waste memory when the module is loaded if
> there is no typhoon NIC; putting it in typhoon_init_one() means it needs
> protection from threaded probing, should that ever be put back in. Given
> that most modern distros don't do probing by blinding loading modules,
> typhoon_init() seems a safe bet.
> 

Sorry Dave, I need tp->pdev so ﻿typhoon_init_one() seems better.
I hope you do not mind this.

> > @@ -2155,6 +2189,9 @@ typhoon_close(struct net_device *dev)
> 
> > +	if (tp->tp_fw_image)
> > +		vfree(tp->tp_fw_image);
> > +
> 
> This goes away and is replaced by a release_firmware() in
> typhoon_cleanup() if you do the above.
> 

OK, Fixed :)

Here is updated patch for typhoon.c :-

Subject: [PATCH] typhoon: use request_firmware

made following const as we treat firmware data as const:
        struct typhoon_file_header *fHdr
        struct typhoon_section_header *sHdr
        u8 *image_data

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 drivers/net/typhoon.c          |   33 +-
diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index c0dd25b..a57941a 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -130,16 +130,18 @@ static const int multicast_filter_limit = 32;
 #include <linux/in6.h>
 #include <linux/version.h>
 #include <linux/dma-mapping.h>
+#include <linux/firmware.h>
 
 #include "typhoon.h"
-#include "typhoon-firmware.h"
 
 static char version[] __devinitdata =
     "typhoon.c: version " DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
+#define FIRMWARE_NAME		"3com/typhoon.bin"
 MODULE_AUTHOR("David Dillow <dave@thedillows.org>");
 MODULE_VERSION(DRV_MODULE_VERSION);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FIRMWARE_NAME);
 MODULE_DESCRIPTION("3Com Typhoon Family (3C990, 3CR990, and variants)");
 MODULE_PARM_DESC(rx_copybreak, "Packets smaller than this are copied and "
 			       "the buffer given back to the NIC. Default "
@@ -1347,14 +1349,28 @@ typhoon_init_rings(struct typhoon *tp)
 	tp->txHiRing.lastRead = 0;
 }
 
+static const struct firmware *typhoon_fw;
+
+static int typhoon_init_firmware(struct typhoon *tp)
+{
+	int err;
+
+	err = request_firmware(&typhoon_fw, FIRMWARE_NAME, &tp->pdev->dev);
+	if (err)
+		printk(KERN_ERR "%s: Failed to load firmware \"%s\"\n",
+		       tp->name, FIRMWARE_NAME);
+
+	return err;
+}
+
 static int
 typhoon_download_firmware(struct typhoon *tp)
 {
 	void __iomem *ioaddr = tp->ioaddr;
 	struct pci_dev *pdev = tp->pdev;
-	struct typhoon_file_header *fHdr;
-	struct typhoon_section_header *sHdr;
-	u8 *image_data;
+	const struct typhoon_file_header *fHdr;
+	const struct typhoon_section_header *sHdr;
+	const u8 *image_data;
 	void *dpage;
 	dma_addr_t dpage_dma;
 	__sum16 csum;
@@ -1369,7 +1385,7 @@ typhoon_download_firmware(struct typhoon *tp)
 	int err;
 
 	err = -EINVAL;
-	fHdr = (struct typhoon_file_header *) typhoon_firmware_image;
+	fHdr = (struct typhoon_file_header *) typhoon_fw->data;
 	image_data = (u8 *) fHdr;
 
 	if(memcmp(fHdr->tag, "TYPHOON", 8)) {
@@ -2445,6 +2461,10 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	tp->name = pci_name(pdev);
 
+	err = typhoon_init_firmware(tp);
+	if (err)
+		goto error_out_reset;
+
 	typhoon_init_interface(tp);
 	typhoon_init_rings(tp);
 
@@ -2625,6 +2645,9 @@ typhoon_init(void)
 static void __exit
 typhoon_cleanup(void)
 {
+	if (typhoon_fw)
+		release_firmware(typhoon_fw);
+
 	pci_unregister_driver(&typhoon_driver);
 }
 
You can check complete patch from :-
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git

Thank you,

Jaswinder Singh.

