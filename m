Return-Path: <linux-kernel-owner+w=401wt.eu-S1762559AbXJDXWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762559AbXJDXWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbXJDXWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:22:36 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:50888 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbXJDXWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:22:35 -0400
Message-ID: <470575AE.9060902@namesys.com>
Date: Fri, 05 Oct 2007 03:22:22 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@clusterfs.com>
CC: Dave Hansen <haveblue@us.ibm.com>, Zan Lynx <zlynx@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       reiserfs-devel <reiserfs-devel@vger.kernel.org>,
       hch <hch@infradead.org>
Subject: [patch] reiser4: do not allocate struct file on stack
References: <1190930060.7667.5.camel@localhost>	 <20070928013024.c7522542.akpm@linux-foundation.org> <1190996517.7344.79.camel@localhost> <46FD8298.5020804@namesys.com>
In-Reply-To: <46FD8298.5020804@namesys.com>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------080606060105080104080505"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080606060105080104080505
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Edward Shishkin wrote:

> Dave Hansen wrote:
>
...

>>
>> I think that stack allocation is a pretty nasty trick for a structure
>> that's supposed to be pretty persistent and dynamically allocated, and
>> is certainly something that needs to get fixed up in a proper way.
>>
>>
>
> agreed.
>
>> This works around the problem for now, but this could potentially cause
>> more bugs any time we add some member to 'struct file' and depend on its
>> state being sane anywhere in the VFS. If there's a list anywhere of
>> merge-stopper reiser4 bugs around, this should probably go in there.
>>
>>
>
> will be fixed.
>

The promised fixup is attached.
Andrew, please apply.

Thanks,
Edward.

--------------080606060105080104080505
Content-Type: text/x-patch;
 name="reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate-2.patch"

Do not allocate struct file on stack, pass the persistent one instead.

Signed-off-by: Edward Shishkin <edward@namesys.com>
---
 linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/file.c            |   35 ++++------
 linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/file.h            |    2 
 linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/tail_conversion.c |   23 ++----
 3 files changed, 26 insertions(+), 34 deletions(-)

--- linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/file.c.orig
+++ linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/file.c
@@ -566,23 +566,18 @@
  * items or add them to represent a hole at the end of file. The caller has to
  * obtain exclusive access to the file.
  */
-static int truncate_file_body(struct inode *inode, loff_t new_size)
+static int truncate_file_body(struct inode *inode, struct iattr *attr)
 {
 	int result;
+	loff_t new_size = attr->ia_size;
 
 	if (inode->i_size < new_size) {
 		/* expanding truncate */
-		struct dentry dentry;
-		struct file file;
-		struct unix_file_info *uf_info;
+		struct file * file = attr->ia_file;
+		struct unix_file_info *uf_info = unix_file_inode_data(inode);
+
+		assert("edward-1532", attr->ia_valid & ATTR_FILE);
 
-		dentry.d_inode = inode;
-		file.f_dentry = &dentry;
-		file.private_data = NULL;
-		file.f_pos = new_size;
-		file.private_data = NULL;
-		file.f_vfsmnt = NULL;
-		uf_info = unix_file_inode_data(inode);
 		result = find_file_state(inode, uf_info);
 		if (result)
 			return result;
@@ -615,19 +610,19 @@
 						return result;
 				}
 			}
