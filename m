Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZFCC4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZFCC4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZFCCzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:55:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbZFCCzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:55:50 -0400
Date: Wed, 3 Jun 2009 12:27:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>
Subject: linux-next: manual merge of the wireless tree with the acpi tree
Message-Id: <20090603122724.ddf679ba.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/platform/x86/toshiba_acpi.c between commit
76e310021ad9560fd02ce3d1e5723e5f0230ea7a ("toshiba_acpi: add full hotkey
support") from the acpi tree and commit
c6d660ce29295d344fcdc3654274b4a0aad1a9c8 ("rfkill: rewrite") from the
wireless tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/toshiba_acpi.c
index ce7de70,81d31ea..0000000
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@@ -45,8 -45,6 +45,7 @@@
  #include <linux/backlight.h>
  #include <linux/platform_device.h>
  #include <linux/rfkill.h>
- #include <linux/input-polldev.h>
 +#include <linux/input.h>
  
  #include <asm/uaccess.h>
  
@@@ -282,15 -249,9 +281,11 @@@ static acpi_status hci_read2(u32 reg, u
  
  struct toshiba_acpi_dev {
  	struct platform_device *p_dev;
- 	struct rfkill *rfk_dev;
- 	struct input_polled_dev *poll_dev;
+ 	struct rfkill *bt_rfk;
 +	struct input_dev *hotkey_dev;
 +	acpi_handle handle;
  
  	const char *bt_name;
- 	const char *rfk_name;
- 
- 	bool last_rfk_state;
  
  	struct mutex mutex;
  };
@@@ -734,167 -675,13 +709,164 @@@ static struct backlight_ops toshiba_bac
          .update_status  = set_lcd_status,
  };
  
 +static struct key_entry *toshiba_acpi_get_entry_by_scancode(int code)
 +{
 +	struct key_entry *key;
 +
 +	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
 +		if (code == key->code)
 +			return key;
 +
 +	return NULL;
 +}
 +
 +static struct key_entry *toshiba_acpi_get_entry_by_keycode(int code)
 +{
 +	struct key_entry *key;
 +
 +	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
 +		if (code == key->keycode && key->type == KE_KEY)
 +			return key;
 +
 +	return NULL;
 +}
 +
 +static int toshiba_acpi_getkeycode(struct input_dev *dev, int scancode,
 +				   int *keycode)
 +{
 +	struct key_entry *key = toshiba_acpi_get_entry_by_scancode(scancode);
 +
 +	if (key && key->type == KE_KEY) {
 +		*keycode = key->keycode;
 +		return 0;
 +	}
 +
 +	return -EINVAL;
 +}
 +
 +static int toshiba_acpi_setkeycode(struct input_dev *dev, int scancode,
 +				   int keycode)
 +{
 +	struct key_entry *key;
 +	int old_keycode;
 +
 +	if (keycode < 0 || keycode > KEY_MAX)
 +		return -EINVAL;
 +
 +	key = toshiba_acpi_get_entry_by_scancode(scancode);
 +	if (key && key->type == KE_KEY) {
 +		old_keycode = key->keycode;
 +		key->keycode = keycode;
 +		set_bit(keycode, dev->keybit);
 +		if (!toshiba_acpi_get_entry_by_keycode(old_keycode))
 +			clear_bit(old_keycode, dev->keybit);
 +		return 0;
 +	}
 +
 +	return -EINVAL;
 +}
 +
 +static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 +{
 +	u32 hci_result, value;
 +	struct key_entry *key;
 +
 +	if (event != 0x80)
 +		return;
 +	do {
 +		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
 +		if (hci_result == HCI_SUCCESS) {
 +			if (value == 0x100)
 +				continue;
 +			else if (value & 0x80) {
 +				key = toshiba_acpi_get_entry_by_scancode
 +					(value & ~0x80);
 +				if (!key) {
 +					printk(MY_INFO "Unknown key %x\n",
 +					       value & ~0x80);
 +					continue;
 +				}
 +				input_report_key(toshiba_acpi.hotkey_dev,
 +						 key->keycode, 1);
 +				input_sync(toshiba_acpi.hotkey_dev);
 +				input_report_key(toshiba_acpi.hotkey_dev,
 +						 key->keycode, 0);
 +				input_sync(toshiba_acpi.hotkey_dev);
 +			}
 +		} else if (hci_result == HCI_NOT_SUPPORTED) {
 +			/* This is a workaround for an unresolved issue on
 +			 * some machines where system events sporadically
 +			 * become disabled. */
 +			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
 +			printk(MY_NOTICE "Re-enabled hotkeys\n");
 +		}
 +	} while (hci_result != HCI_EMPTY);
 +}
 +
 +static int toshiba_acpi_setup_keyboard(char *device)
 +{
 +	acpi_status status;
 +	acpi_handle handle;
 +	int result;
 +	const struct key_entry *key;
 +
 +	status = acpi_get_handle(NULL, device, &handle);
 +	if (ACPI_FAILURE(status)) {
 +		printk(MY_INFO "Unable to get notification device\n");
 +		return -ENODEV;
 +	}
 +
 +	toshiba_acpi.handle = handle;
 +
 +	status = acpi_evaluate_object(handle, "ENAB", NULL, NULL);
 +	if (ACPI_FAILURE(status)) {
 +		printk(MY_INFO "Unable to enable hotkeys\n");
 +		return -ENODEV;
 +	}
 +
 +	status = acpi_install_notify_handler(handle, ACPI_DEVICE_NOTIFY,
 +					      toshiba_acpi_notify, NULL);
 +	if (ACPI_FAILURE(status)) {
 +		printk(MY_INFO "Unable to install hotkey notification\n");
 +		return -ENODEV;
 +	}
 +
 +	toshiba_acpi.hotkey_dev = input_allocate_device();
 +	if (!toshiba_acpi.hotkey_dev) {
 +		printk(MY_INFO "Unable to register input device\n");
 +		return -ENOMEM;
 +	}
 +
 +	toshiba_acpi.hotkey_dev->name = "Toshiba input device";
 +	toshiba_acpi.hotkey_dev->phys = device;
 +	toshiba_acpi.hotkey_dev->id.bustype = BUS_HOST;
 +	toshiba_acpi.hotkey_dev->getkeycode = toshiba_acpi_getkeycode;
 +	toshiba_acpi.hotkey_dev->setkeycode = toshiba_acpi_setkeycode;
 +
 +	for (key = toshiba_acpi_keymap; key->type != KE_END; key++) {
 +		set_bit(EV_KEY, toshiba_acpi.hotkey_dev->evbit);
 +		set_bit(key->keycode, toshiba_acpi.hotkey_dev->keybit);
 +	}
 +
 +	result = input_register_device(toshiba_acpi.hotkey_dev);
 +	if (result) {
 +		printk(MY_INFO "Unable to register input device\n");
 +		return result;
 +	}
 +
 +	return 0;
 +}
 +
  static void toshiba_acpi_exit(void)
  {
- 	if (toshiba_acpi.poll_dev) {
- 		input_unregister_polled_device(toshiba_acpi.poll_dev);
- 		input_free_polled_device(toshiba_acpi.poll_dev);
+ 	if (toshiba_acpi.bt_rfk) {
+ 		rfkill_unregister(toshiba_acpi.bt_rfk);
+ 		rfkill_destroy(toshiba_acpi.bt_rfk);
  	}
  
 +	if (toshiba_acpi.hotkey_dev)
 +		input_unregister_device(toshiba_acpi.hotkey_dev);
 +
- 	if (toshiba_acpi.rfk_dev)
- 		rfkill_unregister(toshiba_acpi.rfk_dev);
- 
  	if (toshiba_backlight_device)
  		backlight_device_unregister(toshiba_backlight_device);
  
