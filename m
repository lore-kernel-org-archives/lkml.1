Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZJ0P1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZJ0P1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZJ0P1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:27:16 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59975 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754345AbZJ0P1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:27:15 -0400
Message-ID: <4AE71167.7060506@sgi.com>
Date: Tue, 27 Oct 2009 08:27:35 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, Myron Stowe <myron.stowe@hp.com>,
       Feng Tang <feng.tang@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] SGI x86_64 UV: Limit the number of ACPI messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	 <20091023233754.668088000@alcatraz.americas.sgi.com> <1256354987.17875.6.camel@dc7800.home>
In-Reply-To: <1256354987.17875.6.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
...
> 
> I know we print way too much stuff for every processor, but again, I'd
> rather see all CPUs or none.  I think there's a little more value in
> this one than the cooling device one (probably because I do a lot of
> platform bringup), but it could certainly be made KERN_DEBUG and/or
> combined with another processor discovery line.

Is this more acceptable?

Thanks,
Mike
--- 

SGI x86_64 UV: Limit the number of ACPI messages

Limit number of ACPI messages of the form:

[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x00] enabled)

[   99.638655] processor ACPI0007:00: registered as cooling_device0

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Myron Stowe <myron.stowe@hp.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/acpi/fan.c            |    2 +-
 drivers/acpi/processor_core.c |    3 +--
 drivers/acpi/tables.c         |   13 ++++++++-----
 3 files changed, 10 insertions(+), 8 deletions(-)

--- linux.orig/drivers/acpi/fan.c
+++ linux/drivers/acpi/fan.c
@@ -267,7 +267,7 @@
 		goto end;
 	}
 
-	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
+	dev_dbg(&device->dev, "registered as cooling_device%d\n", cdev->id);
 
 	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
--- linux.orig/drivers/acpi/processor_core.c
+++ linux/drivers/acpi/processor_core.c
@@ -845,8 +845,7 @@
 		goto err_power_exit;
 	}
 
-	dev_info(&device->dev, "registered as cooling_device%d\n",
-		 pr->cdev->id);
+	dev_dbg(&device->dev, "registered as cooling_device%d\n", pr->cdev->id);
 
 	result = sysfs_create_link(&device->dev.kobj,
 				   &pr->cdev->device.kobj,
--- linux.orig/drivers/acpi/tables.c
+++ linux/drivers/acpi/tables.c
@@ -170,11 +170,14 @@
 	case ACPI_MADT_TYPE_LOCAL_SAPIC:
 		{
 			struct acpi_madt_local_sapic *p =
-			    (struct acpi_madt_local_sapic *)header;
-			printk(KERN_INFO PREFIX
-			       "LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
-			       p->processor_id, p->id, p->eid,
-			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
+				(struct acpi_madt_local_sapic *)header;
+
+			printk(KERN_DEBUG PREFIX
+				"LSAPIC (acpi_id[0x%02x] "
+				"lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
+				p->processor_id, p->id, p->eid,
+				(p->lapic_flags & ACPI_MADT_ENABLED) ?
+					"enabled" : "disabled");
 		}
 		break;
 
