Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZJ0Csk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZJ0Csk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZJ0Csj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:48:39 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19484 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbZJ0Csi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:48:38 -0400
Date: Mon, 26 Oct 2009 20:48:41 -0600
From: Alex Chiang <achiang@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091027024841.GA30509@ldl.fc.hp.com>
References: <20091012145254.GA1517@kroah.com> <20091012145700.GJ9228@kernel.dk> <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026105419.GA10727@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe <jens.axboe@oracle.com>:
> > > acpiphp: enable_slot - physical_slot = 1
> > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > acpiphp: enable_slot - physical_slot = 2
> > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > acpiphp: enable_slot - physical_slot = 6
> > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > acpiphp: enable_slot - physical_slot = 7
> > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > 
> > Hm, so for some reason, firmware on your machine is telling us
> > that it doesn't think cards are present and/or enabled.
> > 
> > Unfortunately, I don't know why your firmware would be saying
> > that. We could add some more debug printks to see what firmware
> > thinks about your system... Or we could just wait and see what
> > happens after you get your hardware replaced.

Let's try and find out why firmware is telling us that we didn't
get ACPI_STA_ALL.

Can you please apply this debug patch and send the output? Again,
please modprobe with debug=1.

Thanks,
/ac

---
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 58d25a1..2caa447 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -797,9 +797,13 @@ static int power_on_slot(struct acpiphp_slot *slot)
 	struct list_head *l;
 	int retval = 0;
 
+	printk("%s\n", __func__);
+
 	/* if already enabled, just skip */
-	if (slot->flags & SLOT_POWEREDON)
+	if (slot->flags & SLOT_POWEREDON) {
+		printk("  slot %ld already powered on\n", slot->sun);
 		goto err_exit;
+	}
 
 	list_for_each (l, &slot->funcs) {
 		func = list_entry(l, struct acpiphp_func, sibling);
@@ -813,6 +817,8 @@ static int power_on_slot(struct acpiphp_slot *slot)
 				goto err_exit;
 			} else
 				break;
+		} else {
+			printk("  no _PS0\n");
 		}
 	}
 
@@ -1122,11 +1128,14 @@ static unsigned int get_slot_status(struct acpiphp_slot *slot)
 	struct list_head *l;
 	struct acpiphp_func *func;
 
+	printk("%s\n", __func__);
+
 	list_for_each (l, &slot->funcs) {
 		func = list_entry(l, struct acpiphp_func, sibling);
 
 		if (func->flags & FUNC_HAS_STA) {
 			status = acpi_evaluate_integer(func->handle, "_STA", NULL, &sta);
+			printk("  FUNC_HAS_STA status %d _STA %#lx\n", status, sta);
 			if (ACPI_SUCCESS(status) && sta)
 				break;
 		} else {
@@ -1134,6 +1143,7 @@ static unsigned int get_slot_status(struct acpiphp_slot *slot)
 						  PCI_DEVFN(slot->device,
 							    func->function),
 						  PCI_VENDOR_ID, &dvid);
+			printk("  reading config space dvid %#lx\n", dvid);
 			if (dvid != 0xffffffff) {
 				sta = ACPI_STA_ALL;
 				break;

