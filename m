Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbYALUff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbYALUff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYALUf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:35:26 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50089 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbYALUfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:35:25 -0500
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI] Crash on
	accessing DVD-RAM
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alexander <aledin@mail.ru>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
In-Reply-To: <47891426.1020604@shaw.ca>
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
	 <478702C7.80401@shaw.ca> <47887982.6050805@mail.ru>
	 <47891426.1020604@shaw.ca>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 14:35:17 -0600
Message-Id: <1200170117.3656.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-12 at 13:25 -0600, Robert Hancock wrote:
> Alexander wrote:
> > Robert Hancock wrote:
> >> There's this patch which was intended to fix it:
> >>
> >> http://lkml.org/lkml/2007/11/22/148
> > 
> > I applied this patch to 2.6.24-rc7. Now at boot time my DVD-RW is
> > normaly detected as:
> > 
> > sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> > 
> > But I cannot mount it. All my attempts failed with
> > 
> > ISOFS: Unable to identify CD-ROM format.
> > 
> > With mem<=4098M or sata_nv.adma=0 it still mounts and works ok.
> 
> As I wrote, it would appear that somehow the blk_queue_bounce_limit 
> setting that the driver has made is not being respected and the block 
> layer is still trying to feed it addresses over 4GB. Any ideas anyone?

Actually, I'd be very sceptical that the blk_queue_bounce_limit isn't
working as advertised; there'd be a large number of failures if it were
not.

However, the "as advertised" part doesn't seem to be generally well
understood.  The point being that block commands are only bounced if
they come from the filesystem or the user, not if they're generated
directly inside the kernel.  Since the fault occurs before mount, it's
suggestive of the latter.

A long time ago, GFP_KERNEL allocations meant that the memory allocated
was physically under 4GB.  Then x86_64 (and before it ia64) wanted to
break this.  So they introduced a new flag:  GFP_DMA32 that behaved like
the old GFP_KERNEL and then changed GFP_KERNEL on their architectures to
return memory from anywhere.  I'd strongly suggest some piece of kernel
memory was allocated for a transfer buffer without GFP_DMA32 and then
passed in to the driver.  Unfortunately, that could be anywhere inside
cdrom or sr.  Knowing what the actual command is might help ... some of
the distinctive MMC media ones only have a single source.

James


