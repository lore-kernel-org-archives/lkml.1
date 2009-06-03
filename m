Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZFCHgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZFCHgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZFCHf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:35:59 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:63334 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZFCHf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=TQEhBpJZ/JEl55LYfceNO5T7+RSzU7w57iaAJldIq6V08oU8moDHz2hXpRnPaQ2Jzz
         ApjGjs1lfgo/n4qktEtPbAkC9TYhn64KMIpNIxugyKVTX6eWDc6j6DiXpmI9dNNWVtEg
         SUc+Yno4s/4Qkg18RKz2vSFa5pDuibVT2wfNg=
Date: Wed, 3 Jun 2009 09:35:52 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Message-ID: <20090603073552.GA2671@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090512060231.GB26286@liondog.tnic> <cone.1242669880.118150.4276.1000@deskpiie> <20090524192219.GA30285@liondog.tnic> <cone.1243865541.882421.4368.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1243865541.882421.4368.1000@deskpiie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 01, 2009 at 04:12:21PM +0200, Peter Feuerer wrote:
>> Ok, minor nitpicks below but it starting to shape up quite ok. You could
>> send it for inclusion upstream.
>
> How exactly do I send the patch for inclusion?

just rediff it against latest git and send an email to Len Brown (i
assume, from looking at git log drivers/thermal/ output) requesting for
driver inclusion.

Len?

If you hurry and do it this week it might be possible to get it in .31
because the merge window opens around the coming weekend.

>>> +/* acer ec functions */
>>> +static int acerhdf_get_temp(void)
>>> +{
>>> +	u8 temp;
>>> +	/* read temperature */
>>> +	if (!ec_read(bios_settings[bios_version].tempreg, &temp)) {
>>> +		if (verbose)
>>
>> you need to check the error status here before printing the temperature
>> since it might be invalid if the ec_read has failed:
>>
>> 	u8 temp;
>> 	int err;
>>
>> 	err = ec_read(bios_settings[bios_version].tempreg, &temp);
>>
>> 	if (err)
>> 		return ACERHDF_ERROR;
>>
>> 	if (verbose)
>> 		acerhdf_notice("temp %d\n", temp);
>>
>> 	return temp;
>> }
>>
>
> The printf was already omitted when ec_read fails the way I wrote it, 
> wasn't it? - Only if ec_read returns 0, the printf is launched and the 
> temperature is returned.

Ah, nevermind. I got mixed up here, sorry.

>>> +			acerhdf_notice("temp %d\n", temp);
>>> +		return temp;
>>> +	}
>>> +	return ACERHDF_ERROR;
>>> +}
>>> +
>>> +
>>> +		if (verbose)
>>> +			acerhdf_error("read state: %d expected state: %d\n",
>>> +					old_state, fanstate);
>>> +
>>> +		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>>> +		disable_kernelmode = 1;
>>> +	}
>>> +
>>> +	if (state == 0) {
>>> +		/* turn fan off only if below fanoff temperature */
>>> +		if ((old_state == ACERHDF_FAN_AUTO) &&
>>> +				(acerhdf_get_temp() < fanoff))
>>
>> it might be cool to tell the user why you're not turning off the fan.
>>
>> 		if (verbose)
>> 			acerhdf_notice("Not turning off fan due to current temp "
>> 				       "exceeding fanoff value\n");
>>
>
> Hm.. I think it should be clear that the fan is turned off, as soon as 
> the temperature is below the fanoff temperature. In my opinion printing 
> this message would be a case for a "verbose==2" verbose mode :)

My reasoning was that because this is called from sysfs and the user
sees nothing happening even if he'd turned off the fan by calling
.set_cur_state that it might be useful to tell him why.

-- 
Regards/Gruss,
    Boris.
