Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZEKSed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZEKSed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZEKSeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:34:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51868 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbZEKSeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:34:19 -0400
Message-ID: <4A086F69.3060607@garzik.org>
Date: Mon, 11 May 2009 14:33:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tim Connors <tconnors+linuxkml@astro.swin.edu.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH #upstream-fixes] libata: fix attach error handling
References: <alpine.DEB.2.00.0905060004100.15177@dirac.rather.puzzling.org> <4A00DA98.5060201@kernel.org> <alpine.DEB.2.00.0905061038340.14678@dirac.rather.puzzling.org> <alpine.DEB.2.00.0905090005560.24222@dirac.rather.puzzling.org> <4A04DF32.4050305@kernel.org> <4A05AA1E.3070700@kernel.org>
In-Reply-To: <4A05AA1E.3070700@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> New device attach path in ata_eh_revalidate_and_attach() is divided
> into two separate loops because ATA requires IDENTIFY to be issued to
> slave first while the user expects to see device probe messages from
> the master device.  new_mask is used to track which devices are the
> new ones between the first loop and the second.
> 
> This usually works well but if an error occurs during configuration
> stage, ata_dev_revalidate_and_attach() returns with error code and
> forgets new_mask.  On the retry run, dev->class is set and new_mask
> for the device is clear, so the device just gets revalidated and thus
> ends up skipping post-configuration procedure including scheduling of
> SCSI_HOTPLUG for the device.  When this occurs, ATA part of probing
> works fine but SCSI probing usually doesn't happen and makes the
> device unreachable.
> 
> The behavior has been around for a very long time but it has been
> uncovered with the recent addition of 1_5_GBPS horkage which uses
> -EAGAIN return value from ata_dev_configure() to restart the probing
> sequence after forcing cable speed.
> 
> This can be fixed by making sure dev->class is permanently set only
> after all configurations are successfully complete.  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Tim Connors <tconnors+linuxkml@astro.swin.edu.au>
> ---
>  drivers/ata/libata-eh.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)

applied


