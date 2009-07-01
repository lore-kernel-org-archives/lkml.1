Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZGAHrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZGAHrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZGAHrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:47:46 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51896 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZGAHro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:47:44 -0400
Message-ID: <35c700707581a42af21dd9edc82a5e84.squirrel@www.hardeman.nu>
In-Reply-To: <20090630142345.58e97b50.akpm@linux-foundation.org>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu>
    <1246079912-17619-3-git-send-email-david@hardeman.nu>
    <20090630142345.58e97b50.akpm@linux-foundation.org>
Date: Wed, 1 Jul 2009 09:47:46 +0200 (CEST)
Subject: Re: [PATCH 2/2] Add a driver for the Winbond WPCD376I IR 
     functionality.
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-input@vger.kernel.org, jbarnes@virtuousgeek.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, June 30, 2009 23:23, Andrew Morton wrote:
> On Sat, 27 Jun 2009 07:18:32 +0200
> David Härdeman <david@hardeman.nu> wrote:
>> +static void
>> +wbcir_set_bits(unsigned long addr, u8 bits, u8 mask)
>> +{
>> +	u8 val;
>> +
>> +	val = inb(addr);
>> +	val = ((val & ~mask) | (bits & mask));
>> +	outb(val, addr);
>> +}
>
> What locking prevents the races which could occur here?
>
> Whatever it is, it would be good to document that here in a code
> comment.

I should probably clarify the comment in "struct wbcir_data" to mention
that wbcir_lock is supposed to protect registers against race conditions.

>>
>> ...
>>
>> +static u8
>> +wbcir_revbyte(u8 byte)
>> +{
>> +	byte = ((byte >> 1) & 0x55) | ((byte << 1) & 0xAA);
>> +	byte = ((byte >> 2) & 0x33) | ((byte << 2) & 0xCC);
>> +	return (byte >> 4) | (byte<<4);
>> +}
>
> Can this use the facilities in include/linux/bitrev.h?

Yes, I grep:ed for a suitable function but must have missed it, thanks for
pointing it out.

>> +	struct wbcir_data *data = input_get_drvdata(dev);
>> +
>> +	if (scancode < 0 || scancode > 0xFFFFFFFF)
>
> Neither of the comparisons in this expression can ever be true.

Didn't know if I could be certain that int is always 32 bit on all
platforms which use/might use the chip...can I?

>> +		return -EINVAL;
>> +
>> +	*keycode = (int)wbcir_do_getkeycode(data, (u32)scancode);
>
> uneeded casts.
>
> Something has gone wrong with the types here.  Where does the fault lie
> - this driver, or input core?

Two issues:

a) the input layer API confused me

include/linux/input.h provides:

struct input_event {
         struct timeval time;
         __u16 type;
         __u16 code;
         __s32 value;
};

(keycode is an unsigned 16 bit integer)

int input_get_keycode(struct input_dev *dev, int scancode, int *keycode);
int input_set_keycode(struct input_dev *dev, int scancode, int keycode);

(keycode is an int)

static inline void input_report_key(struct input_dev *dev,
                                    unsigned int code,
                                    int value)
{
        input_event(dev, EV_KEY, code, !!value);
}

(keycode is an uint)


b) 32 bit scancodes

I wanted to use 32 bit scancodes in my driver since the largest IR message
supported by the driver is RC6 mode 6A which can potentially have a 1 + 15
bits "customer" field + 8 bits address + 8 bits command = 32 bits.

Casting the int scancode passed to input_[get¦set]_keycode to an uint and
assuming it would be at least 32 bits on all platforms using the chip was
the best solution I could come up with without changing the input API.

>> +{
>> +        struct wbcir_data *data = (struct wbcir_data *)cookie;
>> +        unsigned long flags;
>> +
>> +        /*
>> +         * data->keyup_jiffies is used to prevent a race condition if a
>> +         * hardware interrupt occurs at this point and the keyup timer
>> +         * event is moved further into the future as a result.
>> +         */
>
>hm.  I don't see what the race is, nor how the comparison fixes it.  If
>I _did_ understand this, perhaps I could suggest alternative fixes.
>But I don't so I can't.  Oh well.

When the interrupt service routine detects an IR command it reports a
keydown event and sets a timer to report a keyup event in the future if no
repeated ir messages are detected (in which case the timer-driven keyup
should be pushed further into the future to allow the input core to do its
auto-repeat-handling magic).

What I wanted to protect against was something like this:

Thread 1                        Thread 2
--------                        --------
ISR called, grabs
wbcir_lock, reports
keydown for key X,
sets up keyup timer,
releases lock, exits

                    (many ms later)

                                keyup timer function called
                                and preempted before grabbing
                                wbcir_lock

ISR called, grabs wbcir_lock,
notices a repeat event for
key X, pushes the keyup timer
further into the future using
mod_timer (thus reenabling the
timer), releases lock, exits
                                keyup timer function grabs
                                wbcir_lock, reports keyup,
                                exits.
                    (many ms later)

                                keyup timer function called *again*,
                                reports keyup, exits.

The result would be (if I understood the timer implementation correctly)
that a keyup event is reported immediately after the second ISR even
though the "first" timer function call should have been cancelled/pushed
further into the future at that point.

Does this make any sense? :)

>> +static void
>> +add_irdata_bit(struct wbcir_data *data, int set)
>> +{
>> +	if (set)
>> +		data->irdata[data->irdata_count / 8] |=
>> +			0x01 << (data->irdata_count % 8);
>
> Can/should this use generic___set_le_bit() or similar, rather than
> open-coding it?

Will look into it...

You also had various code-comment objections which I'll take care of.

Thanks for the prompt review.

Regards,
David


