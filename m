Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbXITFjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbXITFjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXITFjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:39:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbXITFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:39:21 -0400
Date: Wed, 19 Sep 2007 22:38:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/11] eCryptfs: read_write.c routines
Message-Id: <20070919223850.3e1132ac.akpm@linux-foundation.org>
In-Reply-To: <20070917214632.GK13679@halcrow.austin.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
	<20070917214632.GK13679@halcrow.austin.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 16:46:32 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> Add a set of functions through which all I/O to lower files is
> consolidated. This patch adds a new inode_info reference to a
> persistent lower file for each eCryptfs inode; another patch later in
> this series will set that up. This persistent lower file is what the
> read_write.c functions use to call vfs_read() and vfs_write() on the
> lower filesystem, so even when reads and writes come in through
> aops->readpage and aops->writepage, we can satisfy them without
> resorting to direct access to the lower inode's address space.
> Several function declarations are going to be changing with this
> patchset. For now, in order to keep from breaking the build, I am
> putting dummy parameters in for those functions.
> 
> ..
>
> +/**
> + * ecryptfs_write_lower_page_segment
> + * @ecryptfs_inode: The eCryptfs inode
> + * @page_for_lower: The page containing the data to be written to the
> + *                  lower file
> + * @offset_in_page: The offset in the @page_for_lower from which to
> + *                  start writing the data
> + * @size: The amount of data from @page_for_lower to write to the
> + *        lower file
> + *
> + * Determines the byte offset in the file for the given page and
> + * offset within the page, maps the page, and makes the call to write
> + * the contents of @page_for_lower to the lower inode.
> + *
> + * Returns zero on success; non-zero otherwise
> + */
> +int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
> +				      struct page *page_for_lower,
> +				      size_t offset_in_page, size_t size)
> +{
> +	char *virt;
> +	loff_t offset;
> +	int rc;
> +
> +	offset = (page_for_lower->index << PAGE_CACHE_SHIFT) + offset_in_page;

bug.  You need to cast page.index to loff_t before shifting.

I'd fix it on the spot, but this would be a good time to review the whole
patchset and perhaps the whole fs for this easy-to-do, hard-to-find bug.

> +	virt = kmap(page_for_lower);
> +	rc = ecryptfs_write_lower(ecryptfs_inode, virt, offset, size);
> +	kunmap(page_for_lower);
> +	return rc;
> +}

argh, kmap.  http://lkml.org/lkml/2007/9/15/55

