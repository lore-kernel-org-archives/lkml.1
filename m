Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZJaJ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZJaJ3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZJaJ3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:29:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178AbZJaJ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:29:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Sat, 31 Oct 2009 10:31:17 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <alpine.LFD.2.01.0910301228430.31845@localhost.localdomain> <1256947041.6372.165.camel@pasglop>
In-Reply-To: <1256947041.6372.165.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910311031.17660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 October 2009, Benjamin Herrenschmidt wrote:
> On Fri, 2009-10-30 at 12:47 -0700, Linus Torvalds wrote:
> > 
> > On Fri, 30 Oct 2009, Rafael J. Wysocki wrote:
> > > 
> > >
> > > 1) Resume works if pcmcia_socket_dev_resume(dev) is moved to the "regular"
> > >    resume phase, after resume_device_irqs().
> > 
> > Hmm. We really probably shouldn't call pcmcia_socket_dev_resume() in 
> > early_resume. It takes mutexes etc, and it calls "socket_resume()", which 
> > sleeps etc. That per se should be ok these days (since we don't actualyl 
> > disable CPU irq's, just device irqs), but it also does that whole card 
> > insertion events etc. And _that_ code I wouldn't trust at all.
> > 
> > The PCMCIA code is better than it used to be a long time ago, but some of 
> > it is still pretty crazy. 
> > 
> > I get the feeling that we should just revert that commit 0c570cdeb, and 
> > instead always do PCMCIA suspend as a "eject" event. That way we have no 
> > driver behind it to resume at resume time - and we'll see any plugged-in 
> > device as just a new insertion. 
> 
> To me the proper approach would be to split it so that

Well, agreed, but ...

>  - early_resume() restores power & config space etc... so that existing
> devices can move on (might check for removal). There's no other hotplug
> activity

... that's exactly what doesn't work at the moment.

Thanks,
Rafael
