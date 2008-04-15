Return-Path: <linux-kernel-owner+w=401wt.eu-S1765296AbYDOOs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765296AbYDOOs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765424AbYDOOru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:47:50 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:57388 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765419AbYDOOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:47:49 -0400
Date: Tue, 15 Apr 2008 10:47:48 -0400
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Frans Pop <elendil@planet.nl>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080415144748.GO7385@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <200804021820.04610.elendil@planet.nl> <20080402194938.GI24237@csclub.uwaterloo.ca> <200804031947.07674.elendil@planet.nl> <48017248.4030600@gmail.com> <20080414134734.GB7385@csclub.uwaterloo.ca> <20080414145302.4239b0b9@core> <480414E6.2090205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480414E6.2090205@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 11:37:26AM +0900, Tejun Heo wrote:
> Alan Cox wrote:
> >>If a driver supports a device with dual interfaces, then it better
> >>reserve both sets of ports to prevent the generic driver from trying to
> >>use them.
> >
> >That isn't the problem. The generic driver doesn't know if there is
> >another valid driver for the ports - how can it - and the other driver
> >may not be loaded first so cannot reserve the ports. If you load the
> >generic driver last then you should be fine, and the link order for IDE
> >and libata puts acpi, pci generic and legacy at the end for good reason.
> >
> >Libata pata_legacy has some smarts in this area but they are only good
> >for the common cases.
> 
> Always loading generic or ata_generic used to be safe.  It's still 
> pretty safe but not as much as before.  Nowadays, there are good number 
> of controllers which have dual interfaces.  Usually an ahci interface 
> and a legacy one but there are other controllers which also implement 
> dual interface.
> 
> Because PCI BARs usually contain IO regions for legacy interface in PCI 
> BAR 0-4, the native driver can work it out by claiming all PCI BARs on 
> attach, which I learned the hard way after seeing the generic driver 
> borking the native one on certain configurations.  The thing I'm worried 
> about is that there are a lot of vendors making this type of controllers 
> nowadays and a lot of BIOS implementations for each of them.  And of 
> course each BIOS implementation has its own many ways of configuring the 
> dual mode (or more thanks to fake RAIDs) controller.
> 
> I wouldn't be too surprised if one of those plethora of configurations 
> gets the compatible IO port and BAR configurations mismatched. 
> Especially when the controller is put into native mode.  It's entirely 
> possible to leave the compatible IO ports enabled while not setting the 
> PCI BARs accordingly.  Some of them might even think that's better to 
> prevent IDE drivers from attaching to it.
> 
> So, I don't really want to depend on that.  I don't know.  Do I sound 
> paranoid?

Yes.  After all you would quickly see a problem if you built a kernel
with all the IDE drivers built in, which some people do.  In that case
ide generic is always activated last and anything bad that would happen
with loading a module would happen built in too.

I think it is the wrong place to worry about problems.  If a native
driver takes control of a chip, it is that drivers responsibility to
reserve any relevant ports on that chip sufficiently to prevent another
driver from messing with it that doesn't know anything about that chip.
If the native driver doesn't load at all, then ide-generic ought to try
and drive the chip if it has legacy ports.

So my opinion is that making life easy to those machines with legacy ide
ports is a good thing, while trying to be overly paranoid about one
driver potentially hitting a bug in another driver is just silly.  Why
couldn't two native ide drivers potentially go looking for the same
ports too?  Are you sure no native driver uses the legacy IDE port
numbers to control a chip in native mode?  Finding bugs is good since
then they can be fixed.  Trying to prevent hitting bugs (which shouldn't
be there in the first place) doesn't seem useful.

-- 
Len Sorensen
