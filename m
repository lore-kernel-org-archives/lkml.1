Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYHCE0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYHCE0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 00:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYHCE0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 00:26:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55159 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbYHCE0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 00:26:20 -0400
X-Sasl-enc: E6OqiKrMiK/F1ynf5XjbCWabPNPAYWSiB9BTI4dxI/r/ 1217737578
Date: Sun, 3 Aug 2008 01:26:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill (v2)
Message-ID: <20080803042613.GC6053@khazad-dum.debian.net>
References: <4894B1B4.6050003@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4894B1B4.6050003@overt.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Aug 2008, Philip Langdale wrote:
> +static int bt_rfkill_toggle_radio(void *data, enum rfkill_state state)
> +{
> +	u32 result1, result2;
> +	u32 value;
> +	bool radio_state;
> +
> +	struct toshiba_acpi_dev *dev = data;
> +
> +	value = state == RFKILL_STATE_UNBLOCKED;

value = (state == RFKILL_STATE_UNBLOCKED);

It is a lot easier to read without confusing the == for a =.

> +	case RFKILL_STATE_HARD_BLOCKED:
> +		printk(MY_NOTICE "Ignored HARD_BLOCKED request by software\n");
> +		break;

You don't really need the above, rfkill won't ever call your toggle_radio
callback like that.

If you want paranoid checking, do this instead:

default:
	/* maybe WARN(), WARN_ON() or printk here */
	return -EINVAL;

> +static void bt_acpi_notify(acpi_handle handle, u32 event, void *data)
> +{
> +	struct toshiba_acpi_dev *dev = data;
> +
> +	switch (event) {
> +	case BT_ACPI_SOFT_UNBLOCKED_EVENT:
> +		if (!dev->ignore_next_bt_event) {
> +			bt_rfkill_toggle_radio(data, RFKILL_STATE_UNBLOCKED);
> +			rfkill_force_state(dev->rfk_dev,
> +					   RFKILL_STATE_UNBLOCKED);

This one got me confused.  Why do you need that bt_rfkill_toggle_radio call
here?

> +	if (toshiba_acpi.rfk_dev) {
> +		rfkill_unregister(toshiba_acpi.rfk_dev);
> +		rfkill_free(toshiba_acpi.rfk_dev);
> +	}

Read the kernel-doc headers of every rfkill function you call at least
once...  Never rfkill_free() something you rfkill_unregister()'ed.

rfkill_free() is just for the error unwind of a failure between
rfkill_allocate() and rfkill_register().

> +		toshiba_acpi.rfk_dev->dev.class->suspend = NULL;
> +		toshiba_acpi.rfk_dev->dev.class->resume = NULL;

Why?

> +		ret = rfkill_register(toshiba_acpi.rfk_dev);
> +		if (ret) {
> +			printk(MY_ERR "unable to register rfkill device\n");
> +			toshiba_acpi_exit();
> +			return -ENOMEM;
> +		}
> +
> +		if (hci_get_bt_on(&bt_on) == HCI_SUCCESS && bt_on) {
> +			toshiba_acpi.rfk_dev->state = RFKILL_STATE_UNBLOCKED;
> +		} else if (hci_get_radio_state(&radio_on) == HCI_SUCCESS && radio_on) {
> +			toshiba_acpi.rfk_dev->state = RFKILL_STATE_HARD_BLOCKED;
> +		} else {
> +			toshiba_acpi.rfk_dev->state = RFKILL_STATE_SOFT_BLOCKED;
> +		}

Do the above between rfkill_allocate() and rfkill_register().

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
