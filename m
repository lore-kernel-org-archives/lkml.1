Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYHRPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYHRPmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYHRPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:42:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:28262 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYHRPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=isXyHfzimIzGk6+SOqoeO73OJcKI8PJTjxRdUcDkon2+JgF/sVT1Gr3uEAMv6ROo6N
         iXGgSKs9OG7mjC8bnn+8v/TBICuNmBNFwxawnOOOMdZQTIQutl9OwdUnNIjyqwacCVuu
         SraGroBr8MwcTY2J496pNOus8Ss64WC6Me5Qw=
Date: Mon, 18 Aug 2008 11:42:24 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC]  Resolve 2 year old issue with different demands
	on EVIOCGRAB
Message-ID: <20080818112609.ZZRA012@mailhub.coreip.homeip.net>
References: <18596.58273.713075.332009@notabene.brown> <20080815022453.GA9438@anvil.corenet.prv> <18600.51093.613662.435395@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18600.51093.613662.435395@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 10:51:33AM +1000, Neil Brown wrote:
> On Thursday August 14, dmitry.torokhov@gmail.com wrote:
> > Hi Neil,
> > 
> > On Fri, Aug 15, 2008 at 12:02:09PM +1000, Neil Brown wrote:
> > > 
> > > I'll let the comments in the patch below to most of the talking.
> > > This came up because I wanted to use EVIOCGRAB in some code on an
> > > Openmoko Freerunner, and found that EVIOCGRAG does different things on
> > > that kernel to elsewhere.  I looked into why, and found that there was
> > > a good reason but that the issues hadn't been completely resolved.  I
> > > hope to help resolve the issues so that EVIOCGRAB can behave the same
> > > everywhere, and still meet everybody's needs.
> > > 
> > > I would have Cc:ed to Magnus Vigerlof who wrote the original patch on
> > > which this is based, but his Email address doesn't appear in lkml.org.
> > > 
> > 
> > I don't think this is a viable solution - there are other "good"
> > handlers beisdes evdev, such as rfkill-input, which will still get
> > disabled by the "lightweight" grabs.
> > 
> > Overall I think it is application's responsibility to not use
> > multiplexing devices if they use evdev, bit I can consider adding a new
> > interface (maybe another ioctl) that would disable event delivery though
> > certain interfaces for a device.
> 
> Hi,
> 
>  I think you are saying that if the X server (for example) uses evdev
>  at all, it should use evdev exclusively for getting events, and not
>  use /dev/mice or whatever the equivalent is for keyboard (/dev/tty??).

Not quite, but generally yes - using multiplexing devices makes the
task of filtering out duplicate events much harder so it is better not
to use them. You can use /dev/input/eventX and /dev/input/mouseX
pretty easily but /dev/input/eventX and /dev/input/mice is hard to use
together.

>  But the X server still needs to know a little bit about /dev/tty to
>  make sure that control-C doesn't get delivered the wrong way.  That's
>  awkward.

Does it need to do anything besides switching VC into the raw mode?

>  It also negates much of the power of the input layer (easy hot-plug).
>  I don't much like that approach.
> 

I think this is the only sensible approach though. X needs to have
native hotplug capabilities anyway because of all these new mice that
have bazillion of buttons on them that PS/2 emulation simply can not
support. And once you have hotplug support in X and don't rely on
myultiplexors anymore you can remove bunch of things, like grabbing
devices in one fashion or another and you can even keep the devices
open while switching to the text mode - no need to close and reopen
them all the time.

>  I think your 'can consider' option involves the application (X
>  server) saying  "I want to use both /dev/input/eventX and
>  /dev/input/mice, so I'll break the connection between those so as not
>  to cause problems".
> 

Are there other applications besides X that have this kind of issue?
Hmm, GPM - hotplug scripts can probably just restart it any time they
see a mouse-like device appearing or going away.. DirectFB?

I think that the best solution is to fix applications, rather than
special case multiplexing devices like you suggested below.

Thanks.

-- 
Dmitry
