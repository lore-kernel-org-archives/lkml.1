Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZCCCrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZCCCrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZCCCrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:47:08 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:52869 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZCCCrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:47:05 -0500
MIME-Version: 1.0
In-Reply-To: <20090302130425.23cc628d.akpm@linux-foundation.org>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
	 <20090302130425.23cc628d.akpm@linux-foundation.org>
Date: Mon, 2 Mar 2009 21:47:02 -0500
X-Google-Sender-Auth: 9a3801242b9c6860
Message-ID: <5aa163d00903021847n525e8704jd332610c45e4675a@mail.gmail.com>
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless 
	support and add sysfs interface
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, greg@kroah.com, oliver@neukum.org,
       fweisbec@gmail.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 4:04 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> +static void xpad_process_sticks(struct usb_xpad *xpad, unsigned char *data)
>> +{
>> +     struct input_dev *dev = xpad->dev;
>> +     int coords[4];    /* x, y, rx, ry */
>> +     int x_offset, y_offset, rx_offset, ry_offset;
>> +     int c;
>> +     int range;
>> +     int abs_magnitude, adjusted_magnitude, difference, scale_fraction;
>> +     int dead_zone[2], stick_limit[2];
>> +
>> +     dead_zone[0] = xpad->left_dead_zone;
>> +     dead_zone[1] = xpad->right_dead_zone;
>> +     stick_limit[0] = xpad->left_stick_limit;
>> +     stick_limit[1] = xpad->right_stick_limit;
>> +
>> +     if (xpad->xtype == XTYPE_XBOX) {
>> +             x_offset = 12;
>> +             y_offset = 14;
>> +             rx_offset = 16;
>> +             ry_offset = 18;
>> +     } else {
>> +             x_offset = 6;
>> +             y_offset = 8;
>> +             rx_offset = 10;
>> +             ry_offset = 12;
>> +     }
>> +
>> +     coords[0] = (__s16) le16_to_cpup((__le16 *)(data + x_offset));
>> +     coords[1] = ~(__s16) le16_to_cpup((__le16 *)(data + y_offset));
>> +     coords[2] = (__s16) le16_to_cpup((__le16 *)(data + rx_offset));
>> +     coords[3] = ~(__s16) le16_to_cpup((__le16 *)(data + ry_offset));
>
> We don't need the first typecast here and if `data' were to have type
> `void *', we could do away with the second cast as well.
>

gcc 4.3.3 refused to compile with data set to type void *'. I also
tried removing the casts and changing to le16_to_cpu, but the result
was that stick inputs were lost. After further testing, I reverted to
the original code, which was taken from the driver in the stable tree.

The typecasting follows this logic:

1. The stick axis inputs are 16-bit *unsigned* little endian (0 -
65535), which need to map onto the *signed* axis (-32767 to +32767)
inside the input subsystem.

2. The innermost typecast (__le16 *) tells gcc to treat the (unsigned
char *) address as a pointer to an unsigned little-endian value, which
is converted to a pointer of host endiannes -- still unsigned -- by
le16_to_cpup.

3. The outer cast (__s16) converts the unsigned values to signed
values, while the "~" inverts the y axes to make them function like a
joystick instead of a flight simulator control.

Is there a cleaner way to accomplish the transition from 16-bit
unsigned little endian to 16-bit signed host endian? If so, I can
change it... if not, I can comment this code to explain why it looks
like it does. I don't have enough experience with the Linux internal
types system to have a better solution.

I've fixed the other problems (and maybe created new ones :)...
revision of this part of the patch to follow.

Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
