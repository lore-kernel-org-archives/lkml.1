Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbXKFCH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbXKFCH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 21:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbXKFCHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 21:07:21 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:35863 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbXKFCHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 21:07:19 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat: optimize fat_count_free_clusters()
References: <87hck1pssj.fsf@duaron.myhome.or.jp>
	<20071105164954.ac568ba3.akpm@linux-foundation.org>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 06 Nov 2007 11:07:12 +0900
In-Reply-To: <20071105164954.ac568ba3.akpm@linux-foundation.org> (Andrew Morton's message of "Mon\, 5 Nov 2007 16\:49\:54 -0800")
Message-ID: <87pryom8j3.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> +/* 128kb is the whole sectors for FAT12 and FAT16 */
>> +#define FAT_READA_SIZE		(128 * 1024)
>> +
>> +static void fat_ent_reada(struct super_block *sb, struct fat_entry *fatent,
>> +			  unsigned long reada_blocks)
>> +{
>> +	struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
>> +	sector_t blocknr;
>> +	int i, offset;
>> +
>> +	ops->ent_blocknr(sb, fatent->entry, &offset, &blocknr);
>> +
>> +	for (i = 0; i < reada_blocks; i++)
>> +		sb_breadahead(sb, blocknr + i);
>> +}
>
> You might find that it's simpler and faster to call
> page_cache_sync_readahead() against sb->s_bdev->bd_inode->i_mapping.
>
> Or maybe not - that requires a struct file_ra_state.  We _used_ to have a
> nice simple read-some-stuff-into-pagecache function which didn't need an
> ra_state but that seems to have disappeared in the various recent readahead
> churn.  Oh well.

Yes. I found it, but I gave up for now by file_ra_state. Also I'd like
to use a large block to read FAT.  I'll rethink this code after large
block was merged.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
