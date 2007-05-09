Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbXEINVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbXEINVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXEINVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:21:14 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:10533 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbXEINVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:21:12 -0400
Date: Wed, 9 May 2007 15:20:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509152024.1a57d82a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0705090216030.2213@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
	<20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
	<Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
	<20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
	<20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090216030.2213@asgard.lang.hm>
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

On Wed, 9 May 2007 02:25:10 -0700 (PDT),
david@lang.hm wrote:

> makeing up an example
> 
> today the process would be
> call driver X to initialize it's devices.
> 
> driver X follows these steps
> 
> 1. see if a compatible chipset/device appears to be available
> 
> 2. initialize the chipset/device (loading firmware)
> 
> 3. query the now partially initialized chipset/device to see what specific 
> options are enabled in the hardware
> 
> 4. for each 'thing' that's enabled in hardware, initialize and register 
> it.

The sync ->probe() could return after step 1 (when it is clear the
driver wants to bind to the device). The remainder should be done in
the async function, so that the bus could go on with other devices. The
driver should then signal when it is done with its registrations.

> step 2 can take a long time and so you want it to be async so that it's 
> timeouts can be running in parallel (for that matter step 1 may have some 
> timeouts as well)
> 
> however, you can't tell what devices to register until after step 3
> 
> so in at least some cases, it seems as if the registratin of devices needs 
> to be after the async section.

If you're talking about devices registered by the driver, these should
be in the async section.

> Linus made a good case fo an example (hard drives) where the registration 
> can happen first and fast, but the async section (spinning up) takes a 
> while and could come second.

I don't really see the difference?

> to acommodate both of these device models it seems to me that you can't 
> defice either
> async followed by sync
> or
> sync followed by async
> but instead need to support the combined
> sync followed by async followed by sync.
> 
> now, it's very possible that I'm mistaken and one of the two-part models 
> can be used for everything, if so then it's definantly simpler to do so.

Hm, maybe I'm dense, but I really don't understand the problem here.
Why should (optional) sync followed by (optional) async followed by bus
synchonization not cover all cases? The async portion can also do some
"sync" stuff and then signal completion, can't it?

If you're worried about notifications to userspace, you could first
suppress the add uevent via uevent_suppress and then generate it when
you signal completion to the bus.
