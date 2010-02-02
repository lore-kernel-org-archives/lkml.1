Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0BAX7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 18:59:10 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:65091 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0BAX7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 18:59:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dNf9qmz9qaSCMVyR62GPalfdzFsbV3zur6L+buVRrXR/CR3AtIbxqXmjn8JvWnwhAj
         g71gj6tCW4ip7d9oncZbDDFY7+MDa40t8ivSNXMv90Sffpedpx+tgtMZL5b8StLb8E5h
         QpzkIzLf2LRQ6cGMGnN95xXROfAyDBCMmLJW8=
Message-ID: <4B676B20.8060808@gmail.com>
Date: Mon, 01 Feb 2010 16:00:32 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Meyer <thomas@m3y3r.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] i915: slow acpi_lid_open() causes flickering
References: <1265048453.2619.8.camel@localhost.localdomain> <20100201143348.cb9fa1e3.akpm@linux-foundation.org>
In-Reply-To: <20100201143348.cb9fa1e3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/10 14:33, Andrew Morton wrote:
> On Mon, 01 Feb 2010 19:20:53 +0100
> Thomas Meyer<thomas@m3y3r.de>  wrote:
>
>> acpi_lid_open() could take up to 10ms on my computer.
>> Some component is calling the drm GETCONNECTOR ioctl many times in a row.
>> This results in flickering (for example, when starting a video).
>> Fix it by assuming an always connected lid status.
>>
>> This fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=14670
>>
>> ---
>>   drivers/gpu/drm/i915/intel_lvds.c |   15 ++++++++++++++-
>>   1 files changed, 14 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
>> index aa74e59..0f0779c 100644
>> --- a/drivers/gpu/drm/i915/intel_lvds.c
>> +++ b/drivers/gpu/drm/i915/intel_lvds.c
>> @@ -632,6 +632,18 @@ static const struct dmi_system_id bad_lid_status[] = {
>>   	{ }
>>   };
>>
>> +/* Some lid devices take a long time to report the lid status, assume they're connected*/
>> +static const struct dmi_system_id slow_lid_status[] = {
>> +	{
>> +		.ident = "Aspire 1810T",
>> +		.matches = {
>> +			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
>> +		},
>> +	},
>> +	{ }
>> +};
>> +
>>   /**
>>    * Detect the LVDS connection.
>>    *
>> @@ -643,7 +655,8 @@ static enum drm_connector_status intel_lvds_detect(struct drm_connector *connect
>>   {
>>   	enum drm_connector_status status = connector_status_connected;
>>
>> -	if (!acpi_lid_open()&&  !dmi_check_system(bad_lid_status))
>> +	if (!dmi_check_system(slow_lid_status)&&  !dmi_check_system(bad_lid_status))
>> +	    if (!acpi_lid_open())
>>   		status = connector_status_disconnected;
>>
>>   	return status;
>
> The patch is missing your Signed-off-by: line.  I cheekily added it.
> Please check Documentation/SubmittingPatches, let me know if you
> disagree with this, thanks.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I'm wondering if just adding your DMI entry to
bad_lid_status[] is all that is really needed.
(this way it saves bits in the kernel).

Justin P. Mattock
