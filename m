Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYKZD12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYKZD12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYKZD1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:27:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:36396 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYKZD1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:27:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HJyZiq+SWGOv43cENpkN6dnJCzGt7ivBns5qcf4bxsvOrrirI8zHXCzBXXtBxyj3pf
         7jmkmG2zJkX52BxRsJNDnaHr8fIFBNwS3bUdVn86xpcUNtVF1OBOKu6XQ1Jn+wMWFU29
         obEatBqjl+azutarEP8kCP+Ed5tPNoq+WMkh0=
Message-ID: <45a44e480811251927u5c7839d2q1c1bebe344300737@mail.gmail.com>
Date: Tue, 25 Nov 2008 22:27:17 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Eric Miao" <eric.y.miao@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       "David Brownell" <david-b@pacbell.net>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Jean Delvare" <khali@linux-fr.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <f17812d70811251720u47bec50dt3734f5b2bb0d339@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <f17812d70811251720u47bec50dt3734f5b2bb0d339@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 8:20 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Wed, Nov 26, 2008 at 6:52 AM, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
>> Beloved friends,
>>
>> I would like to request your feedback on the following idea. I hope I have
>> made sure to CC all the right people and the right lists! If not, PLEASE
>> let me know! I couldn't find a MAINTAINERS entry for gpiolib so I just
>> used what I saw in the git log and have also added people and lists that
>> I think may be interested.
>>
>> This is just an RFC. If you all feel it is looking like the right approach
>> then I'll clean it up and make it a patch.
>>
>> Thanks,
>> jaya
>>
>> am300epd was doing 800*600*16*gpio_set_value for each framebuffer transfer
>> (it uses 16-pins of gpio as its data bus). I found this caused a wee
>> performance limitation. This patch adds an API for gpio_set_value_bus
>> which allows users to set batches of consecutive gpio together in a single
>> call. I have done a test implementation on gumstix (pxa255) with am300epd
>> and it provides a nice improvement in performance.
>
> Using a bit mask will be more generic if the GPIOs are not contiguous.

I agree that a bitmask would be more generic.

However, the primary use case for this type of functionality that I
could think of was for devices that are treating gpio as a bus. That's
the place where I think this type of functionality would be
beneficial. In the non-contiguous case, where that device is using
separate bits of gpio (ie: via a bitmask), that would be likely for
control rather than for pushing data in bulk.

> Yet I still doubt this will be generic enough to be added to gpiolib.
> The user of this gpio_set_value_bus() may assume too much about
> the internal, e.g. how many GPIOs on the chip and whether these GPIOs
> are contiguous or not, and whether this GPIO chip support bitwise
> operations.

In this patch, I tried to avoid having the user need to know the
details of the underlying gpio support. For example, in this patch,
the user, am300epd.c does:

gpio_set_value_bus(DB0_GPIO_PIN, data, 16);

and the generic code just does a fallback to software if that's not viable:

+               if (!chip->set_bus) {
+                       while (((gpio + i) < (chip->base + chip->ngpio))
+                               && bitwidth) {
+                               value = values & (1 << i);
+                               chip->set(chip, gpio + i - chip->base, value);
+                               i++;
+                               bitwidth--;
+                       }


>
> Let's have a concrete example: what if the user gives a bunch of GPIOs
> that crosses the chip boundary, say, GPIO29 - GPIO35 (with each chip
> covering 32 GPIOs).
>

Okay. So paraphrasing, we have GPIO29-GPIO35 which is 7 bits wide. I
assume the crossing is at GPIO32 being 2nd chip, ie: chip->ngpio = 32.
In the above code, that would hit the following case:

+       do {
+               chip = gpio_to_chip(gpio + i);
+               WARN_ON(extra_checks && chip->can_sleep);
+
+               if (!chip->set_bus) {
+                       while (((gpio + i) < (chip->base + chip->ngpio))
+                               && bitwidth) {
+                               value = values & (1 << i);
+                               chip->set(chip, gpio + i - chip->base, value);
+                               i++;
+                               bitwidth--;
+                       }
+               } else {
+                       value = values >> i; /* shift off the used stuff */
+                       remwidth = ((chip->base + (int) chip->ngpio) -
+                                       ((int) gpio + i));
+                       width = min(bitwidth, remwidth);
+
+                       chip->set_bus(chip, gpio + i - chip->base, value,
+                                       width);
+                       i += width;
+                       bitwidth -= width;
+               }
+       } while (bitwidth);

so on the first GPIO29-31, it would have value = values >> 0,
chip->base = 0 , ngpio = 32, gpio = 29, i = 0 so width = 3, so it
would do set_bus(chip, 29, value, 3)
and then i += 3, bitwidth -= 3 and so now we do chip = gpio_to_chip(29
+ 3 = 32) so we get the next chip and handle the remaing bits. So in
this scenario that works fine.

In fact, in the case of am300epd.c, it is an identical scenario
because DB0 is pin 58 and it is 16 bits wide so we hit 2 chips, ie :
32 and 64.

Thanks,
jaya
