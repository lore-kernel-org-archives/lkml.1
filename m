Return-Path: <linux-kernel-owner+w=401wt.eu-S1423085AbXBBCsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423085AbXBBCsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 21:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423083AbXBBCsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 21:48:31 -0500
Received: from rtr.ca ([64.26.128.89]:2215 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423081AbXBBCsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 21:48:30 -0500
Message-ID: <45C2A67B.7090907@rtr.ca>
Date: Thu, 01 Feb 2007 21:48:27 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>	 <45C2474E.9030306@rtr.ca> <1170366920.3388.62.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1170366920.3388.62.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-02-01 at 15:02 -0500, Mark Lord wrote:
>..
>> One thing that could be even better than the patch below,
>> would be to have it perhaps skip the entire bio that includes
>> the failed sector, rather than only the bad sector itself.
> 
> Er ... define "skip over the bio".  A bio is simply a block
> representation for a bunch of sg elements coming in to the elevator.

Exactly.  Or rather, a block of sg_elements from a single point
of request, is it not?

> Mostly what we see in SCSI is a single bio per request, so skipping the
> bio is really the current behaviour (to fail the rest of the request).

Very good.  That's what it's supposed to do.

But if each request contained only a single bio, then all of Jens'
work on IO scheduling would be for nothing, n'est-ce pas?

In the case where a request consists of multiple bio's
which have been merged under a single request struct,
we really should give at least one attempt to each bio.

This way, in most cases, only the process that requested the
failed sector(s) will see an error, not the innocent victims
that happened to get merged onto the end.  Which could be very
critical stuff (or not -- it could be quite random).

So the time factor works out to one disk I/O timeout per failed bio.
That's what would have happened with the NOP scheduler anyway.

On the sytems I'm working with, I don't see huge numbers of bad sectors.
What they tend to show is just one or two bad sectors, widely scattered.

So:
>> I think doing that might address most concerns expressed here.
>> Have you got an alternate suggestion, James?

Cheers
