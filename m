Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYAKQlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYAKQlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbYAKQlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:41:09 -0500
Received: from ts.adaptec.com ([162.62.93.58]:42647 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304AbYAKQlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:41:07 -0500
From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Fri, 11 Jan 2008 08:41:04 -0800
Subject: [RFC] aacraid: driver feature flags?
Thread-Topic: [RFC] aacraid: driver feature flags?
Thread-Index: Acgci4Yt2iA4UnBvSre5X+z3cyv6rAEyZGvwDDa+IzAAAGLYIAAAeOvwAADG8HAAAIEosAACN6vgAIplMoAAANv5oA==
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F437E44117@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE738@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE739@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE73E@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F437E96989@ADPE2K703.adaptec.com>
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F437E96989@ADPE2K703.adaptec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feature enhancement.

Do we have a developing standard on how a driver may report to user tools via sysfs what features are supported or not by the driver? In the following I am proposing a 'flags' entry that will reside in the host controllers tree, with a newline separated list of arbitrary ascii named features that indicate whether the combination of driver and controller has support for said feature. Breaking from the one-line output typical of sysfs entries, newline was added to tailor for grep, or simple gets line by line string match within an application. I added one for a compiler time check for existence of debug print output, one for an optional manifest defined enhanced status reporting in the logs, and one for runtime reporting whether the controller and driver supports arrays larger than 2TB to my example below.

Suggestions?

This following patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's handling of patch attachments, so one can NOT use the following to patch, it is only present to demonstrate the idea.

 drivers/scsi/aacraid/linit.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -ru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c      2008-01-11 11:19:11.378159940 -0500
+++ b/drivers/scsi/aacraid/linit.c      2008-01-11 11:23:19.040145945 -0500
@@ -788,6 +788,23 @@
        return len;
 }

+static ssize_t aac_show_flags(struct class_device *class_dev, char *buf)
+{
+       int len = 0;
+       struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
+
+       if (nblank(dprintk(x)))
+               len = snprintf(buf, PAGE_SIZE, "dprintk\n");
+#      ifdef AAC_DETAILED_STATUS_INFO
+               len += snprintf(buf + len, PAGE_SIZE - len,
+                 "AAC_DETAILED_STATUS_INFO\n");
+#      endif
+       if (dev->raw_io_interface && dev->raw_io_64)
+               len += snprintf(buf + len, PAGE_SIZE - len,
+                 "SAI_READ_CAPACITY_16\n");
+       return len;
+}
+
 static ssize_t aac_show_kernel_version(struct class_device *class_dev,
                char *buf)
 {
@@ -897,6 +914,13 @@
        },
        .show = aac_show_vendor,
 };
+static struct class_device_attribute aac_flags = {
+       .attr = {
+               .name = "flags",
+               .mode = S_IRUGO,
+       },
+       .show = aac_show_flags,
+};
 static struct class_device_attribute aac_kernel_version = {
        .attr = {
                .name = "hba_kernel_version",
@@ -951,6 +975,7 @@
 static struct class_device_attribute *aac_attrs[] = {
        &aac_model,
        &aac_vendor,
+       &aac_flags,
        &aac_kernel_version,
        &aac_monitor_version,
        &aac_bios_version,
