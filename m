Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbYAVXBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbYAVXBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbYAVXAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:00:34 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50833 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734AbYAVXA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:00:28 -0500
Date: Tue, 22 Jan 2008 22:59:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
In-Reply-To: <1201039931.3210.96.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0801222241460.30816@blonde.site>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site> 
 <1201022985.3210.24.camel@localhost.localdomain>  <Pine.LNX.4.64.0801221813540.8693@blonde.site>
  <1201031028.3210.61.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801222009070.16267@blonde.site> <1201039931.3210.96.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, James Bottomley wrote:
> 
> libsas looks to be OK because it specifically kmallocs a 512 byte buffer
> which should (for off slab data) be 512 byte aligned.

I don't remember the various SLAB and SLOB and SLUB rules offhand:
I'm not sure it's safe to rely on such alignment on all of them ....

> libata actually
> has an issue because the usual location for IDENTIFY_DEVICE data is
> inside a struct ata_device, which is highly unlikely to be correctly
> aligned.  Fortunately, I think we can only get the bug if we actually
> cross a page boundary for non contiguous pages in the identify data,
> which a kernel allocation will never do, so libata should be safe as
> well.

.... but this would trump it: yes, we don't need 512-byte alignment
for this, and it is okay to cross a page boundary, just so long as
the start of the next page really belongs to our buffer not somebody
else's.

There doesn't seem much likelihood of anyone vmalloc'ing the buffer
in which that IDENTIFY_DEVICE gets done.  Though this discussion
does make me wonder whether ata_pio_sector ought to have a BUG_ON
(and yes, a BUG_ON rather than a WARN_ON) against the possibility.

Hugh
