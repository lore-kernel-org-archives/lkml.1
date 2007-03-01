Return-Path: <linux-kernel-owner+w=401wt.eu-S1030427AbXCAWL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427AbXCAWL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030435AbXCAWL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:11:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:50232 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030359AbXCAWL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:11:57 -0500
X-Provags-ID: V01U2FsdGVkX1+QeFdwxg+QWLOoOxyzekjRq+mFyWXWB0Cqa38/0+
	4OhI4Pgm6txN6y
Date: Thu, 1 Mar 2007 23:11:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, linux-pm@lists.osdl.org,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_sil680 suspend/resume
In-Reply-To: <Pine.LNX.4.60.0702282201250.8832@poirot.grange>
Message-ID: <Pine.LNX.4.60.0703012305030.7351@poirot.grange>
References: <20061122172841.0b90f042@localhost.localdomain>
 <Pine.LNX.4.60.0702262150460.5079@poirot.grange> <Pine.LNX.4.60.0702282201250.8832@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

I tracked this change down to your patch: 
http://marc.theaimsgroup.com/?t=115012763500002&r=1&w=2 (approximately). 
(Interestingly, Jeff submitted the respective cumulative libata patch last 
year on my birthday:-( ) Also, there's a Ubuntu bug report: 
https://launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/76431 
identical to what I see, although I cannot check if it worked before 
2.6.20. Could you, please, comment how is this supposed to work? In 
particular, what shoud trigger the EH action, leading to setting the 
ATA_DFLAG_SUSPENDED flag? Below again my earlier post for reference.

Thanks
Guennadi

On Wed, 28 Feb 2007, Guennadi Liakhovetski wrote:

> On Mon, 26 Feb 2007, Guennadi Liakhovetski wrote:
> 
> > With a post 2.6.20 kernel from powerpc.git I cannot suspend at all:
> > 
> > pata_sil680 0000:00:0c.0: suspend
> > ata1: suspend failed, device 0 still active
> > pci_device_suspend(): ata_pci_device_suspend+0x0/0x74() returns -16
> > suspend_device(): pci_device_suspend+0x0/0xac() returns -16
> > Could not suspend device 0000:00:0c.0: error -16
> 
> AFAICS, "still active" is printed from ata_host_suspend() if a device 
> (disk) on the host to be suspended doesn't have ATA_DFLAG_SUSPENDED flag 
> set. This flag is only set in ata_eh_suspend(), which is only called from 
> ata_eh_recover(), like this:
> 
> generic_error_handler()
> ata_bmdma_drive_eh()
> ata_do_eh()
> ata_eh_recover()
> ata_eh_suspend()
> dev->flags |= ATA_DFLAG_SUSPENDED;
> 
> but I don't understand why the error handler should be envoked? Should the 
> "disk" be suspended before the host and is it when the eh should set the 
> flag? If my guess is right - why doesn't the disk get suspended on my 
> machine? Shall I suspend it explicitely from userspace? I do "hdparm -Y", 
> and it does stop spinning", but I still get the error.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 

---
Guennadi Liakhovetski
