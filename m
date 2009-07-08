Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZGHO24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZGHO24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZGHO2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:28:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:37637 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbZGHO2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:28:47 -0400
Message-ID: <4A54AD1A.1040009@kernel.org>
Date: Wed, 08 Jul 2009 23:28:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christof Warlich <christof@warlich.name>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com> <4A51C929.5010909@warlich.name> <4A52931D.5070109@gmail.com> <4A52F39A.1030704@warlich.name> <4A5311C7.1020507@warlich.name> <4A535973.9090206@gmail.com> <4A5388EA.7030503@warlich.name> <4A53DA88.5080703@gmail.com> <4A543FA5.1090608@warlich.name>
In-Reply-To: <4A543FA5.1090608@warlich.name>
Content-Type: multipart/mixed;
 boundary="------------050408010800040109070601"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Jul 2009 14:28:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050408010800040109070601
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello, Christof, Robert.

Christof Warlich wrote:
> Robert Hancock schrieb:
>> Hmm, so we tried to disable the HPA and enable the entire disk
>> capacity, but the drive refused. But it somehow ends up in the HPA
>> disabled state upon resume. According to the ATA spec, the drive will
>> refuse SET MAX ADDRESS EXT commands after one has already been
>> executed upon power-on or reset. That suggests that the BIOS is
>> applying the HPA on bootup, but not on resume.

Arghhh... this is nasty.  Nasty.

I can't find previous messages.  Can you please post full boot log and
the output of "lspci -nn"?

>> Is there a BIOS update available for this machine?
> Updating the BIOS was the first thing I did when I got the machine,
> maybe two month ago. And only after that update suspend to disk began to
> work at least.
> 
> What about doing it the other way round: Forcing the kernel to apply the
> HPA on resume? Whitout knowing if this is possible at all with
> reasonable effort, it would bring us in sync having the HPA enabled for
> both bootup and resume, right?
> The only drawback would be that we stay having only the 128GiB available.
> 
> I'd assume that Windows XP may do it this way, as suspend to ram does
> work there and it also only sees the 128GiB.

AFAIK, wxp doesn't revalidate or doesn't consider device size while
revalidating disk after resume.  The size check during revalidation is
safety net which is there because ATA devices sometimes don't have
meaning identifiers and there are vendor specific configuration
options which may offset sectors differently and writing to devices in
such cases can lead to data loss.

If the bios configured HPA during boot, it should be restoring it on
resume too.  Maybe those commands have been filtered out.  Eh... no,
all filtered out commands are transfer mode related.  Dang.

One thing we can do is to make libata remember the native size on
initial probing and let revalidation consider it.  Yeap, that would
work.  Can you please test the attached patch and post full log
including boot and suspend/resume?

Thanks.

-- 
tejun

--------------050408010800040109070601
Content-Type: text/x-patch;
 name="revalidate-consider-native.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="revalidate-consider-native.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 045a486..4dadef1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1515,6 +1515,7 @@ static int ata_hpa_resize(struct ata_device *dev)
 
 		return rc;
 	}
+	dev->n_native_sectors = native_sectors;
 
 	/* nothing to do? */
 	if (native_sectors <= sectors || !ata_ignore_hpa) {
@@ -4089,6 +4090,7 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 		       unsigned int readid_flags)
 {
 	u64 n_sectors = dev->n_sectors;
+	u64 n_native_sectors = dev->n_native_sectors;
 	int rc;
 
 	if (!ata_dev_enabled(dev))
@@ -4118,16 +4120,29 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	/* verify n_sectors hasn't changed */
 	if (dev->class == ATA_DEV_ATA && n_sectors &&
 	    dev->n_sectors != n_sectors) {
-		ata_dev_printk(dev, KERN_INFO, "n_sectors mismatch "
+		ata_dev_printk(dev, KERN_WARNING, "n_sectors mismatch "
 			       "%llu != %llu\n",
 			       (unsigned long long)n_sectors,
 			       (unsigned long long)dev->n_sectors);
 
-		/* restore original n_sectors */
-		dev->n_sectors = n_sectors;
-
-		rc = -ENODEV;
-		goto fail;
+		/*
+		 * Something could have caused HPA to be unlocked
+		 * involuntarily.  If n_native_sectors hasn't changed
+		 * and the new size matches it, keep the device.
+		 */
+		if (dev->n_native_sectors == n_native_sectors &&
+		    dev->n_sectors > n_sectors &&
+		    dev->n_sectors == n_native_sectors) {
+			ata_dev_printk(dev, KERN_WARNING,
+				       "new n_sectors matches native, probably "
+				       "late HPA unlock, continuing\n");
+			dev->n_sectors = n_sectors;
+		} else {
+			/* restore original n_sectors */
+			dev->n_sectors = n_sectors;
+			rc = -ENODEV;
+			goto fail;
+		}
 	}
 
 	return 0;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3d501db..5fde0a9 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -588,6 +588,7 @@ struct ata_device {
 #endif
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			n_native_sectors; /* native size, if ATA */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	unsigned long		unpark_deadline;
 

--------------050408010800040109070601--
