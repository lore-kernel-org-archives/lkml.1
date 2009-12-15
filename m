Return-Path: <linux-kernel-owner+w=401wt.eu-S933619AbZLOUsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbZLOUsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932958AbZLOUsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:48:15 -0500
Received: from mail2.shareable.org ([80.68.89.115]:36839 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZLOUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:48:12 -0500
Date: Tue, 15 Dec 2009 20:48:03 +0000
From: Jamie Lokier <jamie@shareable.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Daniel Walker <dwalker@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Ryan Mallon <ryan@bluewatersys.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091215204803.GA26319@shareable.org>
References: <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com> <20091214064545.GK5114@elf.ucw.cz> <1260813293.13078.15.camel@c-dwalke-linux.qualcomm.com> <BD79186B4FD85F4B8E60E381CAEE19090200E9C6@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200E9C6@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> From Pavel's implementation it appears that the gpio's are organized
> as a number of 8-bit ports.  Each of these ports only have one 8-bit
> register.  Writing a '1' to a bit in the register makes the
> associated pin a high-level output.  Writing a '0' makes the pin a
> low-level output or an input pin.  Reading the port at this point
> will return the actual 'input' level of the pin.
> 
> The hardware seems a bit strange and I just wanted to verify that this is
> correct.  If it is, this would explain the need to keep the 'shadow' contents
> of the port in order to set the 'direction' of a pin.

It sounds similar to the PCF8575 (except polarity is reversed), which
is an I2C-driven GPIO chip with "quasi-bidirectional I/O pins", so not
completely weird.

The PCF8575 is more or less an open collector output - it drives a pin
low when 0 is written, and lets it be pulled high by an external
resistor when 1 is written, and reads return the current measured
level.  So by writing 1, you can use the pin as an input, or you can
use it as an output by using a pull-up resistor.

However, to complicate matters, when transitioning from 0 to 1, the
PCF8575 briefly drives the output high, to ensure that a pulled up
output has a rapid transition.

Because of that, you *must not* write 0->1 transitions to the PCF8575
for a GPIO that is driven low by something else, unless you want a
current spike.  So you can't use it as an open collector bus, for
example, and it's important to maintain a shadow variable so that you
don't write back bit values read from the chip.

(I don't know why they don't just use separate enable and value bits
like everything else, but there you go).

Perhaps the Dream's GPIOs are similar, but with opposite polarity.
If it also has the same transition driving spike, writing a 1->0
transition would be bad for the hardware making the shadow variable
even more important.

> I was also wondering if the initial 'shadow' value needs to be written to the
> port at init in order to correctly establish the output value for specific
> pins.

If it's like the PCF8575, after hard reset the bits will all be
configured in the input state, and rely on external pull-downs to set
bootup values.

-- Jamie
