Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbXCYQaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbXCYQaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXCYQaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:30:55 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34131 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751735AbXCYQax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:30:53 -0400
Date: Sun, 25 Mar 2007 18:30:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Michael Krufky <mkrufky@linuxtv.org>, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch 00/31] 2.6.20-stable review
Message-ID: <20070325163057.GO16477@stusta.de>
References: <20070319213647.GB9261@kroah.com> <200703202304.44388.gene.heskett@gmail.com> <20070321033938.GA4907@suse.de> <200703202353.55577.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <200703202353.55577.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Mar 20, 2007 at 11:53:55PM -0400, Gene Heskett wrote:
> On Tuesday 20 March 2007, Greg KH wrote:
> [...]
> >> It looks like, from the series files contents, that I grabbed the
> >> wrong 'queue', its all 2.6.21 stuff.  url please.
> >
> >The patch queue can be found at:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> >
> >All of the patches and the series file are in the review-2.6.20/
> >directory.
> 
> This is not available via ftp?  My git is git version 0.99.7d, veddy veddy 
> long in the tooth by now I suspect.  And, apparently no manpages.  Humm, 
> smart is still running, maybe it has a newer git that's more conversant 
> with your syntax.  Yup smart is pulling it in now.  Later, thanks.

The attached patch was already reported as being responsible for a 
different regression.

Does reverting it help?

If not, and if you'll need any help with bisecting for the guilty patch, 
please send me a private email.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


--TRYliJ5NKNqkz5bu
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="adjust-legacy-ide-resource-setting.patch"

>From stable-bounces@linux.kernel.org Tue Mar 13 11:05:30 2007
From: Jan Beulich <jbeulich@novell.com>
Date: Tue, 13 Mar 2007 14:04:11 -0400
Subject: adjust legacy IDE resource setting (v2)
To: linux-stable <stable@kernel.org>
Message-ID: <45F6E79B.1010208@redhat.com>

From: Jan Beulich <jbeulich@novell.com>

adjust legacy IDE resource setting (v2)

The change to force legacy mode IDE channels' resources to fixed non-zero
values confuses (at least some versions of) X, because the values reported
by the kernel and those readable from PCI config space aren't consistent
anymore.  Therefore, this patch arranges for the respective BARs to also
get updated if possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/probe.c |   45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -639,7 +639,34 @@ static void pci_read_irq(struct pci_dev 
 	dev->irq = irq;
 }
 
-#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+static void change_legacy_io_resource(struct pci_dev * dev, unsigned index,
+                                      unsigned start, unsigned end)
+{
+	unsigned base = start & PCI_BASE_ADDRESS_IO_MASK;
+	unsigned len = (end | ~PCI_BASE_ADDRESS_IO_MASK) - base + 1;
+
+	/*
+	 * Some X versions get confused when the BARs reported through
+	 * /sys or /proc differ from those seen in config space, thus
+	 * try to update the config space values, too.
+	 */
+	if (!(pci_resource_flags(dev, index) & IORESOURCE_IO))
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (not I/O)\n",
+		       pci_name(dev), index);
+	else if (pci_resource_len(dev, index) != len)
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (size %04X)\n",
+		       pci_name(dev), index, (unsigned)pci_resource_len(dev, index));
+	else {
+		printk(KERN_INFO "%s: trying to change BAR%u from %04X to %04X\n",
+		       pci_name(dev), index,
+		       (unsigned)pci_resource_start(dev, index), base);
+		pci_write_config_dword(dev, PCI_BASE_ADDRESS_0 + index * 4, base);
+	}
+	pci_resource_start(dev, index) = start;
+	pci_resource_end(dev, index)   = end;
+	pci_resource_flags(dev, index) =
+		IORESOURCE_IO | IORESOURCE_PCI_FIXED | PCI_BASE_ADDRESS_SPACE_IO;
+}
 
 /**
  * pci_setup_device - fill in class and map information of a device
@@ -692,20 +719,12 @@ static int pci_setup_device(struct pci_d
 			u8 progif;
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				dev->resource[0].start = 0x1F0;
-				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = LEGACY_IO_RESOURCE;
-				dev->resource[1].start = 0x3F6;
-				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 0, 0x1F0, 0x1F7);
+				change_legacy_io_resource(dev, 1, 0x3F6, 0x3F6);
 			}
 			if ((progif & 4) == 0) {
-				dev->resource[2].start = 0x170;
-				dev->resource[2].end = 0x177;
-				dev->resource[2].flags = LEGACY_IO_RESOURCE;
-				dev->resource[3].start = 0x376;
-				dev->resource[3].end = 0x376;
-				dev->resource[3].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 2, 0x170, 0x177);
+				change_legacy_io_resource(dev, 3, 0x376, 0x376);
 			}
 		}
 		break;

--TRYliJ5NKNqkz5bu--
