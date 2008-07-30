Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbYG3WBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbYG3WBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759729AbYG3WAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:00:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759527AbYG3WAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:00:41 -0400
Date: Wed, 30 Jul 2008 15:58:27 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Matt Frost <artusemrys@sbcglobal.net>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Frost <artusemrys@yahoo.com>
Subject: Re: BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
Message-Id: <20080730155827.524f72d2.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.0807301720320.2322-100000@iolanthe.rowland.org>
References: <20080730150953.771b1345.zaitcev@redhat.com>
	<Pine.LNX.4.44L0.0807301720320.2322-100000@iolanthe.rowland.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.13.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 17:28:49 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> wrote:

> > > +		if (bcs->Status == US_BULK_STAT_OK &&
> > > +				scsi_get_resid(srb) == 0 &&
> > > +					((srb->cmnd[0] == INQUIRY &&
> > > +						transfer_length == 36) ||
> > > +					(srb->cmnd[0] == READ_CAPACITY &&
> > > +						transfer_length == 8))) {
> > > +			us->flags |= US_FL_IGNORE_RESIDUE;
> > 
> > Why do you do this for INQUIRY and READ_CAPACITY only?
> > Why not do it for any command?
> 
> Because those are the only two commands for which I'm reasonably
> certain the device should never return a nonzero residue with Okay
> status.  For other commands there might be a valid positive residue --
> although if there is then the device should also return Check Condition
> status (the spec is unclear on this point).

Perhaps I misunderstand how our SCSI stack works. The code in ub is
simpler, it deals with 3 values at the end of transfer:
  Lasked is how much we asked for
  Lgot   is how much was transferred
  Lresid is the reported residue

So, ub checks if the following is true:
  Lasked = Lgot + Lresid

If device fails this check, you can assume that it's just not set up
to report the residue correctly and so, the danger of valid residue
that you outlined becomes rather academic.

The reason I do it this way is, I've seen a device which reported
a correct residue until the first long read, and then residue was
miscalculated due to a 16-bit wrap (it did transfer right data though).
I think it's one of those which are explicitly blacklisted these
days, but I cannot remember.

-- Pete
