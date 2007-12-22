Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXLVE5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXLVE5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 23:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXLVE5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 23:57:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbXLVE5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 23:57:30 -0500
Date: Fri, 21 Dec 2007 20:56:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>, mike@halcrow.us,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] ecryptfs: check for existing key_tfm at mount time
Message-Id: <20071221205618.d04bea09.akpm@linux-foundation.org>
In-Reply-To: <476B4CB9.9070700@redhat.com>
References: <476B4CB9.9070700@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 23:18:49 -0600 Eric Sandeen <sandeen@redhat.com> wrote:

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

This change looks fishy.

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

Here we return a pointer to an object without holding the lock and without
taking a refcount on it.  What prevents it from getting moved/freed/etc
while this thread of control is playing with it?

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

And given that we've just unlocked key_tfm_list_mutex, how do we know that
the return value from ecryptfs_tfm_exists() is still true in this window?


> +		rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0);
> +		if (rc) {
> +			printk(KERN_ERR "Error adding new key_tfm to list; "
> +					"rc = [%d]\n", rc);
>  			goto out;
>  		}
>  	}
> -	mutex_unlock(&key_tfm_list_mutex);

It would all look a lot more solid if this locking was retained and both
ecryptfs_tfm_exists() and ecryptfs_add_new_key_tfm() were designed to be
called under key_tfm_list_mutex.

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

dittoes.
