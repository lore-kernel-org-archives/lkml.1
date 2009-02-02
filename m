Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZBBLih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZBBLih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZBBLi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:38:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:51689 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZBBLi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:38:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ho2iiq02Kdnl0x/CSbPtpIXM3VTy8sEgU6obaa/8rObqZedQdIx1dufSSTOYL5Cgav
         i0dguqWh9ysOfhUfK5SoJuGysxgKvWZUhllkMwUcAhihYmOe1YwTOyhNcsNoPyTzW8BZ
         Uk2U5UIYGbDpGle+QkFDU+vNwj5znBOnI8x7c=
MIME-Version: 1.0
In-Reply-To: <20090202101103.1208c035@hyperion.delvare>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	 <200901291729.24859.trenn@suse.de> <4981FC38.205@redhat.com>
	 <200901301529.14810.trenn@suse.de>
	 <20090201212243.GA23852@dreamland.darkstar.lan>
	 <20090202101103.1208c035@hyperion.delvare>
Date: Mon, 2 Feb 2009 12:38:24 +0100
Message-ID: <68676e00902020338o7326ff7dx4efadf94ed534acf@mail.gmail.com>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Thomas Renninger <trenn@suse.de>, Hans de Goede <hdegoede@redhat.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 10:11 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Sun, 1 Feb 2009 22:22:43 +0100, Luca Tettamanti wrote:
>> --- a/drivers/acpi/osl.c
>> +++ b/drivers/acpi/osl.c
>> @@ -1063,7 +1063,10 @@ __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
>>   * in arbitrary AML code and can interfere with legacy drivers.
>>   * acpi_enforce_resources= can be set to:
>>   *
>> - *   - strict           (2)
>> + *   - auto             (2)
>> + *     -> detect possible conflicts with ACPI drivers and switch to
>> + *     strict if needed, otherwise act like lax
>> + *   - strict           (3)
>>   *     -> further driver trying to access the resources will not load
>>   *   - lax (default)    (1)
>>   *     -> further driver trying to access the resources will load, but you
>> @@ -1073,11 +1076,12 @@ __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
>>   *     -> ACPI Operation Region resources will not be registered
>>   *
>>   */
>> -#define ENFORCE_RESOURCES_STRICT 2
>> +#define ENFORCE_RESOURCES_STRICT 3
>> +#define ENFORCE_RESOURCES_AUTO   2
>>  #define ENFORCE_RESOURCES_LAX    1
>>  #define ENFORCE_RESOURCES_NO     0
>
> I don't see any reason to change ENFORCE_RESOURCES_STRICT from 2 to 3.
> Just add ENFORCE_RESOURCES_AUTO as 3 and that's it, makes your patch
> smaller.

There's an unspoken reason ;-) The options are ordered by
"strictness", I was experimenting with an API to export the parameter,
in order to move the code to a separate quirk file. Since it's not
relevant in this patch I'll back out the change.

>> +static int acpi_res_quick_check_hid(const struct dmi_system_id *d)
>> +{
>> +     acpi_status ret;
>> +     bool found = false;
>> +     char *hid;
>> +
>> +     if (!d->driver_data)
>> +             goto strict;
>> +
>> +     hid = d->driver_data;
>> +     ret = acpi_get_devices(hid, acpi_res_quick_check_hid_cb,
>> +                             NULL, (void **)&found);
>> +
>> +     if (ret == AE_OK && found)
>> +             goto strict;
>> +
>> +     return 0;
>> +strict:
>> +     printk(KERN_DEBUG "ACPI: detected %s system: "
>> +                     "enforcing strict resource checking\n", d->ident);
>
> Should be pr_debug().

Actually I was considering raising the level to info, it might make
easier to explain to the users why they cannot load their favorite
driver anymore.

>> +     return 1;
>> +}
>> +
>> +/* The following systems have ACPI drivers that might overlap the
>> + * functionality of native drivers (mostly in hwmon subsys). If
>> + * acpi_enforce_resources is set to auto the following table is
>> + * used to enforce strict checking in matching systems, in order
>> + * to avoid conflicts.
>> + * Note that driver_data and the acpi_res_quick_check_hid callback
>> + * are used to further refine the match, checking for the presence
>> + * of the given HID (driver_data) in the DSDT. Both fields are
>> + * optional for DMI-only rules.
>> + */
>> +static const struct dmi_system_id resource_quirks[] = {
>
> You must include <linux/dmi.h> for this.

Right, it's included indirectly from somewhere...

> I think it's better to tag this structure as __initdata than const, so
> that it is cleaned up after initialization. Then I guess you can also
> tag acpi_res_quick_check_hid_cb() and acpi_res_quick_check_hid() as
> __init so the runtime memory overhead is zero.

Ok, will do.

Luca
