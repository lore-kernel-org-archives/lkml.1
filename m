Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXJGHbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXJGHbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 03:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXJGHbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 03:31:37 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:45294 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751863AbXJGHbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 03:31:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=pbu5cI1XxvkhBP0RjWgMgU4IbNz9rQGTcDIURVaCZQZ5KRka/xQ7GsUbPMBFIRI71bzrN8tHKE72GzdJjnZXVX73uiox+SbyxB4OY9N2Tq+O1MhqL6GNfz3QTLRtYW48igod0SKfbSokjlAKpP1QXiRmRJsJCNwoOsrM9HWArMo=  ;
X-YMail-OSG: TCNJKZsVM1mgeasiogU0FpGFdYjnVe2XhCZDmIjlmuxJVxlcsjfbDsRCbvePDbe.FDd8w2fCQNNMvrE0onFKFnAzQbBxiTXaVdMWYY0Sl7uo7fbngq4B2MHqKxP2FM_tFpZuUz6vgFyOYOA-
Date: Sun, 07 Oct 2007 00:31:41 -0700
From: David Brownell <david-b@pacbell.net>
To: davem@davemloft.net
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
References: <20071006.235358.104048815.davem@davemloft.net>
In-Reply-To: <20071006.235358.104048815.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071007073141.A88DD2393E2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From davem@davemloft.net  Sat Oct  6 23:56:49 2007
>
> When root_port_reset() in ohci-hub.c polls for the end of the reset,
> it puts no limit on the loop and will only exit the loop when either
> the RH_PS_PRS bit clears or the register returns all 1's (the latter
> condition is a recent addition).

The all-ones typically indicating something like CardBus eject
not preceded by a "polite" driver shutdown.


> If for some reason the bit never clears, we sit here forever and never
> exit the loop.
>
> I actually hit this on one of my machines, and I'm trying to track
> down what's happening.

Sounds like a hardware issue -- unless something else is trashing
controller state.  We've not observed that specific hardware failure
before, for what it's worth.

Is this SPARC, or is ACPI potentially in play?  PCI, or non-PCI?
Are the other ports still behaving?  Is EHCI maybe trying to switch
ownership of that port?  Is maybe the (newish) autosuspend stuff
kicking in?

The OHCI spec requires the controller to stop the reset itself.
Most silicon seems to have a built-in 10 msec timeout.


> Regardless of why my machine is doing this, there absolutely should be
> some upper bound put on the number of times we will run through this
> loop, perhaps enough such that up to 5 seconds elapses waiting for the
> reset bit to clear.  And if it times out we should print a loud
> message onto the console, but still try to continue.

Patches accepted.  :)

Since the PRS bit is specified as "write one", with writing zero
as no-effect (since the rest is hardware-timed), the only recovery
procedure might involve resetting the whole controller.  Messy,
and not something the usb core has historically handled very well.

- Dave

