Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbYB0UBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbYB0UBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbYB0UBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:01:38 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44267 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757517AbYB0UBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:01:37 -0500
Message-Id: <1204142495.7277.1239470309@webmail.messagingengine.com>
X-Sasl-Enc: xqS1+c+NK5YOeTJUhnAit+HLaLkoG4TJDeSsvs0fvk37 1204142495
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com>
   <1203958478.20033.1239002461@webmail.messagingengine.com>
   <20080225170134.GA15839@elte.hu>
   <20080225180750.GA31054@mailshack.com> <47C3053D.5060504@zytor.com>
   <1203968796.24935.1239027765@webmail.messagingengine.com>
   <20080226093046.GK9857@elte.hu> <47C575E4.7050206@suse.de>
Subject: Re: [PATCH] reserve_early end-of-conventional-memory to 1MB II - some
   numbers to put it into perspective
In-Reply-To: <47C575E4.7050206@suse.de>
Date: Wed, 27 Feb 2008 21:01:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 Feb 2008 15:38:28 +0100, "Andi Kleen" <ak@suse.de> said:
> Ingo Molnar wrote:
> > * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > 
> >>> Either way, the code should be shared between 32 and 64 bits. There 
> >>> is nothing bitsize-specific about it!
> >> Of course. That's also why I already added the old-Dell case ;). But 
> >> one problem at a time, please!
> > 
> > i've applied your patch to x86.git#testing. Feel free to send a 
> > code-unification patch too :-)
> 
> Just to give some perspective of this:
> 
> On my laptop here
> 
>  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)

Hi Andi,

Can you provide the complete 'raw' e820 info? This is at least
not complete, and also might be after the sanitation. Do you
mean that (1) there is usable RAM somewhere between 0xa0000
and 0xd2000? Or that (2) this second line should be RAM, not
reserved?

Case (1) would surpise me, because I expect the VGA adapter
(which I assume is there...) to occupy 0xa0000 to 0xc0000 for
the framebuffer. Also, your case would be a lot stronger if
there were a line that explicitly indicated that there was
RAM there.

Case (2) would surprise me too, because a lot of software
would expect the system BIOS to reside in at least the area
0xf0000 to 0x100000. jmp 0xf000:fff0 for a reboot, no?

Laptops do not always have the VGA bios in the standard place,
so the range 0xc0000-0xd2000 could well be unused. Still, I
doubt that there is real RAM accessible in that region.

So I think you have not correctly interpreted the e820 info.
But, if you (or anyone else, for that matter) provide(s) a raw
e820 map that shows usable RAM in the region 0xa0000-0x100000,
the I agree that the patch should be reconsidered.

> This means it reserves only ~193KB in the 640k-1MB area
>
> With this patch it will reserve 384KB instead. This means 191KB
> are lost.

The two lines you gave say that two regions are reserved. Nothing
tells what is in between those regions. If a region is not
covered by e820 at all, it is to be considered unusable, right?

> While that doesn't sound too much it worth as much as
> 382 patches that reduce kernel code size by 512bytes or
> worth 3820 patches that reduce kernel code by 100 bytes in terms
> of memory consumption.

Agreed.

> Now such kernel code size patches are always popular, but why
> undo that work by throwing away perfectly good memory elsewhere?

I don't intend to. I have never seen a machine with usable
memory in the 0xa000-0x100000 region.

> Or also the laptop kernel does
> 
> Freeing unused kernel memory: 340k freed
> 
> This means the 193KB now lost are worth 56% of the complete
> memory that is freed by __initdata/__init. Just maintaining
> these annotations is a lot of work, but why do all that if we
> then throw away than half as much memory as they save so easily?

Agreed, if...

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

