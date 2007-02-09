Return-Path: <linux-kernel-owner+w=401wt.eu-S1946123AbXBIWSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946123AbXBIWSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946120AbXBIWSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:18:32 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:58136 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946123AbXBIWSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:18:31 -0500
Message-ID: <45CCF33F.1000605@yahoo.fr>
Date: Fri, 09 Feb 2007 23:18:39 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------060703070002060709080204"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060703070002060709080204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Andrew Morton a écrit :
> factor-outstanding-i-o-error-handling.patch
> factor-outstanding-i-o-error-handling-tidy.patch
>   

I still like them. But the original problem is still present.

> sync_sb_inodes-propagate-errors.patch
>   

You explained in http://lkml.org/lkml/2007/1/2/238 that the mapping 
flags should be set at the lowest level, but with this change I have a 
hard time choosing a place to stick it. I don't like when a function 
both sets the mapping flags and returns an error code, I think it should 
be mutually exclusive, so that we know what to do (propagate the return 
code?) and what to expect (are the mapping flags up to date?), which 
seemed to be the case before this patch. For instance there is no point 
in propagating an error return code up to sys_sync() as it can only drop it.

The call trace that cleared the flags, the origin of the problem, is:

void do_sync(1)
void sync_inodes(1)
void __sync_inodes(1)
void sync_inodes_sb(sb, 1)
void sync_sb_inodes(sb, WB_SYNC_ALL)
int __writeback_single_inode(inode, WB_SYNC_ALL)
int __sync_single_inode(inode, WB_SYNC_ALL)
int filemap_fdatawait(mapping)
int wait_on_page_writeback_range(mapping)
int test_and_clear(...)


re-setting the flag at a too low level, would mean it is still set after 
a msync() or fsync() that could return the status to its caller. My 
interpretation is that low level functions up to 
__writeback_single_inode() can be used by fsync() and the like that can 
return the error to their caller, unlike high level functions starting 
at sync_sb_inodes() that don't need a return value as their caller can 
do nothing with it. So re-setting the flag in sync_sb_inodes() just 
after __writeback_single_inode() looks right to me, and I propose the 
exact same patch as the first time.


> block_write_full_page-handle-enospc.patch
>   

It seems to me that __block_write_full_page is always called more or 
less directly from __mpage_writepage, and the latter handles enospc in 
the mapping flags. So I am not sure this patch is needed.

Thanks.

-- 
Guillaume


--------------060703070002060709080204
Content-Type: text/x-patch;
 name="sync_sb_inodes_handle_error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sync_sb_inodes_handle_error.patch"

I/O errors could go unnoticed when syncing, for example the following code could
write a file bigger than 10Mib on a 10Mib filesystem. With this patch, msync()
will report the error originally encountered by sync(). Tuning the number of
sync may be needed to reproduce the bug.
make_file.c:

#include <unistd.h>
#include <sys/fcntl.h>
#include <sys/mman.h>
#include <string.h>
#include <stdio.h>

#define NR_SYNC 3 /* Adjust me if needed */
#define SIZE ((10 << 20) + (100 << 10))

int main(void)
{
	int i, fd;
	char *mapping;
	fd = open("mnt/file", O_RDWR | O_CREAT, 0600);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	if (ftruncate(fd, SIZE) < 0) {
		perror("ftruncate");
		return 1;
	}

	mapping = mmap(NULL, SIZE, PROT_WRITE, MAP_SHARED, fd, 0);
	if (mapping == MAP_FAILED) {
		perror("mmap");
		return 1;
	}

	memset(mapping, 0xFF, SIZE);

	for (i = 0; i < NR_SYNC; i++)
		sync();

	if (msync(mapping, SIZE, MS_SYNC) < 0) {
		perror("msync");
		return 1;
	}

	if (close(fd) < 0) {
		perror("close");
		return 1;
	}

	puts("File written successfully => bad!\n");
	return 0;
}

#!/bin/sh

dd if=/dev/zero of=fs.10M bs=10M count=0 seek=1
mkfs.ext2 -qF fs.10M
mkdir mnt
mount fs.10M mnt -o loop
./make_file

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

 fs-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -r ecb3a0d111ec fs/fs-writeback.c
--- a/fs/fs-writeback.c	Fri Feb 09 15:31:50 2007 +0100
+++ b/fs/fs-writeback.c	Fri Feb 09 23:10:47 2007 +0100
@@ -327,6 +327,7 @@ sync_sb_inodes(struct super_block *sb, s
 		struct address_space *mapping = inode->i_mapping;
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		long pages_skipped;
+		int ret;
 
 		if (!bdi_cap_writeback_dirty(bdi)) {
 			list_move(&inode->i_list, &sb->s_dirty);
@@ -376,7 +377,8 @@ sync_sb_inodes(struct super_block *sb, s
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
-		__writeback_single_inode(inode, wbc);
+		ret = __writeback_single_inode(inode, wbc);
+		mapping_set_error(mapping, ret);
 		if (wbc->sync_mode == WB_SYNC_HOLD) {
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);


--------------060703070002060709080204--
