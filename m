Return-Path: <linux-kernel-owner+w=401wt.eu-S934720AbYBMV6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbYBMV6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbYBMVgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:36:07 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43485 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763503AbYBMVgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:36:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6BiOxnk82TYgVt6/dRO1TDxlZL9nSxvbzh6X5lrfwO/NPtSDH5HwBPXJjp0oiTPZ92SOKoMzrz3q5HaBjWXK86VVnbOsRd1snzouvMv7gIEdDKlBj9dlwq0TfkR92tECPpdX5nI7IPSlA5NK17gNZYIKJ/Z1F/0VVDoGlkXdp2Y=  ;
X-YMail-OSG: rIdMxZ8VM1mgA_TNmRNpZvTtlMGm2mzR3tToYQOUIujzgkVnY.xnWXPucscoSLkffdAvO0ejfQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [PATCH] USB: OTG: Fix weirdnesses on enumerating partial otg devices
Date: Wed, 13 Feb 2008 13:36:00 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       me@felipebalbi.com
References: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com> <200802121232.35280.david-b@pacbell.net> <20080213162905.GD4769@gandalf.research.nokia.com>
In-Reply-To: <20080213162905.GD4769@gandalf.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131336.00475.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Felipe Balbi wrote:
> On Tue, Feb 12, 2008 at 12:32:34PM -0800, David Brownell wrote:
> >
> > Your proposal is to strike the "is_b_host" check.  In  terms of the
> > OTG (1.3) state machine, that removes a b_host --> b_peripheral
> > state transition.
> 
> Not at all, we're just not doing transition right now.

When *would* it happen then?  And why not do it as soon as it's
known that the device on the other end of the cable is unsupported?


> > BUT:  notice it doesn't replace it with the ONLY other valid state
> > transition, b_host --> b_idle.   In fact, that can not be initiated
> > by the B-device...
> > 
> > So the current code *is* correct.
> > 
> > 	... deletia ...
> > 
> > > We should at least try to enumerate a_peripheral, if it can't due to
> > > our power capabilities i.e. 100mA, we'll fall into overcurrent
> > > protection and we'll suspend the bus and disconnect, which would give
> > > a_device another change to enumerate us.
> > > 
> > > This sound much better to me.
> > 
> > You're overlooking something:  this is the "!is_targeted(udev)"
> > case, so we have already enumerated the a_peripheral as much as
> > we can.  There is *nothing* more we can do with it.  Sitting
> > around in the b_host state would be utterly pointless.
> 
> And you're overlooking something: tpl is not an enumeration blocker at
> all. The only blockers are drivers and power limits.

The device has already been enumerated at this point.  This is just
whether to set up communication with, and use, the device ... which
activity *IS* predicated on device support, "on the TPL" (as it says
in 6.8.1.4 of the spec for the A_HOST role, later reusing that language
where it describes the B_HOST role).


> Imagine what happens on n810, we have 3 mass storage devices listed on
> its tpl: 770, n800 and itself. Besides that, we allow enumeration of any
> mass storage device as long as it draws less than 100mA. 

While it makes sense to me that an OTG device support things like
mass storage class devices, I still see that spec language saying
that classes can't be on the TPL ... and that only devices on the
TPL get communication beyond what's needed for enumeration.

Regardless, that's a red herring.  If you allow sane things like
arbitrary flash memory sticks to be used, you've effectively put
a device class on the TPL.  But this discussion is about things
that are NOT on the TPL.


> These tips I 
> got from otg chairman himself and from OTG Clarification document, you
> can find it in compliance.usb.org.

Well, I'm glad at least one person there is talking sanely about
the TPL, but there is no such clarification that I can find.

I've observed USB-IF to be slow to address bugs in their specs,
maybe that's what's going on here.  Bugs are often written into
specs as political compromises, and they can linger for various
reasons.  (Including members with hidden agendas to block success,
and people who prefer to deny inconvenient realities.)


> So, what I'm trying to say is if 
> a_device let us become host, we shold at least try to do, let's call it,
> full enumeration. Which means attaching any unlisted mass storage device
> should work.

Attaching works, sure.  If you are willing to communicate with
that device, then it's on the Targeted Peripherals List (TPL),
so this code branch doesn't apply.

Put it this way:  there is no *OTHER* mechanism for deciding not
to talk with a device; and that's the entire purpose of the TPL.


> > >  4. B-device become b_host, checks a_peripheral is not on its tpl, even
> > >     though it has support for that device class
> > 
> > If it supports a device class I'd say that should be included
> > in the TPL ("whitelist").  Though if it tries to do that, it's
> > an explicit violation of the OTG spec (sect 3.3):
> 
> We can't support classes. What I'm trying to say is we have usb mass
> storage support enabled in kernel and we can handle _any_ mass storage
> devices as long as they meet otg requirements.

I think that detail of the OTG spec is stupid and misguided.

Of *course* it should be possible to support, for example,
devices that weren't shipped before your product's TPL was
defined.  How ever you define the list of Targeted/supported
peripherals, that's got to be able to include classes and
similar mechanisms.  That spec stupidity is one issue;
for the scope of this discussion I'll assume the TPL (which
has an algorithmic check) can pass things like flash sticks.

The other issue is what you call the part of your product
documentation which says what devices it can talk to.  The
only term for such stuff in the OTG spec is "Targeted
Peripherals List".  If you're assuming some other design
abstraction packages that notion, that doesn't match what
the Linux-USB code does.

If you wanted to *add* such an abstraction, you'd have to put
it everywhere the current whitelist is used ... better IMO to
just update the current whitelist/TPL code to handle classes.
Right where the comment says to do it.


> > > According to otg tpl clarification, they should work in this scenario,
> > > shouldn't they ? Or should they stay in an hnp loop until someone
> > > decides to end the session ?
> > 
> > Shouldn't work, because your points 1 and 4 violate specs.
> 
> Not true, check again Chapter 6 Host Negotiation Protocol and OTG
> Clarification regarding TPL.

There is no such "OTG Clarification" on the website I just
looked at.


> > Though it would make sense to me to have the host record
> > whether it already gave up on the peripheral once ... and
> > if it did, then power it off.
> 
> Good catch. That'd be nice.

That's a patch I wouldn't NAK.  :)

- Dave

