Return-Path: <linux-kernel-owner+w=401wt.eu-S967017AbXEHSab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967017AbXEHSab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966191AbXEHSab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:30:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966035AbXEHSaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:30:30 -0400
Date: Tue, 8 May 2007 11:30:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Cornelia Huck wrote:
>
> > Threading at a driver level still does that (ie individual disks may be 
> > attached in some order that depends on how fast they are to respond), but 
> > in a much more controlled fashion, and only for drivers that explicitly 
> > say that they can do it.
> 
> How is that better? You still must rely on udev for persistent device
> names.

It's better because then the *driver* can decide whether it supports 
threaded probing or not.

The threaded PCI bus probing was totally and utterly broken exactly 
because many drivers were simply not willing or able to handle it.

Also, quite frankly, when this came up I already posted a much better 
approach for allowing arbitrary threading. It was ignored, but maybe you 
want to take a look.

See

	http://lkml.org/lkml/2006/10/27/185

for last time this came up. Any driver can decide to do

	execute_in_parallel(myprobe, myarguments);

and that really *simple* thing allows synchronization points 
("wait_for_parallel()") and arbitrary setting of the allowed parallelism.

I really think that is a *much* better approach. It allows, for example, 
the driver to do certain things (like name allocations and any 
particularly *fast* parts of probing) synchronously, and then do slow 
things (like spinning up disks and actually reading the partition tables) 
asynchronously.

Anyway, I will refuse to merge anything that does generic bus-level 
(unless the bus is something off-the-board like SCSI) parallelism, unless 
you can really show me how superior and stable it is. I seriously doubt 
you can. We tried it once, and it was a total disaster.

		Linus
