Return-Path: <linux-kernel-owner+w=401wt.eu-S934877AbXJPS0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877AbXJPS0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbXJPS0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:26:38 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:46392 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759387AbXJPS0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:26:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=uWXxOqCxn1iyUJJw4SbK2YgCmCbQcRCp5AUtHZHjxYxiTfHLzBwf8OBUCadTVSneGIkujHyvFPv8BbNQsuqwtNH5ge3ainHkMnvLqnghFAPSZRZrtdyuTbqfgQXb6JfTz9SbBMR3w2+pXC6eDLJafGPrEQYznOsEYJwVy+k8joQ=  ;
X-YMail-OSG: osOXeH4VM1ni0ADgsG7.O6oFQbkX2DdLMLzaI0BS4XRuclVm
Date: Tue, 16 Oct 2007 11:26:34 -0700
From: David Brownell <david-b@pacbell.net>
To: davem@davemloft.net
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
Cc: stern@rowland.harvard.edu, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
References: <20071009.213507.78708496.davem@davemloft.net>
 <20071015.150124.78710191.davem@davemloft.net>
 <20071015233910.5A17123BC99@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071015.165828.59656315.davem@davemloft.net>
In-Reply-To: <20071015.165828.59656315.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071016182634.8956423BCED@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Bad news, even with the rwsem after a lot more testing I can still
> > > trigger the hang in ohci_hub_control() :-(
> > >
> > > I think we need to go back to considering the total serialization
> > > approach to this problem.
> > 
> > We shouldn't need that.  What happens if you add an msleep(5)
> > before ehci-hcd::ehci_run() drops ehci_cf_port_reset_rwsem?
>
> What happens is the heisenbug will go away for another week.

Not if what I suggested is happening is really what's happening.
(Quoted next.)

It's got to be just a *simple* hardware race, and the msleep would
reliably prevent it since the switch takes a finite amount of time
to do its job.  I've had to struggle with real heisenbugs, and this
doesn't have enough conflicting behaviors inside the silicon (or
poor enough design) to qualify.


> > The theory there being that the switch triggered by setting CF
> > doesn't take effect instantaneously, contrary to the effective
> > assumption of that code.  A delay of 5 msec seems like it should
> > be more than enough, but that's kind of a guess ... it's good to
> > keep that low, since unfortunately that's in the critical path
> > for OLPC "resume from idle".
>
> I want to help with this, but if I even breath on the kernel the bug
> goes away.  The race just gets harder to trigger, and if we just keep
> adding things it'll make the problem go away but for the absolutely
> wrong reasons.

So, you're unwilling to explore whether that suggestion addresses
this problem.


> The only way we will provably fix this is to make sure EHCI initialize
> fully, first, regardless of kernel config or what userland does.

As Alan noted: no can do, in general.  That's why I've not griped
harder at the distro vendors who are ignoring the fairly simple
recommendation that's been around for six years now:  load EHCI
before other USB controller drivers.  

Admittedly, until you turned up this glitch there was no downside
known beyond the boot slowdown.


> Also, David, you haven't done anything with the feedback I gave to the
> most recent revision of the OHCI hub reset anti-wedge patch.

It's in a different mailbox, sorry.


>	You
> removed the debug logging when the outer-loop timeout expires, and I
> asked that you put that back so that if it happens there is some
> chance to know that this is what happened.  If it's not supposed to
> happen, there is no harm in putting the debugging log message there
> so that if the impossible does happen we find out about it.

It will exit by the inner loop (with diagnostic) before it exits
from the outer one.  Then the hub logic and other code will give
even more messages.


> I really don't think it's appropriate for that bug fix to sit yet
> another week.

The version I sent should just merge.

- Dave

