Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYG1QZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYG1QZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYG1QZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:25:20 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45434 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYG1QZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:25:18 -0400
Date: Mon, 28 Jul 2008 11:25:03 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of
	memory
Message-ID: <20080728162503.GC7234@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <488DF00F.3080809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488DF00F.3080809@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:13:03AM -0500, Eric Sandeen wrote:
> With SLUB debugging turned on in 2.6.26, I was getting memory corruption
> when testing eCryptfs.  The root cause turned out to be that eCryptfs
> was doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that
> as a nice page-aligned chunk of memory.  But at least with SLUB debugging
> on, this is not always true, and the page we get from virt_to_page does
> not necessarily match the PAGE_CACHE_SIZE worth of memory we got from 
> kmalloc.
> 
> My simple testcase was 2 loops doing "rm -f fileX; cp /tmp/fileX ." for
> 2 different multi-megabyte files.  With this change I no longer see
> the corruption.
> 
> Thanks,
> -Eric
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

> ---
> 
> Index: linux-2.6.26/fs/ecryptfs/crypto.c
> ===================================================================
> --- linux-2.6.26.orig/fs/ecryptfs/crypto.c
> +++ linux-2.6.26/fs/ecryptfs/crypto.c
> @@ -474,8 +474,8 @@ int ecryptfs_encrypt_page(struct page *p
>  {
>  	struct inode *ecryptfs_inode;
>  	struct ecryptfs_crypt_stat *crypt_stat;
> -	char *enc_extent_virt = NULL;
> -	struct page *enc_extent_page;
> +	char *enc_extent_virt;
> +	struct page *enc_extent_page = NULL;
>  	loff_t extent_offset;
>  	int rc = 0;
> 
> @@ -491,14 +491,14 @@ int ecryptfs_encrypt_page(struct page *p
>  			       page->index);
>  		goto out;
>  	}
> -	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
> -	if (!enc_extent_virt) {
> +	enc_extent_page = alloc_page(GFP_USER);
> +	if (!enc_extent_page) {
>  		rc = -ENOMEM;
>  		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
>  				"encrypted extent\n");
>  		goto out;
>  	}
> -	enc_extent_page = virt_to_page(enc_extent_virt);
> +	enc_extent_virt = kmap(enc_extent_page);
>  	for (extent_offset = 0;
>  	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
>  	     extent_offset++) {
> @@ -526,7 +526,10 @@ int ecryptfs_encrypt_page(struct page *p
>  		}
>  	}
>  out:
> -	kfree(enc_extent_virt);
> +	if (enc_extent_page) {
> +		kunmap(enc_extent_page);
> +		__free_page(enc_extent_page);
> +	}
>  	return rc;
>  }
> 
> @@ -608,8 +611,8 @@ int ecryptfs_decrypt_page(struct page *p
>  {
>  	struct inode *ecryptfs_inode;
>  	struct ecryptfs_crypt_stat *crypt_stat;
> -	char *enc_extent_virt = NULL;
> -	struct page *enc_extent_page;
> +	char *enc_extent_virt;
> +	struct page *enc_extent_page = NULL;
>  	unsigned long extent_offset;
>  	int rc = 0;
> 
> @@ -626,14 +629,14 @@ int ecryptfs_decrypt_page(struct page *p
>  			       page->index);
>  		goto out;
>  	}
> -	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
> -	if (!enc_extent_virt) {
> +	enc_extent_page = alloc_page(GFP_USER);
> +	if (!enc_extent_page) {
>  		rc = -ENOMEM;
>  		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
>  				"encrypted extent\n");
>  		goto out;
>  	}
> -	enc_extent_page = virt_to_page(enc_extent_virt);
> +	enc_extent_virt = kmap(enc_extent_page);
>  	for (extent_offset = 0;
>  	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
>  	     extent_offset++) {
> @@ -661,7 +664,10 @@ int ecryptfs_decrypt_page(struct page *p
>  		}
>  	}
>  out:
> -	kfree(enc_extent_virt);
> +	if (enc_extent_page) {
> +		kunmap(enc_extent_page);
> +		__free_page(enc_extent_page);
> +	}
>  	return rc;
>  }
> 
> 