-			result = reiser4_write_extent(&file, NULL, 0,
+			result = reiser4_write_extent(file, NULL, 0,
 						      &new_size);
 			if (result)
 				return result;
 			uf_info->container = UF_CONTAINER_EXTENTS;
 		} else {
 			if (uf_info->container ==  UF_CONTAINER_EXTENTS) {
-				result = reiser4_write_extent(&file, NULL, 0,
+				result = reiser4_write_extent(file, NULL, 0,
 							      &new_size);
 				if (result)
 					return result;
 			} else {
-				result = reiser4_write_tail(&file, NULL, 0,
+				result = reiser4_write_tail(file, NULL, 0,
 							    &new_size);
 				if (result)
 					return result;
@@ -636,10 +631,10 @@
 		}
 		BUG_ON(result > 0);
 		INODE_SET_FIELD(inode, i_size, new_size);
-		file_update_time(&file);
+		file_update_time(file);
 		result = reiser4_update_sd(inode);
 		BUG_ON(result != 0);
-		reiser4_free_file_fsdata(&file);
+		reiser4_free_file_fsdata(file);
 	} else
 		result = shorten_file(inode, new_size);
 	return result;
@@ -2092,7 +2087,7 @@
 		 * first item is formatting item, therefore there was
 		 * incomplete extent2tail conversion. Complete it
 		 */
-		result = extent2tail(unix_file_inode_data(inode));
+		result = extent2tail(file, unix_file_inode_data(inode));
 	else
 		result = -EIO;
 
@@ -2372,7 +2367,7 @@
 		    uf_info->container == UF_CONTAINER_EXTENTS &&
 		    !should_have_notail(uf_info, inode->i_size) &&
 		    !rofs_inode(inode)) {
-			result = extent2tail(uf_info);
+			result = extent2tail(file, uf_info);
 			if (result != 0) {
 				warning("nikita-3233",
 					"Failed (%d) to convert in %s (%llu)",
@@ -2638,7 +2633,7 @@
 	if (result == 0)
 		result = safe_link_add(inode, SAFE_TRUNCATE);
 	if (result == 0)
-		result = truncate_file_body(inode, attr->ia_size);
+		result = truncate_file_body(inode, attr);
 	if (result)
 		warning("vs-1588", "truncate_file failed: oid %lli, "
 			"old size %lld, new size %lld, retval %d",
@@ -2724,7 +2719,7 @@
 	/* truncate file bogy first */
 	uf_info = unix_file_inode_data(inode);
 	get_exclusive_access(uf_info);
-	result = truncate_file_body(inode, 0 /* size */ );
+	result = shorten_file(inode, 0 /* size */ );
 	drop_exclusive_access(uf_info);
 
 	if (result)
--- linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/file.h.orig
+++ linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/file.h
@@ -237,7 +237,7 @@
 #define WRITE_GRANULARITY 32
 
 int tail2extent(struct unix_file_info *);
-int extent2tail(struct unix_file_info *);
+int extent2tail(struct file *, struct unix_file_info *);
 
 int goto_right_neighbor(coord_t *, lock_handle *);
 int find_or_create_extent(struct page *);
--- linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/tail_conversion.c.orig
+++ linux-2.6.23-rc8-mm2/fs/reiser4/plugin/file/tail_conversion.c
@@ -546,7 +546,7 @@
 
 /* for every page of file: read page, cut part of extent pointing to this page,
    put data of page tree by tail item */
-int extent2tail(struct unix_file_info *uf_info)
+int extent2tail(struct file * file, struct unix_file_info *uf_info)
 {
 	int result;
 	struct inode *inode;
@@ -644,20 +644,17 @@
 			/* last page can be incompleted */
 			count = (inode->i_size & ~PAGE_CACHE_MASK);
 		while (count) {
-			struct dentry dentry;
-			struct file file;
-			loff_t pos;
-
-			dentry.d_inode = inode;
-			file.f_dentry = &dentry;
-			file.private_data = NULL;
-			file.f_pos = start_byte;
-			file.private_data = NULL;
-			pos = start_byte;
-			result = reiser4_write_tail(&file,
+			loff_t pos = start_byte;
+
+			assert("edward-1533",
+			       file != NULL && file->f_dentry != NULL);
+			assert("edward-1534",
+			       file->f_dentry->d_inode == inode);
+
+			result = reiser4_write_tail(file,
 						    (char __user *)kmap(page),
 						    count, &pos);
-			reiser4_free_file_fsdata(&file);
+			reiser4_free_file_fsdata(file);
 			if (result <= 0) {
 				warning("", "reiser4_write_tail failed");
 				page_cache_release(page);

--------------080606060105080104080505--
