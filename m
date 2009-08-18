Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbZHRMWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbZHRMWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZHRMWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:22:34 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:59404 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZHRMWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:22:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OmvGqjb7881vi1cGvPwZjyIaEhwynDv5EW/K5AaSSw+o+2pOqNvBNvvcztvEZhQK6r
         shlY8zMRo7UYDwEs+sbOlR0bVI3jNkYPFgdQY4ePrzRQoRRVIU26ev0SH/1vK5zqD10b
         lyIdb9kAHDg4hnhGH+A4afyV2U3ViDjF5oQCg=
MIME-Version: 1.0
In-Reply-To: <9b2b86520908180119m40b6c4b0se8ff7cea7776085b@mail.gmail.com>
References: <4A89E768.7010207@dell.com>
	 <9b2b86520908180119m40b6c4b0se8ff7cea7776085b@mail.gmail.com>
Date: Tue, 18 Aug 2009 13:22:33 +0100
Message-ID: <9b2b86520908180522o1da2c821jf803f66264424fe@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/09, Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
> On 8/18/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
>> In order to be useful in modern kernels and standard interfaces,
>> compal-laptop should have rfkill support.  This patch adds it.
>> --
>> Mario Limonciello
>> *Dell | Linux Engineering*
>> mario_limonciello@dell.com
>>
>
> I have some comments of my own as well, so here goes.
>
>> +static void compal_rfkill_query(struct rfkill *rfkill, void *data)
>> +{
>> +	unsigned long radio = (unsigned long) data;
>> +	u8 result;
>> +	bool blocked;
>> +
>> +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
>> +
>> +	if ((result & KILLSWITCH_MASK) == 0)
>> +		blocked = 1;
>
>> +        else if (radio == WLAN_MASK)
>> +		blocked = !(result & WLAN_MASK);
>> +	else
>> +		blocked = !((result & BT_MASK) >> 1);
>
> Ick, this is overdone.  You should just be able to do
>
> +	else
> +		blocked = !(result & radio);
>
>> +	rfkill_set_sw_state(rfkill,blocked);
>> +	rfkill_set_hw_state(rfkill,0);
>
> This last line is redundant.  The HW state will default to "unblocked"
> if you never set it.
>
>> +static int compal_rfkill_set(void *data, bool blocked)
>> +{
>> +	unsigned long radio = (unsigned long) data;
>> +	u8 result, value;
>> +
>> +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
>> +
>> +	if ((result & KILLSWITCH_MASK) == 0)
>> +		return -EINVAL;
>> +	else {
>> +		if (!blocked)
>> +			value = (u8) (result | radio);
>> +		else
>> +			value = (u8) (result & ~radio);
>> +		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
>> +	}
>> +
>> +	return 0;
>> +}
>
> Note that the return value of rfkill_set is not propagated to
> userspace through the /dev/rfkill interface.
>
> The way you use "KILLSWITCH_MASK", it looks like a hard rfkill bit
> that covers all radios.  Why don't you report it as a hard block on
> each rfkill device?

P.S.  If you do this, you probably also want to set up polling.  I
think you should be able to reuse the query() function for the poll()
method (but you should check yourself whether that makes sense).

Thanks again
Alan
