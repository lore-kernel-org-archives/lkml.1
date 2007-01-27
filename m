Return-Path: <linux-kernel-owner+w=401wt.eu-S965007AbXA0Anf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007AbXA0Anf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030226AbXA0Anf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:43:35 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:23668 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965007AbXA0AnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:43:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=a+lQrDdoj+2tXRm4C6AHx30QW8o7cb5dWpqWazRKHespJG3slu4uNXTrHsxN7NkENZA0C1L2zO34PgHcyC3dU9uQ+kWP/pUsgEBVvi6qNqRMCxMeyJubYKlMqyswpj4AzMRmPloMq8zK/GWzM/CjnnHum/YPWXOASWs4WmruNdA=  ;
X-YMail-OSG: Fl0TTFEVM1k3mB4aiHToNG6O_l_obrHwnWOb0tvXrSllaz42B0TVRCxYZ.i5oSog4YvuSAe.GvQ7DQpy6NrsDYoKJ38l2fXBkdtEQCJcCnI0JmywfKMBFNVRvVixZHnvuwN8bLZMwQtf09f7wNOIthMjySD9wudYxQRI90zjdIist3kJroqBX49aXjJK
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Date: Fri, 26 Jan 2007 16:42:56 -0800
User-Agent: KMail/1.7.1
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20061219185223.GA13256@srcf.ucam.org> <200701261356.42171.david-b@pacbell.net> <20070126231521.GA12370@srcf.ucam.org>
In-Reply-To: <20070126231521.GA12370@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261642.56896.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 3:15 pm, Matthew Garrett wrote:
> On Fri, Jan 26, 2007 at 01:56:41PM -0800, David Brownell wrote:
> 
> > I thought the resolution was that fixing a few of those drivers
> > should solve the problem Matthew needed resolved, and that in
> > the meanwhile "rmmod drivername" should suffice.  There also seemed
> > to be agreement that power management for wireless devices needed
> > more work; there might need to be a state between "down/off" and
> > "configured and able to talk IP".
> 
> It's certainly the case that fixing those drivers would result in a 
> better long-term situation - however, nobody currently seems to have any 
> interest in doing so...

And the way these things work, unfortunately, is that merging your patch
would ensure nobody ever gets such interest.  Removing that "state" file
(and its bogus infrastructure) has already taken a few years too long.


> I'm not sure what you mean by using rmmod instead. Most drivers don't 
> explicitly set the power state when unbinding, and I can't see anywhere 
> in the generic PCI code that will do it.

There are broadly two things happening in a driver suspend()
method:

 -  One of them *always* happens on rmmod:  stopping all driver
    activity.  That eliminates the dynamic power usage, which as
    a rule is what consumes most of the power.

 -  And issuing a pci_set_power_state() call.  That eliminates
    some more power usage, but as a rule it's not as much.

Plus some drivers will also enable the device as system wakeup
source.  That behaves poorly on PC Linux (ACPI doesn't handle it
well yet), but on more power-aware Linux systems it's important
as a way to let the system stay in low power states most of the
time, without sacrificing system response to external actions.

If you measure and find that setting the power state matters,
making those drivers do that on rmmod should be easy.  (And IMO
it would be worth trying to make PCI use those states by default
for driverless devices.  Different issue though.)


> As I've said before, I think it's unreasonable to cripple interfaces for 
> (mostly) aesthetic reasons without ensuring that equivalent 
> functionality already exists.

I don't recall anyone raising aesthetic concerns.  And bug-equivalence
has never been a goal of Linux.


> This patch restores useful functionality  
> without breaking the extra sanity checks that you've added. I appreciate 
> that it's not an interface that you want to support in the long term 
> (well, even the short term...),

You imply that it _was_ once supported, which is not true.  Like any
other bug (in this case "design bug"), it was there and could be abused.
And like some other bugs, fixing it can trigger complaints from (ab)users.

It's been several years now that this interface has been well recognized as
trouble.  Years in which all _other_ users went and did the Right Thing:
they stopped using it, or never started.

If you want sympathy for an application that took the time during which
that mechanism was getting phased out, and then decided to phase *IN* a
new use ... sorry, I'm not constitutionally able to give sympathy.  I can
maybe offer sympathy that you didn't know it was being phased out (since
the decision to do that ISTR predated the "feature removal" schedule, with
its additional publicity), but not much more than that.

- Dave

