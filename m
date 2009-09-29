Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbZI2Qla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbZI2Qla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZI2Ql3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:41:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:38703 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZI2Ql2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:41:28 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: ACPI boot memory leaks in 2.6.32-rc1/2
Date: Tue, 29 Sep 2009 10:41:30 -0600
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com
References: <c4e36d110909290218g3f98c595kaa15566b94527f04@mail.gmail.com>
In-Reply-To: <c4e36d110909290218g3f98c595kaa15566b94527f04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909291041.31481.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 September 2009 03:18:53 am Zdenek Kabelac wrote:
> My qemu guest seems to be reporting now 46 memleaks  ACPI related.

Thanks a lot for the report!

Can you verify that the patch below fixes these leaks?


commit fff7774a805e392ce258f0342e48cbe682ef2b9b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Sep 29 10:32:19 2009 -0600

    ACPI: fix bus scanning memory leaks
    
    Free an acpi_get_object_info() buffer when we're finished.  Skip the
    acpi_get_name() altogether -- it was only used for a printk that was
    really just for debug anyway.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 468921b..14a7481 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1052,6 +1052,8 @@ static void acpi_device_set_id(struct acpi_device *device)
 			device->flags.bus_address = 1;
 		}
 
+		kfree(info);
+
 		/*
 		 * Some devices don't reliably have _HIDs & _CIDs, so add
 		 * synthetic HIDs to make sure drivers can find them.
@@ -1325,13 +1327,8 @@ static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
 			 struct acpi_device **child)
 {
 	acpi_status status;
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	void *device = NULL;
 
-	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
-	printk(KERN_INFO PREFIX "Enumerating devices from [%s]\n",
-	       (char *) buffer.pointer);
-
 	status = acpi_bus_check_add(handle, 0, ops, &device);
 	if (ACPI_SUCCESS(status))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
