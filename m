Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbYKFWNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbYKFWNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYKFWNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:13:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbYKFWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:13:36 -0500
Date: Thu, 6 Nov 2008 14:12:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com, tchicks@us.ibm.com, shaggy@us.ibm.com
Subject: Re: [PATCH 3/5] eCryptfs: Filename Encryption: Encoding and
 encryption functions
Message-Id: <20081106141254.ba887466.akpm@linux-foundation.org>
In-Reply-To: <20081104214120.GC6677@halcrowt61p.austin.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
	<20081104214120.GC6677@halcrowt61p.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 15:41:20 -0600
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> These functions support encrypting and encoding the filename
> contents. The encrypted filename contents may consist of any ASCII
> characters. This patch includes a custom encoding mechanism to map the
> ASCII characters to a reduced character set that is appropriate for
> filenames.
> 
>
> ...
>
> +/* We could either offset on every reverse map or just pad some 0x00's
> + * at the front here */
> +static unsigned char filename_rev_map[] = {
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 31 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 39 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, /* 47 */
> +	0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, /* 55 */
> +	0x0A, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 63 */
> +	0x00, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, /* 71 */
> +	0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, /* 79 */
> +	0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, /* 87 */
> +	0x23, 0x24, 0x25, 0x00, 0x00, 0x00, 0x00, 0x00, /* 95 */
> +	0x00, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, /* 103 */
> +	0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x33, 0x34, /* 111 */
> +	0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, /* 119 */
> +	0x3D, 0x3E, 0x3F
> +};

You might as well make this const also if poss.  It doesn't make much
difference, apart from putting the table into write-protected memory.

>
> ...
>
> +int ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
> +				  const unsigned char *src, size_t src_size)
> +{
> +	u8 current_bit_offset = 0;
> +	size_t src_byte_offset = 0;
> +	size_t dst_byte_offset = 0;
> +	int rc = 0;
> +
> +	if (dst == NULL) {
> +		/* Not exact; conservatively long */
> +		(*dst_size) = (((src_size + 1) * 3) / 4);

Are you sure about that?  The destination will be 0.75 times as long as
the source?  Seems risky.

What's this code doing anyway?  At a guess, I'd say that it's a special
mode to this function which provides the caller with an estimate of how
much storage needs to be allocated to decode *src.  Or maybe that guess
was completely wrong.  A comment is needed, methinks.

> +		goto out;
> +	}
> +	while (src_byte_offset < src_size) {
> +		unsigned char src_byte =
> +				filename_rev_map[(int)src[src_byte_offset]];
> +
> +		switch (current_bit_offset) {
> +		case 0:
> +			dst[dst_byte_offset] = (src_byte << 2);
> +			current_bit_offset = 6;
> +			break;
> +		case 6:
> +			dst[dst_byte_offset++] |= (src_byte >> 4);
> +			dst[dst_byte_offset] = ((src_byte & 0xF)
> +						 << 4);
> +			current_bit_offset = 4;
> +			break;
> +		case 4:
> +			dst[dst_byte_offset++] |= (src_byte >> 2);
> +			dst[dst_byte_offset] = (src_byte << 6);
> +			current_bit_offset = 2;
> +			break;
> +		case 2:
> +			dst[dst_byte_offset++] |= (src_byte);
> +			dst[dst_byte_offset] = 0;
> +			current_bit_offset = 0;
> +			break;
> +		}
> +		src_byte_offset++;
> +	}
> +	(*dst_size) = dst_byte_offset;
> +out:
> +	return rc;
> +}
> +
>
> ...
>
> +int ecryptfs_encrypt_and_encode_filename(
> +	char **encoded_name,
> +	size_t *encoded_name_size,
> +	struct ecryptfs_crypt_stat *crypt_stat,
> +	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
> +	const char *name, size_t name_size)
> +{
> +	size_t encoded_name_no_prefix_size;
> +	int rc = 0;
> +
> +	(*encoded_name) = NULL;
> +	(*encoded_name_size) = 0;
> +	if ((crypt_stat && (crypt_stat->flags & ECRYPTFS_ENCRYPT_FILENAMES))
> +	    || (mount_crypt_stat && (mount_crypt_stat->flags
> +				     & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES))) {
> +		struct ecryptfs_filename *filename;
> +
> +		filename = kzalloc(sizeof(*filename), GFP_KERNEL);
> +		if (!filename) {
> +			printk(KERN_ERR "%s: Out of memory whilst attempting "
> +			       "to kzalloc [%d] bytes\n", __func__,

More printk warnings :(

> +			       sizeof(*filename));
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +		filename->filename = (char *)name;
> +		filename->filename_size = name_size;
> +		rc = ecryptfs_encrypt_filename(filename, crypt_stat,
> +					       mount_crypt_stat);

