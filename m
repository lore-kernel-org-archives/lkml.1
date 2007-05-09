Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbXEIH6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbXEIH6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 03:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXEIH6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:58:30 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:9070 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbXEIH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:58:29 -0400
Date: Wed, 9 May 2007 09:58:12 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
	<20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
	<Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
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

On Tue, 8 May 2007 13:26:00 -0700 (PDT),
david@lang.hm wrote:
 
> is it really enough to do the sync followed by the async piece?
> 
> it seems to me that there may be a need for three steps
> 
> 1. prep (sync, what we do today)
> which will all complete before
> 2. parallel (async)
> which will all complete before
> 3. cleanup (sync)
> 
> for some busses you can do the device enumeration in the prep phase, but I 
> would expect that for others you can't enumerate the devices until you 
> actually go looking for them. so by allowing the cleanup phase you have a 
> spot that can order everything as if the second phase was sequential.
> 
> I would expect that almost no drivers would use all three, but I could see 
> some useing #1 and #2 while others use #2 and #3

Hm, how about:
1. ->probe() called (wait until it is finished)
2. ->probe_async() called (only kick off, don't wait, go to next device)
3. bus waits until all async probes have returned

This would imply a wait mechanism on the bus, like upping a counter for
each successfully called ->probe_async(), the driver downing the
counter when all actions triggered by ->probe_async() have finshed, and
the bus waiting until the counter has reached 0.

(Individual drivers can have 1., 2., or 1. & 2. A bus may support 1.
(like now), 2. & 3. or 1., 2. and 3.)

> in any case there needs to be a way to wait until the async portion 
> finishes before going on to next steps (you don't want to try to probe 
> drives for md partitions until the drives have finished spinning up for 
> example)

Agreed. Would it be enough if we only have one bus in flight
simuntaneously?
