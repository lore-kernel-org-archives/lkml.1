Return-Path: <linux-kernel-owner+w=401wt.eu-S2992714AbXDRVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992714AbXDRVVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992763AbXDRVVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:21:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:35986 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992761AbXDRVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VfOGVzLVmWD1dFGQhGKd6sIqk3rn5klc5qwZsUL5qET7DQS09R73yJHkkinbF4T/L3xH55+f2N3ohEyymonxYbABQ9QBpWs8sLOS5maUXYGBfXBEBBG4UpMBb+deplLnPAcAvSL616FznLRorb8oivsIzmWnjx15ytIu0ryrKPg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Date: Wed, 18 Apr 2007 23:31:14 +0200
User-Agent: KMail/1.9.6
Cc: Mark Lord <liml@rtr.ca>, Chuck Ebbert <cebbert@redhat.com>,
       emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
References: <461D4E2C.6000704@redhat.com> <46254416.6090202@rtr.ca> <4625AF20.7050904@gmail.com>
In-Reply-To: <4625AF20.7050904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704182331.14515.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 18 April 2007, Tejun Heo wrote:
> Mark Lord wrote:
> > Chuck Ebbert wrote:
> >> Mark Lord wrote:
> >>> I'll patch it locally on my own machines, but what about the tens
> >>> of thousands of other Seagate notebook drive owners out there?
> >>>
> >>
> >> This is a problem with Seagate specifically, spinning back up
> >> on receipt of some command after spindown?
> > 
> > No, they just seem to be affected worse by it than some other brands.
> > The bug is that libata/SCSI now spin-down the drive before the distro's
> > scripts are done with it, so it spins down, and then gets spun up again
> > by the distro, and then spun down again by the distro.
> > 
> > And along the way, one/both of the two causes a full mechanism "park",
> > which is hard on things if abused (like this).
> > 
> > Or at least that's what I recall for it.  Tejun?
> 
> This really isn't a regression.  It's been always like that with libata.

Tejun, it is a regression over IDE subsystem
(so all PATA and some SATA also).

Dave/Chuck, this also seems like a FC7 regression
(because of the libata PATA switch).

>  libata doesn't make devices go into standby mode and shutdown(8) does
> it for libata.  The problem here is that libata does issue
> SYNCHRONIZE_CACHE on shutdown.  So, the sequence of event is...
> 
> 1. shutdown(8) issues SYNCHRONIZE_CACHE followed by STANDBY_NOW
> 2. kernel shutdown starts
> 3. libata shutdown issues SYNCHRONIZE_CACHE
> 4. power goes off
> 
> Some drives seem to spin up at step #3 even when its cache is clean and
> power goes off right after the disk finishes the command.  So, it's
> really bad when it happens - spin down, spin up followed by immediate
> power off.
> 
> SCSI part of the fix is queued in scsi-misc-2.6 tree and libata-dev part
> is acked and waiting to be merged, so the fix will be available in
> 2.6.22.  However, it's disabled by default to remain compatible with the
> current behavior and requires userland change to fully fix the problem.
