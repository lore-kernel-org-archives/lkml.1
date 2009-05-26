Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZEZCKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZEZCKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZEZCKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:10:06 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:1263 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZEZCKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:10:05 -0400
Date: Mon, 25 May 2009 23:07:04 -0300
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH] bio-integrity: Copy bip_buf and bip_size in
	bio_integrity_clone()
Message-ID: <20090526020704.GJ1376@blitiri.com.ar>
References: <20090524042035.GF1376@blitiri.com.ar> <yq1iqjpg4co.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1iqjpg4co.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.17 (2008-03-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 01:04:55AM -0400, Martin K. Petersen wrote:
> >>>>> "Alberto" == Alberto Bertogli <albertito@blitiri.com.ar> writes:
> 
> Alberto> While at it, I found that bio_integrity_clone() does not clone
> Alberto> neither bip_buf nor bip_size, which already copies the bvec,
> Alberto> which should have the same data because it's allocated in
> Alberto> bio_integrity_prep().
> 
> Alberto> Is there any reason I'm missing why they shouldn't be copied in
> Alberto> bio_integrity_clone(), as illustrated in the following patch?
> 
> Yes.  The bip_buf is strictly an internal housekeeping construct.  It
> contains a pointer to the kernel buffer that contains the protection
> information if the protection was added by the block layer itself (via
> bio_integrity_prep()).  However, that's not always the case.  The
> protection information may be passed down from a filesystem or
> (eventually) a userland application.  So the bip_buf is for use by the
> top-level of the block layer exclusively.  The bip_vec is what you want
> to use for accessing the actual protection information.
>
> Also, the cloned bio may be truncated or split.  In that case the
> bip_buf isn't going to match the data bvec.  So in any case blindly
> cloning bip_buf isn't going to work.
>
> Right now the integrity vector itself is cloned together with the bio
> because of the way the block layer works (advancing bvec offset for
> partial completion).  However, I'm brewing on a patch that gets rid of
> that so we can avoid cloning the vector and thus cut down on memory
> allocations as the I/O goes through each remapping layer.  With my patch
> in place the bip_vec becomes immutable and bip_buf will go away.

That makes sense, thanks for the explanation.

The case I was thinking about was something like a filesystem calling
bio_integrity_get_tag() on a cloned bio, since it depends on having a bip_buf
available. But if you're going to remove it altogether then it's a moot
question.


> I took a quick look at your DM patch last week and I didn't see any
> reason why it couldn't hook into the block integrity infrastructure.
> Take a look at drivers/scsi/sd_dif.c for clues on how to do that.

Thanks, I've already implemented it, and will post an updated patch soon, after
I clean it up a little.


> Let me know if you have questions...

Actually, I have two minor questions, if you don't mind:

 - What would be a decent name to use in struct blk_integrity for a module
   such as mine? Is LINUX-DMCSUM-V0-CCITT reasonable?
 - How can I test the tag functions? From a quick grep I found no in-tree
   users of bio_integrity_get/set_tag().

Thanks a lot,
		Alberto

