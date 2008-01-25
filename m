Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbYAYUTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbYAYUTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYAYUTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:19:14 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:27638 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbYAYUTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:19:13 -0500
X-Belgacom-Dynamic: yes
Date: Fri, 25 Jan 2008 21:19:11 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>
Subject: DMI: add-type-41
Message-ID: <20080125201911.GB3234@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Would appreciate feedback on this patch.

Thanks in advance,
Wim.

commit 4956e4e5e77b5a8f87bcfe6127ef17a406edf94b
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Dec 31 17:21:33 2007 +0000

    [PATCH] SMBIOS/DMI - add type 41 = Onboard Devices Extended Information
    
    From version 2.6 of the SMBIOS standard, type 10 (On Board Devices Information)
    becomes obsolete. The reason for this is that no further fields can be added to
    this structure without adversely affecting existing software's ability to
    properly parse the data.
    
    Therefore type 41 (Onboard Devices Extended Information) was added.
    The structure is as follows:
    	struct smbios_type_41 {
    		u8 type;
    		u8 length;
    		u16 handle;
    		u8 reference_designation_string;
    		u8 device_type;		/* same device type as in type 10 */
    		u8 device_type_instance;
    		u16 segment_group_number;
    		u8 bus_number;
    		u8 device_function_number;
    	};
    
    For more info: http://www.dmtf.org/standards/smbios
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 0cdadea..c1b2891 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -222,6 +222,28 @@ static void __init dmi_save_ipmi_device(const struct dmi_header *dm)
 	list_add(&dev->list, &dmi_devices);
 }
 
+static void __init dmi_save_extended_devices(const struct dmi_header *dm)
+{
+	const u8 *d = (u8*) dm + 5;
+	struct dmi_device *dev;
+
+	/* Skip disabled device */
+	if ((*d & 0x80) == 0)
+		return;
+
+	dev = dmi_alloc(sizeof(*dev));
+	if (!dev) {
+		printk(KERN_ERR "dmi_save_extended_devices: out of memory.\n");
+		return;
+	}
+
+	dev->type = *d-- & 0x7f;
+	dev->name = dmi_string(dm, *d);
+	dev->device_data = NULL;
+
+	list_add(&dev->list, &dmi_devices);
+}
+
 /*
  *	Process a DMI table entry. Right now all we care about are the BIOS
  *	and machine entries. For 2.5 we should pull the smbus controller info
@@ -264,6 +286,9 @@ static void __init dmi_decode(const struct dmi_header *dm)
 		break;
 	case 38:	/* IPMI Device Information */
 		dmi_save_ipmi_device(dm);
+		break;
+	case 41:	/* Onboard Devices Extended Information */
+		dmi_save_extended_devices(dm);
 	}
 }
 
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 00fc7a9..f9ba4b0 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -35,8 +35,11 @@ enum dmi_device_type {
 	DMI_DEV_TYPE_ETHERNET,
 	DMI_DEV_TYPE_TOKENRING,
 	DMI_DEV_TYPE_SOUND,
+	DMI_DEV_TYPE_PATA,
+	DMI_DEV_TYPE_SATA,
+	DMI_DEV_TYPE_SAS,
 	DMI_DEV_TYPE_IPMI = -1,
-	DMI_DEV_TYPE_OEM_STRING = -2
+	DMI_DEV_TYPE_OEM_STRING = -2,
 };
 
 struct dmi_header {
