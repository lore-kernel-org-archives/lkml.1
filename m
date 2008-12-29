Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYL2UfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYL2UfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYL2Ue2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:34:28 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48120 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752386AbYL2UeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:34:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ngTqykkoZKfviaD44dOiIPJ1hIn/sWxS89+zwoliOuCU1O0ZOvfP0yruh4Uro1V/Evoel2oSQHtq2Z/buYSg2/7qAeVkKCG55Tre9+ZWSAPzuNQaB+hKjTxwifgXFExaioMf8wPBHST5sVmlVdzpve6Ktrt2hL3uY3vB2Ylx+S4=  ;
X-YMail-OSG: aZyUgxkVM1mEtZOQnVbhb5l4.aYe.vkKw965VgpTPDNLS4XkNcwC1BGs9yk_dznWl8zkSp69bpT6Nw6FhQVrPZh8PXUW.Pp3WPLDSvh5KCEO8msSHo.7ovDAOi8mrep.hw85Oz8a3rUL9p31r5EptNRE
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Mon, 29 Dec 2008 11:32:14 -0800
User-Agent: KMail/1.9.10
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com> <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com>
In-Reply-To: <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200812291132.14806.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 December 2008, Jaya Kumar wrote:
> Oh, gosh darn it, how time has flown. My email above was to make sure
> I have understood the feedback. I assume I should just get started on
> implementing. Just to double check, the plan is:
> - add bitmask support.
> - add get_batch support
> - improve naming. I think gpio_get_batch/gpio_set_batch sounds good.

I was expecting to get some agreement on interfaces first.


> I plan to have something like:
> 
> void gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth);
> u32 gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth);

I still don't like the word "batch" here.  Did you look
at the <linux/bitmask.h> interfaces as I suggested?  They
would suggest something rather different:

 - passing bitmasks as {unsigned long *bits, int count} tuples
 - separate calls to:
     * zero a set of bits (loop: gpio_set_value to 0)
     * fill a set of bits (loop: gpio_set_value to 1)
     * copy a set of bits (loop: gpio_set_value to src[i])
     * read a set of bits (loop: dst[i] = gpio_get_value)
     * ... maybe more

Any restriction to 32 bit value seems shortsighted.  It would
make sense to wrap the GPIO bitmask descriptions in a struct,
letting drivers work with smaller sets -- probably most would
fit into a single "unsigned long".


> I think I should explain the bitmask and bitwidth choice. The intended
> use case is:
> for (i=0; i < 800*600; i++) {
>  gpio_set_batch(...)
> }
> 
> bitwidth (needed to iterate and map to chip ngpios) could be
> calculated from bitmask, but that involves iteratively counting bits
> from the mask, so we would have to do 800*600 bit counts. Unless, we
> do ugly things like cache the previous bitwidth/mask and compare
> against the current caller arguments. Given that the bitwidth would
> typically be a fixed value, I believe it is more intuitive for the
> caller to provide it, eg:
> 
> gpio_set_batch(DB0, value, 0xFFFF, 16)
> 
> which has the nice performance benefit of skipping all the bit
> counting in the most common use case scenario.

That doesn't explain the bit mask and bitwidth parameters at all.


> While we are here, I was thinking about it, and its better if I give
> gpio_request/free/direction_batch a miss for now.

Let's not and say we didn't.  Providing incomplete interfaces
isn't really much help.


> Nothing prevents 
> those features being added at a later point. That way I can focus on
> getting gpio_set/get_batch implemented correctly and merged as the
> first step.

First step needs to be defining the interface extensions needed.

- Dave
