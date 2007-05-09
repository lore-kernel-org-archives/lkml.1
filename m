Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbXEIWVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbXEIWVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbXEIWVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:21:02 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:31104 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753329AbXEIWVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:21:00 -0400
Message-ID: <46424963.7070209@cfl.rr.com>
Date: Wed, 09 May 2007 18:21:23 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: david@lang.hm
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com> <alpine.LFD.0.98.0705081123080.3974@woody. <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 May 2007 22:21:13.0761 (UTC) FILETIME=[5AA97110:01C79288]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15166.001
X-TM-AS-Result: No--9.803200-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

I agree.  Considering the particular case of scsi disks, you want to do 
the long INQUIRY command to probe each target in phase 2, so that this 
time consuming step can be done in parallel between multiple scsi 
busses.  After the INQUIRY though, you have to register with the scsi 
layer and assign it a minor number and so on, and this you want to do 
with some predictability, so you need to do this in phase 3.

Take a hypothetical system containing a PCI bus with a video card and 
two scsi cards in it, and each scsi bus has a hard disk on it.  The 
sequence would go:

1) PCI Bus invokes phase 1 on video card, scsi a, scsi b, in that order
2) PCI Bus invokes phase 2 on video card, scsi a, scsi b, each in their 
own thread
2.1) video card uploads firmware
2.2) scsi bus A issues INQUERY commands to each target to detect devices
2.3) scsi bus B issues INQUERY commands to each target to detect devices
3) PCI Bus invokes phase 3 on video card, scsi a, scsi b, in that order
3.1) video card registers with the frame buffer layer
3.2) scsi bus A registers its detected disk with the scsi layer
3.3) scsi bus B registers its detected disk with the scsi layer


Because 3.2 and 3.3 always happen in order, /dev/sda will stay /dev/sda 
even if 2.3 finishes before 2.2.  Likewise if you add a new video card 
to PCI slot 4 which does not require a firmware upload, it will not 
displace the existing video card from /dev/fb0 because phase 3 will take 
place for the first card first, even if phase 2 completed first on the 
new card.

