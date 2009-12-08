Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZLHKFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZLHKFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZLHKFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:05:16 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53963 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZLHKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:05:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AOS4mFurAh1QyVJeYBOhmd0hfwh/wmx9UE0K5kJWm8l3H+Dj8L5gB5h9gyouvDpmEg
         eGChnf4zuZhRJR4ilQZ1xwnvrH1Jefclx1957R/ycEN8K3+mYJawxCwC8/bybnGeJEOt
         vxqqo5LkrBSZPizNFTmpYyefDjOcYrbG+oHTE=
MIME-Version: 1.0
In-Reply-To: <4B192D08.9080608@gmail.com>
References: <4B192D08.9080608@gmail.com>
Date: Tue, 8 Dec 2009 10:05:19 +0000
Message-ID: <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com>
Subject: Re: [PATCH] Toshiba Bluetooth enabler (rfkill)
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/09, Jes Sorensen <jes.sorensen@gmail.com> wrote:
> Hi,
>
> This patch adds a new driver to catch RFKill events to the Bluetooth
> device on modern Toshiba laptops. Without it, the Bluetooth device is
> simply lost on my Portege R500 when the RFKill switch is flipped, and
> doesn't come back until after a reboot.
>
> It binds to the TOS6205 ACPI device and doesn't touch any existing
> code.
>
> Cheers,
> Jes

Cool.  This must be the shortest ACPI driver :-).

Try to send patches inline if possible, it makes them easier to review.


>
> +static int toshiba_bt_rfkill_add(struct acpi_device *device);
>

I think it's simpler to avoid the need for forward declarations, e.g.
by putting the driver structure after the ops functions.  I suppose
it's a matter of taste though.

>
> +static struct acpi_driver toshiba_bt_rfkill_driver = {
> +	.name =		"Toshiba BT",
> +	.class =	"Toshiba",
> +	.ids =		bt_device_ids,
> +	.ops =		{
>

Please also set

	.owner = THIS_MODULE,

in order to provide the correct information under
/sys/module/x/drivers and /sys/bus/acpi/drivers/x/module

>
> +static int toshiba_bluetooth_enable(acpi_handle handle)
> +{
> +	acpi_status res1, res2;
> +	acpi_integer result;
> +
> +	/* Query ACPI to verify RFKill switch is set to on */
> +	res1 = acpi_evaluate_integer(handle, "BTST", NULL, &result);
> +	if (ACPI_FAILURE(res1) || !(result & 0x01))
> +		return -EBUSY;
...
> +static int toshiba_bt_resume(struct acpi_device *device)
> +{
> +	return toshiba_bluetooth_enable(device->handle);
> +}
>

Good to see you're handling resume, but what happens if the rfkill
switch is _not_ set to on?  It looks like resume will return an error,
which will produce a warning message in the kernel log.  I don't think
we want that.

> +static int toshiba_bt_rfkill_add(struct acpi_device *device)
> +{
> +	acpi_status status;
> +	acpi_integer bt_present;
> +	int result = -ENODEV;
> +
> +	status = acpi_evaluate_integer(device->handle, "_STA", NULL,
> +				       &bt_present);

I think this would benefit from an explanation.


/* Some models include a placeholder for the TOS6205 device, but don't
use it */ ?

/* May be disabled in BIOS */ ?

/* This device has _STA, not sure why, but let's honour it if disabled */ ?


That might give us an idea of what to do if we find a model which
doesn't have _STA :-).

Personally I'd err on the side of allowing for models without _STA.
You could handle that by checking that it exists before trying to
evaluate it.  If there's some reason for not doing this, I think it
should also be mentioned in a comment.

>
> +	result = acpi_bus_register_driver(&toshiba_bt_rfkill_driver);
> +	if (result < 0) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
> +				  "Error registering driver\n"));
> +		return -ENODEV;
> +	}

I would suggest you return result, instead of ignoring it and always
returning ENODEV.

> +	depends on RFKILL
> +	depends on BT

But you doesn't use either of these subsystems :-). The BT one
definitely seems bogus; please drop it.

I think you _could_ export an rfkill device.  It would at least be
useful for trouble-shooting, because it lets userspace read the
current state in a generic way.  So I would recommend doing so in the
future, even though most current userspaces won't do anything
interesting with it.  Given that the BIOS sets the state when the
switch is turned off, I would recommend you expose it as a "hard"
block - so you don't let userspace change the state.

But I wouldn't let that hold the driver up, since it serves an
important purpose  even without creating an rfkill device.

Regards
Alan