> +/**
> + * ecryptfs_write
> + * @ecryptfs_file: The eCryptfs file into which to write
> + * @data: Virtual address where data to write is located
> + * @offset: Offset in the eCryptfs file at which to begin writing the
> + *          data from @data
> + * @size: The number of bytes to write from @data
> + *
> + * Write an arbitrary amount of data to an arbitrary location in the
> + * eCryptfs inode page cache. This is done on a page-by-page, and then
> + * by an extent-by-extent, basis; individual extents are encrypted and
> + * written to the lower page cache (via VFS writes). This function
> + * takes care of all the address translation to locations in the lower
> + * filesystem; it also handles truncate events, writing out zeros
> + * where necessary.
> + *
> + * Returns zero on success; non-zero otherwise
> + */
> +int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
> +		   size_t size)
> +{
> +	struct page *ecryptfs_page;
> +	char *ecryptfs_page_virt;
> +	u64 ecryptfs_file_size = i_size_read(ecryptfs_file->f_dentry->d_inode);

Not loff_t?

> +	loff_t data_offset = 0;
> +	loff_t pos;
> +	int rc = 0;
> +
> +	if (offset > ecryptfs_file_size)
> +		pos = ecryptfs_file_size;

loff_t = u64.  The typing seems a bit confused?

> +	else
> +		pos = offset;
> +	while (pos < (offset + size)) {
> +		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
> +		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
> +		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
> +		size_t total_remaining_bytes = ((offset + size) - pos);
> +
> +		if (num_bytes > total_remaining_bytes)
> +			num_bytes = total_remaining_bytes;
> +		if (pos < offset) {
> +			size_t total_remaining_zeros = (offset - pos);
> +
> +			if (num_bytes > total_remaining_zeros)
> +				num_bytes = total_remaining_zeros;
> +		}
> +		ecryptfs_page = ecryptfs_get1page(ecryptfs_file,
> +						  ecryptfs_page_idx);
> +		if (IS_ERR(ecryptfs_page)) {
> +			rc = PTR_ERR(ecryptfs_page);
> +			printk(KERN_ERR "%s: Error getting page at "
> +			       "index [%ld] from eCryptfs inode "
> +			       "mapping; rc = [%d]\n", __FUNCTION__,
> +			       ecryptfs_page_idx, rc);
> +			goto out;
> +		}
> +		if (start_offset_in_page) {
> +			/* Read in the page from the lower
> +			 * into the eCryptfs inode page cache,
> +			 * decrypting */
> +			if ((rc = ecryptfs_decrypt_page(NULL, /* placeholder for git-bisect */
> +							ecryptfs_page))) {

hm, checkpatch doesn't warn about the combined assignment-and-test because
it already warned about the over-80-cols line.


> +				printk(KERN_ERR "%s: Error decrypting "
> +				       "page; rc = [%d]\n",
> +				       __FUNCTION__, rc);
> +				page_cache_release(ecryptfs_page);
> +				goto out;
> +			}
> +		}
> +		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
> +		if (pos >= offset) {
> +			memcpy(((char *)ecryptfs_page_virt
> +				+ start_offset_in_page),
> +			       (data + data_offset), num_bytes);
> +			data_offset += num_bytes;
> +		} else {
> +			/* We are extending past the previous end of the file.
> +			 * Fill in zero values up to the start of where we
> +			 * will be writing data. */
> +			memset(((char *)ecryptfs_page_virt
> +				+ start_offset_in_page), 0, num_bytes);
> +		}
> +		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
> +		flush_dcache_page(ecryptfs_page);
> +		rc = ecryptfs_encrypt_page(NULL /* placeholder for git-bisect */);
> +		if (rc) {
> +			printk(KERN_ERR "%s: Error encrypting "
> +			       "page; rc = [%d]\n", __FUNCTION__, rc);
> +			page_cache_release(ecryptfs_page);
> +			goto out;
> +		}
> +		page_cache_release(ecryptfs_page);
> +		pos += num_bytes;
> +	}
> +	if ((offset + size) > ecryptfs_file_size) {
> +		i_size_write(ecryptfs_file->f_dentry->d_inode, (offset + size));
> +		rc = ecryptfs_write_inode_size_to_metadata(NULL, NULL, NULL,
> +							   NULL, 0); /* placeholders for git-bisect */
> +		if (rc) {
> +			printk(KERN_ERR	"Problem with "
> +			       "ecryptfs_write_inode_size_to_metadata; "
> +			       "rc = [%d]\n", rc);
> +			goto out;
> +		}
> +	}
> +out:
> +	return rc;
> +}
> +
> +/**
> + * ecryptfs_read_lower
> + * @data: The read data is stored here by this function
> + * @offset: Byte offset in the lower file from which to read the data
> + * @size: Number of bytes to read from @offset of the lower file and
> + *        store into @data
> + * @ecryptfs_inode: The eCryptfs inode
> + *
> + * Read @size bytes of data at byte offset @offset from the lower
> + * inode into memory location @data.
> + *
> + * Returns zero on success; non-zero on error
> + */
> +int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
> +			struct inode *ecryptfs_inode)
> +{
> +	struct ecryptfs_inode_info *inode_info =
> +		ecryptfs_inode_to_private(ecryptfs_inode);
> +	ssize_t octets_read;
> +	mm_segment_t fs_save;
> +	size_t i;
> +	int rc = 0;
> +
> +	mutex_lock(&inode_info->lower_file_mutex);
> +	BUG_ON(!inode_info->lower_file);
> +	inode_info->lower_file->f_pos = offset;
> +	fs_save = get_fs();
> +	set_fs(get_ds());
> +	octets_read = vfs_read(inode_info->lower_file, data, size,
> +			       &inode_info->lower_file->f_pos);
> +	set_fs(fs_save);
> +	if (octets_read < 0) {
> +		printk(KERN_ERR "%s: octets_read = [%td]; "
> +		       "expected [%td]\n", __FUNCTION__, octets_read, size);
> +		rc = -EINVAL;
> +	}
> +	mutex_unlock(&inode_info->lower_file_mutex);
> +	for (i = 0; i < size; i += PAGE_CACHE_SIZE) {
> +		struct page *data_page;
> +
> +		data_page = virt_to_page(data + i);
> +		flush_dcache_page(data_page);
> +		if (rc)
> +			ClearPageUptodate(data_page);
> +		else
> +			SetPageUptodate(data_page);
> +	}
> +	return rc;
> +}

It's ...  strange to do virt_to_page() to get at a pageframe (ie: it is
kernel memory) and to then run xxPageUptodate() against it (ie: it is a
pagecache page).

