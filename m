Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYANJph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYANJph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYANJp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:45:28 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:53742 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbYANJp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:45:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P2mSR7IY8PdTX13eu/VjAI0q0TydyTs0J0kTncTqLgDQSWus2uw8QQhJUyqc9CqDNdt8Gim+CccOdkadEkusrYpQZaE6vPEP6wXsAyYkD570A1dmMehIVQraU4VaCftzT01P3iMqF8sKmEe2ijLKnJU/Izz1P70EC0KL++vtu6Q=
Message-ID: <8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
Date: Mon, 14 Jan 2008 04:45:25 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC, PATCH] watchdog on gpio
Cc: "Marc Pignat" <marc.pignat@hevs.ch>, wim@iguana.be,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080114092905.227c5a38@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801101611.08867.marc.pignat@hevs.ch>
	 <8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	 <20080114090329.6efa2921@lxorguk.ukuu.org.uk>
	 <8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
	 <20080114092905.227c5a38@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 4:29 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Saves memory - you can't make inlined strings __initdata without breaking
> > > some compilers. So it is correct.
> >
> > you could make the same argument about all strings used in all __init
> > functions.  making a special case for this one string is just
> > confusing.  this is also used from the *platfrom driver probe*
> > function, not the *module init* function, which means it should be
> > __devinitdata (see below) ... which quickly adds to the
> > confusion/craziness.
>
> Not neccessarily see below. For strings there is a tricky tradeoff
> between space on embedded boxes and simplicity. On a 2GB desktop PC the
> decision is fairly trivial, on a PDA it gets a bit more important.

i'm aware of this (i bang on embedded no-mmu systems).  if his banner
string was crazy long, i'd more understand, but it isnt any longer
than any one of his error strings in the probe function.  in fact, all
of the error strings combined are more than 3x the size of his banner.

wonder if we could design a printk designed for __init functions to
address this in a clean fashion.
#define init_printk(fmt, __VA_ARGS__) \
  do { \
    static const __init char __fmt[] = fmt; \
    printk(__fmt , ## __VA_ARGS__); \
  } while (0)

(yes, i know this isnt perfect as you'd need to pass back the return
value of printk(), but it's an idea)

> > > > > +static int __init gpio_wdt_probe(struct platform_device *pdev)
> > > >
> > > > shouldnt this be __devinit ?
> > >
> > > IFF the device can be found/removed dynamically.
> >
> > wont __init get freed once the module has finished loading ?
>
> If your platform creates the device statically (as a lot of embedded
> platforms do) then the __init is fine. The platform register in
> init_module will call back the driver probe method and attach the device
> before the init_module exits.

there is no hard requirement anywhere that says platform resources
must be in the board resources file.  marking the functions as __init
instead of __devinit will basically cause a kernel crash if someone
tries to use dynamic platform resources.  there is no option that i'm
aware of that prevents dynamic platform resources which means there is
no way for the driver to say "i wont work with standard dynamic
platform resources".
-mike
