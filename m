Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZAEMT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZAEMT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZAEMTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:19:15 -0500
Received: from lazybastard.de ([212.112.238.170]:59639 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZAEMTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:19:14 -0500
Date: Mon, 5 Jan 2009 13:18:50 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: Re: [PATCH V3 11/17] Squashfs: block operations
Message-ID: <20090105121850.GA31994@logfs.org>
References: <E1LJnJo-0002Lt-0v@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1LJnJo-0002Lt-0v@dylan.lougher.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, none of my comments are criticism against merging squashfs.  Code
improvements should continue independently.

On Mon, 5 January 2009 11:08:24 +0000, Phillip Lougher wrote:
> +/*
> + * Read and decompress a metadata block or datablock.  Length is non-zero
> + * if a datablock is being read (the size is stored elsewhere in the
> + * filesystem), otherwise the length is obtained from the first two bytes of
> + * the metadata block.  A bit in the length field indicates if the block
> + * is stored uncompressed in the filesystem (usually because compression
> + * generated a larger block - this does occasionally happen with zlib).
> + */

This is the core function of squashfs.  As such, it could probably use
some kerneldoc that explains each parameter and the return value;

> +int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
> +			int length, u64 *next_index, int srclength)
> +{
> +	struct squashfs_sb_info *msblk = sb->s_fs_info;
> +	struct buffer_head **bh;
> +	int offset = index & ((1 << msblk->devblksize_log2) - 1);
> +	u64 cur_index = index >> msblk->devblksize_log2;
> +	int bytes, compressed, b = 0, k = 0, page = 0, avail;
> +
> +
> +	bh = kcalloc((msblk->block_size >> msblk->devblksize_log2) + 1,
> +				sizeof(*bh), GFP_KERNEL);
> +	if (bh == NULL)
> +		return -ENOMEM;
> +
> +	if (length) {
> +		/*
> +		 * Datablock.
> +		 */
> +		bytes = -offset;
> +		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
> +		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
> +		if (next_index)
> +			*next_index = index + length;
> +
> +		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
> +			index, compressed ? "" : "un", length, srclength);
> +
> +		if (length < 0 || length > srclength ||
> +				(index + length) > msblk->bytes_used)
> +			goto read_failure;
> +
> +		for (b = 0; bytes < length; b++, cur_index++) {
> +			bh[b] = sb_getblk(sb, cur_index);
> +			if (bh[b] == NULL)
> +				goto block_release;
> +			bytes += msblk->devblksize;
> +		}
> +		ll_rw_block(READ, b, bh);
> +	} else {
> +		/*
> +		 * Metadata block.
> +		 */
> +		if ((index + 2) > msblk->bytes_used)
> +			goto read_failure;
> +
> +		bh[0] = get_block_length(sb, &cur_index, &offset, &length);
> +		if (bh[0] == NULL)
> +			goto read_failure;
> +		b = 1;
> +
> +		bytes = msblk->devblksize - offset;
> +		compressed = SQUASHFS_COMPRESSED(length);
> +		length = SQUASHFS_COMPRESSED_SIZE(length);
> +		if (next_index)
> +			*next_index = index + length + 2;
> +
> +		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
> +				compressed ? "" : "un", length);
> +
> +		if (length < 0 || length > srclength ||
> +					(index + length) > msblk->bytes_used)
> +			goto block_release;
> +
> +		for (; bytes < length; b++) {
> +			bh[b] = sb_getblk(sb, ++cur_index);
> +			if (bh[b] == NULL)
> +				goto block_release;
> +			bytes += msblk->devblksize;
> +		}
> +		ll_rw_block(READ, b - 1, bh + 1);
> +	}
> +
> +	if (compressed) {

This looks like a prime candidate for a seperate function.

> +		int zlib_err = 0, zlib_init = 0;
> +
> +		/*
> +		 * Uncompress block.
> +		 */
> +
> +		mutex_lock(&msblk->read_data_mutex);
> +
> +		msblk->stream.avail_out = 0;
> +		msblk->stream.avail_in = 0;
> +
> +		bytes = length;
> +		do {
> +			if (msblk->stream.avail_in == 0 && k < b) {
> +				avail = min(bytes, msblk->devblksize - offset);
> +				bytes -= avail;
> +				wait_on_buffer(bh[k]);
> +				if (!buffer_uptodate(bh[k]))
> +					goto release_mutex;
> +
> +				if (avail == 0) {
> +					offset = 0;
> +					put_bh(bh[k++]);
> +					continue;
> +				}
> +
> +				msblk->stream.next_in = bh[k]->b_data + offset;
> +				msblk->stream.avail_in = avail;
> +				offset = 0;
> +			}
> +
> +			if (msblk->stream.avail_out == 0) {
> +				msblk->stream.next_out = buffer[page++];
> +				msblk->stream.avail_out = PAGE_CACHE_SIZE;
> +			}
> +
> +			if (!zlib_init) {

Could be moved outside the main loop.

> +				zlib_err = zlib_inflateInit(&msblk->stream);
> +				if (zlib_err != Z_OK) {
> +					ERROR("zlib_inflateInit returned"
> +						" unexpected result 0x%x,"
> +						" srclength %d\n", zlib_err,
> +						srclength);
> +					goto release_mutex;
> +				}
> +				zlib_init = 1;
> +			}
> +
> +			zlib_err = zlib_inflate(&msblk->stream, Z_NO_FLUSH);
> +
> +			if (msblk->stream.avail_in == 0 && k < b)
> +				put_bh(bh[k++]);
> +		} while (zlib_err == Z_OK);
> +
> +		if (zlib_err != Z_STREAM_END) {
> +			ERROR("zlib_inflate returned unexpected result"
> +				" 0x%x, srclength %d, avail_in %d,"
> +				" avail_out %d\n", zlib_err, srclength,
> +				msblk->stream.avail_in,
> +				msblk->stream.avail_out);
> +			goto release_mutex;
> +		}
> +
> +		zlib_err = zlib_inflateEnd(&msblk->stream);
> +		if (zlib_err != Z_OK) {
> +			ERROR("zlib_inflateEnd returned unexpected result 0x%x,"
> +				" srclength %d\n", zlib_err, srclength);
> +			goto release_mutex;
> +		}
> +		length = msblk->stream.total_out;
> +		mutex_unlock(&msblk->read_data_mutex);
> +	} else {

Another candidate for a seperate function.  The complete condition could
look roughly like this:

	if (compressed)
		err = read_compressed_block(...);
	else
		err = read_uncompressed_block(...);

out:
	kfree(bh);
	if (err) {
		ERROR("sb_bread failed reading block -1x%llx\n", cur_index);
		return -EIO;
	}
	return length;

The only disadvantage I can see is the put_bh() loop in the error case
that would be duplicated in both read_*_block() functions.

> +		/*
> +		 * Block is uncompressed.
> +		 */
> +		int i, in, pg_offset = 0;
> +
> +		for (i = 0; i < b; i++) {
> +			wait_on_buffer(bh[i]);
> +			if (!buffer_uptodate(bh[i]))
> +				goto block_release;
> +		}
> +
> +		for (bytes = length; k < b; k++) {
> +			in = min(bytes, msblk->devblksize - offset);
> +			bytes -= in;
> +			while (in) {
> +				if (pg_offset == PAGE_CACHE_SIZE) {
> +					page++;
> +					pg_offset = 0;
> +				}
> +				avail = min_t(int, in, PAGE_CACHE_SIZE -
> +						pg_offset);
> +				memcpy(buffer[page] + pg_offset,
> +						bh[k]->b_data + offset, avail);
> +				in -= avail;
> +				pg_offset += avail;
> +				offset += avail;
> +			}
> +			offset = 0;
> +			put_bh(bh[k]);
> +		}
> +	}
> +
> +	kfree(bh);
> +	return length;
> +
> +release_mutex:
> +	mutex_unlock(&msblk->read_data_mutex);
> +
> +block_release:
> +	for (; k < b; k++)
> +		put_bh(bh[k]);
> +
> +read_failure:
> +	ERROR("sb_bread failed reading block 0x%llx\n", cur_index);
> +	kfree(bh);
> +	return -EIO;
> +}
> -- 
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-embedded" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Jörn

-- 
Optimizations always bust things, because all optimizations are, in
the long haul, a form of cheating, and cheaters eventually get caught.
-- Larry Wall
