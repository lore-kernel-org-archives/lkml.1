Return-Path: <linux-kernel-owner+w=401wt.eu-S933595AbXK2VCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbXK2VCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761871AbXK2VCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:02:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:11236 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761089AbXK2VCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=NpcGikivYhO+54Yd2ZbcRiGJJbiIPAEBX3uzJL5B2NbZ+SEbSHH+8rtEWg2yF9x5SdwiXzSikQxEQuwb/edopb5FQ0YQrwW50MOvKW4HgSqjP2HFPOkx4m36CyG5+tLLcBTpCf3SEwIYEuznAg/C/pnbC3lLE33wSyvp5aE9crg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Relax permissions for reading hard drive serial number?
Date: Thu, 29 Nov 2007 22:07:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: "Dan Kegel" <dank@kegel.com>, "Xavier Bestel" <xavier.bestel@free.fr>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
References: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com> <a71bd89a0711290746q57002217ga14c4f4f7201683d@mail.gmail.com> <3ae72650711290939w4fee581fm6f0d65a33abf1b82@mail.gmail.com>
In-Reply-To: <3ae72650711290939w4fee581fm6f0d65a33abf1b82@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711292207.46967.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2007, Kay Sievers wrote:
> On Nov 29, 2007 4:46 PM, Dan Kegel <dank@kegel.com> wrote:
> > On Nov 29, 2007 7:37 AM, Xavier Bestel <xavier.bestel@free.fr> wrote:
> > > > One sticking point is that apps like Photoshop and probably
> > > > Punkbuster want to retrieve the hard drive's serial number
> > >
> > > So they can't be installed on a network drive ?
> >
> > I think Adobe supports that, though perhaps not with the
> > retail version.  Big companies with network drives are
> > probably an important revenue source for them.
> >
> > I haven't looked closely at what happens when you try installing
> > onto network drives.  If you are really interested, it's pretty easy to
> > try yourself; just run the app under wine with
> > WINEDEBUG=+cdrom,+disk and look in the log for calls like
> > CreateFile("\\\\.\\PhysicalDrive0", ...).
> > There's some chance the code always checks drive 0 instead
> > of the drive you're installing onto.
> 
> There are people who, for privacy reasons, really don't like that "unique"
> unchangeable serial numbers can be retrieved by untrusted users.
> 
> You should probably chmod the file on the users system, if he is fine with
> that, but not change the kernel default.

Seconded.

While on it, how's about exporting model/firmware/serial through
sysfs so /proc/ide/hd*/identify don't have to be used?

[PATCH] ide: add /sys/bus/ide/devices/*/{model,firmware,serial} sysfs entries

Cc: Dan Kegel <dank@kegel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1670,10 +1670,34 @@ static ssize_t modalias_show(struct devi
 	return sprintf(buf, "ide:m-%s\n", media_string(drive));
 }
 
+static ssize_t model_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", drive->id->model);
+}
+
+static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", drive->id->fw_rev);
+}
+
+static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", drive->id->serial_no);
+}
+
 static struct device_attribute ide_dev_attrs[] = {
 	__ATTR_RO(media),
 	__ATTR_RO(drivename),
 	__ATTR_RO(modalias),
+	__ATTR_RO(model),
+	__ATTR_RO(firmware),
+	__ATTR(serial, 0400, serial_show, NULL),
 	__ATTR_NULL
 };
 
