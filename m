Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbZEZWIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbZEZWIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZEZWHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:07:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48174 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZEZWHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:07:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: jerry_734@verizon.net
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H - culprit found
Date: Wed, 27 May 2009 00:07:51 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <20090525230259.GA5098@vilya> <20090526211058.GB2538@indigo.myhome.westell.com>
In-Reply-To: <20090526211058.GB2538@indigo.myhome.westell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905270007.52039.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, gapeters@worldnet.att.net wrote:
> On Tue, May 26, 2009 at 01:03:00AM +0200, Richard Atterer wrote:
> > Hello,
> > 
> > "Jerry" contacted me off-list with information about the root of the 
> > problem - many thanks indeed!!!
> > 
> > It turns out that the e100 driver is responsible. (The motherboard actually 
> > has a r8169 chip, but I added an old Intel PCI ethernet card I own.)
> > 
> > By rmmoding e100 before s2disk, the problem goes away. Jerry mentions that 
> > he once saw a message about e100 failing to load its microcode - I never 
> > saw such a message.
> > 
> > The most recent e100 commit ac7c992 by Thadeu Lima de Souza Cascardo (Apr 
> > 28) made some changes to the behaviour in the case of shutdown vs. suspend, 
> > maybe the problem is there? (But note that during bisecting, I tested 
> > kernels older than that commit, and not all of them worked.) Before that, 
> > f902283 (Mar 3 2008) mentions suspend in the log message.
> > 
> > Cheers,
> > 
> >   Richard
> > 
> > -- 
> 
> I think I saw the firmware loader failure during resume. If you leave the
> system alone for ~2 minutes it will resume, but the e100 won't work &
> any thing "touching" it will go into an un-interruptable sleep
> (ifconfig, cat'ing some of its /sys files).
> 
> IIRC started with 2.6.29, with the change to net drivers to use the
> firmware loader. During the hibernate, for some reason, the e100 is
> suspended then resumed, at which point it requests its firmware.
> Userspace is frozen so the firmware load times out (the 2 minute timeout
> which is why I guessed you were having the same problem).
> 
> During resume, the e100 is apparently resumed *before* userspace is
> un-frozen, so again it times out loading its firmware. At this point
> it's unusable.

This theory makes sense.

Generally firmware loading is not going to work from the driver's ->suspend()
and ->resume() callbacks.  For this reason the firmware should be loaded
into RAM before suspend, for example from a PM notifier.

Thanks,
Rafael
