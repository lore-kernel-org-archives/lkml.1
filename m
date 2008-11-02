Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbYKBEA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbYKBEA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 00:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYKBEAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 00:00:17 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49701 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbYKBEAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 00:00:16 -0400
X-Greylist: delayed 829 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Nov 2008 00:00:15 EDT
X-Sasl-enc: +LgjYOWKZ0wUzw30Kails1xlVpsvdwYlMBHcDdcVLFg3 1225598413
Date: Sun, 2 Nov 2008 02:00:08 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4 and 5
Message-ID: <20081102040008.GB29606@khazad-dum.debian.net>
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490B70A3.8010108@tuffmail.co.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Alan Jenkins wrote:
> > Documentation/rfkill.txt implied otherwise

Then we need to make it more clear.

> >     You should:
> >         - rfkill_allocate()
> >         - modify rfkill fields (flags, name)
> >         - modify state to the current hardware state (THIS IS THE ONLY TIME
> >           YOU CAN ACCESS state DIRECTLY)
> >         - rfkill_register()

At which point rfkill core will KICK your device to the state it wants it to
be, so if you lied on the state, you are screwed. I mean it.

You want rfkill_set_default(), and only because it is a platform driver
storing state across shutdown.

> > Admittedly it doesn't say "and I promise not to gratuitously override
> > the state on registration".  Buti t seems weird though, to override the
> > value on registration 

No, it is EXACTLY what it should do.  It is setting policy for a class of
switches (actually, controllers. Call it a switch and you confuse it with
input devices).  It is not "enabling the radio" by default, it is setting
the radio rfkill controllers to the same state that all other rfkill
controllers on radios of that type currently are at.

And there is rfkill_set_default() for *platform* drivers to influence that,
when the platform has a better idea of the proper initial radio rfkill
state.

> Ah, I see.  Wrong end - of course the *rfkill device* doesn't have
> useful state.  The persistent state belongs to the *rfkill switch* - it
> could even be a physical switch.

Of course it has useful state. Set it to whatever the rfkill controller
state really IS at that point.  And it HAS persistent state, but the core
will govern it to match the system-wide policy.

> And now it's clear what was missing from the conversion to rfkill:
> 
>     2. Input device switches (sources of EV_SW events) DO store their
>     current state
>     (so you *must* initialize it by issuing a gratuitous input layer
>     event on
>     driver start-up and also when resuming from sleep)

No.

You *ARE* to send gratuitous input layer events for SWITCHES quite often,
e.g. on every call to the switche's connect() handler, and also often after
system-wide stuff like resume (when state could have changed without you
being able to notice it) because you *HAVE* to tell the input layer which is
the initial/real state of the switch.  If this is not clear, the input layer
needs some doc tweaking. Please feel free to send a patch to Dmitry.

But that has nothing to do with the rfkill core.  You MUST NEVER try to
change rfkill core state through the input layer from inside the kernel.
NEVER.

rfkill_input is NOT part of the rfkill core, and rfkill_input is the ONLY
thing that cares about input events that match one of the "rfkill" input
events.  And it *is* optional.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
