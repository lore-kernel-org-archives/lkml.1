Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXBWQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXBWQIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXBWQIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:08:18 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:43121 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbXBWQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:08:17 -0500
Message-ID: <45DF1165.2080003@student.ltu.se>
Date: Fri, 23 Feb 2007 17:08:05 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Milind Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
References: <3b44d3fb0702222056k1d2a9b57q69a3555a09a9058e@mail.gmail.com>	 <3b44d3fb0702230014x4ee4a1dewdc624c54b3635e15@mail.gmail.com>	 <45DEAC45.7090105@student.ltu.se>	 <3b44d3fb0702230215o2fbd5a3y25729e481a447149@mail.gmail.com>	 <45DEF5EE.4030002@student.ltu.se> <d120d5000702230657s1860efb3o6986277901f13d03@mail.gmail.com>
In-Reply-To: <d120d5000702230657s1860efb3o6986277901f13d03@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 2/23/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>> Milind Choudhary wrote:
>> > On 2/23/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>> >> > +#define BITWRAP(nr)    (1UL << ((nr) % BITS_PER_LONG))
>> >> >
>> >> > & make the whole input subsystem use it
>> >> > The change is huge, more than 125 files using input.h
>> >> > & almost all use the BIT macro.
>> >> It is as a big of change, but have you dismissed the "BIT(nr %
>> >> BITS_PER_LONG)" approach?
>> >
>> > no..
>> > but just looking at the number of places it is being used,
>> > it seems that adding a new  macro would be good
>> > which makes it look short n sweet
>> You have a point there but I still don't think it should be in bitops.h.
>> Why should we favor long-wrap before byte-wrap, so what do you think
>> about doing:
>>
>> #define BITWRAP(x)      BIT((x) % BITS_PER_LONG)
>>
>> in input.h? Otherwise I think it should be call LBITWRAP (or something)
>> to both show what kind it is and enable us to add others later.
>
> Why would you not want to have what you call bitwrap as a standard
> behavior? Most placed to not use modulus because they know the kind of
> data they are working with but should still be fine if generic
> implementation did that.
>
Both because I find the name not as expressive as simple "BIT(x % 
something)", but mainly since it only enables wrapping of the long-type. 
But that is just my opinion.
Just to test:

> grep -Enr "BIT\(.*\%" *
include/asm-arm/arch-h720x/irqs.h:114:#define IRQ_TO_BIT(irq) (1 << ((irq - NR_GLBL_IRQS) % 32))
include/asm-arm/arch-omap/irqs.h:274:#define OMAP_IRQ_BIT(irq)  (1 << ((irq) % 32))
include/asm-i386/mach-visws/piix4.h:17:#define  GPIBIT(x)               (1 << ((x)%8))
include/linux/netfilter/xt_conntrack.h:11:#define XT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
include/linux/netfilter/xt_state.h:4:#define XT_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
...

So it seems there are some instances who wrap but they don't seem to 
like BITSWAP (well, maybe those "% 32" on an appropriate arch).

So I think that if an subsystem uses something like this much (like 
input.h), then it is up to that subsystem to provide it. When more then 
one sub-system have a need for it, then it should be a common define (as 
BIT is now). But as I said, that is just my opinion.

Richard Knutsson

