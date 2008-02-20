Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYBTWzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYBTWzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYBTWy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:54:59 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:37911 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754180AbYBTWy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:54:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dTkN1hatvHTkTz0VwkE/IHtFH3Xzc5k7G25ZuVF0aEObuOjokqEX2G9lgq7B73UHqJwzQNvncFhjJHN5CHrmiN1yCqD1LOFrQSiF7ouXYKeAaT9Z69xW/a4NIxM1LDLlakxI6wBLsLF7NGaSuGc956ko8KLF3w+0aR1YsYCJglY=  ;
X-YMail-OSG: kTIDtRQVM1lwCxOcRhZfJErbZcGuoCwTlWLYh0irL8NHGLyV.OU2OEWj3ZAfZ2YMoj__kMX4lg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Wed, 20 Feb 2008 14:54:51 -0800
User-Agent: KMail/1.9.6
Cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802201725070.24070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201725070.24070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802201454.52125.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008, Alan Stern wrote:
> On Wed, 20 Feb 2008, David Brownell wrote:
> 
> > On Wednesday 20 February 2008, Alan Stern wrote:
> > > > ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
> > > 
> > > lines in the log brings up some ideas that have been percolating in my 
> > > mind for a while.  They have to do with the possibility of a race 
> > > between the watchdog routine and assertion of IAA.
> > 
> > The curious bit IMO being STS_INT (0001), which should also have
> > triggered an IRQ.  Suggesting to me that the race might be lower
> > level than that ... at the level of a conflict between the various
> > mechanisms to ack irqs.
> 
> Maybe it did trigger an IRQ.  Inside the watchdog routine interrupts 
> are disabled.
> 
> > > In fact, if the timing comes out just wrong then it's possible (on SMP
> > > systems) for an IAA interrupt to arrive when the watchdog
> > > routine has already started running.  Then end_unlink_async() might get 
> > > called right at the start of a new IAA cycle, or when the reclaim list 
> > > is empty.
> > 
> > The driver's spinlock should prevent that particular problem from
> > appearing.
> 
> I don't think so:
> 
> 	CPU 0				CPU 1
> 	-----				-----
> 	Watchdog timer expires
> 	Timer routine acquires spinlock
> 					IAA IRQ arrives
> 					ehci_irq tries to acquire 
> 						spinlock...

There's another condition here, and
another action.  The condition is
that ehci->reclaim must first be set;
the action is to clear STS_IAA (and,
given the previous patch, maybe IAAD).

And this "either" is more concisely
written as "call end_unlink_async()"
(point made just for clarity).

> 	Timer routine either sets
> 		ehci->reclaim to NULL 
> 		or else starts a new
> 		IAA cycle
> 	Timer routine releases spinlock
> 		and returns
> 					ehci_irq acquires spinlock
> 						and sees IAA is set

					Can only happen if a new IAA
					cycle was started by CPU0, and
					the IAA condition triggered
					that quickly.

> 					Call end_unlink_async()!
> 
