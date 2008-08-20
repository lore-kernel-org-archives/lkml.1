Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYHTB34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYHTB34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYHTB3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:29:45 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48835 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbYHTB3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:29:44 -0400
X-Sasl-enc: 4DbAUsFtFXXOPw/Z7IWUSgS91WfLD91ISPEsz0dfzWDh 1219195783
Date: Tue, 19 Aug 2008 22:29:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill (v5)
Message-ID: <20080820012936.GE29336@khazad-dum.debian.net>
References: <48A728B0.8030206@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A728B0.8030206@overt.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Philip Langdale wrote:
> @@ -607,7 +796,66 @@ static int __init toshiba_acpi_init(void)
>  	}
>          toshiba_backlight_device->props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
>
> -	return (ACPI_SUCCESS(status)) ? 0 : -ENODEV;
> +	/* Register rfkill switch for Bluetooth */
> +	if (hci_get_bt_present(&bt_present) == HCI_SUCCESS && bt_present) {
> +		toshiba_acpi.rfk_dev = rfkill_allocate(&toshiba_acpi.p_dev->dev,
> +							RFKILL_TYPE_BLUETOOTH);
> +		if (!toshiba_acpi.rfk_dev) {
> +			printk(MY_ERR "unable to allocate rfkill device\n");
> +			toshiba_acpi_exit();
> +			return -ENOMEM;
> +		}
> +
> +		toshiba_acpi.rfk_dev->name = toshiba_acpi.bt_name;
> +		toshiba_acpi.rfk_dev->state = RFKILL_STATE_OFF;

Where did that RFKILL_STATE_OFF came from ? :-)  Just get rid of it, you
override it four statements later anyway...

> +		toshiba_acpi.rfk_dev->toggle_radio = bt_rfkill_toggle_radio;
> +		toshiba_acpi.rfk_dev->user_claim_unsupported = 1;
> +		toshiba_acpi.rfk_dev->data = &toshiba_acpi;
> +
> +		if (hci_get_bt_on(&bt_on) == HCI_SUCCESS && bt_on) {
> +			toshiba_acpi.rfk_dev->state = RFKILL_STATE_UNBLOCKED;
> +		} else if (hci_get_radio_state(&radio_on) == HCI_SUCCESS && radio_on) {
> +			toshiba_acpi.rfk_dev->state = RFKILL_STATE_SOFT_BLOCKED;
> +		} else {
> +			toshiba_acpi.rfk_dev->state = RFKILL_STATE_HARD_BLOCKED;
> +		}

i.e. in the code above.

Other than that, the rfkill bits look fine to me.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
