Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZFVD3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZFVD3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 23:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZFVD3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 23:29:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46649 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZFVD3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 23:29:08 -0400
Date: Mon, 22 Jun 2009 13:29:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <lenb@kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the net/wireless tree with the acpi
 tree
Message-Id: <20090622132906.6dc5b08c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/platform/x86/eeepc-laptop.c between commit
bd134968b9c14d3631e9e33599b27cef0e4d884e ("eeepc-laptop: rfkill
refactoring") from the acpi tree and commit
96e9cfeb9692b0bc6e03f9b6f9cb3c67a40b76d1 ("eeepc-laptop: read rfkill
soft-blocked state on resume") from the wireless tree.

The former changed the names of some structure entries that the latter
used.  I fixed it up (see below) and can carry the fix for a while.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/eeepc-laptop.c
index 67ad360,8153b3e..0000000
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@@ -191,7 -180,7 +191,8 @@@ static struct key_entry eeepc_keymap[] 
   */
  static int eeepc_hotk_add(struct acpi_device *device);
  static int eeepc_hotk_remove(struct acpi_device *device, int type);
 +static void eeepc_hotk_notify(struct acpi_device *device, u32 event);
+ static int eeepc_hotk_resume(struct acpi_device *device);
  
  static const struct acpi_device_id eeepc_device_ids[] = {
  	{EEEPC_HOTK_HID, 0},
@@@ -207,7 -195,7 +208,8 @@@ static struct acpi_driver eeepc_hotk_dr
  	.ops = {
  		.add = eeepc_hotk_add,
  		.remove = eeepc_hotk_remove,
 +		.notify = eeepc_hotk_notify,
+ 		.resume = eeepc_hotk_resume,
  	},
  };
  
@@@ -645,30 -514,14 +647,27 @@@ static int notify_brn(void
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
  	bool blocked;
  
- 	if (event != ACPI_NOTIFY_BUS_CHECK)
- 		return;
- 
  	if (!bus) {
 -		printk(EEEPC_WARNING "Unable to find PCI bus 1?\n");
 +		pr_warning("Unable to find PCI bus 1?\n");
  		return;
  	}
  
@@@ -694,10 -547,18 +693,18 @@@
  		}
  	}
  
 -	rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill, blocked);
 +	rfkill_set_sw_state(ehotk->wlan_rfkill, blocked);
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
@@@ -869,6 -741,33 +876,33 @@@ static int eeepc_hotk_remove(struct acp
  	return 0;
  }
  
+ static int eeepc_hotk_resume(struct acpi_device *device)
+ {
 -	if (ehotk->eeepc_wlan_rfkill) {
++	if (ehotk->wlan_rfkill) {
+ 		bool wlan;
+ 
+ 		/* Workaround - it seems that _PTS disables the wireless
+ 		   without notification or changing the value read by WLAN.
+ 		   Normally this is fine because the correct value is restored
+ 		   from the non-volatile storage on resume, but we need to do
+ 		   it ourself if case suspend is aborted, or we lose wireless.
+ 		 */
+ 		wlan = get_acpi(CM_ASL_WLAN);
+ 		set_acpi(CM_ASL_WLAN, wlan);
+ 
 -		rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill,
++		rfkill_set_sw_state(ehotk->wlan_rfkill,
+ 				    wlan != 1);
+ 
+ 		eeepc_rfkill_hotplug();
+ 	}
+ 
 -	if (ehotk->eeepc_bluetooth_rfkill)
 -		rfkill_set_sw_state(ehotk->eeepc_bluetooth_rfkill,
++	if (ehotk->bluetooth_rfkill)
++		rfkill_set_sw_state(ehotk->bluetooth_rfkill,
+ 				    get_acpi(CM_ASL_BLUETOOTH) != 1);
+ 
+ 	return 0;
+ }
+ 
  /*
   * Hwmon
   */
@@@ -1029,75 -922,6 +1063,75 @@@ static void __exit eeepc_laptop_exit(vo
  	platform_driver_unregister(&platform_driver);
  }
  
 +static int eeepc_new_rfkill(struct rfkill **rfkill,
 +			    const char *name, struct device *dev,
 +			    enum rfkill_type type, int cm)
 +{
 +	int result;
 +
 +	result = get_acpi(cm);
 +	if (result < 0)
 +		return result;
 +
 +	*rfkill = rfkill_alloc(name, dev, type,
 +			       &eeepc_rfkill_ops, (void *)(unsigned long)cm);
 +
 +	if (!*rfkill)
 +		return -EINVAL;
 +
- 	rfkill_set_sw_state(*rfkill, get_acpi(cm) != 1);
++	rfkill_init_sw_state(*rfkill, get_acpi(cm) != 1);
 +	result = rfkill_register(*rfkill);
 +	if (result) {
 +		rfkill_destroy(*rfkill);
 +		*rfkill = NULL;
 +		return result;
 +	}
 +	return 0;
 +}
 +
 +
 +static int eeepc_rfkill_init(struct device *dev)
 +{
 +	int result = 0;
 +
 +	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P6");
 +	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P7");
 +
 +	result = eeepc_new_rfkill(&ehotk->wlan_rfkill,
 +				  "eeepc-wlan", dev,
 +				  RFKILL_TYPE_WLAN, CM_ASL_WLAN);
 +
 +	if (result && result != -ENODEV)
 +		goto exit;
 +
 +	result = eeepc_new_rfkill(&ehotk->bluetooth_rfkill,
 +				  "eeepc-bluetooth", dev,
 +				  RFKILL_TYPE_BLUETOOTH, CM_ASL_BLUETOOTH);
 +
 +	if (result && result != -ENODEV)
 +		goto exit;
 +
 +	result = eeepc_new_rfkill(&ehotk->wwan3g_rfkill,
 +				  "eeepc-wwan3g", dev,
 +				  RFKILL_TYPE_WWAN, CM_ASL_3G);
 +
 +	if (result && result != -ENODEV)
 +		goto exit;
 +
 +	result = eeepc_setup_pci_hotplug();
 +	/*
 +	 * If we get -EBUSY then something else is handling the PCI hotplug -
 +	 * don't fail in this case
 +	 */
 +	if (result == -EBUSY)
 +		result = 0;
 +
 +exit:
 +	if (result && result != -ENODEV)
 +		eeepc_rfkill_exit();
 +	return result;
 +}
 +
  static int eeepc_backlight_init(struct device *dev)
  {
  	struct backlight_device *bd;
