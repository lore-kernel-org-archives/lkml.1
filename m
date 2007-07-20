Return-Path: <linux-kernel-owner+w=401wt.eu-S937438AbXGTW2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937438AbXGTW2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763680AbXGTW2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:28:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761955AbXGTW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:28:00 -0400
Date: Fri, 20 Jul 2007 15:26:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mike@halcrow.us
Subject: Re: [PATCH 1/8] eCryptfs: Add key list structure; search keyring
Message-Id: <20070720152612.90f6254e.akpm@linux-foundation.org>
In-Reply-To: <20070719212546.GB13821@halcrow.austin.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com>
	<20070719212546.GB13821@halcrow.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 16:25:46 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> Add support structures for handling multiple keys. The list in
> crypt_stat contains the key identifiers for all of the keys that
> should be used for encrypting each file's File Encryption Key
> (FEK). For now, each inode inherits this list from the mount-wide
> crypt_stat struct, via the
> ecryptfs_copy_mount_wide_sigs_to_inode_sigs() function.
> 
> This patch also removes the global key tfm from the mount-wide
> crypt_stat struct, instead keeping a list of tfm's meant for dealing
> with the various inode FEK's. eCryptfs will now search the user's
> keyring for FEK's parsed from the existing file metadata, so the user
> can make keys available at any time before or after mounting.
> 
> Now that multiple FEK packets can be written to the file metadata, we
> need to be more meticulous about size limits. The updates to the code
> for writing out packets to the file metadata makes sizes and limits
> more explicit, uniformly expressed, and (hopefully) easier to follow.
> 

You have a few common coding-style slips in this patchset, which
scripts/checkpatch.pl will detect.  Please make checkpatch a part of your
normal patch preparation process.

>
> +	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
> +	BUG_ON(mount_crypt_stat->num_global_auth_toks == 0);
> +	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);

That's odd-looking.  If it was a bug for num_global_auth_toks to be zero,
and if that mutex protects num_global_auth_toks then as soon as the lock
gets dropped, another thread can make num_global_auth_toks zero, hence
the bug is present.  Perhaps?

> +	crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
> +	crypt_stat->flags |= ECRYPTFS_KEY_VALID;

Maybe the compiler can optimise those two statements, but we'd normally
provide it with some manual help.

> +	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
> +						      mount_crypt_stat);
> +	rc = ecryptfs_copy_mount_wide_sigs_to_inode_sigs(crypt_stat,
> +							 mount_crypt_stat);
> +	if (rc) {
> +		printk(KERN_ERR "Error attempting to copy mount-wide key sigs "
> +		       "to the inode key sigs; rc = [%d]\n", rc);
> +		goto out;
> +	}
> +	cipher_name_len =
> +		strlen(mount_crypt_stat->global_default_cipher_name);
> +	memcpy(crypt_stat->cipher,
> +	       mount_crypt_stat->global_default_cipher_name,
> +	       cipher_name_len);
> +	crypt_stat->cipher[cipher_name_len] = '\0';
> +	crypt_stat->key_size =
> +		mount_crypt_stat->global_default_cipher_key_size;
> +	ecryptfs_generate_new_key(crypt_stat);
>  	rc = ecryptfs_init_crypt_ctx(crypt_stat);
>  	if (rc)
>  		ecryptfs_printk(KERN_ERR, "Error initializing cryptographic "
>  				"context for cipher [%s]: rc = [%d]\n",
>  				crypt_stat->cipher, rc);
> +out:
>  	return rc;
>  }
>  
> @@ -1829,3 +1874,98 @@ ecryptfs_process_cipher(struct crypto_blkcipher **key_tfm, char *cipher_name,
>  out:
>  	return rc;
>  }
> +
> +struct kmem_cache *ecryptfs_key_tfm_cache;
> +struct list_head key_tfm_list;
> +struct mutex key_tfm_list_mutex;
> +
> +int ecryptfs_init_crypto(void)
> +{
> +	mutex_init(&key_tfm_list_mutex);
> +	INIT_LIST_HEAD(&key_tfm_list);
> +	return 0;
> +}
> +
> +int ecryptfs_destruct_crypto(void)

ecryptfs_destroy_crypto would be more grammatically correct ;)

> +{
> +	struct ecryptfs_key_tfm *key_tfm, *key_tfm_tmp;
> +
> +	mutex_lock(&key_tfm_list_mutex);
> +	list_for_each_entry_safe(key_tfm, key_tfm_tmp, &key_tfm_list,
> +				 key_tfm_list) {
> +		list_del(&key_tfm->key_tfm_list);
> +		if (key_tfm->key_tfm)
> +			crypto_free_blkcipher(key_tfm->key_tfm);
> +		kmem_cache_free(ecryptfs_key_tfm_cache, key_tfm);
> +	}
> +	mutex_unlock(&key_tfm_list_mutex);
> +	return 0;
> +}
> +
>
> ...
>  
> +struct ecryptfs_global_auth_tok {
> +#define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
> +	u32 flags;
> +	struct list_head mount_crypt_stat_list;
> +	struct key *global_auth_tok_key;
> +	struct ecryptfs_auth_tok *global_auth_tok;
> +	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
> +};
> +
> +struct ecryptfs_key_tfm {
> +	struct crypto_blkcipher *key_tfm;
> +	size_t key_size;
> +	struct mutex key_tfm_mutex;
> +	struct list_head key_tfm_list;
> +	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
> +};

Please consider commenting your struct fields carefully: it's a great way
to help other to understand your code.

