Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbXJVCae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbXJVCae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXJVCa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:30:26 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:60209 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXJVCa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:30:26 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] Add bluetooth support to toshiba-acpi driver
To: Jonathan McDowell <noodles@earth.li>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 22 Oct 2007 06:30:19 +0400
References: <20071021173529.GH1880@earth.li>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <20071022023023.07D74983989@smtp05.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan McDowell wrote:

> This patch adds bluetooth support to the toshiba-acpi driver. I have
> tried to follow the same format for the /proc/acpi/toshiba/bluetooth
> file as followed in the thinkpad-acpi driver. In the long term the
> rfkill infrastructure looks like the way forward for this functionality,
> but at present it doesn't seem to be suitable.
> 

Would it be possible (make sense) to add config option for that? There are
probably a bunch of older models out there that do not have BT at all (I am
owner of such one).

Thank you

-andrey

> Traditionally the userland "toshset" program would have been used to
> enable bluetooth, but this requires either CONFIG_TOSHIBA or a patched
> toshiba-acpi to emulate the /dev/toshiba device. Also toshset doesn't
> currently run in 64bit mode.
> 
> Patch has been successfully tested on a Portégé R200 (in 32bit mode) and
> an R500 (in 64bit mode).
> 
> Signed-Off-By: Jonathan McDowell <noodles@earth.li>
> 
> -----
> --- drivers/acpi/toshiba_acpi.c.orig  2007-10-21 18:29:01.000000000 +0100
> +++ drivers/acpi/toshiba_acpi.c       2007-10-21 18:15:34.000000000 +0100
> @@ -33,7 +33,7 @@
>   *
>   */
>  
> -#define TOSHIBA_ACPI_VERSION "0.18"
> +#define TOSHIBA_ACPI_VERSION "0.19"
>  #define PROC_INTERFACE_VERSION       1
>  
>  #include <linux/kernel.h>
> @@ -55,6 +55,7 @@ MODULE_LICENSE("GPL");
>  #define MY_ERR KERN_ERR MY_LOGPREFIX
>  #define MY_NOTICE KERN_NOTICE MY_LOGPREFIX
>  #define MY_INFO KERN_INFO MY_LOGPREFIX
> +#define strlencmp(a,b) (strncmp((a), (b), strlen(b)))
>  
>  /* Toshiba ACPI method paths */
>  #define METHOD_LCD_BRIGHTNESS        "\\_SB_.PCI0.VGA_.LCD_._BCM"
> @@ -90,6 +91,7 @@ MODULE_LICENSE("GPL");
>  #define HCI_VIDEO_OUT                        0x001c
>  #define HCI_HOTKEY_EVENT             0x001e
>  #define HCI_LCD_BRIGHTNESS           0x002a
> +#define HCI_BLUETOOTH                        0x0056
>  
>  /* field definitions */
>  #define HCI_LCD_BRIGHTNESS_BITS              3
> @@ -482,6 +484,129 @@ static unsigned long write_keys(const ch
>  return count;
>  }
>  
> +static int toshiba_bluetooth_present(void)
> +{
> +     u32 hci_result;
> +     u32 value;
> +
> +     hci_read1(HCI_BLUETOOTH, &value, &hci_result);
> +     if (hci_result == HCI_SUCCESS) {
> +             return (value & 0x0f) == 0x0f;
> +     } else
> +             return -EFAULT;
> +}
> +
> +static int toshiba_bluetooth_get(void)
> +{
> +     u32 in[HCI_WORDS];
> +     u32 out[HCI_WORDS];
> +     acpi_status status;
> +
> +     in[0] = HCI_GET;
> +     in[1] = HCI_BLUETOOTH;
> +     in[2] = 0;
> +     in[3] = 1;
> +     status = hci_raw(in, out);
> +     if (status != AE_OK) {
> +             printk(MY_ERR "Error checking Bluetooth device status.\n");
> +             return -EIO;
> +     }
> +
> +     /* 0x1 == switch on, 0x40 == attached, 0x80 == power on */
> +     return (out[2] & 0xC1) == 0xC1;
> +}
> +
> +static int toshiba_bluetooth_set(int state)
> +{
> +     u32 in[HCI_WORDS];
> +     u32 out[HCI_WORDS];
> +     acpi_status status;
> +
> +     switch (state) {
> +     case 0:
> +             in[0] = HCI_SET;
> +             in[1] = HCI_BLUETOOTH;
> +             in[2] = 0;
> +             in[3] = 0x40;
> +             status = hci_raw(in, out);
> +             if (status != AE_OK) {
> +                     printk(MY_ERR "Error detaching Bluetooth device.\n");
> +                     return -EIO;
> +             }
> +
> +             in[0] = HCI_SET;
> +             in[1] = HCI_BLUETOOTH;
> +             in[2] = 0;
> +             in[3] = 0x80;
> +             status = hci_raw(in, out);
> +             if (status != AE_OK) {
> +                     printk(MY_ERR "Error deactivating Bluetooth device.\n");
> +                     return -EIO;
> +             }
> +             break;
> +     case 1:
> +             in[0] = HCI_SET;
> +             in[1] = HCI_BLUETOOTH;
> +             in[2] = 1;
> +             in[3] = 0x80;
> +             status = hci_raw(in, out);
> +             if (status != AE_OK) {
> +                     printk(MY_ERR "Error activating Bluetooth device.\n");
> +                     return -EIO;
> +             }
> +
> +             in[0] = HCI_SET;
> +             in[1] = HCI_BLUETOOTH;
> +             in[2] = 1;
> +             in[3] = 0x40;
> +             status = hci_raw(in, out);
> +             if (status != AE_OK) {
> +                     printk(MY_ERR "Error attaching Bluetooth device.\n");
> +                     return -EIO;
> +             }
> +             break;
> +     default:
> +             printk(MY_ERR "Unknown state for Bluetooth.\n");
> +     };
> +
> +     return 0;
> +}
> +
> +static char *read_bluetooth(char *p)
> +{
> +     int value = toshiba_bluetooth_get();
> +
> +     if (!toshiba_bluetooth_present()) {
> +             p += sprintf(p, "status:\t\tnot supported\n");
> +     } else if (value >= 0) {
> +             p += sprintf(p, "status:\t\t%s\n",
> +                             value ? "enabled" : "disabled");
> +             p += sprintf(p, "commands:\tenable, disable\n");
> +     } else {
> +             printk(MY_ERR "Error reading bluetooth status.\n");
> +     }
> +
> +     return p;
> +}
> +
> +static unsigned long write_bluetooth(const char *buffer, unsigned long
> count) +{
> +     int ret ;
> +
> +     if (!toshiba_bluetooth_present()) {
> +             ret = -ENODEV;
> +     } else if (strlencmp(buffer, "enable") == 0) {
> +             toshiba_bluetooth_set(1);
> +             ret = count;
> +     } else if (strlencmp(buffer, "disable") == 0) {
> +             toshiba_bluetooth_set(0);
> +             ret = count;
> +     } else {
> +             ret = -EINVAL;
> +     }
> +     return ret;
> +}
> +
>  static char *read_version(char *p)
>  {
>  p += sprintf(p, "driver:                  %s\n", TOSHIBA_ACPI_VERSION);
> @@ -496,6 +621,7 @@ static char *read_version(char *p)
>  #define PROC_TOSHIBA         "toshiba"
>  
>  static ProcItem proc_items[] = {
> +     {"bluetooth", read_bluetooth, write_bluetooth},
>  {"lcd", read_lcd, write_lcd},
>  {"video", read_video, write_video},
>  {"fan", read_fan, write_fan},
> -----
> 
> J.
> 


