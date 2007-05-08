Return-Path: <linux-kernel-owner+w=401wt.eu-S1031548AbXEHTWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031548AbXEHTWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031555AbXEHTWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:22:00 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:38762 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967660AbXEHTV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:21:58 -0400
Date: Tue, 8 May 2007 21:21:17 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 11:30:03 -0700 (PDT),
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> It's better because then the *driver* can decide whether it supports 
> threaded probing or not.

Is there any reason why a driver shouldn't be able to handle probing
several devices at once? What if two devices become hotplugged at the
same time? Does this imply that the bus _always_ needs to do some
serializing there?

> Also, quite frankly, when this came up I already posted a much better 
> approach for allowing arbitrary threading. It was ignored, but maybe you 
> want to take a look.
> 
> See
> 
> 	http://lkml.org/lkml/2006/10/27/185
> 
> for last time this came up. Any driver can decide to do
> 
> 	execute_in_parallel(myprobe, myarguments);
> 
> and that really *simple* thing allows synchronization points 
> ("wait_for_parallel()") and arbitrary setting of the allowed parallelism.

Yeah, I saw this back then. But this is much too inflexible. How do you
determine the settings? On a large system, you could throttle too much,
obliterating most of the benefits of the parallel approach; on a small
system, you could overwhelm the system.

> I really think that is a *much* better approach. It allows, for example, 
> the driver to do certain things (like name allocations and any 
> particularly *fast* parts of probing) synchronously, and then do slow 
> things (like spinning up disks and actually reading the partition tables) 
> asynchronously.

Hm, I think "asynchronous" is the key word here, not "multithreaded".
Thinking some more of it, we really want to do the following:
- look at the device:
  - do the fast stuff
  - kick off the slow stuff
- look at the next device
  - ...
- wait until all devices said they are finished
- each device needs to signal completion when the slow stuff has been
done (or hit a timeout)

(By some curious accident, that is what s390 cio does :))

This way, we are much more flexible than with the execute_in_parallel()
approach. This async approach especially looks suited to stuff where
some kind of operation is submitted to the hardware and we need to wait
for an interrupt/completion. And for that kind of operations, it scales
equally well on small or big machines.

> Anyway, I will refuse to merge anything that does generic bus-level 
> (unless the bus is something off-the-board like SCSI) parallelism, unless 
> you can really show me how superior and stable it is. I seriously doubt 
> you can. We tried it once, and it was a total disaster.

Maybe the criterion should be more "a resonably unified set of
devices". s390 channel attached devices are really all the same (at a
certain not driver-specific level), and the same may be true for
something like scsi. pci may be just too diverse with too many
dissimilar drivers.
