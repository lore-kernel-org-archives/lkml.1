Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZFHOpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZFHOpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZFHOpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:45:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52257 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbZFHOpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:45:12 -0400
Date: Mon, 8 Jun 2009 16:44:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608144455.GA20905@elte.hu>
References: <20090608065419.GA13568@elte.hu> <200906081330.50045.rjw@sisk.pl> <20090608130509.GA3272@elte.hu> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <20090608133215.GA15482@srcf.ucam.org> <20090608134647.GA14234@elte.hu> <20090608135431.GA16052@srcf.ucam.org> <20090608142450.GE14234@elte.hu> <20090608143513.GB16752@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608143513.GB16752@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Jun 08, 2009 at 04:24:50PM +0200, Ingo Molnar wrote:
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > eSATA is pretty common now.
> > 
> > [ And 99% of the CPUs have an IDT still 99.9% of the users dont know 
> >   what it is :) ]
> 
> Users know that there's a socket on the front of their computer that 
> they can plug a hard drive into, and if that doesn't work then they're 
> going to be upset.
> 
> > > The problem with this kind of default is that you get people who 
> > > are confused that their hardware doesn't work.
> > 
> > If the hardware 'doesnt work' that is a kernel bug. Hardware that 
> > _cannot be suspended_ safely (physically) should not be 
> > auto-suspended, of course.
> 
> So, like I said, the kernel can't automatically suspend AHCI unless it's 
> received some information from elsewhere that tells it it's ok to. The 
> kernel can't know if there's an eSATA port or not.
> 
> > > If the kernel doesn't have enough information to make a decision 
> > > it should err on the side of functionality - we're talking about 
> > > fairly low-level power savings, but potentially several years of 
> > > aggregate confusion on the part of users.
> > 
> > the difference between a 10W and a 1W footprint is a long series of 
> > 'low-level power savings'.
> > 
> > If users are getting confused and if hardware gets broken then tha's 
> > a plain bug and the wrong path is being walked.
> 
> Yes. And powersaving is a tradeoff between functionality and power 
> consumption. The kernel doesn't know what level of functionality a 
> given user requires. It *can't* know that itself.
> 
> > > Users are generally ok at realising correlation between a setting 
> > > change and something no longer working, so as long as you provide 
> > > that they'll be happy. I agree that this sucks. What we actually 
> > > want is some means of reliably identifying whether a port is 
> > > hotplug or not, but eSATA makes this very difficult.
> > 
> > Is it impossible?
> 
> To the best of my knowledge, yes.
> 
> > > My argument is "Hardware should work, and if the kernel default is 
> > > for it to be broken then the default is wrong". We went through 
> > > this for USB autosuspend. Userspace simply has more available 
> > > information than the kernel, and it's not just a matter of static 
> > > configuration (though that may be part of it). For instance, 
> > > Oliver's example of screensavers and USB keyboards. If nothing's 
> > > paying attention to volume keys (or if the keyboard doesn't have 
> > > any) then you can enable remote wakeup and suspend the keyboard. 
> > > If something /is/ paying attention to volume keys, you can't do 
> > > that. That's the kind of case I'm discussing.
> > 
> > See my reply to Oliver. This is really advocating a broken model 
> > of device usage. That volume key usage dependency is being 
> > hidden from the kernel, and then you want to kludge it around by 
> > pushing suspend functionality to user-space? That way lies 
> > madness. The proper way is to close the device if it's not used 
> > by anything. Then the kernel can auto-suspend it just like it 
> > could auto-suspend network interfaces that are not in use, or 
> > like it could auto-suspend a dislay port that has no monitor or 
> > other output device attached.
> 
> No, we can't just close it - then we won't get notification that a 
> key's been hit in order to unlock the screensaver. [...]

Looks like a broken notification model.

> [...] Yes, we can greatly expand the userland-visible interface to 
> every piece of hardware in order to make this work, but that's a 
> huge amount of effort to avoid a model where userspace sets some 
> tunables appropriately.

What huge amount of effort? All you are doing is to track the "is 
the device really used" state in user-space - and, if the current 
desktop experience is any measure, highly imperfectly so.

What i'm suggesting is to track it properly in the kernel. It's not 
like the kernel doesnt need to know whether a piece of hardware is 
under use or not ...

	Ingo
