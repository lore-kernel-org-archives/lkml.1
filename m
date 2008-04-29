Return-Path: <linux-kernel-owner+w=401wt.eu-S965274AbYD2Aql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274AbYD2Aql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762508AbYD2AqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:46:14 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:22100 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755040AbYD2AqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:46:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=u3Sv6CjOfYDkUrkvytpCKjDAJXMfsIyORRs+99wT7p5FDLjosMF8C5iii1AH3LHefrtZjr138tdRYMyt+KEV7M2vBnHtzY+jxXtpYJWXhjdKr0nfdzaGUfPuY+jWPyf7lQPf5D66KtBTIRIf7FkRt9k2jeEJBCJuez43X9Hy4ZQ=  ;
X-YMail-OSG: Tp1E4MsVM1lTAWbX7qBBNQksl50mSdPh1Y_7wJTt.je0Y1cPDK5z9gjV4mGTu7HXKoWNzYuUF4985oghg_znf9Dg4jtn4aRjLPa2i7_T6CXeyFz7a3mJYuuKvvW2f1YndaA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Mon, 28 Apr 2008 17:45:58 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <Pine.LNX.4.64.0804281507160.6832@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0804281507160.6832@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804281745.59442.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Trent Piepho wrote:
> On Mon, 28 Apr 2008, David Brownell wrote:
> > Simple sysfs interface for GPIOs.
> >
> >    /sys/class/gpio
> >        /gpio-N ... for each exported GPIO #N
> 
> I liked it better they way I had it, "label:N".

Those labels may not be available though; or valid in pathnames.

 
> When you have multiple GPIO sources, it's a lot easier to see where they are
> comming from if they use the chip label.  Especially if support for dynamic
> allocation of gpio numbers is written.

I'd rather see such stuff in a "chip_label" attribute.  Easy enough to
add such a thing.  (The dynamic allocation code is now kernel GIT...)

 
> > 	    /value ... always readable, writes fail except for output GPIOs
> > 	    /direction ... writable as: in, out (default low), high, low
> 
> You took away the code for the label field?  That was one of the features of
> my code that Ben Nizette mentioned as an advantage over a char-device
> interface.

Since it's not always available, I removed it.  Note that you're
talking about the label passed to gpio_request() here, not the one
applied to the gpio_chip.  I could restore this as a "gpio_label"
attribute, that's not always present ... but I'd rather not have
such "optional" stuff.

 
> >    	/control ... to request a GPIO be exported or unexported
> >
> > GPIOs may be exported by kernel code using gpio_export(), which should
> > be most useful for driver debugging.  Userspace may also ask that they
> > be exported by writing to the sysfs control file, helping to cope with
> > incomplete board support:
> 
> Why can't all gpios appear read-only in sysfs by default?

Typical SOC based systems have up to a few hundred pins that could
be used as GPIOs.  The number actually used as GPIOs is rarely more
than a dozen or two, with other pins generally muxed to a peripheral
function ... or not even connected.

There's no point in having a few hundred useless nodes in sysfs!


> > This adds a device pointer to "struct gpio_chip".  When GPIO providers
> > initialize that, sysfs gpio class devices become children of that device
> > instead of being "virtual" devices.  The (few) gpio_chip providers which
> > have such a device node have been updated.  (Some also needed to update
> > their module "owner" field ... for which missing kerneldoc was added.)
> 
> I don't see what's wrong with having devices add to gpiolib create a device

It can't know where in the device tree to put such device nodes,
or how to implement operations like suspend() and resume() for
such nodes.  Creating such nodes, and their drivers, is NOT a role
for generic code like gpiolib.


> for the gpio's to be the children of.  You said that some devices can't do
> this, but I don't see the difficulty.
> 
> platform_device_register_simple("my-gpio", 0, NULL, 0);
> 
> How hard is that?

Most GPIOs come from platform code that doesn't create such a device
today.  In cases like OMAP, GPIOs are usable even before memory
allocations can work, so creating and using device nodes for GPIO
controllers would involve updating code running VERY early in boot...

You're free to write patches creating such device nodes, and work
with the platform maintainers to convert their GPIO support to use
standard driver model devices and drivers, then merge the results.

 
> > Based on a patch from Trent Piepho <tpiepho@freescale.com>, and comments
> > from various folk including Hartley Sweeten.
> 
> I don't recall seeing those comments.  Where were they posted?

Some were on-list, some were off-list.  The comments have been
coming off and on for a few years now, so I'm certain you would
not have seen all of them.  (I wouldn't have, either!)


> > +		status = gpio_export(gpio);
> > +		if (status < 0)
> > +			gpio_free(gpio);
> > +		else
> > +			set_bit(FLAG_SYSFS, &gpio_desc[gpio].flags);
> > +
> > +	} else if (strcmp(cmd, "unexport") == 0) {
> > +		/* reject bogus commands (gpio_unexport ignores them) */
> > +		if (!gpio_is_valid(gpio))
> > +			goto fail;
> > +		if (!test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags))
> > +			goto fail;
> > +
> > +		gpio_free(gpio);
> 
> Maybe you could simplify the text parsing by having positive gpio numbers
> export the gpio and negative numbers un-export the gpio?  Then there would not
> be any need to parse a command with arguments.

I had that thought too.  Even though I think that solution
is kind o fugly.  ;)

If need be, that can be changed.

- Dave