> +extern struct list_head key_tfm_list;
> +extern struct mutex key_tfm_list_mutex;
> +
>  /**
>   * This struct is to enable a mount-wide passphrase/salt combo. This
>   * is more or less a stopgap to provide similar functionality to other
> @@ -276,15 +304,14 @@ struct ecryptfs_mount_crypt_stat {
>  #define ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED 0x00000001
>  #define ECRYPTFS_XATTR_METADATA_ENABLED        0x00000002
>  #define ECRYPTFS_ENCRYPTED_VIEW_ENABLED        0x00000004
> +#define ECRYPTFS_MOUNT_CRYPT_STAT_INITIALIZED  0x00000008
>  	u32 flags;
> -	struct ecryptfs_auth_tok *global_auth_tok;
> -	struct key *global_auth_tok_key;
> +	struct list_head global_auth_tok_list;
> +	struct mutex global_auth_tok_list_mutex;
> +	size_t num_global_auth_toks;
>  	size_t global_default_cipher_key_size;
> -	struct crypto_blkcipher *global_key_tfm;
> -	struct mutex global_key_tfm_mutex;
>  	unsigned char global_default_cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE
>  						 + 1];
> -	unsigned char global_auth_tok_sig[ECRYPTFS_SIG_SIZE_HEX + 1];
>  };
>  
>  /* superblock private data. */
> @@ -468,6 +495,9 @@ extern struct kmem_cache *ecryptfs_header_cache_2;
>  extern struct kmem_cache *ecryptfs_xattr_cache;
>  extern struct kmem_cache *ecryptfs_lower_page_cache;
>  extern struct kmem_cache *ecryptfs_key_record_cache;
> +extern struct kmem_cache *ecryptfs_key_sig_cache;
> +extern struct kmem_cache *ecryptfs_global_auth_tok_cache;
> +extern struct kmem_cache *ecryptfs_key_tfm_cache;

gosh ecryptfs has a lot of slab caches.

Generally one only creates a custom cache when we expect there to be a
"lot" of obejcts concurrently allocated.  Please check that this describes
all the caches which ecryptfs implements.  Otherwise, plain old kmalloc can
be used.

They just changed the kmem_cache_create() signature so I might have a build
error to fix here.  Have already fixed at least thirty such failures from that
change, sigh.


> +/**
> + * decrypt_passphrase_encrypted_session_key - Decrypt the session key
> + * with the given auth_tok.
>   *
>   * Returns Zero on success; non-zero error otherwise.
>   */

That comment purports to be a kerneldoc-style comment.  But

- kerneldoc doesn't support multiple lines on the introductory line which
  identifies the name of the function (alas).  So you'll need to overflow
  80 cols here.

- the function args weren't documented

But the return value is!  People regularly forget to do that.  And they
frequently forget to document the locking prerequisites and the permissible
calling contexts (process/might_sleep/hardirq, etc)

(please check all ecryptfs kerneldoc for this stuff sometime)

> -static int decrypt_session_key(struct ecryptfs_auth_tok *auth_tok,
> -			       struct ecryptfs_crypt_stat *crypt_stat)
> +static int
> +decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
> +					 struct ecryptfs_crypt_stat *crypt_stat)
>  {
> -	struct ecryptfs_password *password_s_ptr;
> -	struct scatterlist src_sg[2], dst_sg[2];
> +	struct scatterlist dst_sg;
> +	struct scatterlist src_sg;
>  	struct mutex *tfm_mutex = NULL;

This initialisation looks like it's here to kill bogus gcc warning (if it
is, it should have been commented).  Please investigate uninitialized_var()
and __maybe_unused sometime.

Then again, maybe it isn't ;)


> +int ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok)
> +{
> +	int rc = 0;
> +
> +	(*sig) = NULL;
> +	switch (auth_tok->token_type) {
> +	case ECRYPTFS_PASSWORD:
> +		(*sig) = auth_tok->token.password.signature;
> +		break;
> +	case ECRYPTFS_PRIVATE_KEY:
> +		(*sig) = auth_tok->token.private_key.signature;
> +		break;
> +	default:
> +		printk(KERN_ERR "Cannot get sig for auth_tok of type [%d]\n",
> +		       auth_tok->token_type);
> +		rc = -EINVAL;
> +	}
> +	return rc;
> +}

Please check that all the newly-added global symbols do indeed need to be
global.  (I think they are OK, but I'm lazy).

>  /**
>   * ecryptfs_parse_packet_set
>   * @dest: The header page in memory
> @@ -1058,25 +1177,22 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
>  			      struct dentry *ecryptfs_dentry)
>  {
>  	size_t i = 0;
> -	size_t found_auth_tok = 0;
> +	size_t found_auth_tok;
>  	size_t next_packet_is_auth_tok_packet;
> -	char sig[ECRYPTFS_SIG_SIZE_HEX];
>  	struct list_head auth_tok_list;
> -	struct list_head *walker;
> -	struct ecryptfs_auth_tok *chosen_auth_tok = NULL;
> -	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
> -		&ecryptfs_superblock_to_private(
> -			ecryptfs_dentry->d_sb)->mount_crypt_stat;
> +	struct ecryptfs_auth_tok *matching_auth_tok = NULL;
>  	struct ecryptfs_auth_tok *candidate_auth_tok = NULL;

Again, we might have some gcc-squashing going on here.  When really bored
you might want to grep the fs for "= NULL;" and have a think about the
result.



