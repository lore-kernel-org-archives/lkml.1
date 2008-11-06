Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbYKFWNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbYKFWNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYKFWNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:13:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYKFWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:13:21 -0500
Date: Thu, 6 Nov 2008 14:12:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com, tchicks@us.ibm.com, shaggy@us.ibm.com
Subject: Re: [PATCH 1/5] eCryptfs: Filename Encryption: Tag 70 packets
Message-Id: <20081106141234.ba53c112.akpm@linux-foundation.org>
In-Reply-To: <20081104213908.GA6677@halcrowt61p.austin.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
	<20081104213908.GA6677@halcrowt61p.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 15:39:08 -0600
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> A tag 70 packet contains a filename encrypted with a Filename Encryption
> Key (FNEK). This patch implements functions for writing and parsing tag
> 70 packets. This patch also adds definitions and extends structures to
> support filename encryption.
> 
>
> ...
>
> +/**
> + * write_tag_70_packet - Write encrypted filename (EFN) packet against FNEK
> + * @filename: NULL-terminated filename string
> + *
> + * This is the simplest mechanism for achieving filename encryption in
> + * eCryptfs. It encrypts the given filename with the mount-wide
> + * filename encryption key (FNEK) and stores it in a packet to @dest,
> + * which the callee will encode and write directly into the dentry
> + * name.
> + */
> +int
> +ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
> +			     size_t *packet_size,
> +			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
> +			     char *filename, size_t filename_size)
> +{
> +	struct ecryptfs_write_tag_70_packet_silly_stack *s;
> +	int rc = 0;
> +
> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +	if (!s) {
> +		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
> +		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));

size_t's must be printed with %zd.

