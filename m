Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZGAVED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZGAVED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZGAVDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:03:53 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:35034 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753292AbZGAVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:03:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2S1gXx5r0bzMiypNyHGfaiR09RsDxlm2Sn4dn1mPWSPbU7yr7a2eCH8zpDCFMf12aOM7ErVofbXa82qX+iSe8Y+SxzLKha5BQwO3ssbbD3vPhp0qqsCwCgqDpOQ+5h9bihSNTbEAmasnhWP/1l5IrjBy434xlVvmQVahaNedt5U=  ;
X-YMail-OSG: NU2YzdgVM1m7S1UsMWTIPlanTVFQnYRVvtNR7PscMWHOwJV4rOQJTIesX0.9V2wdvBu_Vf3nWf.49V0kzuo1VgPSKgtEAGTADuL13pNv8Z2dLhk5tJNtnAJpzh4rjEXRIfHED8eqcuHwt00Z3he7bHg6iMcWLzKxgdIGrcpnz7Y2Hcv4gOICMAfJU6ZV5vfXZqTntgNODy8hviOtEgdWXeiMyJ9mNsbmQ61tEmf6HNNAr6asIKfhisH0ncT.Mlz.TTVU9JysEl53YDXJVKTM.tWS.GIAmVz93SvjfKue6.G7iaLchw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: Re: [RFC PATCH 0/3] GPIO switch framework
Date: Wed, 1 Jul 2009 14:03:53 -0700
User-Agent: KMail/1.9.10
Cc: ext Ben Nizette <bn@niasdigital.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "juha.yrjola@solidboot.com" <juha.yrjola@solidboot.com>
References: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com> <1237703121.2720.39.camel@linux-51e8.site> <1238491138.5936.86.camel@jani-desktop>
In-Reply-To: <1238491138.5936.86.camel@jani-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907011403.53811.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Jani Nikula wrote:
> Hi Ben, and thanks for your feedback.
> 
> On Sun, 2009-03-22 at 07:25 +0100, ext Ben Nizette wrote:
> > On Fri, 2009-03-20 at 15:50 +0200, Jani Nikula wrote:
> > > Hi -
> > > 
> > > This RFC patchset is a pretty straightforward adaptation of OMAP GPIO
> > > switch framework for mainline integration.
> > > 
> > > The GPIO switch framework allows reporting and changing GPIO switches
> > > via sysfs, with debouncing and sysfs/in-kernel notifications for input
> > > switches.
> > 
> > OK, so what does this do that /sys/class/gpio/gpioN doesn't currently do
> > apart from debouncing?  And the output being a string rather than a
> > simple value (which IMO might be better suited to userspace
> > interpretation anyway).
> 
> In addition to debouncing, there's sysfs and in-kernel notifications.

And you had said off-list you were looking at adding
some debouncing support to the sysfs hooks.


> To hide potential changes in hardware from userspace, there's naming of
> the sysfs entries (e.g. /sys/class/gpio/switch-foo) and a flag for
> inverting the value.

You've recently sent a patch to do that using the existing
gpio sysfs support ... it's in the MM tree, although an update
will remove the BUG_ON calls.

  http://marc.info/?l=linux-kernel&m=124471204121635&w=2

I agree with Ben that string names are better left for userspace
tools to handle.  (Why limit things to English?)  Same for all
interpretation -- "0" might mean "open" or "connected" or "on",
or maybe sometimes it's "1" which means that.


> > I've got a patch, little abandoned at the bottom of my queue, which adds
> > poll(2) compatibility to the gpiolib sysfs entries [1] and extending
> > this patch to do debouncing as well would be almost trivial.
> 
> Your patch certainly looks promising, and indeed overlaps with my work.
> Debouncing could be easily added, and perhaps symbolic links to provide
> names for the switches.

And as you know, Daniel Glöckner has an updated version:

  http://marc.info/?l=linux-kernel&m=124463747423885

Looks promising.

 
> However, if I didn't miss anything, your patch allows setting up the
> notification through sysfs only, and there's no way of doing it from
> kernel side. Also, I'd need debounced callback notifications.

That is, in-kernel notifications?  Normally that's what GPIO interrupts
handle.

Debouncing gets messy, what with hardware support varying so much,
but presumably some low-bitrate software debounce may serve.  Folk
have asked for such things in the not-so-distant past.


> > I guess what I'm getting at is that this seems like it solves a problem
> > which has been pretty much solved elsewhere since the OMAP boys wrote
> > this.
> 
> It's been only partially solved by your patch, and as you say yourself,
> it's still at the bottom of your queue. There's also the gpio-keys
> (pointed out by Philipp Zabel elsewhere in this thread), but that's
> input only and lacks in-kernel notifications.

Note that gpio-keys has some minimal debouncing already.
Maybe not the most effective solution for software debounce
of GPIOs, but if there's a generalized version of debounce
then maybe that driver could use it too.

As for the input framework ... stuff like MMC/SD and PCMCIA
card insert/remove events have not yet been handled through
that framework, and I think it's very appropriate that an
MMC host adapter be independent of the input subsystem.  :)

But maybe some of those cases should be handled through small
shims that can issue the event callbacks to MMC or PCMCIA
host adapter code based on input events.  The systems you
work with can assume the input subsystem, I think.


> AFAIK the input layer is 
> also pretty fixed in what can be reported. So I am not convinced this
> has been solved elsewhere.

Parts of it have been, and in more general ways.  I'm a lot more
comfortable with the notion of having a solution that's built of
reusable chunks than having something quite so focussed on what,
say, only a Nokia tablet needs.  Which seems to be what you're
thinking lately too, so all is fine.  ;)

- Dave

