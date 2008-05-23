Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYEWU06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYEWU06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYEWU0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:26:47 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37333 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYEWU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:26:46 -0400
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <g176e5$6fb$1@ger.gmane.org>
References: <g0mkaf$i1r$1@ger.gmane.org>
	 <20080518021423.3dcf0ddd.akpm@linux-foundation.org>
	 <1211456081.3956.39.camel@localhost.localdomain>
	 <g176e5$6fb$1@ger.gmane.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 15:26:42 -0500
Message-Id: <1211574403.11477.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 20:34 +0100, Sitsofe Wheeler wrote:
> <posted & mailed>
> 
> James Bottomley wrote:
> 
> > Actually, I think this is a very subtle bug; what I think is happening
> > is that after Hannes sysfs changes, we now add scsi_bus_type to the
> > target device.  However, scsi_bus_uevent() unconditionally casts from
> > dev to a struct scsi_device and then looks at the type entry.  My theory
> > is that in this particular config going from struct scsi_target to
> > struct device and back to struct scsi_device actually tips us over into
> > unmapped space for the -> type deref.
> > 
> > Hopefully this should fix it by checking the device type before doing
> > the deref.
> 
> This fixed the problem for me (it was horribly intermittant but I've done
> 10+ consecutive reboots without seeing an oopos). I changed the patch to
> printk everytime the condition was hit and it seems to happen twice per
> PATA device - once after each scsi?: pata_via message and then again after
> each scsi 0:0:0:0: Direct-Accesss ATA DISKID etc : 0 ANSI: 5 .
> 
> The thing I don't understand about your explanation is that it sounds like
> the device struct is being round-tripped (but is just being cast to
> different things along the way). If this is the case why would this problem
> ever arise? Surely if it is really a struct scsi_device underneath there
> should be no problem?

The event is called for all generic device objects belonging to the
scsi_bus_type.  That means both struct scsi_device and struct
scsi_target objects.  When it's called for struct scsi_target objects,
casting out to struct scsi_device does the wrong thing.

James


