Return-Path: <linux-kernel-owner+w=401wt.eu-S1764925AbXJPJNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764925AbXJPJNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbXJPJMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:12:54 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49773 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498AbXJPJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:12:53 -0400
X-Sasl-enc: i1qfOXJnQ65+bw6AUbDL9UpXE0VLJsCNELxHqVwyAxg6 1192525971
Date: Tue, 16 Oct 2007 07:12:48 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Katz <katzj@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071016091247.GC15293@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <1192483627.25568.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192483627.25568.60.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Jeremy Katz wrote:
> On Mon, 2007-10-15 at 19:07 -0200, Henrique de Moraes Holschuh wrote:
> > On Mon, 15 Oct 2007, Jeremy Katz wrote:
> > > There are standard keycodes for brightness and volume; map the events to
> > > emit them so that things work properly
> > 
> > NAK.  It is the completely wrong thing to do for IBM thinkpads which process
> > volume and brightness completely in firmware.
> > 
> > And the input subsystem maintainer has made it extremely clear in various
> > threads that the input devices are *not* to be used as a notification
> > service for on-screen-display or other such stuff.  If you send volume and
> > brightness *key* events to userspace, it is supposed to act on them and
> > raise/lower brightness/volume, which is the wrong thing to do on thinkpads.
> > Never mind that HAL is ignoring the input maintainer's directions and
> > violating this.
> 
> It seemed to be doing the right thing here on an X31 (had to give it
> back to its owner; will retrieve and test again tomorrow to make sure
> everything is matching up).

Look *very* closedly at what HAL is doing on that X31.  If it seems to do
the "right thing" while reporting keys to userspace over the input layer, it
is because HAL is abusing the input layer and using input events in "passive
mode", just to report brightness and volume changes through OSD or somesuch.
Either that, or you have such an old userpace there, that it doesn't react
to input events at all...

I am not exactly against the notion of passive input events (i.e. stuff you
are *not* to act upon other than to give user feedback), but you cannot
deliver them as EV_KEY (you cannot tell those apart from proper "please do
change the brightness/volume/whatever" EV_KEY), and the input subsystem is
not to be used like that according to its maintainer.

So, I want no such behaviour in thinkpad-acpi, please.  There are other ways
to adress the needs of userspace, and they are being implemented (although
slowly, I am sorry about this, but my bandwidth is limited).

> > We should fix the backlight class to be more useful and support poll() or
> > somesuch, for userspace to track the backlight level in a resource-friendly
> > way for OSD (the only sane thing to do on an IBM thinkpad with such events).
> > And an ALSA mixer to provide a proper path to the thinkpad-acpi volume
> > functionality is also in my schedule for 2.6.25.
> 
> I don't know that having another mixer is really the right answer.  You

It is on IBM thinkpads, were you *really* have a second hardware mixer, that
operates completely independent of the OS and controls the output signal
level for the speakers and headphone (and does NOT control the output signal
level on the audio output on docks and port replicators, etc).

The volume and mute buttons act directly on that mixer (through the
firmware), and thinkpad-acpi can control that mixer fully.  A mixer is a
mixer, and the proper interface to talk to a mixer is an ALSA mixer
interface.

The fact that an IBM thinkpad also lets you know exactly which mixer control
was pressed *on some models* (T4x and newer, X31 and newer, as long as the
latest BIOS is used) does not mean you are to use that to poke on the AC97
mixer controls.   Heavy hint: Windows does NOT touch the AC97 mixer.
Another heavy hint: you need to track the mixer state and filter the events
to reproduce the mixer behaviour, where mute always mutes (not mute/unmute)
and you unmute with a press of one of the volume up/down buttons (which
won't change volume level when unmuting).

And on Lenovo thinkpads, the same level of control is available.  The
difference is that I am not sure if the firmware is always acting on the
mixer automatically on all models and BIOS revisions.  I will ask Lenovo
about it.   This still asks for a mixer interface to control the internal
speaker/headphone mixer, but it *might* ask for input events for volume
up/down/mute in *some* Lenovo models.  Again, this is not something the
patch in question does correctly.

> want to have the buttons/hardware volume matching (and showing)
> on-screen changes to the system volume.  Otherwise, things are just
> confusing to a user.

Any thinkpad user that looks at that keyboard and thinks that pressing its
keys is to do anything else than control the volume of the built-in speakers
and headphone output, is already confused.  Blame IBM, if you must... but
that's how things are.  Lenovo may change it... or not.  If they do, I will
adapt the driver to do the right thing: that's why the driver *can* report
volume input events.  So that I can enable it by default should it become
the right thing to do on a given thinkpad model.

And really, you will *not* have me agree that pressing a volume key should
act on both mixers at once, ever.  This reduces by half the dynamic range of
the volume control on a part of the curve (the AC97 mixer has more levels
than the internal mixer).

OSDs for volume should be tied to the ALSA mixers.  One will be provided by
thinkpad-acpi soon.  Heck, I can get it ready for 2.6.24 if you convince
Linus and Len to take it in after -rc1.  Otherwise, it is scheduled for
2.6.25.

> > As for Lenovo thinkpads, brightness control is to be processed by the ACPI
> > video module, so brightness hot keys are not to be reported by default there
> > either.  
> 
> Brightness events are being reported as is with the X60t I've got...

They are reported through ACPI events and not by thinkpad-acpi.  Remove the
drivers and watch the ACPI messages.

> > I am not so sure about the volume keys, but your patch touches the
> > IBM keymap *and* you provide no testing information for the various Lenovo
> > models, so I have to NAK it as well until more information is available.
> 
> Having the volume keys reported makes it so that we get the on-screen
> display of the volume changing and /proc/acpi/ibm/volume matches what
> the displayed volume shows.
>
> As far as other Lenovos, if you want it tested out on more of them,
> that's easy enough to do as they're very common in the office here.  But
> the couple of people that I've given the patched module to haven't had
> problems (various T60s)

Empirically testing things without really taking into account the path the
information will travel will not get you the right answers for this problem.
I hope I explained why that happens clearly enough in this mail...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
