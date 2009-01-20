Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZATG6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZATG6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 01:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZATG5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 01:57:55 -0500
Received: from ns2.suse.de ([195.135.220.15]:41557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZATG5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 01:57:54 -0500
Message-ID: <49757750.6010008@suse.de>
Date: Tue, 20 Jan 2009 15:03:44 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Bob Copeland <me@bobcopeland.com>, Anders Larsen <al@alarsen.net>,
       reiserfs-devel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/20] return f_fsid for statfs(2)
References: <4974B8C4.3070703@suse.de> <1232393334.5893.42.camel@norville.austin.ibm.com> <20090119233651.GK3286@webber.adilger.int> <1232419149.19468.3.camel@norville.austin.ibm.com> <20090120041349.GL3286@webber.adilger.int> <49755376.3000100@suse.de> <20090120044447.GM3286@webber.adilger.int>
In-Reply-To: <20090120044447.GM3286@webber.adilger.int>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andreas Dilger Wrote:
> On Jan 20, 2009  12:30 +0800, Coly Li wrote:
>> Ext[234] is sophisticated to have on-disk uuid record. Most file systems
>> in the patches (except jfs and reiser3) do not have a persistent uuid,
>> a reasonable/feasible solution without media format modification is fsid
>> in boot/mount life cycle. That's why huge_encode_dev(sb->s_bdev->bd_dev)
>> is used here.  For jfs and reiserfs3, is there any use case for
>> persistent fsid cross boots ?
> 
> I would say yes, this is worthwhile to do, or the fsid can change between
> boots unnecessarily.
> 
If no partitioning happens between boots/mounts, fsid from huge_encode_dev() should be identical.
For non-uuid file systems, IMHO huge_encode_dev() method is acceptable.
But YES, for jfs and reiserfs3 there is chance to provide persistent fsid cross boots, here are
examples,
- in fs/jfs/super.c:jfs_statfs(), generate f_fsid by:
	buf->f_fsid.val[0] = crc32_le(0, sbi->uuid, sizeof(sbi->uuid)/2);
	buf->f_fsid.val[1] = crc32_le(0, sbi->uuid + sizeof(sbi->uuid)/2,
					sizeof(sbi->uuid)/2);
- in fs/reiserfs/super.c:reiserfs_statfs(), generate f_fsid by:
	buf->f_fsid.val[0] = (u32)crc32_le(0, rs->s_uuid, sizeof(rs->s_uuid)/2);
	buf->f_fsid.val[1] = (u32)crc32_le(0, rs->s_uuid + sizeof(rs->s_uuid)/2,
				sizeof(rs->s_uuid)/2);

I will update corresponded patches for the implementation. Thanks for your comments.

-- 
Coly Li
SuSE Labs