What's actually happening here?

Has it been tested on i386 highmem?

sparse might get upset about the mixture of kernel pointers and __user
pointers in this new code.

> +/**
> + * ecryptfs_read_lower_page_segment
> + * @page_for_ecryptfs: The page into which data for eCryptfs will be
> + *                     written
> + * @offset_in_page: Offset in @page_for_ecryptfs from which to start
> + *                  writing
> + * @size: The number of bytes to write into @page_for_ecryptfs
> + * @ecryptfs_inode: The eCryptfs inode
> + *
> + * Determines the byte offset in the file for the given page and
> + * offset within the page, maps the page, and makes the call to read
> + * the contents of @page_for_ecryptfs from the lower inode.
> + *
> + * Returns zero on success; non-zero otherwise
> + */
> +int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
> +				     pgoff_t page_index,
> +				     size_t offset_in_page, size_t size,
> +				     struct inode *ecryptfs_inode)
> +{
> +	char *virt;
> +	loff_t offset;
> +	int rc;
> +
> +	offset = ((page_index << PAGE_CACHE_SHIFT) + offset_in_page);

Another overflow bug.

> +	virt = kmap(page_for_ecryptfs);
> +	rc = ecryptfs_read_lower(virt, offset, size, ecryptfs_inode);
> +	kunmap(page_for_ecryptfs);
> +	return rc;
> +}
> +
> +/**
> + * ecryptfs_read
> + * @data: The virtual address into which to write the data read (and
> + *        possibly decrypted) from the lower file
> + * @offset: The offset in the decrypted view of the file from which to
> + *          read into @data
> + * @size: The number of bytes to read into @data
> + * @ecryptfs_file: The eCryptfs file from which to read
> + *
> + * Read an arbitrary amount of data from an arbitrary location in the
> + * eCryptfs page cache. This is done on an extent-by-extent basis;
> + * individual extents are decrypted and read from the lower page
> + * cache (via VFS reads). This function takes care of all the
> + * address translation to locations in the lower filesystem.
> + *
> + * Returns zero on success; non-zero otherwise
> + */
> +int ecryptfs_read(char *data, loff_t offset, size_t size,
> +		  struct file *ecryptfs_file)
> +{
> +	struct page *ecryptfs_page;
> +	char *ecryptfs_page_virt;
> +	u64 ecryptfs_file_size = i_size_read(ecryptfs_file->f_dentry->d_inode);

loff_t

> +	loff_t data_offset = 0;
> +	loff_t pos;
> +	int rc = 0;
> +
> +	if ((offset + size) > ecryptfs_file_size) {
> +		rc = -EINVAL;
> +		printk(KERN_ERR "%s: Attempt to read data past the end of the "
> +			"file; offset = [%lld]; size = [%td]; "
> +		       "ecryptfs_file_size = [%lld]\n",
> +		       __FUNCTION__, offset, size, ecryptfs_file_size);
> +		goto out;
> +	}
> +	pos = offset;
> +	while (pos < (offset + size)) {
> +		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
> +		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
> +		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
> +		size_t total_remaining_bytes = ((offset + size) - pos);
> +
> +		if (num_bytes > total_remaining_bytes)
> +			num_bytes = total_remaining_bytes;
> +		ecryptfs_page = ecryptfs_get1page(ecryptfs_file,
> +						  ecryptfs_page_idx);
> +		if (IS_ERR(ecryptfs_page)) {
> +			rc = PTR_ERR(ecryptfs_page);
> +			printk(KERN_ERR "%s: Error getting page at "
> +			       "index [%ld] from eCryptfs inode "
> +			       "mapping; rc = [%d]\n", __FUNCTION__,
> +			       ecryptfs_page_idx, rc);
> +			goto out;
> +		}
> +		rc = ecryptfs_decrypt_page(NULL /* placeholder for git-bisect */, ecryptfs_page);
> +		if (rc) {
> +			printk(KERN_ERR "%s: Error decrypting "
> +			       "page; rc = [%d]\n", __FUNCTION__, rc);
> +			page_cache_release(ecryptfs_page);
> +			goto out;
> +		}
> +		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
> +		memcpy((data + data_offset),
> +		       ((char *)ecryptfs_page_virt + start_offset_in_page),
> +		       num_bytes);
> +		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
> +		page_cache_release(ecryptfs_page);
> +		pos += num_bytes;
> +		data_offset += num_bytes;
> +	}
> +out:
> +	return rc;
> +}

