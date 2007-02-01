Return-Path: <linux-kernel-owner+w=401wt.eu-S1751041AbXBAVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041AbXBAVz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXBAVz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:55:26 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:37763 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbXBAVzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:55:25 -0500
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mark Lord <liml@rtr.ca>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <45C2474E.9030306@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>
	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	 <45C2474E.9030306@rtr.ca>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 15:55:20 -0600
Message-Id: <1170366920.3388.62.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 15:02 -0500, Mark Lord wrote:
> I believe you made the first change in response to my prodding at the time,
> when libata was not returning valid sense data (no LBA) for media errors.
> The SCSI EH handling of that was rather poor at the time,
> and so having it not retry the remaining sectors was actually
> a very good fix at the time.
> 
> But now, libata *does* return valid sense data for LBA/DMA drives,
> and the workaround from circa 2.6.16 is no longer the best we can do.
> Now that we know which sector failed, we ought to be able to skip
> over it, and continue with the rest of the merged request.

We can ... the big concern with your approach, which you haven't
addressed is the time factor.  For most SCSI devices, returning a fatal
MEDIUM ERROR means we're out of remapping table, and also that there's
probably a bunch of sectors on the track that are now out.  Thus, there
are almost always multiple sector failures.  In linux, the average
request size on a filesystem is around 64-128kb; thats 128-256 sectors.
If we fail at the initial sector, we have to go through another 128-256
attempts, with the internal device retries, before we fail the entire
request.  Some devices can take a second or so for each read before they
finally give up and decide they really can't read the sector, so you're
looking at 2-5 minutes before the machine finally fails this one
request ... and much worse for devices that retry more times.

> One thing that could be even better than the patch below,
> would be to have it perhaps skip the entire bio that includes
> the failed sector, rather than only the bad sector itself.

Er ... define "skip over the bio".  A bio is simply a block
representation for a bunch of sg elements coming in to the elevator.
Mostly what we see in SCSI is a single bio per request, so skipping the
bio is really the current behaviour (to fail the rest of the request).

> I think doing that might address most concerns expressed here.
> Have you got an alternate suggestion, James?

James


