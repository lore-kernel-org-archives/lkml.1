Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYFZPqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYFZPqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYFZPqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:46:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17564 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbYFZPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:46:20 -0400
Date: Thu, 26 Jun 2008 08:45:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Phillip Killewald <killewald.1@osu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Toshiba laptop bluetooth power control patch
Message-Id: <20080626084533.eac16d23.randy.dunlap@oracle.com>
In-Reply-To: <486382D7.6010105@osu.edu>
References: <486382D7.6010105@osu.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 13:51:51 +0200 Phillip Killewald wrote:

> Greetings,
> 
> This is my first post to the kernel mailing list.  I have found many
> people having the same problem with Toshiba laptops and their bluetooth
> devices.  Namely, the bluetooth device starts in a powered-off state,
> but the current toshiba_acpi module does not easily offer the option of
> modifying that state.  To rectify this, I have modified a version of a
> patch to toshiba_acpi.c found at
> http://www.sfires.net/toshiba/index.html, and have been using it
> successfully on my Toshiba M400 with all of the kernel versions since
> 2.6.21.  The patch creates an entry /proc/acpi/toshiba/bluetooth, which
> you can use to power-up and attach the bluetooth device with the
> commands cat 'power: 1' >> /proc/acpi/toshiba/bluetooth and 'attach: 1'
> >> /proc/acpi/toshiba/bluetooth.
> 
> Is there any way these changes can be incorporated into the kernel so I
> do not have to continually patch my system at every upgrade?  The text
> of the patch is below.

Hi Phillip,

a.  You should cc: the toshiba_acpi maintainer (from the MAINTAINERS file):

TOSHIBA ACPI EXTRAS DRIVER
P:	John Belmonte
M:	toshiba_acpi@memebeam.org
W:	http://memebeam.org/toys/ToshibaAcpiDriver
S:	Maintained


b.  It looks like thunderbird wrapped a few lines of your patch where they
should not have been split/broken.  See http://lkml.org/lkml/2008/6/26/228
for how it appears.  You can check if Documentation/email-clients.txt has
any useful help in it for Thunderbird.

c.  Look over Documentation/CodingStyle.  The patch has some unusual
style (lack of whitespace, etc.) in it that should be fixed.  I can go into
more detail on that if needed.


