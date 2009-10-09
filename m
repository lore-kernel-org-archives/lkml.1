Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbZJIXRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbZJIXRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761675AbZJIXRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:47 -0400
Received: from kroah.org ([198.145.64.141]:36849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761708AbZJIXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:03 2009
Message-Id: <20091009231003.272029049@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:09:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <jdelvare@suse.de>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 25/26] ACPI: Clarify resource conflict message
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=acpi-clarify-resource-conflict-message.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <jdelvare@suse.de>

commit 14f03343ad1080c2fea29ab2c13f05b976c4584e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/osl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
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


