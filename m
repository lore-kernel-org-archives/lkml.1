Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYHDBLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYHDBLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 21:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYHDBLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 21:11:02 -0400
Received: from usul.saidi.cx ([204.11.33.34]:37298 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753537AbYHDBLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 21:11:00 -0400
Message-ID: <48965716.6020508@overt.org>
Date: Sun, 03 Aug 2008 18:10:46 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v2)
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net>
In-Reply-To: <20080803042613.GC6053@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
>> +	value = state == RFKILL_STATE_UNBLOCKED;
> 
> value = (state == RFKILL_STATE_UNBLOCKED);
> 
> It is a lot easier to read without confusing the == for a =.

Fixed.

> 
> You don't really need the above, rfkill won't ever call your toggle_radio
> callback like that.
> 
> If you want paranoid checking, do this instead:
> 
> default:
> 	/* maybe WARN(), WARN_ON() or printk here */
> 	return -EINVAL;

Fixed.

>> +static void bt_acpi_notify(acpi_handle handle, u32 event, void *data)
>> +{
>> +	struct toshiba_acpi_dev *dev = data;
>> +
>> +	switch (event) {
>> +	case BT_ACPI_SOFT_UNBLOCKED_EVENT:
>> +		if (!dev->ignore_next_bt_event) {
>> +			bt_rfkill_toggle_radio(data, RFKILL_STATE_UNBLOCKED);
>> +			rfkill_force_state(dev->rfk_dev,
>> +					   RFKILL_STATE_UNBLOCKED);
> 
> This one got me confused.  Why do you need that bt_rfkill_toggle_radio call
> here?

When you turn off the hardware kill switch, the hardware will not reactivate
the bluetooth device. it just returns to the SOFT_UNBLOCKED state. I put that
in so that it would turn the device back on - a generally more desirable
behaviour - otherwise the user has to dig around for a software way to turn
it back. All the other hardware I've ever seen (including the wifi device on
this laptop) turns it back on, so it seemed sensible to try and make it work
as people would expect.

> 
> Read the kernel-doc headers of every rfkill function you call at least
> once...  Never rfkill_free() something you rfkill_unregister()'ed.
> 
> rfkill_free() is just for the error unwind of a failure between
> rfkill_allocate() and rfkill_register().

Fair enough, but it doesn't help that rfkill and input-polldev work in
exactly opposite ways; polldev requires you to unregister and then free;
some consistency wouldn't hurt.

>> +		toshiba_acpi.rfk_dev->dev.class->suspend = NULL;
>> +		toshiba_acpi.rfk_dev->dev.class->resume = NULL;
> 
> Why?

Good question. Gone.

> 
> Do the above between rfkill_allocate() and rfkill_register().
> 

Moved.

Diff is updated and resent as v3.

Thanks,

--phil
