Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZJ3UbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZJ3UbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 16:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZJ3UbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 16:31:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbZJ3UbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 16:31:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Fri, 30 Oct 2009 21:32:44 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910301948.24473.rjw@sisk.pl> <alpine.LFD.2.01.0910301228430.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910301228430.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910302132.44759.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 October 2009, Linus Torvalds wrote:
> 
> On Fri, 30 Oct 2009, Rafael J. Wysocki wrote:
> > 
> >
> > 1) Resume works if pcmcia_socket_dev_resume(dev) is moved to the "regular"
> >    resume phase, after resume_device_irqs().
> 
> Hmm. We really probably shouldn't call pcmcia_socket_dev_resume() in 
> early_resume. It takes mutexes etc, and it calls "socket_resume()", which 
> sleeps etc. That per se should be ok these days (since we don't actualyl 
> disable CPU irq's, just device irqs), but it also does that whole card 
> insertion events etc. And _that_ code I wouldn't trust at all.

I thought so when I worked on commit 0c570cdeb, but then it turned out to
work just fine with a number of boxes.

> The PCMCIA code is better than it used to be a long time ago, but some of 
> it is still pretty crazy. 
> 
> I get the feeling that we should just revert that commit 0c570cdeb,

Well, there's nothing wrong with doing the PCI stuff and restoring the state at
the _noirq stage IMO, so instead of reverting it altogether, I'd add
yenta_dev_suspend|resume() that would just call
pcmcia_socket_dev_suspend|resume() during "regular" suspend|resume.

> and instead always do PCMCIA suspend as a "eject" event. That way we have no 
> driver behind it to resume at resume time - and we'll see any plugged-in 
> device as just a new insertion. 

In fact I thought about that.

It looks like I need to find a CardBus adapter somewhere and clean that thing up.

That said, I'd really like to know what's going on in there. :-)

Thanks,
Rafael
