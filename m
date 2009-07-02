Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbZGBJIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbZGBJIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZGBJIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:08:43 -0400
Received: from smtp.nokia.com ([192.100.122.233]:41525 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZGBJIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:08:42 -0400
Subject: Re: [RFC PATCH 0/3] GPIO switch framework
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: ext Ben Nizette <bn@niasdigital.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "juha.yrjola@solidboot.com" <juha.yrjola@solidboot.com>
In-Reply-To: <200907011403.53811.david-b@pacbell.net>
References: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
	 <1237703121.2720.39.camel@linux-51e8.site>
	 <1238491138.5936.86.camel@jani-desktop>
	 <200907011403.53811.david-b@pacbell.net>
Content-Type: text/plain; charset=utf-8
Date: Thu, 02 Jul 2009 12:07:56 +0300
Message-Id: <1246525676.9225.101.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jul 2009 09:08:01.0470 (UTC) FILETIME=[99B7E5E0:01C9FAF4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 23:03 +0200, ext David Brownell wrote:
> On Tuesday 31 March 2009, Jani Nikula wrote:
> > Hi Ben, and thanks for your feedback.
> > 
> > On Sun, 2009-03-22 at 07:25 +0100, ext Ben Nizette wrote:
> > > On Fri, 2009-03-20 at 15:50 +0200, Jani Nikula wrote:
> > > > Hi -
> > > > 
> > > > This RFC patchset is a pretty straightforward adaptation of OMAP GPIO
> > > > switch framework for mainline integration.
> > > > 
> > > > The GPIO switch framework allows reporting and changing GPIO switches
> > > > via sysfs, with debouncing and sysfs/in-kernel notifications for input
> > > > switches.
> > > 
> > > OK, so what does this do that /sys/class/gpio/gpioN doesn't currently do
> > > apart from debouncing?  And the output being a string rather than a
> > > simple value (which IMO might be better suited to userspace
> > > interpretation anyway).
> > 
> > In addition to debouncing, there's sysfs and in-kernel notifications.
> 
> And you had said off-list you were looking at adding
> some debouncing support to the sysfs hooks.

Yes, Daniel Glöckner's patch you refer to below looks like a good base
for that. It came after this patch set, and I think it's a nice generic
building block that accomplishes a part of what the gpio-switch
framework does.

> > To hide potential changes in hardware from userspace, there's naming of
> > the sysfs entries (e.g. /sys/class/gpio/switch-foo) and a flag for
> > inverting the value.
> 
> You've recently sent a patch to do that using the existing
> gpio sysfs support ... it's in the MM tree, although an update
> will remove the BUG_ON calls.
> 
>   http://marc.info/?l=linux-kernel&m=124471204121635&w=2

The update is now in the MM tree as well. Another building block.

> I agree with Ben that string names are better left for userspace
> tools to handle.  (Why limit things to English?)  Same for all
> interpretation -- "0" might mean "open" or "connected" or "on",
> or maybe sometimes it's "1" which means that.

Agreed.

> > > I've got a patch, little abandoned at the bottom of my queue, which adds
> > > poll(2) compatibility to the gpiolib sysfs entries [1] and extending
> > > this patch to do debouncing as well would be almost trivial.
> > 
> > Your patch certainly looks promising, and indeed overlaps with my work.
> > Debouncing could be easily added, and perhaps symbolic links to provide
> > names for the switches.
> 
> And as you know, Daniel Glöckner has an updated version:
> 
>   http://marc.info/?l=linux-kernel&m=124463747423885
> 
> Looks promising.

Indeed.

> > However, if I didn't miss anything, your patch allows setting up the
> > notification through sysfs only, and there's no way of doing it from
> > kernel side. Also, I'd need debounced callback notifications.
> 
> That is, in-kernel notifications?  Normally that's what GPIO interrupts
> handle.

True, but then you'd need to have two debouncing mechanisms (I'm talking
about software debouncing), one for gpiolib sysfs (once someone
implements that) and one for the interrupts. Or the driver would need to
have its own sysfs.

Without debouncing, there's no problem of course in just using GPIO
interrupts - except maybe for gpio_request being done in gpiolib for the
sysfs, so it can't be done in the driver.

Maybe this is a corner case and a non-issue here.

> Debouncing gets messy, what with hardware support varying so much,
> but presumably some low-bitrate software debounce may serve.  Folk
> have asked for such things in the not-so-distant past.

Software debouncing is what I'm talking about, and in connection with
the gpiolib sysfs, a high-bitrate hardware debouncing would be overkill,
don't you think?

> > > I guess what I'm getting at is that this seems like it solves a problem
> > > which has been pretty much solved elsewhere since the OMAP boys wrote
> > > this.
> > 
> > It's been only partially solved by your patch, and as you say yourself,
> > it's still at the bottom of your queue. There's also the gpio-keys
> > (pointed out by Philipp Zabel elsewhere in this thread), but that's
> > input only and lacks in-kernel notifications.
> 
> Note that gpio-keys has some minimal debouncing already.
> Maybe not the most effective solution for software debounce
> of GPIOs, but if there's a generalized version of debounce
> then maybe that driver could use it too.

Something along the lines of what OMAP gpio-switch framework or
gpio-keys have for debouncing was what I had in mind. If you have better
ideas, I'm all ears. Anyway, implementing that as a generic debouncing
module that could be used elsewhere would be a good idea too.

> As for the input framework ... stuff like MMC/SD and PCMCIA
> card insert/remove events have not yet been handled through
> that framework, and I think it's very appropriate that an
> MMC host adapter be independent of the input subsystem.  :)
> 
> But maybe some of those cases should be handled through small
> shims that can issue the event callbacks to MMC or PCMCIA
> host adapter code based on input events.  The systems you
> work with can assume the input subsystem, I think.
> 
> 
> > AFAIK the input layer is 
> > also pretty fixed in what can be reported. So I am not convinced this
> > has been solved elsewhere.
> 
> Parts of it have been, and in more general ways.  I'm a lot more
> comfortable with the notion of having a solution that's built of
> reusable chunks than having something quite so focussed on what,
> say, only a Nokia tablet needs.  Which seems to be what you're
> thinking lately too, so all is fine.  ;)

Yes, well, I kind of had to change my thinking, since this patch set
wasn't going anywhere! :) And I do appreciate the reusable chunks as
well.

Thanks for your comments.


BR,
Jani.


