Return-Path: <linux-kernel-owner+w=401wt.eu-S1032692AbXHMSLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032692AbXHMSLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974245AbXHMR5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:57:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S974194AbXHMR4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:56:55 -0400
Message-ID: <46C09AE0.5010902@redhat.com>
Date: Mon, 13 Aug 2007 12:54:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, security@kernel.org
Subject: [PATCH V3] limit minixfs printks on corrupted dir i_size, CVE-2006-6058
References: <8Qlff-3jX-29@gated-at.bofh.it> <8Qn7m-6li-27@gated-at.bofh.it> <E1IJFr4-0000is-Ox@be1.lrz>
In-Reply-To: <E1IJFr4-0000is-Ox@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:

> Warning: I'm only looking at the patch.
>
> You are supposed to print an error message for a user, not to write in a
> chat window to a 1337 script kiddie. OK, you just matched the current style,
> and your patch is IMHO OK for a quick security fix, but:
>
> - Security fixes should be CCed to the security mailing list, shouldn't they?
>   (It might be security@ or stable@, I'll remember tomorrow, but then I'd
>    forget to comment)
> - Imagine you have three mounts containing a minix fs, how can you tell which
>   one is the the defective one?
> - The message says "minix_bmap", while the patch suggests it's in
>   block_to_path. Therefore I asume "minix_bmap" to have only random
>   informational value.
> - Does block < 0 or block > $size make a difference?
> - the printk lacks the loglevel.
> - Asuming minix supports error handling, shouldn't it do something?
>
> I'd suggest a message saying something like "minix: Bad block address on
> device 08:15, needs fsck".
>   
Ok, do you like this slightly better?  It states the subsystem, the 
function with the error, the block nr. in the case of a too-large block,
and the block device on which the error occurred.  Honestly minix.fsck
doesn't handle the situation well either, so at this point I hesitate
to recommend it in the print.  :)

--------------------------

This attempts to address CVE-2006-6058
http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6058
 
first reported at http://projects.info-pull.com/mokb/MOKB-17-11-2006.html

Essentially a corrupted minix dir inode reporting a very large
i_size will loop for a very long time in minix_readdir, minix_find_entry,
etc, because on EIO they just move on to try the next page.  This is
under the BKL, printk-storming as well.  This can lock up the machine
for a very long time.  Simply ratelimiting the printks gets things back
under control.  Make the message a bit more informative while we're here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.22-rc4/fs/minix/itree_v1.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/minix/itree_v1.c
+++ linux-2.6.22-rc4/fs/minix/itree_v1.c
@@ -23,11 +23,16 @@ static inline block_t *i_data(struct ino
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
+	char b[BDEVNAME_SIZE];
 
 	if (block < 0) {
-		printk("minix_bmap: block<0\n");
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
+			block, bdevname(inode->i_sb->s_bdev, b));
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("MINIX-fs: block_to_path: "
+			       "block %ld too big on dev %s\n",
+				block, bdevname(inode->i_sb->s_bdev, b));
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 512) {
Index: linux-2.6.22-rc4/fs/minix/itree_v2.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/minix/itree_v2.c
+++ linux-2.6.22-rc4/fs/minix/itree_v2.c
@@ -23,12 +23,17 @@ static inline block_t *i_data(struct ino
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
+	char b[BDEVNAME_SIZE];
 	struct super_block *sb = inode->i_sb;
 
 	if (block < 0) {
-		printk("minix_bmap: block<0\n");
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
+			block, bdevname(sb->s_bdev, b));
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksize)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("MINIX-fs: block_to_path: "
+			       "block %ld too big on dev %s\n",
+				block, bdevname(sb->s_bdev, b));
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 256) {


