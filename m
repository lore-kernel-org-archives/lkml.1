Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYJJVKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYJJVKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbYJJVKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:10:08 -0400
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:52667
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233AbYJJVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:10:07 -0400
Subject: Re: [RFC PATCH 0/4] V3 - Implementation of IR support using the
 input subsystem
From: Jarod Wilson <jarod@wilsonet.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Dmitry Torokhov <dtor_core@ameritech.net>, Pavel Machek <pavel@suse.cz>,
       lirc-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <9e4733910810100708sa321030g70eab786ac3fe176@mail.gmail.com>
References: <20081006194032.15992.8393.stgit@terra>
	 <20081009120333.GA1623@ucw.cz>
	 <1223611899.13345.86.camel@xavier.wilsonet.com>
	 <9e4733910810092204wbe6dd7dgde9c7ee50f698309@mail.gmail.com>
	 <1223646159.15204.12.camel@xavier.wilsonet.com>
	 <9e4733910810100708sa321030g70eab786ac3fe176@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 17:10:01 -0400
Message-Id: <1223673001.15204.47.camel@xavier.wilsonet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 (2.24.0-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 10:08 -0400, Jon Smirl wrote:
> On Fri, Oct 10, 2008 at 9:42 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
> > On Fri, 2008-10-10 at 01:04 -0400, Jon Smirl wrote:
> >> On Fri, Oct 10, 2008 at 12:11 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
> >> > On Thu, 2008-10-09 at 14:03 +0200, Pavel Machek wrote:
> > [...]
> >> >> > How should multiple remotes be handled? Split them out into
> >> >> > individual input devices, or group them onto a single IR device? I
> >> >> > can implement either.
> >> >>
> >> >> Individual input devices, I'd say... so that app can only listen for
> >> >> 'its' remote.
> >> >
> >> > I don't quite get it. How can we tell there are multiple remotes to set
> >> > up multiple input devices when the system comes up? All we can know
> >> > about at driver init time is the receiver(s), no? Or would this be keyed
> >> > off a config file? Or ______ ?
> >>
> >>
> >> We could create a sysfs attribut named ir_config. For each config file
> >> you copy to it it creates a new input device. The config files have
> >> lists of map this protocol, device, command tuple to this key. When a
> >> remote button is pressed the raw codes are fed to the in-kernel
> >> protocol engine. That engine turns the raw codes into tuples. Tuples
> >> are matched against the configs that have been loaded until a hit is
> >> found. If no hit they get sent out the catch-all device.
> >
> > Okay. I presume the catch-all device would simply note that it saw
> > something, and not actually take any action beyond that.
> 
> The catch-all device is an device in /dev/input. It gets the input
> tuples in protocol/device/command form sent to it. I should probably
> send all IR input to this device, and flag the events that were
> translated and sent to another input device.

Sounds sane.

> > Also, a minor clarification: If its config file based, then its not so
> > much one input device per remote, its one input device per config file,
> > so one could set up two separate config files that are actually commands
> > from the same remote, but have them listened to by different apps, or
> > one could group together commands from multiple remotes in a single
> > config so that multiple remotes would all control the same thing. Sounds
> > good to me, provides for a reasonable amount of flexibility.
> 
> That is how it works.

Cool. Still getting this all straight in my head... :)

> > Of course, this suggests a receiver wouldn't be able to do anything
> > until the user provided a key mapping table of some sort. Would it make
> > sense to provide a default IR-to-key mapping for each receiver type? A
> > bit difficult to provide a sane default for something like a home-brew
> > serial IR receiver, but you could certainly provide sane defaults for
> > things like mceusb and imon (i.e., mappings for the remotes typically
> > bundled with those receivers).
> 
> Receivers can process the raw tuples using the catch-all device.
> 
> You could write a little app like udev that listens to the catch-all
> device and then search the config files for untranslated tuples. When
> you match on an untranslated tuple, load that config file into the
> kernel.

That's just the sort of thing I *don't* want though -- I can imagine my
receiver picking up all the signals intended for my other AV devices and
loading up a bunch of configs, thinking it should do something with
these signals. Seems you'd want a training/pairing mode you could put
the driver in to set this stuff up.

> I'm taking the kids on their first trip to Disneyworld next week so I
> won't be able to work on this for a while.

Have fun! In the mean time, I've got a bit of porting to try out still,
as well as some remaining review clean-ups...



-- 
Jarod Wilson
jarod@wilsonet.com

