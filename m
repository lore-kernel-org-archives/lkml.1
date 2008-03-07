Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYCGCot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYCGCot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbYCGCoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:44:39 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45520 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902AbYCGCoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:44:38 -0500
Subject: Re: ata_ram driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>,
       Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47D0A58D.3050500@garzik.org>
References: <20080222200951.GI16995@parisc-linux.org>
	 <47BF3E54.9050609@rtr.ca>  <47CFA9A6.2040506@gmail.com>
	 <1204817301.3062.3.camel@localhost.localdomain>
	 <47D08478.8010700@gmail.com>
	 <1204848119.3062.94.camel@localhost.localdomain>
	 <47D08892.3080209@gmail.com>
	 <1204849353.3062.107.camel@localhost.localdomain>
	 <47D08C32.8060907@gmail.com>  <47D0A58D.3050500@garzik.org>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 20:44:30 -0600
Message-Id: <1204857870.3062.121.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 21:16 -0500, Jeff Garzik wrote:
> Tejun Heo wrote:
> > James Bottomley wrote:
> >>> Yeap, sure.  It's the combination of things that always made me put this
> >>> off.  Is there a function I can call to just shutdown the host instead
> >>> of destroying it?
> >> Not really ... the process of unbinding the ULDs causes their remove
> >> methods to call shudown.  It is possible to separate this in the ULDS;
> >> but the original design was to make remove and shutdown be similar for
> >> the very reason that if you're removing the driver with unflushed data
> >> in the cache, we'd really like it flushed (flush is called from
> >> shutdown) because you have no way to talk to the device after this
> >> without reinserting the driver.
> > 
> > The problem is that libata EH and other stuff aren't ready to let go of
> > the SCSI host up until the last moment and that last moment can't be
> > moved before SCSI host destruction because shutdown sequence (flush and
> > spindown) requires live EH.  I think this can be solved by shooting down
> > individual sdev's instead of destroying the scsi_host.
> 
> I'm curious how the picture would change, if we used a scsi_host for 
> each ata_host.

It would probably make the whole paradigm a lot easier.  Currently, if
you look at the transport classes that do this type of thing, they
shadow host and add port and other components as extra bits.  libata
does a rather strange thing trying to have one SCSI host per SATA port,
so scsi_host and ata_host don't match up.  Then on destruction you can
just follow the standard SCSI teardown path.

James


