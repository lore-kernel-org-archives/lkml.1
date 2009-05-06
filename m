Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbZEFTlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbZEFTlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZEFTky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:40:54 -0400
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:43462 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZEFTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:40:53 -0400
References: <cone.1240623959.159615.9486.1000@mentalhome> <cone.1240648971.372002.7492.1000@mentalhome> <20090426172947.GB3643@liondog.tnic> <cone.1240858632.795110.5316.1000@onepiie> <20090428072519.GA12170@liondog.tnic> <1240913055.29860.14.camel@maxim-laptop> <cone.1240949852.549814.7466.1000@mentalhome> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic>
Message-ID: <cone.1241638874.190271.13804.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: petkovbb@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Wed, 06 May 2009 21:41:14 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

thank you very much! A modified patch with your suggestions will follow 
as soon as I tested it. Just some things I would like to discuss:

Borislav Petkov writes:
>> +/* change current fan state - is overwritten when running in kernel mode */
>> +static int set_cur_state(struct thermal_cooling_device *cdev,
>> +		unsigned long state)
>> +{
>> +	int old_state;
>> +
>> +	/* let the thermal layer disable kernelmode. This ensures that
>> +	 * the thermal layer doesn't switch off the fan again */
>> +	if (disable_kernelmode) {
>> +		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>> +		disable_kernelmode = 0;
>> +		kernelmode = 0;
>> +		return 0;
>> +	}
>> +
>> +	if (!kernelmode) {
>> +		acerhdf_change_fanstate(state);
>> +		return 0;
>> +	}
> 
> why are we changing the fan state if kernelmode is off? If I'm not
> mistaken, the BIOS should be controlling the fan here.

The user can control the fan in userspace (by e.g. echoing 0 to the 
/sys/class/thermal.../cur_state file) then this function is called. This is 
useful if somebody wants to program an userspace tool to handle the 
temperature and the fan.

>> +	old_state = acerhdf_get_fanstate();
>> +
>> +	/* if reading the fan's state returns unexpected value, there's a
>> +	 * problem with the ec register. -> let the BIOS take control of
>> +	 * the fan to prevent hardware damage */
>> +	if (old_state != fanstate) {
> 
> you should be checking 
> 
> 	old_state == ACERHDF_ERROR
> 
> here instead.

Comparing to fanstate is better. It implys the ACERHDF_ERROR check, as 
fanstate can only be ACERHDF_FAN_AUTO or ACERHDF_FAN_OFF. And on the other 
Hand there will be thrown an error too, if the ec register contains an 
unexpected value. So it is more failsafe this way.

What do you think will be the next steps to get the kernel into mainline? 
Matthew said I should CC Len Brown, as he is responsible to include 
the module. But Len didn't write anything yet :-(

kind regards,
--peter
