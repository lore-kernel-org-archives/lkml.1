Return-Path: <linux-kernel-owner+w=401wt.eu-S935047AbXLQQOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047AbXLQQOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXLQQNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:13:55 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:28112 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933139AbXLQQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:13:54 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 11:13:53 EST
X-YMail-OSG: z3HYGJkVM1l6jKqUqLhKaar1u6ft.UGiMODAuatNRs5C2ILXUUSEgOYQw6HDsHgYmufGcy0RmQ--
Date: Mon, 17 Dec 2007 09:58:22 -0600
From: Michael Halcrow <mike@halcrow.us>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH] ecryptfs: fix fsx data corruption problems
Message-ID: <20071217155821.GJ13486@halcrow.us>
Reply-To: Michael Halcrow <mike@halcrow.us>
References: <476609F1.6040408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476609F1.6040408@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 11:32:33PM -0600, Eric Sandeen wrote:
> ecryptfs in 2.6.24-rc3 wasn't surviving fsx for me at all,
> dying after 4 ops.  Generally, encountering problems with stale
> data and improperly zeroed pages.  An extending truncate + write
> for example would expose stale data.
> 
> With the changes below I got to a million ops and beyond with all
> mmap ops disabled - mmap still needs work.  (A version of this
> patch on a RHEL5 kernel ran for over 110 million fsx ops)
> 
> I added a few comments as well, to the best of my understanding
> as I read through the code.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

I recommend this for the next -rc release.

> ---
> 
> 
> Index: linux-2.6.24-rc3/fs/ecryptfs/mmap.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/mmap.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/mmap.c
> @@ -263,14 +263,13 @@ out:
>  	return 0;
>  }
>  
> +/* This function must zero any hole we create */
>  static int ecryptfs_prepare_write(struct file *file, struct page *page,
>  				  unsigned from, unsigned to)
>  {
>  	int rc = 0;
> +	loff_t prev_page_end_size;
>  
> -	if (from == 0 && to == PAGE_CACHE_SIZE)
> -		goto out;	/* If we are writing a full page, it will be
> -				   up to date. */
>  	if (!PageUptodate(page)) {
>  		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
>  						      PAGE_CACHE_SIZE,
> @@ -283,22 +282,32 @@ static int ecryptfs_prepare_write(struct
>  		} else
>  			SetPageUptodate(page);
>  	}
> -	if (page->index != 0) {
> -		loff_t end_of_prev_pg_pos =
> -			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
>  
> -		if (end_of_prev_pg_pos > i_size_read(page->mapping->host)) {
> +	prev_page_end_size = ((loff_t)page->index << PAGE_CACHE_SHIFT);
> +
> +	/*
> +	 * If creating a page or more of holes, zero them out via truncate.
> +	 * Note, this will increase i_size.
> +	 */
> +	if (page->index != 0) {
> +		if (prev_page_end_size > i_size_read(page->mapping->host)) {
>  			rc = ecryptfs_truncate(file->f_path.dentry,
> -					       end_of_prev_pg_pos);
> +					       prev_page_end_size);
>  			if (rc) {
>  				printk(KERN_ERR "Error on attempt to "
>  				       "truncate to (higher) offset [%lld];"
> -				       " rc = [%d]\n", end_of_prev_pg_pos, rc);
> +				       " rc = [%d]\n", prev_page_end_size, rc);
>  				goto out;
>  			}
>  		}
> -		if (end_of_prev_pg_pos + 1 > i_size_read(page->mapping->host))
> -			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
> +	}
> +	/*
> +	 * Writing to a new page, and creating a small hole from start of page?
> +	 * Zero it out.
> +	 */
> +	if ((i_size_read(page->mapping->host) == prev_page_end_size) &&
> +	    (from != 0)) {
> +		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
>  	}
>  out:
>  	return rc;
> Index: linux-2.6.24-rc3/fs/ecryptfs/read_write.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/read_write.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/read_write.c
> @@ -124,6 +124,10 @@ int ecryptfs_write(struct file *ecryptfs
>  	loff_t pos;
>  	int rc = 0;
>  
> +	/*
> +	 * if we are writing beyond current size, then start pos
> +	 * at the current size - we'll fill in zeros from there.
> +	 */
>  	if (offset > ecryptfs_file_size)
>  		pos = ecryptfs_file_size;
>  	else
> @@ -137,6 +141,7 @@ int ecryptfs_write(struct file *ecryptfs
>  		if (num_bytes > total_remaining_bytes)
>  			num_bytes = total_remaining_bytes;
>  		if (pos < offset) {
> +			/* remaining zeros to write, up to destination offset */
>  			size_t total_remaining_zeros = (offset - pos);
>  
>  			if (num_bytes > total_remaining_zeros)
> @@ -167,17 +172,27 @@ int ecryptfs_write(struct file *ecryptfs
>  			}
>  		}
>  		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
> +
> +		/*
> +		 * pos: where we're now writing, offset: where the request was
> +		 * If current pos is before request, we are filling zeros
> +		 * If we are at or beyond request, we are writing the *data*
> +		 * If we're in a fresh page beyond eof, zero it in either case
> +		 */
> +		if (pos < offset || !start_offset_in_page) {
> +			/* We are extending past the previous end of the file.
> +			 * Fill in zero values to the end of the page */
> +			memset(((char *)ecryptfs_page_virt
> +				+ start_offset_in_page), 0,
> +				PAGE_CACHE_SIZE - start_offset_in_page);
> +		}
> +
> +		/* pos >= offset, we are now writing the data request */
>  		if (pos >= offset) {
>  			memcpy(((char *)ecryptfs_page_virt
>  				+ start_offset_in_page),
>  			       (data + data_offset), num_bytes);
>  			data_offset += num_bytes;
> -		} else {
> -			/* We are extending past the previous end of the file.
> -			 * Fill in zero values up to the start of where we
> -			 * will be writing data. */
> -			memset(((char *)ecryptfs_page_virt
> -				+ start_offset_in_page), 0, num_bytes);
>  		}
>  		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
>  		flush_dcache_page(ecryptfs_page);
> 
