Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYAVWMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYAVWMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYAVWMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:12:20 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60412 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbYAVWMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:12:17 -0500
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801222009070.16267@blonde.site>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
	 <1201022985.3210.24.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801221813540.8693@blonde.site>
	 <1201031028.3210.61.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801222009070.16267@blonde.site>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 16:12:10 -0600
Message-Id: <1201039931.3210.96.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-22 at 20:20 +0000, Hugh Dickins wrote:
> On Tue, 22 Jan 2008, James Bottomley wrote:
> > 
> > Actually, I don't think it's a smaller I/O issue.  The SMART protocol
> > specifically mandates that the transfers for SMART READ DATA and SMART
> > READ LOG shall be 512 bytes).  However, the pio transfer routine does
> > seem to be assuming sector alignment as well, which will be where your
> > problems are coming from.  I think we need to specify sector minimum
> > alignment for ata (but not atapi, which has its own non sector size pio
> > routine).  How about the attached?
> > 
> > We have to do this for all ATA devices, because they'll likely all
> > support SMART, and SMART is defined to be a PIO command.
> 
> Thanks, you've answered several of my uncertainties (why the PIO,
> why the sector size).
> 
> I've just tried it, and can confirm that your replacement patch
> below fixes the issue for me in practice.

Thanks!

> What I can't say, you and Jeff and others will judge, is whether that's
> actually the right placement for the blk_queue_update_dma_alignment call
> (as an outsider, I'm not convinced that the SMART requirement should be
> imposing this limitation on the rest).

It's certainly the correct placement.  The slight problem is that the
actual alignment checking is only really done for commands coming down
from the user, not for commands incoming from the kernel.  That leaves
us a potential nasty in IDENTIFY_DEVICE; that's also a PIO only 512 byte
transfer command.

libsas looks to be OK because it specifically kmallocs a 512 byte buffer
which should (for off slab data) be 512 byte aligned.  libata actually
has an issue because the usual location for IDENTIFY_DEVICE data is
inside a struct ata_device, which is highly unlikely to be correctly
aligned.  Fortunately, I think we can only get the bug if we actually
cross a page boundary for non contiguous pages in the identify data,
which a kernel allocation will never do, so libata should be safe as
well.

James


