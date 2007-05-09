Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbXEIRII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbXEIRII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXEIRHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:07:54 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:37644 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbXEIRHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:07:53 -0400
Date: Wed, 9 May 2007 19:07:36 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509190736.35cf51d2@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0705090910050.4467@asgard.lang.hm>
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
	<20070509152024.1a57d82a@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090910050.4467@asgard.lang.hm>
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

On Wed, 9 May 2007 09:18:10 -0700 (PDT),
david@lang.hm wrote:

> I'm not worried about notification to userspace, I'm worried about devices 
> getting registered during the async stage appearing in different orders on 
> different boots due to different timeings.

Ah, now I think I understand what you mean. You're talking about stuff
like block devices or net devices, right?

> 
> if you can identify the device well enough to register it quickly then the 
> approach that Linus proposed works well, which is
> 
> sync probe, identify devices, register devices
> async initialize devices
> wait for all async to complete
> 
> however I'm talking about cases where you can't fully identify the devices 
> (at least not well enough to register them with the kernel) and am saying 
> that doing
> 
> sync probe
> async initialize device, register device
> wait for all async to complete
> 
> results in unpredictable device ordering, but if instead you did
> 
> sync probe
> async initialize device
> sync wait for all async to complete, register device
> 
> you can get back to predictable ordering

Hm, so that sound like a case for a distinct setup() routine:

1. bus calls ->probe(), which return synchronously
2. bus calls ->probe_async() for all devices (optional)
3. bus waits for all probes to finish
4. bus calls ->setup() for all devices (which does the registering)

(->setup() can but need not be sync, although it should be for your
case)

Note that ordering is not guaranteed on hotpluggable busses anyway, and
if you use ->setup() as a function that may or may not be called later
on, there's no ordering guarantee either. (Unless the bus/device driver
implements something to that effect, or you have udev rules in place.)
