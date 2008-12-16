Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYLPUtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYLPUtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYLPUtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:49:47 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:16252 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYLPUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:49:46 -0500
Date: Tue, 16 Dec 2008 14:49:45 -0600
From: scameron@beardog.cca.cpqcorp.net
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mikem@roadking.cca.cpqcorp.net
Subject: Re: [patch] cciss: Fix problem that deleting multiple logical drives could cause a panic
Message-ID: <20081216204945.GN1126@beardog.cca.cpqcorp.net>
References: <20081216201703.GL1126@beardog.cca.cpqcorp.net> <20081216202730.GZ32491@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216202730.GZ32491@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 09:27:30PM +0100, Jens Axboe wrote:
> On Tue, Dec 16 2008, scameron@beardog.cca.cpqcorp.net wrote:
> > 
> > Fix problem that deleting multiple logical drives could cause a panic.
> 
> This looks like a 2.6.28 candidate, correct?

Yes, and we would like to get it in anywhere else it needs to go
(backport to 2.6.27.x? if that makes sense.)

It fixes a panic which can be easily reproduced in the following
way: Just create several "arrays," each with multiple logical 
drives via hpacucli, then delete the first array, and it will blow
up in deregister_disk(), in the call to get_host() when it tries to
dig the hba pointer out of a NULL queue pointer.

The problem has been present since my code to make 
rebuild_lun_table behave better went in.

-- steve

> 
> > 
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
> > ---
> > 
> >  drivers/block/cciss.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff -puN drivers/block/cciss.c~fix_rebuild_lun_table_bug drivers/block/cciss.c
> > --- linux-2.6.28-rc8/drivers/block/cciss.c~fix_rebuild_lun_table_bug	2008-12-16 14:00:52.000000000 -0600
> > +++ linux-2.6.28-rc8-root/drivers/block/cciss.c	2008-12-16 14:00:52.000000000 -0600
> > @@ -1693,6 +1693,11 @@ static int rebuild_lun_table(ctlr_info_t
> >  	for (i = 0; i <= h->highest_lun; i++) {
> >  		int j;
> >  		drv_found = 0;
> > +
> > +		/* skip holes in the array from already deleted drives */
> > +		if (h->drv[i].raid_level == -1)
> > +			continue;
> > +
> >  		for (j = 0; j < num_luns; j++) {
> >  			memcpy(&lunid, &ld_buff->LUN[j][0], 4);
> >  			lunid = le32_to_cpu(lunid);
> > _
> 
> -- 
> Jens Axboe
> 
