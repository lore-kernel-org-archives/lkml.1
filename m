Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbXKCH1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbXKCH1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 03:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbXKCH1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 03:27:09 -0400
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:47194 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbXKCH1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 03:27:08 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Mike Galbraith <efault@gmx.de>
In-Reply-To: <1194065777.11539.5.camel@Homer.simpson.net>
Subject: Re: [Linux-NTFS-Dev] 2.6.23 regression: second access of empty ntfs file leads to D	state hang
References: <1193638086.7409.21.camel@Homer.simpson.net> <E3E758D0-25AC-45B8-9BAB-F8CDF75AF3CA@cam.ac.uk> <1193658311.7324.2.camel@Homer.simpson.net> <4E61D235-B8E8-43DF-96A5-B3169E6AB223@cam.ac.uk> <1193668997.7284.2.camel@Homer.simpson.net> <1193671099.7172.0.camel@Homer.simpson.net> <1193731202.7229.9.camel@Homer.simpson.net> <3BFCE55A-F7E2-4A19-8FD9-F23AF2A29D76@cam.ac.uk> <1EEFFD17-64E7-41C6-BFED-529A5794EC36@cam.ac.uk> <1194065777.11539.5.camel@Homer.simpson.net>
Message-Id: <FC4CF4B4-06A3-4D14-916A-0622D4D2A719@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v912)
Date: Sat, 3 Nov 2007 07:27:03 +0000
Cc: LKML <linux-kernel@vger.kernel.org>,
       ntfs-dev <linux-ntfs-dev@lists.sourceforge.net>,
       Neil Brown <neilb@suse.de>
X-Mailer: Apple Mail (2.912)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Great, thanks!  I will submit it to Linus.

Best regards,

	Anton

On 3 Nov 2007, at 04:56, Mike Galbraith wrote:

> On Fri, 2007-11-02 at 19:22 +0000, Anton Altaparmakov wrote:
>
>> Would you be able to test it in your setup?  Thanks a lot in advance!
>
> Modulo uninitialized vi, works fine.  I moved it up, and all is well.
> Thanks.
>
> Tested-by:  Mike Galbraith <efault@gmx.de>
>
> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index cfdc790..ad87cb0 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -405,6 +405,15 @@ static int ntfs_readpage(struct file *file,  
> struct page *page)
>
> retry_readpage:
> 	BUG_ON(!PageLocked(page));
> +	vi = page->mapping->host;
> +	i_size = i_size_read(vi);
> +	/* Is the page fully outside i_size? (truncate in progress) */
> +	if (unlikely(page->index >= (i_size + PAGE_CACHE_SIZE - 1) >>
> +			PAGE_CACHE_SHIFT)) {
> +		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
> +		ntfs_debug("Read outside i_size - truncated?");
> +		goto done;
> +	}
> 	/*
> 	 * This can potentially happen because we clear PageUptodate() during
> 	 * ntfs_writepage() of MstProtected() attributes.
> @@ -413,7 +422,6 @@ retry_readpage:
> 		unlock_page(page);
> 		return 0;
> 	}
> -	vi = page->mapping->host;
> 	ni = NTFS_I(vi);
> 	/*
> 	 * Only $DATA attributes can be encrypted and only unnamed $DATA
> diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
> index 92dabdc..50d3b0c 100644
> --- a/fs/ntfs/attrib.c
> +++ b/fs/ntfs/attrib.c
> @@ -179,10 +179,7 @@ int ntfs_map_runlist_nolock(ntfs_inode *ni, VCN  
> vcn, ntfs_attr_search_ctx *ctx)
> 	 * ntfs_mapping_pairs_decompress() fails.
> 	 */
> 	end_vcn = sle64_to_cpu(a->data.non_resident.highest_vcn) + 1;
> -	if (!a->data.non_resident.lowest_vcn && end_vcn == 1)
> -		end_vcn = sle64_to_cpu(a->data.non_resident.allocated_size) >>
> -				ni->vol->cluster_size_bits;
> -	if (unlikely(vcn >= end_vcn)) {
> +	if (unlikely(vcn && vcn >= end_vcn)) {
> 		err = -ENOENT;
> 		goto err_out;
> 	}
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index d98daf5..d1619d0 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -561,6 +561,16 @@ int ntfs_read_compressed_block(struct page *page)
> 	read_unlock_irqrestore(&ni->size_lock, flags);
> 	max_page = ((i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT) -
> 			offset;
> +	/* Is the page fully outside i_size? (truncate in progress) */
> +	if (xpage >= max_page) {
> +		kfree(bhs);
> +		kfree(pages);
> +		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
> +		ntfs_debug("Compressed read outside i_size - truncated?");
> +		SetPageUptodate(page);
> +		unlock_page(page);
> +		return 0;
> +	}
> 	if (nr_pages < max_page)
> 		max_page = nr_pages;
> 	for (i = 0; i < max_page; i++, offset++) {

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

