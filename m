Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYLaR6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYLaR6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYLaR6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:58:45 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:60745 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYLaR6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:58:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L9aUqviq1Uu7HmJQiqANUeiaD8AxhWkYQiN2zLsKsqdQUZh8EqPZaxKoBSXHLFKh+z
         rVd0givNuKV8HoTNdADjakNzevYBsvDnppAp0xfcdra9xLbgH8HJHmcLhF2NpRcEAFTr
         DU81TYnI6ntfLvaBoEwmtlJBkLwtyouex5UzU=
Message-ID: <45a44e480812310958tb11f125qa338d03c45c45d6f@mail.gmail.com>
Date: Thu, 1 Jan 2009 01:58:40 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Dave Hylands" <dhylands@gmail.com>
Subject: Re: [RFC 2.6.28 1/1] gpiolib: add set/get batch v3
Cc: "David Brownell" <david-b@pacbell.net>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <c32efac40812310722x238c8348j5f4ed48ae87c4704@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12307156721518-git-send-email-jayakumar.lkml@gmail.com>
	 <c32efac40812310722x238c8348j5f4ed48ae87c4704@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 11:22 PM, Dave Hylands <dhylands@gmail.com> wrote:
> Hi Jaya,
>
> ...snip...
>> There was a question about why have both bitmask AND width when width
>> could be worked out from bitmask. The reason for having both bitmask and
>> length is for performance. Let's compare the following two scenarios:
>>
>> /* flash to black */
>> for (i=0; i < 800*600; i++)
>>        gpio_set_batch(DB0, 0x00000000, 0x0000FFFF)
>>
>> Internally, the above implementation has to work out the length of bits
>> that are being set in bitmask in order to figure out which register
>> boundaries are being crossed. That means looping through the bitmask
>> and counting bits. That would need to be repeated for every call of
>> gpio_set_batch in the above loop and would be a relatively high expense.
>>
>> /* flash to black */
>> for (i=0; i < 800*600; i++)
>>        gpio_set_batch(DB0, 0x00000000, 0x0000FFFF, 16)
>>
>> In the 2nd case, the implementation is able to skip all the bit counting.
>> This usage method is also the intuitive way for drivers that are trying
>> to push data across a gpio bus since they explicitly know the bus length.
> ...snip...
>
> I haven't been following too closely, but what about
>
>        gpio_set_batch(DB0, 0x00000000, 0x00FF00FF, 16)
>
> That also has 16 bits set, but in different positions.

Hi Dave,

+ * @bitwidth: width inclusive of masked-off bits.

I believe you meant , 24) in the above 0xFF00FF example. If we had
mask 0x8000_0001, the bitwidth would be 32 because the mask is 32 bits
wide, as opposed to 2 bits set. I'll improve the API docs to highlight
that.

>
> Shouldn't you just not bother with the length and optimize particular
> bitmasks (i.e. 0xFF, 0xFFFF, 0xFFFFFF, 0xFFFFFFFF)?
>

That's an interesting question. I believe the reason we should have
the length/width argument to the function is in order to allow for
optimization. By using bitwidth, we can achieve a better level of
performance with simpler code than we could if we put in specific mask
based optimizations. To elaborate on this, lets evaluate the example
you gave on a specific platform: eg: a Gumstix Basix (pxa255). We'd
want the following two example calls to both be as fast as possible:
a) gpio_set_batch(DB0, 0x00000000, 0x0000FFFF, 16);
and
b) gpio_set_batch(DB0, 0x00000000, 0x00FF00FF, 24);

Let's make it easy and say that DB0 is pin 32. pxa255 has chip->ngpio
== 32. So in a), we immediately hit the fastpath condition in
gpio_set_batch() in mach-pxa/i/m/gpio.h:

+       if (__builtin_constant_p(gpio) &&
+               (gpio + bitwidth < NR_BUILTIN_GPIO) &&
+               ((gpio + bitwidth) <= roundup(gpio+1, 32))) {

which then immediately sets the desired value.

+               values = (values << shift) & bitmask;
+               if (values)
+                       GPSR(gpio) = values;
+
+               values = ~values & bitmask;
+               if (values)
+                       GPCR(gpio) = values

Okay, so now we look at scenario b), and this too hits the fully
optimized case. Yay! The reason we're able to achieve that instant
determination that this fits the fastpatch is because of the bitwidth
argument. If we didn't have bitwidth, we would instead need to have a
set of comparisons to count bits, even with constant masks (where
basically we'd be using a lookup table), to determine if gpio + the
width of the mask remained in a single register. That would basically
be trying to quickly calculate width in order to evaluate if we can
actually use the fastpath. This is what I sought to avoid. That
complexity can be removed and the implementation code simplified by
providing the width directly. This provides the benefit that the
underlying implementation can then optimize as needed.

Okay, so we've considered the easy case, now lets make it harder. Lets
say that DB0 is pin 58. So now both a) and b) span 2 registers. The
fastpatch check:
+       if (__builtin_constant_p(gpio) &&
+               (gpio + bitwidth < NR_BUILTIN_GPIO) &&
+               ((gpio + bitwidth) <= roundup(gpio+1, 32))) {

will evaluate false and we therefore hit the first level
__gpio_set_batch() in gpiolib.c, which does:

+void __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth)
+{
+       struct gpio_chip *chip;
+       int i = 0;
+       int value, width, remwidth;
+       u32 mask;
+
+       BUG_ON(bitwidth > 32);
+       do {
+               chip = gpio_to_chip(gpio + i);
+               WARN_ON(extra_checks && chip->can_sleep);
+
+               value = values >> i; /* shift off the used data bits */
+               remwidth = ((chip->base + (int) chip->ngpio) -
+                                       ((int) gpio + i));
+               width = min(bitwidth, remwidth);
+
+               /* shift off the used mask bits */
+               mask = bitmask >> i;
+               /* now adjust mask by width of this set */
+               mask &= ((1 << width) - 1);
+
+               chip->set_batch(chip, gpio + i - chip->base, value, mask,
+                                       width);
+               i += width;
+               bitwidth -= width;
+       } while (bitwidth);

the first iteration of scenario a) through the do{} while sees, width
= 6 bits (because 58 = bit 26 in the 32-63 register, and the used bits
in that register are 6) and does that set in a single pass. Same for
scenario b).

In the 2nd iteration, scenario a) sees width = 10 bits ( 16 - 6 and
bit 64 with mask 0x0000003F in the 64-96 register) and does that set
in a single pass. Scenario b) sees width = 18 bits ( 24 - 6 and bit 64
with mask 0x003F003) and again completes in a single pass. So total is
2 sets in both cases, which is optimum since the range spaned 2
registers.

Without the bitwidth argument, both of those determinations would have
required more code complexity in order to calculate that repeatedly
from the mask.

Thanks,
jaya
