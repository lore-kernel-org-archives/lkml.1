Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZFRB3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZFRB3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZFRB3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:29:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44776 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZFRB3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:29:05 -0400
Date: Thu, 18 Jun 2009 11:29:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: linux-next: manual merge of the wireless tree with the acpi tree
Message-Id: <20090618112904.bc72af37.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got conflicts in
drivers/platform/x86/eeepc-laptop.c between commits
eedd8dca3c0e6c1fcb5cba11321ea9d69917d85b ("eeepc-laptop: Register as a
pci-hotplug device") and 9f4b0f13e8346a42178d70b5079f46f7f886d13c ("ACPI:
eeepc-laptop: use .notify method instead of installing handler directly")
from the acpi tree and commit 372b1630720763fe276bd4ad439fa4799ed2112e
("eeepc-laptop: read rfkill soft-blocked state on resume") from the
wireless tree.

I fixed it up (see below - worth checking) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/eeepc-laptop.c
index a469275,8153b3e..0000000
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@@ -182,7 -180,7 +182,8 @@@ static struct key_entry eeepc_keymap[] 
   */
  static int eeepc_hotk_add(struct acpi_device *device);
  static int eeepc_hotk_remove(struct acpi_device *device, int type);
 +static void eeepc_hotk_notify(struct acpi_device *device, u32 event);
+ static int eeepc_hotk_resume(struct acpi_device *device);
  
  static const struct acpi_device_id eeepc_device_ids[] = {
  	{EEEPC_HOTK_HID, 0},
@@@ -198,7 -195,7 +199,8 @@@ static struct acpi_driver eeepc_hotk_dr
  	.ops = {
  		.add = eeepc_hotk_add,
  		.remove = eeepc_hotk_remove,
 +		.notify = eeepc_hotk_notify,
+ 		.resume = eeepc_hotk_resume,
  	},
  };
  
@@@ -526,20 -514,7 +528,20 @@@ static int notify_brn(void
  	return -1;
  }
  
 +static int eeepc_get_adapter_status(struct hotplug_slot *hotplug_slot,
 +				    u8 *value)
 +{
 +	int val = get_acpi(CM_ASL_WLAN);
 +
 +	if (val == 1 || val == 0)
 +		*value = val;
 +	else
 +		return -EINVAL;
 +
 +	return 0;
 +}
 +
- static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+ static void eeepc_rfkill_hotplug(void)
  {
  	struct pci_dev *dev;
  	struct pci_bus *bus = pci_find_bus(0, 1);
@@@ -578,7 -550,15 +577,15 @@@
  	rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill, blocked);
  }
  
+ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+ {
+ 	if (event != ACPI_NOTIFY_BUS_CHECK)
+ 		return;
+ 
+ 	eeepc_rfkill_hotplug();
+ }
+ 
 -static void eeepc_hotk_notify(acpi_handle handle, u32 event, void *data)
 +static void eeepc_hotk_notify(struct acpi_device *device, u32 event)
  {
  	static struct key_entry *key;
  	u16 count;
