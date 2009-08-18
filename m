Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZHRIUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZHRIUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZHRIUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:20:00 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:38003 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZHRIT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WFg7kYFYzTf40GikNI6e9TSQECyzWDkJ3D0KzRMQ6s2mVY1aFuqV1yLkRa9dtKMaMu
         yj+Yknnfcc8l8luNa8sQkeQH0kXUJBfY/hEiN3SZV9J4Lpd+h8rTHMgisp+UyDYb4Sqn
         hFgJicjLr8PaNPeK6kFDpQbBpztAgFTgf0/Xk=
MIME-Version: 1.0
In-Reply-To: <4A89E768.7010207@dell.com>
References: <4A89E768.7010207@dell.com>
Date: Tue, 18 Aug 2009 09:19:56 +0100
Message-ID: <9b2b86520908180119m40b6c4b0se8ff7cea7776085b@mail.gmail.com>
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

On 8/18/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> In order to be useful in modern kernels and standard interfaces,
> compal-laptop should have rfkill support.  This patch adds it.
> --
> Mario Limonciello
> *Dell | Linux Engineering*
> mario_limonciello@dell.com
>

I have some comments of my own as well, so here goes.

> +static void compal_rfkill_query(struct rfkill *rfkill, void *data)
> +{
> +	unsigned long radio = (unsigned long) data;
> +	u8 result;
> +	bool blocked;
> +
> +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> +
> +	if ((result & KILLSWITCH_MASK) == 0)
> +		blocked = 1;

> +        else if (radio == WLAN_MASK)
> +		blocked = !(result & WLAN_MASK);
> +	else
> +		blocked = !((result & BT_MASK) >> 1);

Ick, this is overdone.  You should just be able to do

+	else
+		blocked = !(result & radio);

> +	rfkill_set_sw_state(rfkill,blocked);
> +	rfkill_set_hw_state(rfkill,0);

This last line is redundant.  The HW state will default to "unblocked"
if you never set it.

> +static int compal_rfkill_set(void *data, bool blocked)
> +{
> +	unsigned long radio = (unsigned long) data;
> +	u8 result, value;
> +
> +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> +
> +	if ((result & KILLSWITCH_MASK) == 0)
> +		return -EINVAL;
> +	else {
> +		if (!blocked)
> +			value = (u8) (result | radio);
> +		else
> +			value = (u8) (result & ~radio);
> +		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
> +	}
> +
> +	return 0;
> +}

Note that the return value of rfkill_set is not propagated to
userspace through the /dev/rfkill interface.

The way you use "KILLSWITCH_MASK", it looks like a hard rfkill bit
that covers all radios.  Why don't you report it as a hard block on
each rfkill device?

Note that strictly speaking, you should only call one rfkill_set
function within the query() method.

"@query: query the rfkill block state(s) and call exactly one of the
rfkill_set{,_hw,_sw}_state family of functions."

(I'd recommend reading the comments in include/linux/rfkill.h if you
haven't already).  So If you do want to set both hw and sw states in
query(), you should use rfkill_set_states().

> +static int setup_rfkill(void)
> +{
> +	int ret;
> +
> +	wifi_rfkill = rfkill_alloc("compal-wifi", NULL, RFKILL_TYPE_WLAN,
> +					&compal_rfkill_ops, (void *) WLAN_MASK);

I think you should use "compal_device->dev" in place of NULL here.
Otherwise the rfkill devices will appear in sysfs as "virtual
devices", belonging to no "physical" device.

> +	bluetooth_rfkill = rfkill_alloc("compal-bluetooth", NULL, RFKILL_TYPE_BLUETOOTH,
> +					&compal_rfkill_ops, (void *) BT_MASK);

Same here.

Regards
Alan
