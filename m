Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZBXPa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZBXPa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZBXPaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:30:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43883 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZBXPaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:30:16 -0500
Date: Tue, 24 Feb 2009 16:29:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, vapier.adi@gmail.com
Subject: Re: [PATCH] physmap: Fix leak of memory returned by
	parse_mtd_partitions
Message-ID: <20090224152958.GN21900@pengutronix.de>
References: <20081112.235733.01917391.anemo@mba.ocn.ne.jp> <20090224133505.GJ21900@pengutronix.de> <20090224.233600.27954115.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224.233600.27954115.anemo@mba.ocn.ne.jp>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 15:49:28 up 6 days,  6:42, 40 users,  load average: 0.56, 1.57,
	1.85
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 11:36:00PM +0900, Atsushi Nemoto wrote:
> On Tue, 24 Feb 2009 14:35:05 +0100, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Wed, Nov 12, 2008 at 11:57:33PM +0900, Atsushi Nemoto wrote:
> > > The mtd partition parser returns an allocated pointer array of
> > > mtd_partition.  The caller must free it.  The array is used only for
> > > add_mtd_partitions(), so free it just after the call.
> > 
> > This patch breaks command line parsing support. With command line
> > partition parsing the struct mtd_partition array is allocated, but only
> > once. On my board with NAND and NOR (both with command line partition
> > parsing) It fails badly in parse_cmdline_partitions() when the second
> > device gets parsed.
> > 
> > The following patch fixes it, but I don't know if this is
> > the correct solution. Does anybody have more insights on this?
> 
> Do your NAND and NOR have same mtd-id?  The cmdlinepart allocates
> mtd_partition aray for each mtd-id.  So usually another array will be
> returned for NAND and NOR.

Yes, it allocates one array for NAND and one for NOR. The problem starts
in mtdpart_setup_real():

>		struct cmdline_mtd_partition *this_mtd;
> 		struct mtd_partition *parts;
> 
> 		[...]
> 
> 		/*
> 		 * parse one mtd. have it reserve memory for the
> 		 * struct cmdline_mtd_partition and the mtd-id string.
> 		 */
> 		parts = newpart(p + 1,		/* cmdline */
> 				&s,		/* out: updated cmdline ptr */
> 				&num_parts,	/* out: number of parts */
> 				0,		/* first partition */
> 				(unsigned char**)&this_mtd, /* out: extra mem */
> 				mtd_id_len + 1 + sizeof(*this_mtd) +
> 				sizeof(void*)-1 /*alignment*/);
>

Here we allocate the array containing not only the struct mtd_partition,
but also the names and the struct cmdline_mtd_partition...

> 	for(part = partitions; part; part = part->next)
> 	{
> 		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id)))
> 		{
> 			for(i = 0, offset = 0; i < part->num_parts; i++)
> 			{
> 				if (part->parts[i].offset == OFFSET_CONTINUOUS)
> 				  part->parts[i].offset = offset;
> 				else
> 				  offset = part->parts[i].offset;
> 				if (part->parts[i].size == SIZE_REMAINING)
> 				  part->parts[i].size = master->size - offset;
> 				if (offset + part->parts[i].size > master->size)
> 				{
> 					printk(KERN_WARNING ERRP
> 					       "%s: partitioning exceeds flash size, truncating\n",
> 					       part->mtd_id);
> 					part->parts[i].size = master->size - offset;
> 					part->num_parts = i;
> 				}
> 				offset += part->parts[i].size;
> 			}
> 			*pparts = part->parts;

...here this array is returned and kfreed in the physmap flash driver. The
next time we enter this loop 'part' points to already freed memory.

*pparts is not meant to be freed, cmdlinepart.c needs it for the whole
kernel life. We can only return a copy of the partition array.

 
> 
> The physmap patch has another bug and fixes are on the way mainline:
> 
> http://git.infradead.org/mtd-2.6.git?a=commit;h=e480814f138cd5d78a8efe397756ba6b6518fdb6
> 
> But this seems not enough, as you wrote.  If multiple mtd have same
> mtd-id, bad things can happen.  And more seriously, if I load physmap
> driver _again_ after unload, cmdlinepart will return a freed pointer
> on the second time.
> 
> Hmm, little memory leak is less serious than crash.  Now I start
> thinking reverting the commit 176bf2e0 will be best for 2.6.29
> release.

Even when reverting the commit the same problem still exists because the
array then gets freed in physmap_flash_remove(). This won't hurt me
though because I never use mtd drivers as modules.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