> ----------
> --- /usr/src/linux/drivers/acpi/toshiba_acpi.c.orig    2007-05-30
> 03:03:09.000000000 -0400
> +++ drivers/acpi/toshiba_acpi.c    2007-05-30 10:24:35.000000000 -0400
> @@ -33,7 +33,7 @@
>   *
>   */
>  
> -#define TOSHIBA_ACPI_VERSION    "0.18"
> +#define TOSHIBA_ACPI_VERSION    "0.18-p2"
>  #define PROC_INTERFACE_VERSION    1
>  
>  #include <linux/kernel.h>
> @@ -210,6 +210,26 @@
>      *result = (status == AE_OK) ? out[0] : HCI_FAILURE;
>      return status;
>  }
> +static acpi_status hci_write2(u32 reg, u32 in1, u32 in2, u32* result)
> +{
> +    u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
> +    u32 out[HCI_WORDS];
> +    acpi_status status = hci_raw(in, out);
> +    *result = (status == AE_OK) ? out[0] : HCI_FAILURE;
> +    return status;
> +}
> +
> +static acpi_status hci_read2(u32 reg, u32* out1, u32* out2, u32* result)
> +{
> +    u32 in[HCI_WORDS] = { HCI_GET, reg, *out1, *out2, 0, 0 };
> +    u32 out[HCI_WORDS];
> +    acpi_status status = hci_raw(in, out);
> +    *out1 = out[2];
> +    *out2 = out[3];
> +    *result = (status == AE_OK) ? out[0] : HCI_FAILURE;
> +    return status;
> +}
> +
>  
>  static struct proc_dir_entry *toshiba_proc_dir /*= 0*/ ;
>  static struct backlight_device *toshiba_backlight_device;
> @@ -482,6 +502,161 @@
>      return count;
>  }
>  
> +static char* read_wk(char* p)
> +{
> +    u32 hci_result;
> +    u32 value, value2;
> +    value = 0;
> +    value2 = 0x0001;
> +    hci_read2(0x0056, &value, &value2, &hci_result);
> +    if (hci_result == HCI_SUCCESS) {
> +        p += sprintf(p,"wireless key:                  %d\n", value );
> +    } else {
> +        p += sprintf(p, "ERROR\n");
> +    }
> +
> +    return p;
> +}
> +
> +static char* read_bt(char* p)
> +{
> +    u32 hci_result;
> +    u32 value, value2;
> +    value = 0;
> +    value2 = 0;
> +    hci_read2(0x0056, &value, &value2, &hci_result);
> +    if (hci_result == HCI_SUCCESS) {
> +/*      p += sprintf(p,"present:                  %d\n", value);*/
> +        p += sprintf(p,"present:                  %d\n", (value &
> 0x0f)?1:0);
> +    } else {
> +        p += sprintf(p, "ERROR\n");
> +    }
> +    value = 0;
> +    value2 = 0x0001;
> +    hci_read2(0x0056, &value, &value2, &hci_result);
> +    if (hci_result == HCI_SUCCESS) {
> +        p += sprintf(p,"power:                    %d\n", (value & 128)
> >> 7);
> +        p += sprintf(p,"attach:                   %d\n", (value &  64)
> >> 6);
> +        p += sprintf(p,"wireless:                 %d\n", (value & 512)
> >> 9);
> +    } else {
> +        p += sprintf(p, "ERROR\n");
> +    }
> +
> +    return p;
> +}
> +
> +static unsigned long write_bt(const char* buffer, unsigned long count)
> +{
> +    int value, value2;
> +    u32 hci_result;
> +    value2 = 0x0080;
> +
> +    if (sscanf(buffer, " power : %i", &value) == 1 &&
> +               value >= 0 && value <= 1) {
> +        hci_write2(0x0056, value, value2, &hci_result);
> +        if (hci_result != HCI_SUCCESS)
> +            return -EFAULT;
> +    } else if (sscanf(buffer, " attach : %i", &value) == 1 &&
> +                    value >= 0 && value <= 1) {
> +        value2 = 0x0040;
> +        hci_write2(0x0056, value, value2, &hci_result);
> +        if (hci_result != HCI_SUCCESS)
> +            return -EFAULT;
> +    } else if (sscanf(buffer, " orinoco : %i", &value) == 1 &&
> +                    value >= 0 && value <= 1) {
> +        value2 = 0x0200;
> +        hci_write2(0x0056, value, value2, &hci_result);
> +        if (hci_result != HCI_SUCCESS)
> +            return -EFAULT;
> +    } else {
> +        return -EINVAL;
> +    }
> +
> +    return count;
> +}
> +/*
> +static char* read_arb(char* p)
> +{
> +    u32 hci_result;
> +    u32 value, value2;
> +    value = 0;
> +    value2 = arbitrary2;
> +   
> +    p += sprintf(p,"arg1 :                  %d\n", value  );
> +    p += sprintf(p,"arg2 :                  %d\n", value2 );
> +
> +    hci_read2(arbitrary, &value, &value2, &hci_result);
> +    if (hci_result == HCI_SUCCESS) {
> +        p += sprintf(p,"arbitrary call:           %d\n", arbitrary);
> +        p += sprintf(p,"return1:                  %x\n", value);
> +        p += sprintf(p,"return2:                  %x\n",value2);
> +    } else
> +        p += sprintf(p, "ERROR\n");
> +
> +    return p;
> +}
> +
> +static unsigned long write_arb(const char* buffer, unsigned long count)
> +{
> +    int value, value2, i;
> +    value2 = 0x0080;
> +
> +    sscanf(buffer, " arb : %i", &value) ;
> +        arbitrary=value;
> +    i=0;
> +    while(buffer[i]!=';')i++; 
> +    if (sscanf(buffer+i+1, " arb2 : %i", &value) == 1 )
> +        arbitrary2=value;
> +    else     
> +            return -EINVAL;
> +
> +    return count;
> +}
> +
> +
> +static char* read_arb_c(char* p)
> +{
> +    u32 hci_result;
> +    u32 value, value2;
> +
> +    value = arbitrary1;
> +    value2 = arbitrary2;
> +    p += sprintf(p,"arg1 :                  %d\n", value  );
> +    p += sprintf(p,"arg2 :                  %d\n", value2 );
> +
> +    hci_write2(arbitrary, value, value2, &hci_result);
> +    if (hci_result == HCI_SUCCESS) {
> +        p += sprintf(p,"arbitrary call:                  %d\n", arbitrary);
> +        p += sprintf(p,"return1:                  %d\n", value);
> +        p += sprintf(p,"return2:                  %d\n",value2);
> +    } else
> +        p += sprintf(p, "ERROR\n");
> +
> +    return p;
> +}
> +
> +static unsigned long write_arb_c(const char* buffer, unsigned long count)
> +{
> +    int value, value2, i;
> +    value2 = 0x0080;
> +
> +    sscanf(buffer, " arb : %i", &value) ;
> +    arbitrary=value;
> +    i=0;
> +    while(buffer[i]!=';')i++;
> +    sscanf(buffer+i+1, " arb2 : %i", &value);
> +    arbitrary2=value;
> +    i++; 
> +    while(buffer[i]!=';')i++; 
> +    if (sscanf(buffer+i+1, " arb1 : %i", &value) == 1 )
> +        arbitrary1=value;
> +    else     
> +        return -EINVAL;
> +
> +    return count;
> +}
> +*/
> +
>  static char *read_version(char *p)
>  {
>      p += sprintf(p, "driver:                  %s\n", TOSHIBA_ACPI_VERSION);
> @@ -501,6 +676,8 @@
>      {"fan", read_fan, write_fan},
>      {"keys", read_keys, write_keys},
>      {"version", read_version, NULL},
> +    {"wireless_key",read_wk,0},
> +    {"bluetooth",read_bt,write_bt},
>      {NULL}
>  };
> ----------


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
