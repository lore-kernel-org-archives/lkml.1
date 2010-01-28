Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616Ab0A1SPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0A1SPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017Ab0A1SPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:15:05 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39238 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0A1SPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:15:01 -0500
Date: Thu, 28 Jan 2010 16:11:26 -0200
From: cascardo@holoscopio.com
To: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Status of 'toshiba-acpi: Add support for hotkey notifications'
 patch?
Message-ID: <20100128181116.GA3847@holoscopio.com>
References: <201001261759.01081.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <201001261759.01081.elendil@planet.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 26, 2010 at 05:59:00PM +0100, Frans Pop wrote:
> Hi Matthew,
>=20
> What's the status of the patch below [1]? IIRC you were waiting for feedb=
ack
> from a particular user?
>=20
> The patch works fine for me on my Satellite A40 and I'd like to see
> it included.
>=20
> Cheers,
> FJP
>=20

I'd recommend using the new sparse keymap feature instead of introducing
struct key_entry and scancode/keycode functions already in place in this
new feature.

Regards,
Cascardo.

> [1] Patch has been rebased for current mainline.
>=20
> Author: Matthew Garrett <mjg59@srcf.ucam.org>
> ~Subject: toshiba-acpi: Add support for hotkey notifications
>=20
> Calling the ENAB method on Toshiba laptops results in notifications being
> sent when laptop hotkeys are pressed. This patch simply calls that method
> and sets up an input device if it's successful.
>=20
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>=20
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/t=
oshiba_acpi.c
> index 77bf5d8..13344b1 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -46,6 +46,8 @@
>  #include <linux/backlight.h>
>  #include <linux/platform_device.h>
>  #include <linux/rfkill.h>
> +#include <linux/input-polldev.h>
> +#include <linux/input.h>
> =20
>  #include <asm/uaccess.h>
> =20
> @@ -62,9 +64,10 @@ MODULE_LICENSE("GPL");
> =20
>  /* Toshiba ACPI method paths */
>  #define METHOD_LCD_BRIGHTNESS	"\\_SB_.PCI0.VGA_.LCD_._BCM"
> -#define METHOD_HCI_1		"\\_SB_.VALD.GHCI"
> -#define METHOD_HCI_2		"\\_SB_.VALZ.GHCI"
> +#define TOSH_INTERFACE_1	"\\_SB_.VALD"
> +#define TOSH_INTERFACE_2	"\\_SB_.VALZ"
>  #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
> +#define GHCI_METHOD		".GHCI"
> =20
>  /* Toshiba HCI interface definitions
>   *
> @@ -116,6 +119,37 @@ static const struct acpi_device_id toshiba_device_id=
s[] =3D {
>  };
>  MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
> =20
> +struct key_entry {
> +	char type;
> +	u16 code;
> +	u16 keycode;
> +};
> +
> +enum {KE_KEY, KE_END};
> +
> +static struct key_entry toshiba_acpi_keymap[]  =3D {
> +	{KE_KEY, 0x101, KEY_MUTE},
> +	{KE_KEY, 0x13b, KEY_COFFEE},
> +	{KE_KEY, 0x13c, KEY_BATTERY},
> +	{KE_KEY, 0x13d, KEY_SLEEP},
> +	{KE_KEY, 0x13e, KEY_SUSPEND},
> +	{KE_KEY, 0x13f, KEY_SWITCHVIDEOMODE},
> +	{KE_KEY, 0x140, KEY_BRIGHTNESSDOWN},
> +	{KE_KEY, 0x141, KEY_BRIGHTNESSUP},
> +	{KE_KEY, 0x142, KEY_WLAN},
> +	{KE_KEY, 0x143, KEY_PROG1},
> +	{KE_KEY, 0x17f, KEY_BRIGHTNESSDOWN},
> +	{KE_KEY, 0xb05, KEY_PROG2},
> +	{KE_KEY, 0xb06, KEY_WWW},
> +	{KE_KEY, 0xb07, KEY_MAIL},
> +	{KE_KEY, 0xb30, KEY_STOP},
> +	{KE_KEY, 0xb31, KEY_PREVIOUSSONG},
> +	{KE_KEY, 0xb32, KEY_NEXTSONG},
> +	{KE_KEY, 0xb33, KEY_PLAYPAUSE},
> +	{KE_KEY, 0xb5a, KEY_MEDIA},
> +	{KE_END, 0, 0},
> +};
> +
>  /* utility
>   */
> =20
> @@ -251,6 +285,9 @@ static acpi_status hci_read2(u32 reg, u32 *out1, u32 =
*out2, u32=20
> *result)
>  struct toshiba_acpi_dev {
>  	struct platform_device *p_dev;
>  	struct rfkill *bt_rfk;
> +	struct input_polled_dev *poll_dev;
> +	struct input_dev *hotkey_dev;
> +	acpi_handle handle;
> =20
>  	const char *bt_name;
> =20
> @@ -711,6 +748,154 @@ static struct backlight_ops toshiba_backlight_data =
=3D {
>          .update_status  =3D set_lcd_status,
>  };
> =20
> +static struct key_entry *toshiba_acpi_get_entry_by_scancode(int code)
> +{
> +	struct key_entry *key;
> +
> +	for (key =3D toshiba_acpi_keymap; key->type !=3D KE_END; key++)
> +		if (code =3D=3D key->code)
> +			return key;
> +
> +	return NULL;
> +}
> +
> +static struct key_entry *toshiba_acpi_get_entry_by_keycode(int code)
> +{
> +	struct key_entry *key;
> +
> +	for (key =3D toshiba_acpi_keymap; key->type !=3D KE_END; key++)
> +		if (code =3D=3D key->keycode && key->type =3D=3D KE_KEY)
> +			return key;
> +
> +	return NULL;
> +}
> +
> +static int toshiba_acpi_getkeycode(struct input_dev *dev, int scancode,
> +				   int *keycode)
> +{
> +	struct key_entry *key =3D toshiba_acpi_get_entry_by_scancode(scancode);
> +
> +	if (key && key->type =3D=3D KE_KEY) {
> +		*keycode =3D key->keycode;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int toshiba_acpi_setkeycode(struct input_dev *dev, int scancode,
> +				   int keycode)
> +{
> +	struct key_entry *key;
> +	int old_keycode;
> +
> +	if (keycode < 0 || keycode > KEY_MAX)
> +		return -EINVAL;
> +
> +	key =3D toshiba_acpi_get_entry_by_scancode(scancode);
> +	if (key && key->type =3D=3D KE_KEY) {
> +		old_keycode =3D key->keycode;
> +		key->keycode =3D keycode;
> +		set_bit(keycode, dev->keybit);
> +		if (!toshiba_acpi_get_entry_by_keycode(old_keycode))
> +			clear_bit(old_keycode, dev->keybit);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static void toshiba_acpi_notify(acpi_handle handle, u32 event, void **da=
ta)
> +{
> +	u32 hci_result, value;
> +	struct key_entry *key;
> +
> +	if (event !=3D 0x80)
> +		return;
> +	do {
> +		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
> +		if (hci_result =3D=3D HCI_SUCCESS) {
> +			if (value =3D=3D 0x100)
> +				continue;
> +			else if (!(value & 0x80)) {
> +				key =3D toshiba_acpi_get_entry_by_scancode
> +					(value);
> +				if (!key) {
> +					printk(MY_INFO "Unknown key %x\n",
> +					       value);
> +					continue;
> +				}
> +				input_report_key(toshiba_acpi.hotkey_dev,
> +						 key->keycode, 1);
> +				input_sync(toshiba_acpi.hotkey_dev);
> +				input_report_key(toshiba_acpi.hotkey_dev,
> +						 key->keycode, 0);
> +				input_sync(toshiba_acpi.hotkey_dev);
> +			}
> +		} else if (hci_result =3D=3D HCI_NOT_SUPPORTED) {
> +			/* This is a workaround for an unresolved issue on
> +			 * some machines where system events sporadically
> +			 * become disabled. */
> +			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
> +			printk(MY_NOTICE "Re-enabled hotkeys\n");
> +		}
> +	} while (hci_result !=3D HCI_EMPTY);
> +}
> +
> +static int toshiba_acpi_setup_keyboard(char *device)
> +{
> +	acpi_status status;
> +	acpi_handle handle;
> +	int result;
> +	const struct key_entry *key;
> +
> +	status =3D acpi_get_handle(NULL, device, &handle);
> +	if (ACPI_FAILURE(status)) {
> +		printk(MY_INFO "Unable to get notification device\n");
> +		return -ENODEV;
> +	}
> +
> +	toshiba_acpi.handle =3D handle;
> +
> +	status =3D acpi_evaluate_object(handle, "ENAB", NULL, NULL);
> +	if (ACPI_FAILURE(status)) {
> +		printk(MY_INFO "Unable to enable hotkeys\n");
> +		return -ENODEV;
> +	}
> +
> +	status =3D acpi_install_notify_handler (handle, ACPI_DEVICE_NOTIFY,
> +					      toshiba_acpi_notify, NULL);
> +	if (ACPI_FAILURE(status)) {
> +		printk(MY_INFO "Unable to install hotkey notification\n");
> +		return -ENODEV;
> +	}
> +
> +	toshiba_acpi.hotkey_dev =3D input_allocate_device();
> +	if (!toshiba_acpi.hotkey_dev) {
> +		printk(MY_INFO "Unable to register input device\n");
> +		return -ENOMEM;
> +	}
> +
> +	toshiba_acpi.hotkey_dev->name =3D "Toshiba input device";
> +	toshiba_acpi.hotkey_dev->phys =3D device;
> +	toshiba_acpi.hotkey_dev->id.bustype =3D BUS_HOST;
> +	toshiba_acpi.hotkey_dev->getkeycode =3D toshiba_acpi_getkeycode;
> +	toshiba_acpi.hotkey_dev->setkeycode =3D toshiba_acpi_setkeycode;
> +
> +	for (key =3D toshiba_acpi_keymap; key->type !=3D KE_END; key++) {
> +		set_bit(EV_KEY, toshiba_acpi.hotkey_dev->evbit);
> +		set_bit(key->keycode, toshiba_acpi.hotkey_dev->keybit);
> +	}
> +
> +	result =3D input_register_device(toshiba_acpi.hotkey_dev);
> +	if (result) {
> +		printk(MY_INFO "Unable to register input device\n");
> +		return result;
> +	}
> +
> +	return 0;
> +}
> +
>  static void toshiba_acpi_exit(void)
>  {
>  	if (toshiba_acpi.bt_rfk) {
> @@ -718,9 +903,15 @@ static void toshiba_acpi_exit(void)
>  		rfkill_destroy(toshiba_acpi.bt_rfk);
>  	}
> =20
> +	if (toshiba_acpi.hotkey_dev)
> +		input_unregister_device(toshiba_acpi.hotkey_dev);
> +
>  	if (toshiba_backlight_device)
>  		backlight_device_unregister(toshiba_backlight_device);
> =20
> +	acpi_remove_notify_handler(toshiba_acpi.handle, ACPI_DEVICE_NOTIFY,
> +				   toshiba_acpi_notify);
> +
>  	remove_device();
> =20
>  	if (toshiba_proc_dir)
> @@ -742,11 +933,15 @@ static int __init toshiba_acpi_init(void)
>  		return -ENODEV;
> =20
>  	/* simple device detection: look for HCI method */
> -	if (is_valid_acpi_path(METHOD_HCI_1))
> -		method_hci =3D METHOD_HCI_1;
> -	else if (is_valid_acpi_path(METHOD_HCI_2))
> -		method_hci =3D METHOD_HCI_2;
> -	else
> +	if (is_valid_acpi_path(TOSH_INTERFACE_1 GHCI_METHOD)) {
> +		method_hci =3D TOSH_INTERFACE_1 GHCI_METHOD;
> +		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_1))
> +			printk(MY_INFO "Unable to activate hotkeys\n");
> +	} else if (is_valid_acpi_path(TOSH_INTERFACE_2 GHCI_METHOD)) {
> +		method_hci =3D TOSH_INTERFACE_2 GHCI_METHOD;
> +		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
> +			printk(MY_INFO "Unable to activate hotkeys\n");
> +	} else
>  		return -ENODEV;
> =20
>  	printk(MY_INFO "Toshiba Laptop ACPI Extras version %s\n",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkth00QACgkQyTpryRcqtS2KAACeK2WO0ksodH04QRkplBKZ9ERd
+QQAn3ztuVJSorneiV8eKycRZ62dTIpR
=RSH2
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
