Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZAJHhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZAJHhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 02:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZAJHhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 02:37:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:37505 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZAJHhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 02:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IwJVU9w+CQ0Il8WzYye5s8qPhJwMjQ/DwD23IRC2QEUiuKNVuSj+hq/W491mbPOVKz
         i9fPO82OGFscrPrzUEeKhKmgKYJjNzzzd26xY6xr4xHXWgSROS4L/0t6FUtW2rmxiWwn
         35lfycw7c8nyRnK6fCkPm5LH57r4iMAxSTSI0=
MIME-Version: 1.0
In-Reply-To: <200901061741.12410.rgetz@blackfin.uclinux.org>
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <200812311238.13810.rgetz@blackfin.uclinux.org>
	 <45a44e480812311005k709c410ao1116187e9427e452@mail.gmail.com>
	 <200901061741.12410.rgetz@blackfin.uclinux.org>
Date: Sat, 10 Jan 2009 15:37:19 +0800
Message-ID: <45a44e480901092337vbd08832l79436786f848e102@mail.gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Eric Miao <eric.miao@marvell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>, Ben Gardner <bgardner@wabtec.com>,
       Greg KH <greg@kroah.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 6:41 AM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Wed 31 Dec 2008 13:05, Jaya Kumar pondered:
>> On Thu, Jan 1, 2009 at 1:38 AM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>> > On Tue 30 Dec 2008 23:58, Jaya Kumar pondered:
>> >> On Tue, Dec 30, 2008 at 11:55 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>> >> > Yeah, I hadn't thought about spanning more than one gpio_chip. That's a good
>> >> > point.
>> >>
>> >> The currently posted code already supports spanning more than one gpio_chip.
>> >>
>> >
>> > But doesn't do all the other things that David suggested/requested.
>>
>> Hi Robin,
>>
>> Yes, you are right. My implementation does not support a driver that
>> needs to set/get more than 32-bits of gpio in a single call. I'm okay
>> with that restriction as I don't see a concrete use case for that.
>
> It's not the more than 32-bits that I'm concerned about - it is spanning
> more than one register. (if all the GPIOs that are left on the board are
> 2, 64, and 128, where 2, and 64 are part of the SOC's GPIO, and 128 is on
> a GPIO expander - which is a common use case - is this handled?)
>

Hi Robin,

You are correct in that the 2, 64, 128 case would not be accelarated
by my current implementation. The reason is that those 3 numbers can't
fit into a 32 bit bitmask (the mask is for consecutive bits). The user
would need to use the pre-existing single bit API for that scenario,
ie: gpio_set_value(2, val); (64, val), (128, val);

In my current patch, I'm trying to address the performance issue seen
by am300epd.c because of the use of gpio as a 16-bit data bus to
transfer framebuffer data using the current single bit gpio API. I
want to make my implementation more generic than just that which is
why I've added the bitmask and support up to 32-bits. I want to expand
on that to the extent that that can be done without diluting the
performance and without losing the simplicity of the current gpiolib
API.

After reading your points, I think I understand that you would prefer
a higher level API. I am thinking along the lines of:
array_of_gpio_numbers[] = [ 2 , 64, 128 ];
cookie = gpio_register_bundle(array_of_gpio_numbers, sizeof(array));
error = gpio_set_bundle(cookie, values[]);
error = gpio_get_bundle(cookie, values[]);
gpio_unregister_bundle(cookie);

I think that's elegant and I agree that it is feasible but it is a
level higher than what I'm trying to achieve. Would you agree with me
that the above API could be implemented on top of the lower level API
that I have proposed? To be specific, I imagine something along the
lines of:

int gpio_set_bundle(int cookie, u32 *values)
{
  offsets = retrieve_offsets_from_cookie(cookie);
  err = generate_chips_from_offsets(offsets, &chips);
  err = merge_consecutive_chips(chips, &merged_chips)
  foreach chip (merged_chips) {
   values = generate_values(chip, offset);
   mask = generate_mask(chip, offset);
   masklength = calculate_length(mask);
   gpio_set_batch(chip, offset, values, mask, masklength);
 }
}

forgive the naming, I'm just hurrying to illustrate what I mean.

So my goal is to get the lower level batch API working and solid. It
would solve the am300epd.c problem and put into place a framework for
others[1]. Once we've gotten to that level of support, I believe we
could start implementing the higher level API that you've described on
top of that. Does this sound like a reasonable plan that would address
your concerns?

Thanks,
jaya

[1]  The same underlying display controller that I seek to support,
broadsheet, will be used across more than just am300epd.c's pxa255. I
know with certainty that it has been used on iMX31L. Several other
SoCs including the S3C6410 are likely. So if we've got this lower
level batch API done, I hope to see it commonly implemented across
those other SoCs too in order to ensure all of those use cases are
accelerated. I am happy to work on that, especially if I can get
hardware. :-)

ps: I noticed you said the above 2, 64, 128 is a common use case. I
don't dispute that, but is that a case where acceleration is
essential? It would also help if I could look through an example of
this use case in the tree or elsewhere so that I can improve my
understanding.
