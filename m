Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZASAPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZASAPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZASAOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:14:54 -0500
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:54324 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754506AbZASAOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:14:53 -0500
Message-ID: <4973C616.4010009@bluewatersys.com>
Date: Mon, 19 Jan 2009 13:15:18 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Jaya Kumar <jayakumar.lkml@gmail.com>
CC: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [RFC 2.6.28 1/2] gpiolib: add set/get batch v4
References: <12321862383405-git-send-email-jayakumar.lkml@gmail.com>	 <49738B8C.7020404@bluewatersys.com> <45a44e480901181546t140f7127hb2f2b5fbfdec8464@mail.gmail.com>
In-Reply-To: <45a44e480901181546t140f7127hb2f2b5fbfdec8464@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaya Kumar wrote:
> On Mon, Jan 19, 2009 at 4:05 AM, Ryan Mallon <ryan@bluewatersys.com> wrote:
>> Jaya Kumar wrote:
>>> Hi friends,
>>>
>>> +
>>> +     /* BATCH GPIO OUTPUT */
>>> +int gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int maskwidth);
>>> +
>>> +The following examples help explain how this function is to be used.
>>> + Q: How to set gpio pins 0 through 7 to all 0? (8 bits)
>>> + A: gpio_set_batch(gpio=0, values=0x0, bitmask=0xFF, width=8);
>>> + Q: How to set gpio pins 58 through 73 to all 1? (16 bits)
>>> + A: gpio_set_batch(gpio=58, values=0xFFFF, bitmask=0xFFFF, width=16);
>>> + Q: How to set gpio pins 16 through 47 to 0xCAFEC001? (32 bits)
>>> + A: gpio_set_batch(gpio=16, values=0xCAFEC001, bitmask=0xFFFFFFFF, width=32);
>>> +
>> Can the gpio_set_batch function be used to set non-consecutive gpios?
>> For example:
>>
>>  gpio_set_batch(0, 0x0, 0x88, 8);
>>
>> To clear gpios 3 and 7? It looks like the pxa implementation will
> 
> Hi Ryan,
> 
> For the first part, yes, it can do non-consecutive gpios by using the
> mask. Pins 3 and 7 are handled using a 5-bit mask. You'd  do
> gpio_set_batch(3 <- starting pin is gpio 3, 0x0 <- clear, 0x1F <-
> mask, 5 <- bit width of mask);
> 
>> support this, but can it be guaranteed for other architectures? If so,
> 
> That's a tough question. My basic answer would be yes because I've
> provided the generic set_batch handler that just uses single bit sets
> to achieve it. See __generic_gpio_set_batch() in patch). But if your
> question is deeper, ie: can it be optimized for other architectures? ;
> then I think I have to handwave a bit. I believe it can, as most of
> the CPUs I've seen expose gpio via a set register and clear register
> with variation between a context register to select which bank/module
> of gpios is being accessed versus just having a pool of set and clear
> registers (like pxa). If a CPU didn't have this and just had a blanket
> gpio register then the implementation would have to first read the
> previous register value (or cache it) in order to support doing the
> mask.

The EP93xx has a single register for reading, set and clearing the
states of gpios, so it would have to be read, masked and written. I'm
not sure if that would be quicker than doing a for-loop over the 8-bits
in the register (the EP93xx has 8 register banks of 8 gpios, each with
their own reigster set). I guess that even if it cannot be optimised for
a given architecture, then the standard for-loop method can be used. As
long as it is documented that non-consecutive setting should work so
that arch implementers can get it correct.

>> can we put an example in the documentation. If not, can we make it clear
> 
> Good point. I'll put it in the docs.

Cool, thanks.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
