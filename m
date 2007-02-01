Return-Path: <linux-kernel-owner+w=401wt.eu-S1161181AbXBAPzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161181AbXBAPzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXBAPzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:55:06 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:61496 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXBAPzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:55:04 -0500
Message-ID: <45C20D41.6040608@namesys.com>
Date: Thu, 01 Feb 2007 18:54:41 +0300
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>, Andrew Morton <akpm@osdl.org>
CC: "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-list@namesys.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reiserfs-dev <reiserfs-dev@namesys.com>
Subject: Re: linux-2.6.20-rc4-mm1 Reiser4 filesystem freeze and corruption
References: <1169229490.6266.11.camel@oberon>	 <200701200334.07690.vs@namesys.com> <1170267238.22971.1.camel@oberon>
In-Reply-To: <1170267238.22971.1.camel@oberon>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------070200040704060302040100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070200040704060302040100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Zan Lynx wrote:

>On Sat, 2007-01-20 at 03:34 +0300, Vladimir V. Saveliev wrote:
>  
>
>>Hello
>>
>>On Friday 19 January 2007 20:58, Zan Lynx wrote:
>>    
>>
>>>I have been running 2.6.20-rc2-mm1 without problems, but both rc3-mm1
>>>and rc4-mm1 have been giving me these freezes.  They were happening
>>>inside X and without external console it was impossible to get anything,
>>>plus I was reluctant to test it since the freeze sometimes requires a
>>>full fsck.reiser4 --build-fs to recover the filesystem.
>>>
>>>But I finally got some output in a console session.  I wasn't able to
>>>get it all, I made some notes of what I think the problem is.  I may try
>>>again later once I get netconsole working (netconsole fails as a
>>>built-in, I'll try it as a module next).
>>>      
>>>
>[snip]
>  
>
>>yes, please provide more information. Full kernel output at time of freeze is very desirable.
>>    
>>
>
>Here comes a full sized bug report, as best as I can do it.  This is
>kernel 2.6.20-rc6-mm3 instead of rc4-mm1.  Still has the problem.
>  
>

Thanks for the dump.

>[ 3138.456588]  [<ffffffff8033f5de>] current_atom_finish_all_fq+0x12e/0x280
>[ 3138.456661]  [<ffffffff80296510>] autoremove_wake_function+0x0/0x30
>[ 3138.456674]  [<ffffffff803350ac>] submit_wb_list+0x11c/0x130
>[ 3138.456690]  [<ffffffff80335409>] reiser4_txn_end+0x349/0x530
>[ 3138.456710]  [<ffffffff803355f9>] reiser4_txn_restart+0x9/0x20
>[ 3138.456781]  [<ffffffff80335680>] force_commit_atom+0x50/0x60
>[ 3138.456793]  [<ffffffff8034cfb1>] writepages_unix_file+0x671/0x780
>[ 3138.456824]  [<ffffffff802590b3>] do_writepages+0x43/0x80
>[ 3138.456838]  [<ffffffff8024dbf8>] __filemap_fdatawrite_range+0x58/0x70
>[ 3138.456914]  [<ffffffff8024e19d>] do_fsync+0x3d/0xe0
>[ 3138.456930]  [<ffffffff802c2473>] sys_msync+0x143/0x1f0
>[ 3138.456945]  [<ffffffff8025c11e>] system_call+0x7e/0x83
>  
>

This is waiting for IO completion, and no success because of new plugging
policy introduced by block layer folks. The attached patch should help.
Andrew, please apply.

Thanks,
Edward.


--------------070200040704060302040100
Content-Type: text/x-patch;
 name="reiser4-vs-git-block3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-vs-git-block3.patch"

Signed-off-by: Edward Shishkin <edward@namesys.com>
---
 linux-2.6.20-rc6-mm3/fs/reiser4/status_flags.c |    2 ++
 linux-2.6.20-rc6-mm3/fs/reiser4/wander.c       |   18 +++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

--- linux-2.6.20-rc6-mm3/fs/reiser4/status_flags.c.orig
+++ linux-2.6.20-rc6-mm3/fs/reiser4/status_flags.c
@@ -63,6 +63,7 @@
 	}
 	lock_page(page);
 	submit_bio(READ, bio);
+	blk_replug_current_nested();
 	wait_on_page_locked(page);
 	if (!PageUptodate(page)) {
 		warning("green-2007",
@@ -157,6 +158,7 @@
 	lock_page(get_super_private(sb)->status_page);	// Safe as nobody should touch our page.
 	/* We can block now, but we have no other choice anyway */
 	submit_bio(WRITE, bio);
+	blk_replug_current_nested();
 	return 0;		// We do not wait for io to finish.
 }
 
--- linux-2.6.20-rc6-mm3/fs/reiser4/wander.c.orig
+++ linux-2.6.20-rc6-mm3/fs/reiser4/wander.c
@@ -718,6 +718,7 @@
 	jnode *first, int nr, const reiser4_block_nr *block_p,
 	flush_queue_t *fq, int flags)
 {
+	int ret = 0;
 	struct super_block *super = reiser4_get_current_sb();
 	int write_op = ( flags & WRITEOUT_BARRIER ) ? WRITE_BARRIER : WRITE;
 	int max_blocks;
@@ -738,9 +739,10 @@
 		int nr_used;
 
 		bio = bio_alloc(GFP_NOIO, nr_blocks);
-		if (!bio)
-			return RETERR(-ENOMEM);
-
+		if (!bio) {
+			ret = RETERR(-ENOMEM);
+			break;
+		}
 		bio->bi_bdev = super->s_bdev;
 		bio->bi_sector = block * (super->s_blocksize >> 9);
 		for (nr_used = 0, i = 0; i < nr_blocks; i++) {
@@ -843,8 +845,10 @@
 				reiser4_submit_bio(write_op, bio);
 				not_supported = bio_flagged(bio, BIO_EOPNOTSUPP);
 				bio_put(bio);
-				if (not_supported)
-					return -EOPNOTSUPP;
+				if (not_supported) {
+					ret = -EOPNOTSUPP;
+					break;
+				}
 			}
 
 			block += nr_used - 1;
@@ -855,8 +859,8 @@
 		}
 		nr -= nr_used;
 	}
-
-	return 0;
+	blk_replug_current_nested();
+	return ret;
 }
 
 /* This is a procedure which recovers a contiguous sequences of disk block

--------------070200040704060302040100--
