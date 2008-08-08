Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbYHHVHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbYHHVHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbYHHVHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:07:30 -0400
Received: from web83203.mail.mud.yahoo.com ([216.252.101.47]:44171 "HELO
	web83203.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754117AbYHHVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:07:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=uQiLK8C6Z9SqLkNqfiHRuX8rVe0NgjpW3C9bjp85Nz4+cKTCtHhqUGn9dN1ojg74WDybKft84X7aazyUhO0n1eAV6kAjMVUlP25yINpxv6gzQW5b+J1U4NPTT3AvfM8hzmXoANEnpkgbADWL9X3DtXFW6QKnLRC/ZFdcnzFP9jA=;
X-YMail-OSG: 60__XyMVM1l9s7v7iixR3o98HUT2FTu95lliI92wzsPcIM8QdrMK8.TINGOIVDXe2swXYERJE3hhyEVYFEku6dXeBqEkIXEd1ALkfHq1USw5W3Ftu8PwB_8ksZH1ft0-
Date: Fri, 8 Aug 2008 14:07:28 -0700 (PDT)
From: Matthew Frost <artusemrys@sbcglobal.net>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
To: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Matthew Frost <artusemrys@yahoo.com>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <656254.26203.qm@web83208.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <779703.44181.qm@web83203.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Matthew Frost <artusemrys@yahoo.com> wrote:

> --- Matthew Frost <artusemrys@sbcglobal.net> wrote:
> 
> > Alan Stern wrote:
> > > > The patches to fix this that I have tried do not apply
> > > > cleanly to lk 2.6.26 (and break during compile if forced:
> > > > "us->fflags" is not defined).
> > > > 
> > > > Is there a lk 2.6.26 patch available?
> > > 
> > > Sorry about that; my patches are against the USB development tree and
> > > I tend to forget to redo them against the vanilla kernel.  Below is a
> > > patch against 2.6.26.  Or you can just edit the original patch and
> > > change the occurrences of "fflags" to "flags".
> > > 
> > > Alan Stern
> > > 
> > > 
> > > Index: 2.6.26/drivers/usb/storage/transport.c
> > > ===================================================================
> > > --- 2.6.26.orig/drivers/usb/storage/transport.c
> > > +++ 2.6.26/drivers/usb/storage/transport.c
> > > @@ -1034,8 +1034,21 @@ int usb_stor_Bulk_transport(struct scsi_
> > >  
> > >  	/* try to compute the actual residue, based on how much data
> > >  	 * was really transferred and what the device tells us */
> > > -	if (residue) {
> > > -		if (!(us->flags & US_FL_IGNORE_RESIDUE)) {
> > > +	if (residue && !(us->flags & US_FL_IGNORE_RESIDUE)) {
> > > +
> > > +		/* Heuristically detect devices that generate bogus residues
> > > +		 * by seeing what happens with INQUIRY and READ CAPACITY
> > > +		 * commands.
> > > +		 */
> > > +		if (bcs->Status == US_BULK_STAT_OK &&
> > > +				scsi_get_resid(srb) == 0 &&
> > > +					((srb->cmnd[0] == INQUIRY &&
> > > +						transfer_length == 36) ||
> > > +					(srb->cmnd[0] == READ_CAPACITY &&
> > > +						transfer_length == 8))) {
> > > +			us->flags |= US_FL_IGNORE_RESIDUE;
> > > +
> > > +		} else {
> > >  			residue = min(residue, transfer_length);
> > >  			scsi_set_resid(srb, max(scsi_get_resid(srb),
> > >  			                                       (int) residue));
> > > 
> > > 
> > 
> > Thanks!  I've been trying to fix it manually, and it wouldn't work. 
> Trying
> > this version now.  Let's see if this fixes my problem.
> > 
> > Matt Frost
> > 
> 
> Tested under two distributions, this patch restores correct functionality
> to my hardware.  Thank you very much!
> 
> Matt
> 
Update/sqeaking-of-the-wheel:

The same problem still happens under 2.6.27-rc2, and I haven't seen this
bumped to -stable, either.  It continues to solve the problem here.

Matt
