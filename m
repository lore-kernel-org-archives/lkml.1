Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYHFNLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYHFNLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbYHFNLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:11:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53968 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbYHFNL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:11:27 -0400
Date: Wed, 6 Aug 2008 07:11:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Matt_Domsch@dell.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long Physical Sectors
Message-ID: <20080806131109.GH2055@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx> <1217957207-23116-3-git-send-email-matthew@wil.cx> <20080805214651.621263f5@lxorguk.ukuu.org.uk> <20080806022255.GC2055@parisc-linux.org> <20080806100647.21529284@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806100647.21529284@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:06:47AM +0100, Alan Cox wrote:
> > I'm not sure that's necessary.  The spec says to check whether words are
> > valid by doing the & 0xc000 == 0x4000 test.
> 
> What early spec says what state word 106 is in ? Healthy paranoia is a
> good idea in the IDE world because its all a bit murky in the early days
> and you get some quite strange ident data from early devices - one reason
> for 0xC000 = 0x4000 is that some early drives use 0xFFFF for unknown words
> for example!

ATA-1 says that word 106 is reserved (and further that reserved means
the drive shall return 0).  I don't have a spec earlier than that.

I suspect the ATA spec writers are assuming that no drive puts random
bits there.  all-0 and all-1 make sense, but alternating 0 and 1 are
unlikely.  At least, it's good enough for us for checking words 48, 76, 78,
83, 84 and 87, so I'm not sure why 106 would be different.

> > good migration path?  We could have the driver set a flag, or call into
> > the driver from the midlayer to check whether it can cope with a
> > particular sector size.
> 
> On the driver side I need to know so I can control the FIFO so I guess
> knowing when you start/end planning to use large sector sizes. The driver
> could do it per command but the cost is almost certainly not worth it as
> I'd expect us to stick to a size. A driver method would do the trick
> nicely if it could return -EOPNOTSUPP or similar.

Obviously it is going to change per command -- because different
commands have different sizes.  I was thinking that we could call the
driver to see if it can handle a particular sector size right after we
get the IDENTIFY data.  

Something like this, perhaps:

diff --git a/drivers/ata/ata_ram.c b/drivers/ata/ata_ram.c
index 7479b69..7c30e97 100644
--- a/drivers/ata/ata_ram.c
+++ b/drivers/ata/ata_ram.c
@@ -595,11 +595,17 @@ static bool ata_ram_qc_fill_rtf(struct ata_queued_cmd *qc)
 	return true;
 }
 
+static bool ata_ram_sector_size_supported(struct ata_device *dev)
+{
+	return 1;
+}
+
 static struct ata_port_operations ata_ram_port_ops = {
 	.qc_fill_rtf = ata_ram_qc_fill_rtf,
 	.qc_prep = ata_ram_qc_prep,
 	.qc_issue = ata_ram_qc_issue,
 	.error_handler = ata_ram_error_handler,
+	.sector_size_supported = ata_ram_sector_size_supported,
 };
 
 static struct scsi_host_template ata_ram_template = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8f38d0c..28f16fb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2236,6 +2236,20 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
 }
 
+static int ata_check_sect_size(struct ata_device *dev)
+{
+	/* Every device can handle 512 byte sectors */
+	if (dev->sect_size == 512)
+		return 0;
+	/* Linux doesn't handle sectors larger than 4GB.  This may be a
+	 * problem around 2050 or so.  Deal with it then.  */
+	if (dev->sect_size > 0xffffffffULL)
+		return -EINVAL;
+	if (!dev->link->ap->ops->sector_size_supported)
+		return -EINVAL;
+	return dev->link->ap->ops->sector_size_supported(dev) ? 0 : -EINVAL;
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2356,10 +2370,10 @@ int ata_dev_configure(struct ata_device *dev)
 
 		dev->n_sectors = ata_id_n_sectors(id);
 		dev->sect_size = ata_id_sect_size(id);
-		if (dev->sect_size > 0xffffffffULL) {
-			ata_dev_printk(dev, KERN_ERR, "sector size larger than "
-						"4GB not supported.\n");
-			rc = -EINVAL;
+		rc = ata_check_sect_size(dev);
+		if (rc) {
+			ata_dev_printk(dev, KERN_ERR, "sector size %lld not "
+					"supported.\n", dev->sect_size);
 			goto err_out_nosup;
 		}
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index fcf84d1..16a2132 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -754,6 +754,7 @@ struct ata_port_operations {
 	unsigned int (*read_id)(struct ata_device *dev, struct ata_taskfile *tf, u16 *id);
 
 	void (*dev_config)(struct ata_device *dev);
+	bool (*sector_size_supported)(struct ata_device *dev);
 
 	void (*freeze)(struct ata_port *ap);
 	void (*thaw)(struct ata_port *ap);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
