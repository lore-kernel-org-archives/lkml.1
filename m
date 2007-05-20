Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXETXK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXETXK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 19:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbXETXKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 19:10:19 -0400
Received: from flpi102.sbcis.sbc.com ([207.115.20.71]:19015 "EHLO
	flpi102.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066AbXETXKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 19:10:19 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2007 19:10:18 EDT
X-ORBL: [76.211.248.48]
Message-ID: <4650D409.7090400@cowan.name>
Date: Sun, 20 May 2007 16:04:41 -0700
From: Micah Cowan <micah@cowan.name>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Use of SIGXFSZ outside of soft limits
References: <461BF183.10007@cowan.name> <20070410223829.23bc3d36@the-village.bc.nu> <461C04E5.4090809@cowan.name>
In-Reply-To: <461C04E5.4090809@cowan.name>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4A1B4EB1;
	url=http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0xECCF21C94A1B4EB1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micah Cowan wrote:
> Alan Cox wrote:
>>> [XSI] [Option Start] If the request would cause the file size to
>>> exceed the soft file size limit for the process and there is no room
>>> for any bytes to be written, the request shall fail and the
>>> implementation shall generate the SIGXFSZ signal for the thread.
>>> [Option End]
>>>  >>>
>>
>> This all depends which document and version you review. AIX for example
>> has or had the same behaviour as Linux which comes from the Large File
>> Summit and indeed our implementation was carefully tested to pass the
>> test suite of the time.
>>
>> SUSv3 seems to subsume the older LFS standards, and has adjusted them
>> somewhat in the merging so there may well be a good case for normalizing
>> our behaviour to match SUSv3. Run some tests and send patches.
>>
>> Alan
> 
> Thanks very much for this response, Alan.
> 
> I kind of suspected it might be something like this. I'm relieved to
> know that the original reasons for signaling that on other cases may no
> longer apply.
> 
> I'll plan to be back with patches, then! :)
> 
> -Micah
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Sorry it's taken this long. The patch seems to work well, and the changes are _quite_ trivial.

diff -ru linux-2.6.20.6-orig/fs/ncpfs/file.c linux-2.6.20.6/fs/ncpfs/file.c
--- linux-2.6.20.6-orig/fs/ncpfs/file.c	2007-04-06 13:02:48.000000000 -0700
+++ linux-2.6.20.6/fs/ncpfs/file.c	2007-04-14 11:16:56.000000000 -0700
@@ -203,7 +203,6 @@

 	if (pos + count > MAX_NON_LFS && !(file->f_flags&O_LARGEFILE)) {
 		if (pos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (count > MAX_NON_LFS - (u32)pos) {
@@ -212,7 +211,6 @@
 	}
 	if (pos >= inode->i_sb->s_maxbytes) {
 		if (count || pos > inode->i_sb->s_maxbytes) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 	}
diff -ru linux-2.6.20.6-orig/fs/reiserfs/file.c linux-2.6.20.6/fs/reiserfs/file.c
--- linux-2.6.20.6-orig/fs/reiserfs/file.c	2007-04-06 13:02:48.000000000 -0700
+++ linux-2.6.20.6/fs/reiserfs/file.c	2007-04-14 11:17:46.000000000 -0700
@@ -1323,7 +1323,6 @@
 	if (get_inode_item_key_version (inode) == KEY_FORMAT_3_5 &&
 	    *ppos + count > MAX_NON_LFS) {
 		if (*ppos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (count > MAX_NON_LFS - (unsigned long)*ppos)
diff -ru linux-2.6.20.6-orig/mm/filemap.c linux-2.6.20.6/mm/filemap.c
--- linux-2.6.20.6-orig/mm/filemap.c	2007-04-06 13:02:48.000000000 -0700
+++ linux-2.6.20.6/mm/filemap.c	2007-04-14 11:14:20.000000000 -0700
@@ -1971,7 +1971,6 @@
 	if (unlikely(*pos + *count > MAX_NON_LFS &&
 				!(file->f_flags & O_LARGEFILE))) {
 		if (*pos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (*count > MAX_NON_LFS - (unsigned long)*pos) {
@@ -1989,7 +1988,6 @@
 	if (likely(!isblk)) {
 		if (unlikely(*pos >= inode->i_sb->s_maxbytes)) {
 			if (*count || *pos > inode->i_sb->s_maxbytes) {
-				send_sig(SIGXFSZ, current, 0);
 				return -EFBIG;
 			}
 			/* zero-length writes at ->s_maxbytes are OK */
