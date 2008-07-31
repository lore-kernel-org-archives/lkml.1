Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYGaPKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYGaPKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYGaPKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:10:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36472 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751928AbYGaPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:10:22 -0400
Date: Thu, 31 Jul 2008 11:10:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pete Zaitcev <zaitcev@redhat.com>
cc: Douglas Gilbert <dougg@torque.net>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Matt Frost <artusemrys@sbcglobal.net>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Frost <artusemrys@yahoo.com>
Subject: Re: BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
In-Reply-To: <20080730155827.524f72d2.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0807311102550.4409-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Pete Zaitcev wrote:

> Perhaps I misunderstand how our SCSI stack works. The code in ub is
> simpler, it deals with 3 values at the end of transfer:
>   Lasked is how much we asked for
>   Lgot   is how much was transferred
>   Lresid is the reported residue
> 
> So, ub checks if the following is true:
>   Lasked = Lgot + Lresid
> 
> If device fails this check, you can assume that it's just not set up
> to report the residue correctly and so, the danger of valid residue
> that you outlined becomes rather academic.

This algorithm is wrong.  See the description under Case (4) or (5) in 
6.7.2 of the Bulk-Only spec:

	The device may send fill data to pad up to a total of
	dCBWDataTransferLength.

So it's legal to have Lgot == Lasked and Lresid > 0.  There are devices 
which really do this.

(It may seem pointless to add the padding.  However for reasons that 
aren't clear, the spec requires the device to STALL the bulk-in 
endpoint if the padding isn't present -- and many devices don't like to 
STALL bulk endpoints.  Similar reasoning applies to the case of OUT 
transfers.)

> The reason I do it this way is, I've seen a device which reported
> a correct residue until the first long read, and then residue was
> miscalculated due to a 16-bit wrap (it did transfer right data though).
> I think it's one of those which are explicitly blacklisted these
> days, but I cannot remember.

I hope it's blacklisted!

Alan Stern

