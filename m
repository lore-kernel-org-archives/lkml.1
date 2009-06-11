Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbZFKWB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbZFKWB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbZFKWBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:01:11 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:46175 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124AbZFKWBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:01:10 -0400
MIME-Version: 1.0
In-Reply-To: <20090603132217.GA18353@oksana.dev.rtsoft.ru>
References: <4A255B21.8040002@gersys.de> <20090602171527.GA8745@oksana.dev.rtsoft.ru> 
	<4A266FB2.2040902@gersys.de> <20090603132217.GA18353@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 11 Jun 2009 16:00:51 -0600
Message-ID: <fa686aa40906111500w1760290bm890f3ee132500b1d@mail.gmail.com>
Subject: Re: PWM class? (was: Re: MPC52xx simple GPIO support)
To: avorontsov@ru.mvista.com
Cc: Stefan Strobl <nst@gersys.de>, ppc-dev <linuxppc-dev@ozlabs.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 7:22 AM, Anton Vorontsov<avorontsov@ru.mvista.com> wrote:
> On Wed, Jun 03, 2009 at 02:42:26PM +0200, Stefan Strobl wrote:
> [...]
>> The led class provides support for setting the brightness, which
>> obviously the gpio driver doesn't support. The hardware (mpc52xx_gpt)
>> would support it in PWM mode though. I'm now wandering how this could be
>> best implemented.
>>
>> 1) - Create some PWM class similar to the GPIO class
>>    - Add support for PWM mode in mpc52xx_gpt.c that uses that PWM class
>>    - And add an interface for the LED to use the PWM class
>>
>> 2) - Create an LED driver that accesses the mpc52xx_gpt directly.
>>
>> I think I would be overwhelmed trying to implement (1) but am confident
>> to do (2). What do you think is the right approach?
>
> I'd suggest creating a generic PWM class, i.e. PWMLIB, alike to
> GPIOLIB. (2) can be an acceptable approach for now, but for the
> long-term solution (1) is the way to go.
>
> The non-lib PWM API is already there, see include/linux/pwm.h,
> and arch/arm/mach-pxa/pwm.c as an implementation example.
>
> Note that PXA implementation is SOC-specific, which is not very
> good.
>
> So I'd suggest creating drivers/pwm/pwmlib.c, borrowing
> ideas from gpiolib. And then we can reuse drivers/leds/leds-pwm.c
> driver (of course, after adding appropriate OF code into it).

Ugh.  The referenced pwm api is about as trivial as it gets; it is an
anonymous context pointer (anonymous struct pwm_device *) with a set
of accessor functions.  PWMs are also not nearly as common as GPIO
pins, and I am not interested in gpiolib being duplicated for PWMs, at
least not until there are more that just two examples of use to draw
from.

If anything, I'd rather struct pwm_device be non-anonymous and contain
a set of ops which call directly into the driver.  That way is at
least multiplatform friendly.  I don't think the gpio API is the
example to follow here.  But even then I think it is premature to try
and define a PWM api.  Personally, I'd modify mpc52xx_gpt to export
its own PWM interface for the time being using the existing GPIO
infrastructure to find the appropriate pin.

If you do decide to do a generic PWM api, then I think the way to go
is to build it as an extension to gpiolib.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
