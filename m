Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZF3VX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZF3VX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZF3VXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:23:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbZF3VXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:23:49 -0400
Date: Tue, 30 Jun 2009 14:23:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-input@vger.kernel.org, jbarnes@virtuousgeek.org,
       david@hardeman.nu
Subject: Re: [PATCH 2/2] Add a driver for the Winbond WPCD376I IR
 functionality.
Message-Id: <20090630142345.58e97b50.akpm@linux-foundation.org>
In-Reply-To: <1246079912-17619-3-git-send-email-david@hardeman.nu>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu>
	<1246079912-17619-3-git-send-email-david@hardeman.nu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jun 2009 07:18:32 +0200
David H__rdeman <david@hardeman.nu> wrote:

> This patch adds a driver for the the Consumer IR (CIR) functionality
> of the Winbond WPCD376I chipset (found on e.g. Intel DG45FC
> motherboards).
> 
> Changes since the driver was last posted to the list:
> o Homebrew dprintk -> dev_dbg
> o Some magic values changed to defines
> o Fixed a bug where the wake-ir-command mask/value would not be
>   written properly
> o Fixed the use of the invert parameter both for wake and normal
>   IR reception.
> 
>
> ...
>
> +static void
> +wbcir_set_bits(unsigned long addr, u8 bits, u8 mask)
> +{
> +	u8 val;
> +
> +	val = inb(addr);
> +	val = ((val & ~mask) | (bits & mask));
> +	outb(val, addr);
> +}

What locking prevents the races which could occur here?

Whatever it is, it would be good to document that here in a code
comment.

>
> ...
>
> +static u8
> +wbcir_revbyte(u8 byte)
> +{
> +	byte = ((byte >> 1) & 0x55) | ((byte << 1) & 0xAA);
> +	byte = ((byte >> 2) & 0x33) | ((byte << 2) & 0xCC);
> +	return (byte >> 4) | (byte<<4);
> +}

Can this use the facilities in include/linux/bitrev.h?

> +static u8
> +wbcir_to_rc6cells(u8 val)
> +{
> +	u8 coded = 0x00;
> +	int i;
> +
> +	val &= 0x0F;
> +	for (i = 0; i < 4; i++) {
> +		if (val & 0x01)
> +			coded |= 0x02 << (i * 2);
> +		else
> +			coded |= 0x01 << (i * 2);
> +		val >>= 1;
> +	}
> +
> +	return coded;
> +}

geeze, what does that do?

Code needs comments..

>
> ...
>
> +static int
> +wbcir_getkeycode(struct input_dev *dev, int sscancode, int *keycode)
> +{
> +	unsigned int scancode = (unsigned int)sscancode;

unneeded cast.

> +	struct wbcir_data *data = input_get_drvdata(dev);
> +
> +	if (scancode < 0 || scancode > 0xFFFFFFFF)

Neither of the comparisons in this expression can ever be true.

> +		return -EINVAL;
> +
> +	*keycode = (int)wbcir_do_getkeycode(data, (u32)scancode);

uneeded casts.

Something has gone wrong with the types here.  Where does the fault lie
- this driver, or input core?

> +	return 0;
> +}
> +
> +static int
> +wbcir_setkeycode(struct input_dev *dev, int sscancode, int keycode)
> +{
> +	struct wbcir_data *data = input_get_drvdata(dev);
> +	struct wbcir_keyentry *keyentry;
> +	struct wbcir_keyentry *new_keyentry;
> +	unsigned long flags;
> +	unsigned int old_keycode = KEY_RESERVED;
> +	unsigned int scancode = (unsigned int)sscancode;
> +
> +	if (scancode < 0 || scancode > 0xFFFFFFFF)

various dittoes.

> +		return -EINVAL;
> +
> +	if (keycode < 0 || keycode > KEY_MAX)
> +		return -EINVAL;
> +
> +	new_keyentry = kmalloc(sizeof(*new_keyentry), GFP_KERNEL);
> +	if (!new_keyentry)
> +		return -ENOMEM;
> +
> +	write_lock_irqsave(&keytable_lock, flags);
> +
> +	list_for_each_entry(keyentry, &data->keytable, list) {
> +		if (keyentry->key.scancode != scancode)
> +			continue;
> +
> +		old_keycode = keyentry->key.keycode;
> +		keyentry->key.keycode = keycode;
> +
> +		if (keyentry->key.keycode == KEY_RESERVED) {
> +			list_del(&keyentry->list);
> +			kfree(keyentry);
> +		}
> +
> +		break;
> +	}
> +
> +	set_bit(keycode, dev->keybit);
> +
> +	if (old_keycode == KEY_RESERVED) {
> +		new_keyentry->key.scancode = (u32)scancode;
> +		new_keyentry->key.keycode = (unsigned int)keycode;
> +		list_add(&new_keyentry->list, &data->keytable);
> +	} else {
> +		kfree(new_keyentry);
> +		clear_bit(old_keycode, dev->keybit);
> +		list_for_each_entry(keyentry, &data->keytable, list) {
> +			if (keyentry->key.keycode == old_keycode) {
> +				set_bit(old_keycode, dev->keybit);
> +				break;
> +			}
> +		}
> +	}
> +
> +	write_unlock_irqrestore(&keytable_lock, flags);
> +	return 0;
> +}
> +
> +static void
> +wbcir_keyup(unsigned long cookie)

It would be useful to add a comment telling the reader that this is a
timer-handler function.

> +{
> +	struct wbcir_data *data = (struct wbcir_data *)cookie;
> +	unsigned long flags;
> +
> +	/*
> +	 * data->keyup_jiffies is used to prevent a race condition if a
> +	 * hardware interrupt occurs at this point and the keyup timer
> +	 * event is moved further into the future as a result.
> +	 */

hm.  I don't see what the race is, nor how the comparison fixes it.  If
I _did_ understand this, perhaps I could suggest alternative fixes. 
But I don't so I can't.  Oh well.

> +	spin_lock_irqsave(&wbcir_lock, flags);
> +
> +	if (time_is_after_eq_jiffies(data->keyup_jiffies) && data->keypressed) {
> +		data->keypressed = 0;
> +		led_trigger_event(data->rxtrigger, LED_OFF);
> +		input_report_key(data->input_dev, data->last_keycode, 0);
> +		input_sync(data->input_dev);
> +	}
> +
> +	spin_unlock_irqrestore(&wbcir_lock, flags);
> +}
> +
>
> ...
>
> +static void
> +add_irdata_bit(struct wbcir_data *data, int set)
> +{
> +	if (set)
> +		data->irdata[data->irdata_count / 8] |=
> +			0x01 << (data->irdata_count % 8);

Can/should this use generic___set_le_bit() or similar, rather than
open-coding it?

> +	data->irdata_count++;
> +}
> +
> +/* Gets count bits of irdata */
> +static u16
> +get_bits(struct wbcir_data *data, int count)
> +{
> +	u16 val = 0x0;
> +
> +	if (data->irdata_count - data->irdata_off < count) {
> +		data->irdata_error = 1;
> +		return 0x0;
> +	}
> +
> +	while (count > 0) {
> +		val <<= 1;
> +		if (data->irdata[data->irdata_off / 8] &
> +		    (0x01 << (data->irdata_off % 8)))
> +			val |= 0x1;

ditto

> +		count--;
> +		data->irdata_off++;
> +	}
> +
> +	return val;
> +}
> +
>
> ...
>

