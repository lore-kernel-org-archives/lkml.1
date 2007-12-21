Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbXLUPII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbXLUPII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXLUPH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:07:57 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45370 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXLUPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 10:07:56 -0500
Date: Fri, 21 Dec 2007 09:01:45 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, mike@halcrow.us,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] ecryptfs: check for existing key_tfm at mount time
Message-ID: <20071221150145.GE10989@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <476B4CB9.9070700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476B4CB9.9070700@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 11:18:49PM -0600, Eric Sandeen wrote:
> Jeff Moyer pointed out that a mount; umount loop of ecryptfs,
> with the same cipher & other mount options, created a new 
> ecryptfs_key_tfm_cache item each time, and the cache could
> grow quite large this way.
> 
> Looking at this with mhalcrow, we saw that ecryptfs_parse_options()
> unconditionally called ecryptfs_add_new_key_tfm(), which is what
> was adding these items.
> 
> Refactor ecryptfs_get_tfm_and_mutex_for_cipher_name() to create a 
> new helper function, ecryptfs_tfm_exists(), which checks for the 
> cipher on the cached key_tfm_list, and sets a pointer
> to it if it exists.  This can then be called from 
> ecryptfs_parse_options(), and new key_tfm's can be added only when
> a cached one is not found.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>

> ---
> 
> Index: linux-2.6.24-rc3/fs/ecryptfs/crypto.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/crypto.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/crypto.c
> @@ -1868,6 +1868,33 @@ out:
>  	return rc;
>  }
> 
> +/**
> + * ecryptfs_tfm_exists - Search for existing tfm for cipher_name.
> + * @cipher_name: the name of the cipher to search for
> + * @key_tfm: set to corresponding tfm if found
> + *
> + * Returns 1 if found, with key_tfm set
> + * Returns 0 if not found, key_tfm set to NULL
> + */
> +int ecryptfs_tfm_exists(char *cipher_name, struct ecryptfs_key_tfm **key_tfm)
> +{
> +	struct ecryptfs_key_tfm *tmp_key_tfm;
> +
> +	mutex_lock(&key_tfm_list_mutex);
> +	list_for_each_entry(tmp_key_tfm, &key_tfm_list, key_tfm_list) {
> +		if (strcmp(tmp_key_tfm->cipher_name, cipher_name) == 0) {
> +			mutex_unlock(&key_tfm_list_mutex);
> +			if (key_tfm)
> +				(*key_tfm) = tmp_key_tfm;
> +			return 1;
> +		}
> +	}
> +	mutex_unlock(&key_tfm_list_mutex);
> +	if (key_tfm)
> +		(*key_tfm) = NULL;
> +	return 0;
> +}
> +
>  int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
>  					       struct mutex **tfm_mutex,
>  					       char *cipher_name)
> @@ -1877,22 +1904,15 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
> 
>  	(*tfm) = NULL;
>  	(*tfm_mutex) = NULL;
> -	mutex_lock(&key_tfm_list_mutex);
> -	list_for_each_entry(key_tfm, &key_tfm_list, key_tfm_list) {
> -		if (strcmp(key_tfm->cipher_name, cipher_name) == 0) {
> -			(*tfm) = key_tfm->key_tfm;
> -			(*tfm_mutex) = &key_tfm->key_tfm_mutex;
> -			mutex_unlock(&key_tfm_list_mutex);
> +
> +	if (!ecryptfs_tfm_exists(cipher_name, &key_tfm)) {
> +		rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0);
> +		if (rc) {
> +			printk(KERN_ERR "Error adding new key_tfm to list; "
> +					"rc = [%d]\n", rc);
>  			goto out;
>  		}
>  	}
> -	mutex_unlock(&key_tfm_list_mutex);
> -	rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0);
> -	if (rc) {
> -		printk(KERN_ERR "Error adding new key_tfm to list; rc = [%d]\n",
> -		       rc);
> -		goto out;
> -	}
>  	(*tfm) = key_tfm->key_tfm;
>  	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
>  out:
> Index: linux-2.6.24-rc3/fs/ecryptfs/ecryptfs_kernel.h
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/ecryptfs_kernel.h
> +++ linux-2.6.24-rc3/fs/ecryptfs/ecryptfs_kernel.h
> @@ -623,6 +623,7 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
>  			 size_t key_size);
>  int ecryptfs_init_crypto(void);
>  int ecryptfs_destroy_crypto(void);
> +int ecryptfs_tfm_exists(char *cipher_name, struct ecryptfs_key_tfm **key_tfm);
>  int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
>  					       struct mutex **tfm_mutex,
>  					       char *cipher_name);
> Index: linux-2.6.24-rc3/fs/ecryptfs/main.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/main.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/main.c
> @@ -410,9 +410,11 @@ static int ecryptfs_parse_options(struct
>  	if (!cipher_key_bytes_set) {
>  		mount_crypt_stat->global_default_cipher_key_size = 0;
>  	}
> -	rc = ecryptfs_add_new_key_tfm(
> -		NULL, mount_crypt_stat->global_default_cipher_name,
> -		mount_crypt_stat->global_default_cipher_key_size);
> +	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
> +				 NULL))
> +		rc = ecryptfs_add_new_key_tfm(
> +			NULL, mount_crypt_stat->global_default_cipher_name,
> +			mount_crypt_stat->global_default_cipher_key_size);
>  	if (rc) {
>  		printk(KERN_ERR "Error attempting to initialize cipher with "
>  		       "name = [%s] and key size = [%td]; rc = [%d]\n",
> 
