Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYKYABS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYKYABS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYKYABI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:01:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51566 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbYKYABH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:01:07 -0500
Date: Tue, 25 Nov 2008 00:01:02 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: petkovbb@gmail.com, bzolnier@gmail.com, sshtylyov@ru.mvista.com,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081125000102.GC8293@csn.ul.ie>
References: <20081124155632.GE23190@csn.ul.ie> <20081124225139.GA26953@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081124225139.GA26953@gollum.tnic>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 11:51:39PM +0100, Borislav Petkov wrote:
> Hi,
> 
> On Mon, Nov 24, 2008 at 03:56:32PM +0000, Mel Gorman wrote:
> > Hi,
> > 
> > I got caught by commit 20df429dd6671804999493baf2952f82582869fa as I didn't
> > immediately guess that "ide_generic." was necessary on the kernel command line
> > when compiled in instead of as a module. While it didn't catch me for long,
> > my concern is that this is going to trip up other people with old machines
> > that need that mask.  This change was introduced in 2.6.28-rc1 but I didn't
> > catch it till now as I hadn't used the laptop in a while.
> > 
> > I have a few questions on the commit.
> > 
> > 1. Why was it necessary to disable the legacy probes like this at all?
> > Would it be possible to try the probe_mask in the event nothing is found
> > or does that have other consequences?
> 
> take a look at 0cbccbc30a60ff60dbeb203154f1f527c632de9b for background
> info on the decision behind the probe_mask. Now ide-generic probes only
> the legacy ports as is the case in common machine configurations and
> is a sort-of fall-back option in case there's no PCI IDE controller
> present.

I think this is on a PCI bus though. ioports tells me

0170-0177 : 0000:00:07.1
  0170-0177 : ide_generic
01f0-01f7 : 0000:00:07.1
  01f0-01f7 : ide_generic

and that appears to correspond to the following in lspci

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
        Flags: bus master, medium devsel, latency 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
        Flags: bus master, medium devsel, latency 64
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        I/O ports at 1850 [size=16]

> In addition, the Kconfig text explains more why ide-generic
> should not be used in modern systems (not sharing IRQs, preventing
> controller-specific drivers from attaching in certain cases).
> 

Which is a fair comment. I should have been using PIIX (which was not compiled
at all) on this machine in the first place making it even less likely someone
is going to hit this problem in practice. Disabling ide-generic and using
the piix driver makes everything work together happily so maybe most of this
problem can just be filed under PEBKAC.

> And the probing _is_ done when loaded as a module so the problem is
> not with the mask - in your case the probing will work just fine as
> you need ide0 and ide1, AFAICT.

Out of curiousity, I loaded ide-generic as a module and tried the suggested
probe_mask. It loads after e100 which is built in and then has a crap attack
as it tries to register IO regions which are already registered, triggers
sysfs warnings for creating duplicate files and then continues along to
a state where networking doesn't work anyway. That suggestion of 0x3f may
still catch someone.

> The problem is that the probing is not
> being done when ide-generic is compiled in and is the only controller
> driver enabled. The only trick I can think of off the top of my head
> is a Kconfig-option enabling ide-generic only when no other controller
> driver is enabled and getting rid of the possibility of compiling it as
> a module.
> 
> Bart, I'm sure you have a better idea :).
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
