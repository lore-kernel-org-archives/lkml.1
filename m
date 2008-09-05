Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYIEPgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYIEPgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYIEPgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:36:42 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17662 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYIEPgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:36:41 -0400
Subject: Re: [PATCH 2/6] Adjust block device size after an online resize of
	a disk.
From: Andrew Patterson <andrew.patterson@hp.com>
To: Andre Noll <maan@systemlinux.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com,
       jmoyer@redhat.com
In-Reply-To: <20080905131244.GC3795@skl-net.de>
References: <20080904202714.10456.88061.stgit@bob.kio>
	 <20080904202725.10456.62289.stgit@bob.kio>
	 <20080905131244.GC3795@skl-net.de>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 09:36:37 -0600
Message-Id: <1220628997.7790.30.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-05 at 15:12 +0200, Andre Noll wrote:
> On 14:27, Andrew Patterson wrote:
> >  int revalidate_disk(struct gendisk *disk)
> >  {
> > +	struct block_device *bdev;
> >  	int ret = 0;
> >  
> >  	if (disk->fops->revalidate_disk)
> >  		ret = disk->fops->revalidate_disk(disk);
> 
> Maybe we should return early at this point if revalidate_disk()
> failed or fops->revalidate_disk is NULL.

We won't run check_disk_size_change() if we return early here. So the
question is would anyone ever make this call if they didn't have a
revalidate_disk routine? This in not the case in the current code. I
could go either way.

> 
> > +	bdev = bdget_disk(disk, 0);
> > +	if (!bdev)
> > +		return ret;
> 
> We might return success here even if bdev is NULL. OTOH, as the callers
> of revalidate_disk() do not check the return value anyway (although at
> least tapeblock_revalidate_disk() might return a negative value) it's
> probably also an option to change the return type of revalidate_disk()
> to void.
> 

The revalidate_disk() wrapper tries to maintain compatibility with the
current interface. It might make sense to change it given no one
actually really seems to use the return value. I guess I am very wary
about effectively changing the interface of the lower-level
revalidate_disk() routines, at least in this particular patchset.

> Andre

