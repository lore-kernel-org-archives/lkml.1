Return-Path: <linux-kernel-owner+w=401wt.eu-S968424AbXEHQjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968424AbXEHQjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968318AbXEHQjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:39:09 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:42320 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966965AbXEHQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:39:06 -0400
Date: Tue, 8 May 2007 18:38:46 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
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

On Tue, 8 May 2007 08:27:34 -0700 (PDT),
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And no, we should not do it at the device core level. In fact, I don't 
> think we should do it at that level at all. 
> 
> I'm pretty sure that the performance problems are at individual device 
> drivers, and that the right solution is to thread at *that* level. Not 
> higher up.

These are two different problems:

1. Probing taking long for individual device drivers. I agree, this
should be solved at the driver level.

2. Sheer volume of devices on a bus. Even if the indivdual probing
doesn't take long, having all devices probed one after the other may
take a lot of time. Putting the actual probe on a thread makes it
possible to run several probes in parallel, thereby cutting probing
time.

(FWIW, the s390 cio layer does asynchronous probing at the bus level,
where work is usually outstanding for a lot of devices at once. Where a
2.4 kernel might take half an hour to detect all devices, we slashed it
down to half a minute. I believe we could make rescans work even better
with multithreaded probing with some tweaking.)

> Threading at the bus level just inevitably means things like random 
> numbers for devices depending on some timing/scheduling issue. That's 
> nasty.
> 
> Threading at a driver level still does that (ie individual disks may be 
> attached in some order that depends on how fast they are to respond), but 
> in a much more controlled fashion, and only for drivers that explicitly 
> say that they can do it.

How is that better? You still must rely on udev for persistent device
names. And controlling device names in the driver can still be done in
the device driver with multithreaded probing (on s390 ccw, devices
already pop up in a random order, and the dasd driver manages to
conjure up consistent names for those devices that the user specified.)
