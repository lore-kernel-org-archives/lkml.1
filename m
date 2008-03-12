Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYCLPJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYCLPJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYCLPJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:09:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49305 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751783AbYCLPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:08:59 -0400
Date: Wed, 12 Mar 2008 11:08:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Sven Schnelle <svens@stackframe.org>, <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL
 pointer dereference
In-Reply-To: <47D7D580.5060406@panasas.com>
Message-ID: <Pine.LNX.4.44L0.0803121103390.4595-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Boaz Harrosh wrote:

> OK Now I see isd200_ata_command() is called from a usb.c internal thread.
> 
> What I need to do is call scsi_get_command(scsi_device*) on first invocation.

Why?

> Now for the call to scsi_put_command()? At the time of the call to 
> isd200_free_info_ptrs() do you think I still have a valid scsi_device at this point?

Definitely not.

> What I will do is this. I will resend my original patch with your comments
> fixed. This is for the 2.6.25-rc. And I will send another patch that uses
> the proper scsi_get/put_command() for testing and inclusion into the 2.6.26 kernel.
> Please ACK on the patch

Okay.

> > Yes.  The three lines of code there are unnecessary.  You should remove
> > them (and the comment) instead of adding more somewhere else.  Or if
> > you want to keep them, just add a line to kfree(us->extra) before 
> > us->extra is set to NULL.
> 
> How are they unnecessary? who will free them? other wise they will only be
> freed at the very end.

That's what I meant.

> And that is only because usb_stor_transparent_scsi_command()
> does not need any us->extra of it's own. But if ever it will, then this code
> buried here will become a leak.

Any additional resources needed by the transparent-SCSI handler will be 
added directly into the main us_data structure; they won't be part of 
us->extra.  That hook was meant specifically for use by the nonstandard 
subdrivers.

But on the whole you are right, and I agree with the change in your 
follow-up patch.

Alan Stern

