Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZBCV6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZBCV6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZBCV6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:58:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZBCV6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:58:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Tue, 3 Feb 2009 22:57:53 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031026.34093.rjw@sisk.pl> <alpine.LFD.2.00.0902030949590.3247@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902030949590.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032257.54041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Linus Torvalds wrote:
> 
> On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > As I said, I tend to prefer the "loop of disable_irq()" approach, because it
> > would allow us to preserve the current ordering of ACPI operations.  Namely,
> > if we do:
> > 
> > suspend devices (normal suspend)
> >   loop of disable_irq()
> >     late suspend of devices
> >       _PTS
> >         disable nonboot CPUs
> >           local_irq_disable()
> >             sysdev suspend
> >               enter sleep state
> >               get control from the BIOS
> >             sysdev resume
> >             (*)
> >           local_irq_enable()
> >         enable nonboot CPUs
> >       _WAK
> >     early resume of devices
> >   loop of enable_irq()
> > resume devices (normal resume)
> > 
> > the ordering of _PTS with respect to putting devices into low power states and
> > disabling the nonboot CPUs will be the same as it is now and the same applies
> > to _WAK and putting devices into D0 etc. (I really _really_ wouldn't like to
> > change this ordering, since this alone is likely to break things badly).
> 
> Yes.
> 
> Also, make the "loop of disable/enable_irq()" phase be a helper function 
> that also sets system_state to SYSTEM_SUSPENDING/SYSTEM_RUNNING 
> respectively, and it should all be pretty clean, and the changes really 
> should be pretty minimal.

OK

So, I'm going to implement something along these lines.  We'll see how it
works out.

Thanks,
Rafael
