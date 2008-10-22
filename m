Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbYJVT1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbYJVT1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbYJVT0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:26:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37846 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830AbYJVT0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:26:40 -0400
Date: Wed, 22 Oct 2008 12:57:29 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH] ecryptfs: fix memory corruption when storing crypto
	info in xattrs
Message-ID: <20081022175729.GF19060@halcrowt61p.halcrow.us>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <48FF5F58.6040502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF5F58.6040502@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:14:00PM -0500, Eric Sandeen wrote:
> When ecryptfs allocates space to write crypto headers into, before
> copying it out to file headers or to xattrs, it looks at the value of
> crypt_stat->num_header_bytes_at_front to determine how much space it
> needs.  This is also used as the file offset to the actual encrypted
> data, so for xattr-stored crypto info, the value was zero.
> 
> So, we kzalloc'd 0 bytes, and then ran off to write to that memory.
> (Which returned as ZERO_SIZE_PTR, so we explode quickly).
> 
> The right answer is to always allocate a page to write into; the current
> code won't ever write more than that (this is enforced by the 
> (PAGE_CACHE_SIZE - offset) length in the call to 
> ecryptfs_generate_key_packet_set).  To be explicit about this, we now
> send in a "max" parameter, rather than magically using PAGE_CACHE_SIZE 
> there.
> 
> Also, since the pointer we pass down the callchain eventually gets the
> virt_to_page() treatment, we should be using a alloc_page variant, not
> kzalloc (see also 7fcba054373d5dfc43d26e243a5c9b92069972ee)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

The removal of the memset is okay because it is header information,
which is written to the disk in the clear anyway and is not
sensitive.

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

> ---
> 
> Index: linux-2.6.27.x86_64/fs/ecryptfs/crypto.c
> ===================================================================
> --- linux-2.6.27.x86_64.orig/fs/ecryptfs/crypto.c
> +++ linux-2.6.27.x86_64/fs/ecryptfs/crypto.c
> @@ -1251,6 +1251,7 @@ struct kmem_cache *ecryptfs_header_cache
>  /**
>   * ecryptfs_write_headers_virt
>   * @page_virt: The virtual address to write the headers to
> + * @max: The size of memory allocated at page_virt
>   * @size: Set to the number of bytes written by this function
>   * @crypt_stat: The cryptographic context
>   * @ecryptfs_dentry: The eCryptfs dentry
> @@ -1278,7 +1279,8 @@ struct kmem_cache *ecryptfs_header_cache
>   *
>   * Returns zero on success
>   */
> -static int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
> +static int ecryptfs_write_headers_virt(char *page_virt, size_t max,
> +				       size_t *size,
>  				       struct ecryptfs_crypt_stat *crypt_stat,
>  				       struct dentry *ecryptfs_dentry)
>  {
> @@ -1296,7 +1298,7 @@ static int ecryptfs_write_headers_virt(c
>  	offset += written;
>  	rc = ecryptfs_generate_key_packet_set((page_virt + offset), crypt_stat,
>  					      ecryptfs_dentry, &written,
> -					      PAGE_CACHE_SIZE - offset);
> +					      max - offset);
>  	if (rc)
>  		ecryptfs_printk(KERN_WARNING, "Error generating key packet "
>  				"set; rc = [%d]\n", rc);
> @@ -1368,14 +1370,14 @@ int ecryptfs_write_metadata(struct dentr
>  		goto out;
>  	}
>  	/* Released in this function */
> -	virt = kzalloc(crypt_stat->num_header_bytes_at_front, GFP_KERNEL);
> +	virt = (char *)get_zeroed_page(GFP_KERNEL);
>  	if (!virt) {
>  		printk(KERN_ERR "%s: Out of memory\n", __func__);
>  		rc = -ENOMEM;
>  		goto out;
>  	}
> -	rc = ecryptfs_write_headers_virt(virt, &size, crypt_stat,
> -					 ecryptfs_dentry);
> +	rc = ecryptfs_write_headers_virt(virt, PAGE_CACHE_SIZE, &size,
> +					 crypt_stat, ecryptfs_dentry);
>  	if (unlikely(rc)) {
>  		printk(KERN_ERR "%s: Error whilst writing headers; rc = [%d]\n",
>  		       __func__, rc);
> @@ -1393,8 +1395,7 @@ int ecryptfs_write_metadata(struct dentr
>  		goto out_free;
>  	}
>  out_free:
> -	memset(virt, 0, crypt_stat->num_header_bytes_at_front);
> -	kfree(virt);
> +	free_page((unsigned long)virt);
>  out:
>  	return rc;
>  }
> 
