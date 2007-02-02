Return-Path: <linux-kernel-owner+w=401wt.eu-S1945960AbXBBQGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945960AbXBBQGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945958AbXBBQGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:06:22 -0500
Received: from rtr.ca ([64.26.128.89]:1733 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945950AbXBBQGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:06:21 -0500
Message-ID: <45C3617B.2020400@rtr.ca>
Date: Fri, 02 Feb 2007 11:06:19 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Ric Wheeler <ric@emc.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca>	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>	<45C2474E.9030306@rtr.ca>	<1170366920.3388.62.camel@mulgrave.il.steeleye.com>	<45C32C7F.9050706@emc.com> <20070202145003.525bd682@localhost.localdomain>
In-Reply-To: <20070202145003.525bd682@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>
> If this is the right strategy for disk recovery for a given type of
> device then this ought to be an automatic strategy. Most end users will
> not have the knowledge to frob about in sysfs, and if the bad sector hits
> at the wrong moment a sensible automatic recovery strategy is going to do
> the right thing faster than human intervention, which may be some hours
> away.

I think something we seem to be discussing here are the opposite aims
of enterprise RAID (traditional SCSI market) versus desktop filesystems
(now the number one user of Linux SCSI, courtesy of libata).

With RAID, it's safe to suggest that a very fast, bounded exit from EH
is almost always what the customer / end-user wants, because the higher
level RAID management can then deal with the failed drive offline.

But for a desktop filesystem, failing out quickly and bulk-failing megabytes
around a couple of bad sectors is not good -- no redundancy, and this will
lead to unneeded data loss.

It's beginning to look like this needs to be run-time tuneable,
per block minor device (per-partition), through sysfs at a minimum.
The RAID tools could then automatically choose settings to bias more
towards an "instant exit" when errors are found, whereas a non-RAID
desktop could select a more reliable recovery strategy.

Right now, with Jame's patch (earlier in this thread), the whole scheme
is heavily weighted towards the RAID "instant exit" strategy, which is
making me quite nervous about the data on my laptop.

Cheers 
