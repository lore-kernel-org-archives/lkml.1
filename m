Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZHJGge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZHJGge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZHJGgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:36:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40603 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZHJGgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:36:32 -0400
X-AuditID: b753bd60-ac247ba000006009-df-4a7fbfee76b4
Message-ID: <4A7FBFD1.2010208@hitachi.com>
Date: Mon, 10 Aug 2009 15:36:01 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: tytso@mit.edu, hch@infradead.org, mfasheh@suse.com, aia21@cantab.net,
       hugh.dickins@tiscali.co.uk, swhiteho@redhat.com,
       akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [16/19] HWPOISON: Enable .remove_error_page for migration
    aware file systems
References: <200908051136.682859934@firstfloor.org> 
    <20090805093643.E0C00B15D8@basil.firstfloor.org>
In-Reply-To: <20090805093643.E0C00B15D8@basil.firstfloor.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andi Kleen wrote:

> Index: linux/fs/ext3/inode.c
> ===================================================================
> --- linux.orig/fs/ext3/inode.c
> +++ linux/fs/ext3/inode.c
> @@ -1819,6 +1819,7 @@ static const struct address_space_operat
>  	.direct_IO		= ext3_direct_IO,
>  	.migratepage		= buffer_migrate_page,
>  	.is_partially_uptodate  = block_is_partially_uptodate,
> +	.error_remove_page	= generic_error_remove_page,
>  };

(I'm sorry if I'm missing the point.)

If my understanding is correct, the following scenario can happen:

1. An uncorrected error on a dirty page cache page is detected by
   memory scrubbing
2. Kernel unmaps and truncates the page to recover from the error
3. An application reads data from the file location corresponding
   to the truncated page
   ==> Old or garbage data will be read into a new page cache page
4. The application modifies the data and write back it to the disk
5. The file will corrurpt!

(Yes, the application is wrong to not do the right thing, i.e. fsync,
 but it's not user's fault!)

A similar data corruption can be caused by a write I/O error,
because dirty flag is cleared even if the page couldn't be written
to the disk.

However, we have a way to avoid this kind of data corruption at
least for ext3.  If we mount an ext3 filesystem with data=ordered
and data_err=abort, all I/O errors on file data block belonging to
the committing transaction are checked.  When I/O error is found,
abort journaling and remount the filesystem with read-only to
prevent further updates.  This kind of feature is very important
for mission critical systems.

If we merge this patch, we would face the data corruption problem
again.

I think there are three options,

(1) drop this patch
(2) merge this patch with new panic_on_dirty_page_cache_corruption
    sysctl
(3) implement a more sophisticated error_remove_page function
  
>  static const struct address_space_operations ext3_writeback_aops = {
> @@ -1834,6 +1835,7 @@ static const struct address_space_operat
>  	.direct_IO		= ext3_direct_IO,
>  	.migratepage		= buffer_migrate_page,
>  	.is_partially_uptodate  = block_is_partially_uptodate,
> +	.error_remove_page	= generic_error_remove_page,
>  };

The writeback case would be OK. It's not much different from the I/O
error case.

>  static const struct address_space_operations ext3_journalled_aops = {
> @@ -1848,6 +1850,7 @@ static const struct address_space_operat
>  	.invalidatepage		= ext3_invalidatepage,
>  	.releasepage		= ext3_releasepage,
>  	.is_partially_uptodate  = block_is_partially_uptodate,
> +	.error_remove_page	= generic_error_remove_page,
>  };
>  
>  void ext3_set_aops(struct inode *inode)

I'm not sure about the journalled case.  I'm going to take a look at
it later.

Best regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

