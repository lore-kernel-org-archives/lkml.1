Return-Path: <linux-kernel-owner+w=401wt.eu-S1161158AbXDKDbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158AbXDKDbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161161AbXDKDbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:31:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:36460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161149AbXDKDbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:31:19 -0400
From: Neil Brown <neilb@suse.de>
To: Reuben Farrelly <reuben-linuxkernel@reub.net>
Date: Wed, 11 Apr 2007 13:31:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17948.22139.163549.68639@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: RAID1 "out of memory" error, was Re: 2.6.21-rc5-mm4
In-Reply-To: message from Reuben Farrelly on Friday April 6
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<461524BF.7050304@reub.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday April 6, reuben-linuxkernel@reub.net wrote:
> 
> Looks like some damage, or maybe intolerance to on-disk damage, to RAID-1.

Difference is that kzalloc(0, ) now returns NULL.  Maybe it is a
SLUB/SLAB difference? (So maybe it did use memory it shouldn't have
before, but now it fails, which is the better behaviour).

This patch fixes the maths and should probably go in various 'stable'
kernels.  Bug is in 2.6.18, but not 2.6.16.

Patch won't work for 2.6.18 as DIV_ROUND_UP is missing, but 2.6.19 and
later have it.

Thanks for the bug report.

NeilBrown


-----------------------------
Fix calculation for size of filemap_attr array in md/bitmap.

If 'num_pages' were ever 1 more than a multiple of 8 (32bit platforms)
for of 16 (64 bit platforms). filemap_attr would be allocated one
'unsigned long' shorter than required.  We need a round-up in there.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-04-11 13:24:50.000000000 +1000
+++ ./drivers/md/bitmap.c	2007-04-11 13:24:59.000000000 +1000
@@ -863,9 +863,7 @@ static int bitmap_init_from_disk(struct 
 
 	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
 	bitmap->filemap_attr = kzalloc(
-		(((num_pages*4/8)+sizeof(unsigned long)-1)
-		 /sizeof(unsigned long))
-		*sizeof(unsigned long),
+		roundup( DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
 		GFP_KERNEL);
 	if (!bitmap->filemap_attr)
 		goto out;
