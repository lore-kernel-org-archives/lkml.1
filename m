Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYHHVaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYHHVaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYHHVaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:30:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3208 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753675AbYHHVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:30:08 -0400
Date: Fri, 8 Aug 2008 17:30:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Frost <artusemrys@sbcglobal.net>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Douglas Gilbert <dougg@torque.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Matthew Frost <artusemrys@yahoo.com>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
In-Reply-To: <779703.44181.qm@web83203.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0808081728340.24293-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Matthew Frost wrote:

> > > > Index: 2.6.26/drivers/usb/storage/transport.c
> > > > ===================================================================
> > > > --- 2.6.26.orig/drivers/usb/storage/transport.c
> > > > +++ 2.6.26/drivers/usb/storage/transport.c
> > > > @@ -1034,8 +1034,21 @@ int usb_stor_Bulk_transport(struct scsi_
> > > >  
> > > >  	/* try to compute the actual residue, based on how much data
> > > >  	 * was really transferred and what the device tells us */
> > > > -	if (residue) {
> > > > -		if (!(us->flags & US_FL_IGNORE_RESIDUE)) {
> > > > +	if (residue && !(us->flags & US_FL_IGNORE_RESIDUE)) {
> > > > +
> > > > +		/* Heuristically detect devices that generate bogus residues
> > > > +		 * by seeing what happens with INQUIRY and READ CAPACITY
> > > > +		 * commands.
> > > > +		 */
> > > > +		if (bcs->Status == US_BULK_STAT_OK &&
> > > > +				scsi_get_resid(srb) == 0 &&
> > > > +					((srb->cmnd[0] == INQUIRY &&
> > > > +						transfer_length == 36) ||
> > > > +					(srb->cmnd[0] == READ_CAPACITY &&
> > > > +						transfer_length == 8))) {
> > > > +			us->flags |= US_FL_IGNORE_RESIDUE;
> > > > +
> > > > +		} else {
> > > >  			residue = min(residue, transfer_length);
> > > >  			scsi_set_resid(srb, max(scsi_get_resid(srb),
> > > >  			                                       (int) residue));
> > > > 
> > > > 
> > > 
> > > Thanks!  I've been trying to fix it manually, and it wouldn't work. 
> > Trying
> > > this version now.  Let's see if this fixes my problem.
> > > 
> > > Matt Frost
> > > 
> > 
> > Tested under two distributions, this patch restores correct functionality
> > to my hardware.  Thank you very much!
> > 
> > Matt
> > 
> Update/sqeaking-of-the-wheel:
> 
> The same problem still happens under 2.6.27-rc2, and I haven't seen this
> bumped to -stable, either.  It continues to solve the problem here.

The patch has not yet been pushed to mainline but it is present in Greg 
KH's USB development tree.  Presumably it will end up in the mainline 
kernel before 2.6.27-final is released.

Alan Stern

