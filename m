Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbYHVUP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbYHVUP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYHVUPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:15:10 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:64108 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYHVUPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cS2ZhUsU36HI6MUz/oR5CBTn0VYhlxvLSHafClFpcKp1qR3bwHLkRgEsQ6dO/36AlR
         MTS64MQVeReaOZw5+FkEi9YRiFbcO+XkXYnCUjsenPlTYgDY+buL6cvMy4krXwOKra03
         qrj32AeqB9NIohCT4sgMP6KMLSU4sT6xREM+g=
Date: Fri, 22 Aug 2008 16:15:03 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC]  Resolve 2 year old issue with different demands
	on EVIOCGRAB
Message-ID: <20080822160414.ZZRA012@mailhub.coreip.homeip.net>
References: <18596.58273.713075.332009@notabene.brown> <20080815022453.GA9438@anvil.corenet.prv> <18600.51093.613662.435395@notabene.brown> <20080818112609.ZZRA012@mailhub.coreip.homeip.net> <18604.45689.859491.192621@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18604.45689.859491.192621@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 10:10:33AM +1000, Neil Brown wrote:
> On Monday August 18, dmitry.torokhov@gmail.com wrote:
> > On Mon, Aug 18, 2008 at 10:51:33AM +1000, Neil Brown wrote:
> > >  But the X server still needs to know a little bit about /dev/tty to
> > >  make sure that control-C doesn't get delivered the wrong way.  That's
> > >  awkward.
> > 
> > Does it need to do anything besides switching VC into the raw mode?
> 
> Probably not, no.
> 
> > 
> > >  It also negates much of the power of the input layer (easy hot-plug).
> > >  I don't much like that approach.
> > > 
> > 
> > I think this is the only sensible approach though. X needs to have
> > native hotplug capabilities anyway because of all these new mice that
> > have bazillion of buttons on them that PS/2 emulation simply can not
> > support. And once you have hotplug support in X and don't rely on
> > myultiplexors anymore you can remove bunch of things, like grabbing
> > devices in one fashion or another and you can even keep the devices
> > open while switching to the text mode - no need to close and reopen
> > them all the time.
> 
> So your position is that for anything non-trivial, the clever stuff in
> the input layer like multiplexing and simulating PS2 mice is not
> sufficiently powerful and not worth fixing, and it should all be left
> to userspace.  Correct?

Yes, due to limitations of the PS/2 protocol itself among other
things. I am sure Vojtech will correct me but I believe he made
/dev/input/mice as a stop-gap measure until X is ready... well, it was
8 some years ago ;(

> I must confess a certain sympathy for that position, but it does make
> solving my current problem harder - which dampens my enthusiasm :-)
>

Yeah, I can understand that.

> So:  The X server need to support hotplug of input devices. 
> Apparently there is code out there (for nearly 2 years) but it doesn't
> seem to be in a release yet.
> Quoting http://wiki.x.org/wiki/XInputHotplug
> 
>    The X.org server supports hotplugging input devices since November
>    2006
>    http://lists.freedesktop.org/archives/xorg/2006-October/019007.html
>    (X11R7.2 will NOT have hotplug support yet).  
> 
> So both the kernel and the X server could provide the hotplug support
> required, but neither are really quite usable at the moment for very
> different reasons.  Sad.
> Options...
>  First: problem description.
>    Device with a touchscreen wants:
>     - touch screen events to be delivered as absolute events to X
>          server.
>     - Other programs to be able to monitor the touch screen to
>       e.g. detect activity independently of whether an X server is in
>       use or direct fbdev access is happening (e.g. Qtopia).
>     - hot-plugged mice (e.g. bluetooth) should be recognised by
>       X server.
> 
>  We could:
>   1/ Wait for X11 XInputHotplug to be released.
>   2/ Hack a little input driver for X which somehow finds 
>      mouse devices and interprets them.
>   3/ Use kernel's input multiplexing and:
>    3a/ change EVIOCGRAB to not exclude other evdev devices
>    3b/ change EVIOCGRAB to optionally not exclude other evdev devices.
>    3c/ somehow convince mousedev never to listen on the touchscreen.
> 
>  Did I miss anything?
> 
>  3a is what the openmoko kernel (and presumably others) do today.  But
>  it breaks backwards compatibility .
>  3b is what I suggested but you don't like.
>  1 does not provide a solution in a reasonable time frame
>  2 is likely to be very messy and error prone
> 
>  So I'm now wondering about 3c.

All these solutions require changes to userspace/drivers. I feel that
this time is better spent on the X itself rather on various drivers
re-implementing the same thing and stumbling over the same problems.

>  While I can understand the value of pretending that a touch-pad looks
>  like a mouse, a touch-screen is a very different thing.  I don't
>  think it would ever make sense for a touch screen to generate
>  relative events.

It probaibly was a mistake to make touchscreens go through
/dev/input/mice. Again, the adea was to allow limitied use until
proper driver is installed.

>  So how might we make our touchscreen appear uninteresting to
>  mousedev?
> 
>  We could get it to return some other 'key' rather one of
>      BTN_TOUCH BTN_TOOL_FINGER BTN_LEFT
> 
>  Maybe BTN_STYLUS.  Given that the touchpad is designed for finger
>  usage it is a bit of a lie.  But it would work.
> 
>  This is really sidestepping the issue.  We really want to be able to
>  say "This is a device where relative events are completely
>  meaningless".  I suspect that isn't going to happen though.
> 
>  tslib doesn't seem to care much about what key is sent.  It only
>  looks for BTN_TOUCH, but all it sees is when the value goes to zero
>  as a "finger is removed" event.  It equally gets that from
>  ABS_PRESSURE going to zero.
> 
>  So if I just arranged for the touchscreen to deliver BTN_STYLUS
>  instead of BTN_TOUCH it would hide it from all the mousedev devices
>  (which I think is the correct thing) and mean that the Xserver
>  doesn't need to use EVIOCGRAB, so we don't need to break it in the
>  kernel.
> 
> OK, I think I can go forward with that.  Thanks for listening.
> 

Maybe openmoko could just patch mousedev to ignore touchscreens for
now, until X is fixed?

-- 
Dmitry