> +		goto out;
> +	}
> +	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +	(*packet_size) = 0;
> +	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(
> +		&s->desc.tfm,
> +		&s->tfm_mutex, mount_crypt_stat->global_default_fn_cipher_name);
> +	if (unlikely(rc)) {
> +		printk(KERN_ERR "Internal error whilst attempting to get "
> +		       "tfm and mutex for cipher name [%s]; rc = [%d]\n",
> +		       mount_crypt_stat->global_default_fn_cipher_name, rc);
> +		goto out;
> +	}
> +	mutex_lock(s->tfm_mutex);
> +	s->block_size = crypto_blkcipher_blocksize(s->desc.tfm);
> +	/* Plus one for the \0 separator between the random prefix
> +	 * and the plaintext filename */
> +	s->num_rand_bytes = (ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES + 1);
> +	s->block_aligned_filename_size = (s->num_rand_bytes + filename_size);
> +	if ((s->block_aligned_filename_size % s->block_size) != 0) {
> +		s->num_rand_bytes += (s->block_size
> +				      - (s->block_aligned_filename_size
> +					 % s->block_size));
> +		s->block_aligned_filename_size = (s->num_rand_bytes
> +						  + filename_size);
> +	}
> +	/* Octet 0: Tag 70 identifier
> +	 * Octets 1-N1: Tag 70 packet size (includes cipher identifier
> +	 *              and block-aligned encrypted filename size)
> +	 * Octets N1-N2: FNEK sig (ECRYPTFS_SIG_SIZE)
> +	 * Octet N2-N3: Cipher identifier (1 octet)
> +	 * Octets N3-N4: Block-aligned encrypted filename
> +	 *  - Consists of a minimum number of random characters, a \0
> +	 *    separator, and then the filename */
> +	s->max_packet_size = (1                   /* Tag 70 identifier */
> +			      + 3                 /* Max Tag 70 packet size */
> +			      + ECRYPTFS_SIG_SIZE /* FNEK sig */
> +			      + 1                 /* Cipher identifier */
> +			      + s->block_aligned_filename_size);
> +	if (dest == NULL) {
> +		(*packet_size) = s->max_packet_size;
> +		goto out_unlock;
> +	}
> +	if (s->max_packet_size > (*remaining_bytes)) {
> +		printk(KERN_WARNING "%s: Require [%d] bytes to write; only "
> +		       "[%d] available\n", __func__, s->max_packet_size,
> +		       (*remaining_bytes));
> +		rc = -EINVAL;
> +		goto out_unlock;
> +	}
> +	s->block_aligned_filename = kzalloc(s->block_aligned_filename_size,
> +					    GFP_KERNEL);
> +	if (!s->block_aligned_filename) {
> +		printk(KERN_ERR "%s: Out of kernel memory whilst attempting to "
> +		       "kzalloc [%Zd] bytes\n", __func__,

like that ;)

(I think %Z is a legacy gcc-ism, and that %z is the standard token)

In fact this patch alone adds all these warnings to the powerpc build:

fs/ecryptfs/keystore.c: In function 'ecryptfs_write_tag_70_packet':
fs/ecryptfs/keystore.c:514: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
fs/ecryptfs/keystore.c:561: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
fs/ecryptfs/keystore.c:561: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/ecryptfs/keystore.c:599: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/ecryptfs/keystore.c:697: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/ecryptfs/keystore.c:707: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/ecryptfs/keystore.c: In function 'ecryptfs_parse_tag_70_packet':
fs/ecryptfs/keystore.c:790: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
fs/ecryptfs/keystore.c:831: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
fs/ecryptfs/keystore.c:831: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/ecryptfs/keystore.c:864: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/ecryptfs/keystore.c:873: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
fs/ecryptfs/keystore.c:884: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/ecryptfs/keystore.c:948: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

More care and better testing is needed here, please.  These bugs can
and do cause machine crashes.

It looks like fixing all this will churn the patches rather a lot, so
I'll duck version #1.

>
> ...
>
> +/**
> + * parse_tag_70_packet - Parse and process FNEK-encrypted passphrase packet
> + * @filename: This function kmalloc's the memory for the filename
> + */

This kernedoc missed lots of the arguments.

> +int
> +ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
> +			     size_t *packet_size,
> +			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
> +			     char *data, size_t max_packet_size)
> +{
> +	struct ecryptfs_parse_tag_70_packet_silly_stack *s;
> +	int rc = 0;
> +
> +	(*packet_size) = 0;
> +	(*filename_size) = 0;
> +	(*filename) = NULL;
> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +	if (!s) {
> +		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
> +		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));
> +		goto out;
> +	}
> +	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +	if (max_packet_size < (1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1)) {
> +		printk(KERN_WARNING "%s: max_packet_size is [%Zd]; it must be "
> +		       "at least [%d]\n", __func__, max_packet_size,
> +			(1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1));
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +	/* Octet 0: Tag 70 identifier
> +	 * Octets 1-N1: Tag 70 packet size (includes cipher identifier
> +	 *              and block-aligned encrypted filename size)
> +	 * Octets N1-N2: FNEK sig (ECRYPTFS_SIG_SIZE)
> +	 * Octet N2-N3: Cipher identifier (1 octet)
> +	 * Octets N3-N4: Block-aligned encrypted filename
> +	 *  - Consists of a minimum number of random numbers, a \0
> +	 *    separator, and then the filename */
> +	if (data[(*packet_size)++] != ECRYPTFS_TAG_70_PACKET_TYPE) {
> +		printk(KERN_WARNING "%s: Invalid packet tag [0x%.2x]; must be "
> +		       "tag [0x%.2x]\n", __func__,
> +		       data[((*packet_size) - 1)], ECRYPTFS_TAG_70_PACKET_TYPE);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +	rc = ecryptfs_parse_packet_length(&data[(*packet_size)],
> +					  &s->parsed_tag_70_packet_size,
> +					  &s->packet_size_len);
> +	if (rc) {
> +		printk(KERN_WARNING "%s: Error parsing packet length; "
> +		       "rc = [%d]\n", __func__, rc);
> +		goto out;
> +	}
> +	s->block_aligned_filename_size = (s->parsed_tag_70_packet_size
> +					  - ECRYPTFS_SIG_SIZE - 1);
> +	if ((1 + s->packet_size_len + s->parsed_tag_70_packet_size)
> +	    > max_packet_size) {
> +		printk(KERN_WARNING "%s: max_packet_size is [%d]; real packet "
> +		       "size is [%d]\n", __func__, max_packet_size,
> +		       (1 + s->packet_size_len + 1
> +			+ s->block_aligned_filename_size));
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +	(*packet_size) += s->packet_size_len;
> +	ecryptfs_to_hex(s->fnek_sig_hex, &data[(*packet_size)],
> +			ECRYPTFS_SIG_SIZE);
> +	s->fnek_sig_hex[ECRYPTFS_SIG_SIZE_HEX] = '\0';
> +	(*packet_size) += ECRYPTFS_SIG_SIZE;
> +	s->cipher_code = data[(*packet_size)++];
> +	rc = ecryptfs_cipher_code_to_string(s->cipher_string, s->cipher_code);
> +	if (rc) {
> +		printk(KERN_WARNING "%s: Cipher code [%d] is invalid\n",
> +		       __func__, s->cipher_code);
> +		goto out;
> +	}
> +	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(&s->desc.tfm,
> +							&s->tfm_mutex,
> +							s->cipher_string);
> +	if (unlikely(rc)) {
> +		printk(KERN_ERR "Internal error whilst attempting to get "
> +		       "tfm and mutex for cipher name [%s]; rc = [%d]\n",
> +		       s->cipher_string, rc);
> +		goto out;
> +	}
> +	mutex_lock(s->tfm_mutex);
> +	rc = virt_to_scatterlist(&data[(*packet_size)],
> +				 s->block_aligned_filename_size, &s->src_sg, 1);
> +	if (rc != 1) {
> +		printk(KERN_ERR "%s: Internal error whilst attempting to "
> +		       "convert encrypted filename memory to scatterlist; "
> +		       "expected rc = 1; got rc = [%d]. "
> +		       "block_aligned_filename_size = [%d]\n", __func__, rc,
> +		       s->block_aligned_filename_size);
> +		goto out_unlock;
> +	}
> +	(*packet_size) += s->block_aligned_filename_size;
> +	s->decrypted_filename = kmalloc(s->block_aligned_filename_size,
> +					GFP_KERNEL);
> +	if (!s->decrypted_filename) {
> +		printk(KERN_ERR "%s: Out of memory whilst attempting to "
> +		       "kmalloc [%d] bytes\n", __func__,
> +		       s->block_aligned_filename_size);
> +		rc = -ENOMEM;
> +		goto out_unlock;
> +	}
> +	rc = virt_to_scatterlist(s->decrypted_filename,
> +				 s->block_aligned_filename_size, &s->dst_sg, 1);
> +	if (rc != 1) {
> +		printk(KERN_ERR "%s: Internal error whilst attempting to "
> +		       "convert decrypted filename memory to scatterlist; "
> +		       "expected rc = 1; got rc = [%d]. "
> +		       "block_aligned_filename_size = [%d]\n", __func__, rc,
> +		       s->block_aligned_filename_size);
> +		goto out_free_unlock;
> +	}
> +	/* The characters in the first block effectively do the job of
> +	 * the IV here, so we just use 0's for the IV. Note the
> +	 * constraint that ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES
> +	 * >= ECRYPTFS_MAX_IV_BYTES. */
> +	memset(s->iv, 0, ECRYPTFS_MAX_IV_BYTES);
> +	s->desc.info = s->iv;
> +	rc = ecryptfs_find_auth_tok_for_sig(&s->auth_tok, mount_crypt_stat,
> +					    s->fnek_sig_hex);
> +	if (rc) {
> +		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> +		       "fnek sig [%s]; rc = [%d]\n", __func__, s->fnek_sig_hex,
> +		       rc);
> +		goto out_free_unlock;
> +	}
> +	/* TODO: Support other key modules than passphrase for
> +	 * filename encryption */
> +	BUG_ON(s->auth_tok->token_type != ECRYPTFS_PASSWORD);
> +	rc = crypto_blkcipher_setkey(
> +		s->desc.tfm,
> +		s->auth_tok->token.password.session_key_encryption_key,
> +		mount_crypt_stat->global_default_fn_cipher_key_bytes);
> +	if (rc < 0) {
> +		printk(KERN_ERR "%s: Error setting key for crypto context; "
> +		       "rc = [%d]. s->auth_tok->token.password.session_key_"
> +		       "encryption_key = [0x%p]; mount_crypt_stat->"
> +		       "global_default_fn_cipher_key_bytes = [%Zd]\n", __func__,
> +		       rc,
> +		       s->auth_tok->token.password.session_key_encryption_key,
> +		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
> +		goto out_free_unlock;
> +	}
> +	rc = crypto_blkcipher_decrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
> +					 s->block_aligned_filename_size);
> +	if (rc) {
> +		printk(KERN_ERR "%s: Error attempting to decrypt filename; "
> +		       "rc = [%d]\n", __func__, rc);
> +		goto out_free_unlock;
> +	}
> +	s->i = 0;
> +	while (s->decrypted_filename[s->i] != '\0'
> +	       && s->i < s->block_aligned_filename_size)
> +		s->i++;
> +	if (s->i == s->block_aligned_filename_size) {
> +		printk(KERN_WARNING "%s: Invalid tag 70 packet; could not "
> +		       "find valid separator between random characters and "
> +		       "the filename\n", __func__);
> +		rc = -EINVAL;
> +		goto out_free_unlock;
> +	}
> +	s->i++;
> +	(*filename_size) = (s->block_aligned_filename_size - s->i);
> +	if (!((*filename_size) > 0 && (*filename_size < PATH_MAX))) {
> +		printk(KERN_WARNING "%s: Filename size is [%Zd], which is "
> +		       "invalid\n", __func__, (*filename_size));
> +		rc = -EINVAL;
> +		goto out_free_unlock;
> +	}
> +	(*filename) = kmalloc(((*filename_size) + 1), GFP_KERNEL);
> +	if (!(*filename)) {
> +		printk(KERN_ERR "%s: Out of memory whilst attempting to "
> +		       "kmalloc [%d] bytes\n", __func__,
> +		       ((*filename_size) + 1));
> +		rc = -ENOMEM;
> +		goto out_free_unlock;
> +	}
> +	memcpy((*filename), &s->decrypted_filename[s->i], (*filename_size));
> +	(*filename)[(*filename_size)] = '\0';
> +out_free_unlock:
> +	kfree(s->decrypted_filename);
> +out_unlock:
> +	mutex_unlock(s->tfm_mutex);
> +out:
> +	if (rc) {
> +		(*packet_size) = 0;
> +		(*filename_size) = 0;
> +		(*filename) = NULL;
> +	}
> +	kfree(s);
> +	return rc;
> +}

Boy, that's a tricky function.

>
> ...
>

