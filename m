Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbYDNPTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbYDNPTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYDNPTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:19:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:32418 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYDNPT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hynwu3mu0l4JcBileQDzp5nESPdwsQrovgFCx8RMCBINMhR3smDPhmJ/cVTTBNFZUIjvkSC7xh9dQraplgIxuwdfxVxsBChXQAMrBEKKtJmztU+cIqcioTgYK4otfAzqSAiixUQOf4FHKWgksKGNOf1mRyx4kz5qXqYqUtYWhos=
Date: Mon, 14 Apr 2008 11:19:17 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080414105933.ZZRA012@mailhub.coreip.homeip.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.43547.IvDoorn@gmail.com> <20080414012038.GB14406@khazad-dum.debian.net> <200804141400.41319.IvDoorn@gmail.com> <20080414100018.ZZRA012@mailhub.coreip.homeip.net> <20080414143603.GA31298@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414143603.GA31298@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:36:03AM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 14 Apr 2008, Dmitry Torokhov wrote:
> > What exactly breaks with user_claim? I think the general issue is that
> 
> The same thing that happens if userspace is in charge and doesn't
> cooperate or if rfkill-input is not loaded:  the rfkill driver state is
> never updated (remember, it is about the radio controller, not the input
> device).
> 

And it should not - setting user_claim means userspace controls the
transmitter state. If userspace decides to ignore KEY_* event and not
turn the radio on or off - that is fine. rfkill-input simply provides
default kernel policy for reacting to KEY_WLAN, KEY_BLUETOOTH, etc.
If there are drivers sense button presses and alter their actual
transmitter state immediately but then rely on rfkill-input to update
their sysfs rfkill attributes then such drivers should be fixed.

> > rfkill was originally not supposed to be used with switches that can't
> > be programmatically controlled. If we have a switch that mechanically
> 
> The input layer does not provide a way for userspace to get access to
> the current state of any switches easily (or at all?).  It just exports
> events reporting these states sometimes.
>

You can use EVIOCGSW to get state of switches. I'd expect applications
to use it when they open devices first time and then rely on event
delivery to monitor changes in state of input devices.

> We could fix it in the input subsystem, instead.  How difficult (and
> welcome a change?) would it be for the input device infrastructure to
> provide pollable (for good measure!) "state" attributes for every EV_SW
> event an input device registers in evbits+swbits ?
> 

Given the above I don't see the need.

> If the input subsystem exports that information, we can define that
> slave read-only radio controllers must NOT be registered as rfkill
> devices, and drop support for read-only rfkill devices, as all master
> rfkill devices (which are input devices by definition) would get their
> state exported to userspace through the input layer.
> 
> However, that DOES mean userspace would need to look for rfkill state in
> two places.  Input layer, to get the current state of the rfkill input
> devices, and rfkill class to get the current state of the rfkill
> radio controllers.
>

I think you outlined the problem in your other mail quite well. We
keep confusing button state with the transmitter state. Only for
buttons that are hardwired to transmitters the states are the same,
for programmatically controlled RF transmitters state may be
different. So if you need to see state of transmitters you should look
in /sys/class/rfkill and for input devices - hook into input devices.
 
> > The input side (input polldev or other kind of button/switch/slider
> > inmplementation) still can issue KEY_WLAN or something to indicate that
> > user toggled the state and userspace or kernel may try to shut off the
> > rest of RF transmitters in the box but as far as this particlular
> > switch goes it is game over. I expected that here we'd just rely on
> > netif_carrier_* to notify the network side of things about interface
> > losing connection.
> 
> Yes.  And that's the plan, actually.  But it DOES NOT work at all with
> the current mess, which used input events to keep the internal
> rfkill->state state in sync with the hardware.
> 
> > Unfortunately (or may be fortunately, I am not quite sure yet) rfkill
> 
> Let's decide this NOW, then.  But if we decide to not do it in rfkill,
> you will have to add attributes to every input device which has
> registered itself as a source of EV_SW events.
>

No, since they may not be tied directly to any RF transmitter.

> > started to be used for mechanical type switches as well, disabling
> > user_claim option, so now we do need the "read-only" kind of rfkill
> > switch support that allows setting switch state directly from the
> > driver.
> 
> We always had read/write rfkill controllers, they were just not properly
> supported at all, and that is the root cause of the mess.
> 
> 
> Anyway, do we fix read-only rfkill input device support in the input
> layer (add access to their state using sysfs and make it clear they are
> NOT to be registered with rfkill class) or in the rfkill class (add
> read-only rfkill controller support)?
> 
> I better make it clear that I have NO idea how to properly implement the
> required changes in the input layer if we go that way so if it is left
> for me to do that work, it won't be ready anytime soon and it might be
> supbar, so I'd appreciate lots of help in that case.
> 

Well, let's see.. Do we have any issues with transmitters that can be
controlled programmatically? Or is it the hardwired ones that give us
trouble at the moment? I think that exporting all of them in rfkill is
a good idea, even though originally I thought we would not need to do
that. Therefore we do need to allow hardwided drivers updating their
rfkill state directly. The only problem I see is that we need to monitor
this closely, so non-hardwired cases won't try to use this mechanism.

-- 
Dmitry
