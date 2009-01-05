Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbZAENJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbZAENJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZAENJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:09:28 -0500
Received: from corega.com.ru ([195.178.208.66]:58077 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZAENJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:09:27 -0500
Date: Mon, 5 Jan 2009 16:09:23 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: Re: [PATCH V3 02/17] Squashfs: directory lookup operations
Message-ID: <20090105130923.GA14147@ioremap.net>
References: <E1LJnJn-0002L7-I8@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LJnJn-0002L7-I8@dylan.lougher.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip.

One possible 'show-stopper' below and couple trivials.

On Mon, Jan 05, 2009 at 11:08:23AM +0000, Phillip Lougher (phillip@lougher.demon.co.uk) wrote:
> +static int get_dir_index_using_name(struct super_block *sb,
> +			u64 *next_block, int *next_offset, u64 index_start,
> +			int index_offset, int i_count, const char *name,
> +			int len)
> +{
> +	struct squashfs_sb_info *msblk = sb->s_fs_info;
> +	int i, size, length = 0, err;
> +	struct squashfs_dir_index *index;
> +	char *str;
> +
> +	TRACE("Entered get_dir_index_using_name, i_count %d\n", i_count);
> +
> +	index = kmalloc(sizeof(*index) + SQUASHFS_NAME_LEN * 2 + 2, GFP_KERNEL);
> +	if (index == NULL) {
> +		ERROR("Failed to allocate squashfs_dir_index\n");
> +		goto out;
> +	}
> +
> +	str = &index->name[SQUASHFS_NAME_LEN + 1];
> +	strncpy(str, name, len);
> +	str[len] = '\0';
> +
> +	for (i = 0; i < i_count; i++) {
> +		err = squashfs_read_metadata(sb, index, &index_start,
> +					&index_offset, sizeof(*index));
> +		if (err < 0)
> +			break;
> +
> +

Double new line. Code-style purists will scream when see this.
This was a show-stopper.

> +		size = le32_to_cpu(index->size) + 1;
> +
> +		err = squashfs_read_metadata(sb, index->name, &index_start,
> +					&index_offset, size);
> +		if (err < 0)
> +			break;
> +
> +		index->name[size] = '\0';
> +
> +		if (strcmp(index->name, str) > 0)
> +			break;
> +
> +		length = le32_to_cpu(index->index);
> +		*next_block = le32_to_cpu(index->start_block) +
> +					msblk->directory_table;
> +	}
> +
> +	*next_offset = (length + *next_offset) % SQUASHFS_METADATA_SIZE;
> +	kfree(index);
> +
> +out:
> +	/*
> +	 * Return index (f_pos) of the looked up metadata block.  Translate
> +	 * from internal f_pos to external f_pos which is offset by 3 because
> +	 * we invent "." and ".." entries which are not actually stored in the
> +	 * directory.
> +	 */
> +	return length + 3;
> +}
> +
> +

Another double new-line show-stopper.

> +static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
> +				 struct nameidata *nd)
> +{
> +	const unsigned char *name = dentry->d_name.name;
> +	int len = dentry->d_name.len;
> +	struct inode *inode = NULL;
> +	struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
> +	struct squashfs_dir_header dirh;
> +	struct squashfs_dir_entry *dire;
> +	u64 block = squashfs_i(dir)->start + msblk->directory_table;
> +	int offset = squashfs_i(dir)->offset;
> +	int err, length = 0, dir_count, size;
> +
> +	TRACE("Entered squashfs_lookup [%llx:%x]\n", block, offset);
> +
> +	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
> +	if (dire == NULL) {
> +		ERROR("Failed to allocate squashfs_dir_entry\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	if (len > SQUASHFS_NAME_LEN) {
> +		err = -ENAMETOOLONG;
> +		goto failed;
> +	}
> +
> +	length = get_dir_index_using_name(dir->i_sb, &block, &offset,
> +				squashfs_i(dir)->dir_idx_start,
> +				squashfs_i(dir)->dir_idx_offset,
> +				squashfs_i(dir)->dir_idx_cnt, name, len);
> +

You do not check the return value here.
Plus dir entry allocation can be done after above len check.
This one is trivial.

-- 
	Evgeniy Polyakov
