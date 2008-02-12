Return-Path: <linux-kernel-owner+w=401wt.eu-S1764036AbYBLUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764036AbYBLUcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYBLUcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:32:39 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:20849 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752114AbYBLUch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:32:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=s/GLKBS3xZrklYESnBGXg7t6yq6hqMhHgP+KMcjVZ5YVHjNHV6upwsrxyVfQPPDVTbIADI0C4Y8cF3RhfgwXrqLD+QYWQNUzw13VOAjJDbRr7Yu8bBC0h3E04KYig7DW7gEdkAtRExjA4+Zfx+hEIIqPL/OTc3XomKYDpmTIXms=  ;
X-YMail-OSG: e1snxb0VM1nszKfD44tESKzwdn7TOkY9a0aTyKXAAJyni3UOIO7_J8t66kyMVeuAZEr7HyyHmw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [PATCH] USB: OTG: Fix weirdnesses on enumerating partial otg devices
Date: Tue, 12 Feb 2008 12:32:34 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       me@felipebalbi.com
References: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com> <200802120502.48019.david-b@pacbell.net> <20080212202215.GY4769@gandalf.research.nokia.com>
In-Reply-To: <20080212202215.GY4769@gandalf.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802121232.35280.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > Some devices claim
> > > > > to be b_host even though they have an a_connector attached to it.
> > > > 
> > > > Why not just fix that bug?  Remember that's Linux code.
> > > 
> > > The device claiming to be b_host is not linux based.
> > 
> > Wrong ... the meaning of that flag is:  *THIS* system is a
> > Linux-USB OTG device which came up in B-peripheral role, and
> > then through the magic of HNP morphed into the B-host role.
> 
> Don't be sarcastic I won't even fall into what Jean Delvare told you.

I see no sarcasm there.  People seem to want different degrees
of handholding when being told they're wrong.  First time gently,
second time less so ...

I think there are limits to how long you can realistically expect
someone (in this case, me) to let that drag on.

(You object to "magic"?  Most LKML readers know squat about OTG,
and that seemed like a succinct introduction to what it does.)


> > Linux is acting as a host at that point.  So either it's
> > being the A-host, or the B-host.  That flag says which.  If
> > the other device has the A-connector, yet we're the B-host,
> > then right now it is acting as an A-peripheral.  That's
> > exactly what HNP is designed to do.
> 
> True, but allowing hnp nowing we're b_host doesn't sound correct.

Why not?  The B-host can't proceed in that case.  The mechanism
for not-proceeding is inside this:

        if (!is_targeted(udev)) {
                if (udev->bus->b_hnp_enable || udev->bus->is_b_host) {
                        err = usb_port_suspend(udev);
                        if (err < 0)
                                dev_dbg(&udev->dev, "HNP fail, %d\n", err);
                }
                err = -ENOTSUPP;
                goto fail;
        }

Your proposal is to strike the "is_b_host" check.  In  terms of the
OTG (1.3) state machine, that removes a b_host --> b_peripheral
state transition.

BUT:  notice it doesn't replace it with the ONLY other valid state
transition, b_host --> b_idle.   In fact, that can not be initiated
by the B-device...

So the current code *is* correct.


> If 
> we're b_host it can get two scenarios we would get to fall into this
> state:
> 
> 	1. We asked to become host; or

This is always the case... the other side can enable HNP all
it wants, but it won't proceed unless the b-peripheral does
its side of the dance.  (In terms of spec:  b_bus_req must be
true before HNP can proceed.)


> 	2. A_device allowed us become host because it can't handle us.

We actually can't know why it started HNP; it may well have
had other reasons.  All we know is that the roles switched.

Maybe it finished its initial task, and decided to give our
side the opportunity to accomplish some tasks it couldn't
know about in advance.


> In both cases, HNP is quite useless happening again, don't you think?

No.  You have no way of knowing what the A-device may or may not
do when it becomes host again.  It's getting a chance to do
more work, in conformance with what OTG is supposed to do.


> We should at least try to enumerate a_peripheral, if it can't due to
> our power capabilities i.e. 100mA, we'll fall into overcurrent
> protection and we'll suspend the bus and disconnect, which would give
> a_device another change to enumerate us.
> 
> This sound much better to me.

You're overlooking something:  this is the "!is_targeted(udev)"
case, so we have already enumerated the a_peripheral as much as
we can.  There is *nothing* more we can do with it.  Sitting
around in the b_host state would be utterly pointless.


> > So it can happen again, to go back into the b_peripheral state.
> > (And of course, we can't set the b_hnp_enable flag in a device
> > which is in the a_peripheral state...)
> 
> it shouldn't happen again at this point. If we're b_host, we should try to
> enumerate a_peripheral. If it draws more than 100mA the session should
> end, otherwise we'd fall into hnp loops until we start getting hub port
> errors and linux decide to suspend roothub and end the session.

Notice that because we're b_host we are not supplying power.  :)

Re HNP loops, go look again at the B-device state diagram.  Now
tell me how the B-device could terminate such a loop ... it can't.
But look at the A-device diagram ... it obviously *CAN* terminate
such a loop (by turning off VBUS power).

Though I don't think Linux currently *will* terminate that loop.
It needs to disable port power, which is still problematic.  And
also it would need to *decide* to disable port power.


> > Seems like the root cause of the problem here is that you
> > have some correctly functioning code, but for some reason
> > you're surprised by that correct functioning.  (Maybe this
> > is a case where neither device is on the other's whitelist?)
> 
> True, neither is in other's whitelist, but the point is:
> 
>  1. Currently standard-a device supports hnp only on A states

That would be a bug; the a_peripheral --> a_wait_bcon transition
has always been part of OTG.


>  2. Currently standard-b device supports hnp on both roles

Correct; that conforms with OTG requirements.


>  3. A-device enumerates b-device, checks it's not tpl'ed and allow hnp

OK ...

>  4. B-device become b_host, checks a_peripheral is not on its tpl, even
>     though it has support for that device class

If it supports a device class I'd say that should be included
in the TPL ("whitelist").  Though if it tries to do that, it's
an explicit violation of the OTG spec (sect 3.3):

	The Targeted Peripheral List shall not list supported
	USB Classes or “similar” devices.


>     and it draws less than  100mA.

Irrelevent, though possibly the Linux code there needs to be
taught to ignore the power constraints when it is_b_host ...
because the B-device is never supplying power to the A-device,
even when it's in the b_host state.


> According to otg tpl clarification, they should work in this scenario,
> shouldn't they ? Or should they stay in an hnp loop until someone
> decides to end the session ?

Shouldn't work, because your points 1 and 4 violate specs.

Though it would make sense to me to have the host record
whether it already gave up on the peripheral once ... and
if it did, then power it off.

- Dave

