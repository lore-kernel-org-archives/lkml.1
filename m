Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbYDNOgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbYDNOgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbYDNOgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:36:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57923 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757810AbYDNOgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:36:08 -0400
X-Sasl-enc: yEfMpDZrYFpQB3b6X26oK0oMwrnKyhPRfzamcZnL2pqL 1208183766
Date: Mon, 14 Apr 2008 11:36:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080414143603.GA31298@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.43547.IvDoorn@gmail.com> <20080414012038.GB14406@khazad-dum.debian.net> <200804141400.41319.IvDoorn@gmail.com> <20080414100018.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414100018.ZZRA012@mailhub.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Dmitry Torokhov wrote:
> What exactly breaks with user_claim? I think the general issue is that

The same thing that happens if userspace is in charge and doesn't
cooperate or if rfkill-input is not loaded:  the rfkill driver state is
never updated (remember, it is about the radio controller, not the input
device).

> rfkill was originally not supposed to be used with switches that can't
> be programmatically controlled. If we have a switch that mechanically

The input layer does not provide a way for userspace to get access to
the current state of any switches easily (or at all?).  It just exports
events reporting these states sometimes.

We could fix it in the input subsystem, instead.  How difficult (and
welcome a change?) would it be for the input device infrastructure to
provide pollable (for good measure!) "state" attributes for every EV_SW
event an input device registers in evbits+swbits ?

If the input subsystem exports that information, we can define that
slave read-only radio controllers must NOT be registered as rfkill
devices, and drop support for read-only rfkill devices, as all master
rfkill devices (which are input devices by definition) would get their
state exported to userspace through the input layer.

However, that DOES mean userspace would need to look for rfkill state in
two places.  Input layer, to get the current state of the rfkill input
devices, and rfkill class to get the current state of the rfkill
radio controllers.

> The input side (input polldev or other kind of button/switch/slider
> inmplementation) still can issue KEY_WLAN or something to indicate that
> user toggled the state and userspace or kernel may try to shut off the
> rest of RF transmitters in the box but as far as this particlular
> switch goes it is game over. I expected that here we'd just rely on
> netif_carrier_* to notify the network side of things about interface
> losing connection.

Yes.  And that's the plan, actually.  But it DOES NOT work at all with
the current mess, which used input events to keep the internal
rfkill->state state in sync with the hardware.

> Unfortunately (or may be fortunately, I am not quite sure yet) rfkill

Let's decide this NOW, then.  But if we decide to not do it in rfkill,
you will have to add attributes to every input device which has
registered itself as a source of EV_SW events.

> started to be used for mechanical type switches as well, disabling
> user_claim option, so now we do need the "read-only" kind of rfkill
> switch support that allows setting switch state directly from the
> driver.

We always had read/write rfkill controllers, they were just not properly
supported at all, and that is the root cause of the mess.


Anyway, do we fix read-only rfkill input device support in the input
layer (add access to their state using sysfs and make it clear they are
NOT to be registered with rfkill class) or in the rfkill class (add
read-only rfkill controller support)?

I better make it clear that I have NO idea how to properly implement the
required changes in the input layer if we go that way so if it is left
for me to do that work, it won't be ready anytime soon and it might be
supbar, so I'd appreciate lots of help in that case.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
