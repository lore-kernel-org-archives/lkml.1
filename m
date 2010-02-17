Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab0BQFzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 00:55:17 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:48296 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0BQFzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 00:55:15 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2010 00:55:15 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E80U1sGMla+KsRUR3FCalXGQRCcHqR1ELjW56avWLhQ/0sLPdoexv6NCeIOPyBfm/B
         8H5pz+fhEQeL209vPHfBKvdvBAlTg0gnywDJVjiCZ58dSs2J8b401bbR1A0Qus5R1Pgb
         8ZEx0FJotTqTchFqFvHtMvF1XuyrLtss1Z7Zo=
Date: Tue, 16 Feb 2010 21:49:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bob Rodgers <Robert_Rodgers@dell.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "lenb@kernel.org" <lenb@kernel.org>,
       "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] v2 - Add Dell Business Class Netbook LED driver
Message-ID: <20100217054911.GE7160@core.coreip.homeip.net>
References: <4B75617B.4000805@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B75617B.4000805@dell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

On Fri, Feb 12, 2010 at 08:11:07AM -0600, Bob Rodgers wrote:
> This patch adds an LED driver to support the Dell Activity LED on the 
> Dell Latitude 2100 netbook and future products to come. The Activity LED 
> is visible externally in the lid so classroom instructors can observe it 
> from a distance. The driver uses the sysfs led_class and provides a 
> standard LED interface. This driver is ready for submission upstream.
> 
> Signed-off by: Bob Rodgers <Robert_Rodgers@dell.com>
> Signed-off-by: Louis Davis <Louis_Davis@dell.com>
> Signed-off-by: Jim Dailey <Jim_Dailey@dell.com>, Developers
> Acked-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> Description of changes in v2:
> 1) Added X86 and ACPI_WMI dependencies to the Kconfig file.
> 2) Removed platform_driver and platform_device as they are not needed in this driver.
> 

With the platform device stiff gone it looks much better, still a few
things:

> +
> +#include <linux/platform_device.h>

Do you still need platform_device.h?

> +#include <linux/acpi.h>
> +#include <linux/leds.h>
> +
> +MODULE_AUTHOR("Louis Davis/Jim Dailey");
> +MODULE_DESCRIPTION("Dell LED Control Driver");
> +MODULE_LICENSE("GPL");
> +
> +#define DELL_LED_BIOS_GUID "F6E4FE6E-909D-47cb-8BAB-C9F6F2F8D396"
> +MODULE_ALIAS("wmi:" DELL_LED_BIOS_GUID);
> +
> +/* Error Result Codes: */
> +#define INVALID_DEVICE_ID	250
> +#define INVALID_PARAMETER	251
> +#define INVALID_BUFFER		252
> +#define INTERFACE_ERROR		253
> +#define UNSUPPORTED_COMMAND	254
> +#define UNSPECIFIED_ERROR	255
> +
> +/* Device ID */
> +#define DEVICE_ID_PANEL_BACK	1
> +
> +/* LED Commands */
> +#define CMD_LED_ON	16
> +#define CMD_LED_OFF	17
> +#define CMD_LED_BLINK	18
> +
> +struct bios_args {
> +	unsigned char length;
> +	unsigned char result_code;
> +	unsigned char device_id;
> +	unsigned char command;
> +	unsigned char on_time;
> +	unsigned char off_time;
> +};
> +
> +static u8 dell_led_perform_fn(u8 length,
> +		u8 result_code,
> +		u8 device_id,
> +		u8 command,
> +		u8 on_time,
> +		u8 off_time)
> +{
> +	struct bios_args *bios_return;
> +	u8 return_code;
> +	union acpi_object *obj;
> +	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
> +	struct acpi_buffer input;
> +
> +	struct bios_args args;
> +	args.length = length;
> +	args.result_code = result_code;
> +	args.device_id = device_id;
> +	args.command = command;
> +	args.on_time = on_time;
> +	args.off_time = off_time;
> +
> +	input.length = sizeof(struct bios_args);
> +	input.pointer = &args;
> +
> +	wmi_evaluate_method(DELL_LED_BIOS_GUID,
> +		1,
> +		1,
> +		&input,
> +		&output);

This needs error handling.

> +
> +	obj = output.pointer;
> +
> +	if (!obj || obj->type != ACPI_TYPE_BUFFER)
> +		return -EINVAL;

You are leaking obj when obj is not NULL and is not a buffer.

> +
> +static int __init dell_led_init(void)
> +{
> +	int error = 0;
> +
> +	if (!wmi_has_guid(DELL_LED_BIOS_GUID)) {
> +		printk(KERN_DEBUG KBUILD_MODNAME
> +			": could not find: DELL_LED_BIOS_GUID\n");

Please ocnsider using pr_xxx() family.

> +		return -ENODEV;
> +	}
> +
> +	error = led_off();
> +	if (error != 0) {
> +		printk(KERN_DEBUG KBUILD_MODNAME

This is a warning or an error, not a debug.

Thank you.

-- 
Dmitry
