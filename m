Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbZJBOvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbZJBOvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbZJBOvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:51:24 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:39181 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbZJBOvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:51:23 -0400
Date: Fri, 02 Oct 2009 10:51:09 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: stable@kernel.org
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 2.6.31.stable] ACPI: Clarify resource conflict message
Message-id: <alpine.LFD.2.00.0910021048230.25240@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

upstream 14f03343ad1080c2fea29ab2c13f05b976c4584e

>From 14f03343ad1080c2fea29ab2c13f05b976c4584e Mon Sep 17 00:00:00 2001
From: Jean Delvare <jdelvare@suse.de>
Date: Tue, 8 Sep 2009 15:31:46 +0200
Subject: [PATCH] ACPI: Clarify resource conflict message
X-Patchwork-Hint: ignore

The message "ACPI: Device needs an ACPI driver" is misleading. The
device _may_ need an ACPI driver, if the BIOS implemented a custom
API for the device in question (which, AFAIK, can't be checked.) If
not, then either a generic ACPI driver may be used (for example
"thermal"), or nothing can be done (other than a white list).

I propose to reword the message to:

ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver

which I think is more correct. Comments and suggestions welcome.

I also added a message warning about possible problems and system
instability when users pass acpi_enforce_resources=lax, as suggested
by Len.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/osl.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

Index: linux-2.6.31.y/drivers/acpi/osl.c
===================================================================
--- linux-2.6.31.y.orig/drivers/acpi/osl.c
+++ linux-2.6.31.y/drivers/acpi/osl.c
@@ -1182,7 +1182,13 @@ int acpi_check_resource_conflict(struct 
 			       res_list_elem->name,
 			       (long long) res_list_elem->start,
 			       (long long) res_list_elem->end);
-			printk(KERN_INFO "ACPI: Device needs an ACPI driver\n");
+			if (acpi_enforce_resources == ENFORCE_RESOURCES_LAX)
+				printk(KERN_NOTICE "ACPI: This conflict may"
+				       " cause random problems and system"
+				       " instability\n");
+			printk(KERN_INFO "ACPI: If an ACPI driver is available"
+			       " for this device, you should use it instead of"
+			       " the native driver\n");
 		}
 		if (acpi_enforce_resources == ENFORCE_RESOURCES_STRICT)
 			return -EBUSY;
