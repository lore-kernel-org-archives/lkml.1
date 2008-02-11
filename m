Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYBKSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYBKSK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYBKSKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:10:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbYBKSKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:10:19 -0500
Message-ID: <47B08F6B.2020502@redhat.com>
Date: Mon, 11 Feb 2008 13:09:47 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] firewire: fw-sbp2: fix I/O errors during reconnect
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.8110272bacc3f714@s5r6.in-berlin.de>
In-Reply-To: <tkrat.8110272bacc3f714@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> While fw-sbp2 takes the necessary time to reconnect to a logical unit
> after bus reset, the SCSI core keeps sending new commands.  They are all
> immediately completed with host busy status, and application clients or
> filesystems will break quickly.  The SCSI device might even be taken
> offline:  http://bugzilla.kernel.org/show_bug.cgi?id=9734
> 
> The only remedy seems to be to block the SCSI device until reconnect.
> Alas the SCSI core has no useful API to block only one logical unit i.e.
> the scsi_device, therefore we block the entire Scsi_Host.  This
> currently corresponds to an SBP-2 target.  In case of targets with
> multiple logical units, we need to satisfy the dependencies between
> logical units by carefully tracking the blocking state of the target and
> its units.  We block all logical units of a target as soon as one of
> them needs to be blocked, and keep them blocked until all of them are
> ready to be unblocked.
> 
> Furthermore, as the history of the old sbp2 driver has shown, the
> scsi_block_requests() API is a minefield with high potential of
> deadlocks.  We therefore take extra measures to keep logical units
> unblocked during __scsi_add_device() and during shutdown.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

> +/*
> + * Blocks lu->tgt if all of the following conditions are met:
> + *   - Login, INQUIRY, and high-level SCSI setup of all logical units of the
> + *     target have been successfully finished (indicated by dont_block == 0).
> + *   - The lu->generation is stale.  sbp2_reconnect will unblock lu later.
> + */
> +static void sbp2_conditionally_block(struct sbp2_logical_unit *lu)
> +{
> +	struct fw_card *card = fw_device(lu->tgt->unit->device.parent)->card;
> +
> +	if (!atomic_read(&lu->tgt->dont_block) &&
> +	    lu->generation != card->generation &&
> +	    atomic_cmpxchg(&lu->blocked, 0, 1) == 0) {

Just to be absolutely sure, we don't need any barriers here to ensure we 
get the right generations, do we?

Also, this isn't expected to let I/O survive a disk being unplugged 
briefly, then plugged back in, is it? (I recall that being discussed, 
but I think it was as a 'would be nice to do in the future' thing).

-- 
Jarod Wilson
jwilson@redhat.com

