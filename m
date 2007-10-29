Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbXJ2Nla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbXJ2Nla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXJ2NlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:41:20 -0400
Received: from ppsw-8.csi.cam.ac.uk ([131.111.8.138]:46792 "EHLO
	ppsw-8.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbXJ2NlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:41:20 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Cc: LKML <linux-kernel@vger.kernel.org>,
       ntfs-dev <linux-ntfs-dev@lists.sourceforge.net>
Message-Id: <DD2C80EE-D28D-4487-AA68-BB49F91098A9@cam.ac.uk>
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Mike Galbraith <efault@gmx.de>
In-Reply-To: <4E61D235-B8E8-43DF-96A5-B3169E6AB223@cam.ac.uk>
Content-Type: multipart/mixed; boundary=Apple-Mail-1-609708939
Subject: Re: [Linux-NTFS-Dev] 2.6.23 regression: second access of empty ntfs file leads to D	state hang
Mime-Version: 1.0 (Apple Message framework v912)
Date: Mon, 29 Oct 2007 13:41:13 +0000
References: <1193638086.7409.21.camel@Homer.simpson.net> <E3E758D0-25AC-45B8-9BAB-F8CDF75AF3CA@cam.ac.uk> <1193658311.7324.2.camel@Homer.simpson.net> <4E61D235-B8E8-43DF-96A5-B3169E6AB223@cam.ac.uk>
X-Mailer: Apple Mail (2.912)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-1-609708939
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit

oops. forgot to attach the patch...   Here it is...

Best regards,

	Anton


--Apple-Mail-1-609708939
Content-Disposition: attachment;
	filename=ntfstest.diff
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="ntfstest.diff"
Content-Transfer-Encoding: 7bit

diff -urNp linux-2.6.23.1/fs/ntfs/attrib.c linux-2.6.23.1.new/fs/ntfs/attrib.c
--- linux-2.6.23.1/fs/ntfs/attrib.c	2007-10-12 17:43:44.000000000 +0100
+++ linux-2.6.23.1.new/fs/ntfs/attrib.c	2007-10-29 13:21:43.000000000 +0000
@@ -102,11 +102,19 @@ int ntfs_map_runlist_nolock(ntfs_inode *
 	if (!ctx) {
 		ctx_is_temporary = ctx_needs_reset = true;
 		m = map_mft_record(base_ni);
-		if (IS_ERR(m))
+		if (IS_ERR(m)) {
+			ntfs_error(ni->vol->sb, "map_mft_record() failed for "
+					"inode 0x%lx, vcn 0x%llx, error %d.",
+					ni->mft_no, (unsigned long long)vcn,
+					PTR_ERR(m));
 			return PTR_ERR(m);
+		}
 		ctx = ntfs_attr_get_search_ctx(base_ni, m);
 		if (unlikely(!ctx)) {
 			err = -ENOMEM;
+			ntfs_error(ni->vol->sb, "Failed to allocate search "
+					"context for inode 0x%lx, vcn 0x%llx.",
+					ni->mft_no, (unsigned long long)vcn);
 			goto err_out;
 		}
 	} else {
@@ -165,6 +173,10 @@ int ntfs_map_runlist_nolock(ntfs_inode *
 		err = ntfs_attr_lookup(ni->type, ni->name, ni->name_len,
 				CASE_SENSITIVE, vcn, NULL, 0, ctx);
 		if (unlikely(err)) {
+			ntfs_error(ni->vol->sb, "ntfs_attr_lookup() failed for "
+					"inode 0x%lx, vcn 0x%llx, error %d.",
+					ni->mft_no, (unsigned long long)vcn,
+					err);
 			if (err == -ENOENT)
 				err = -EIO;
 			goto err_out;
@@ -183,13 +195,21 @@ int ntfs_map_runlist_nolock(ntfs_inode *
 		end_vcn = sle64_to_cpu(a->data.non_resident.allocated_size) >>
 				ni->vol->cluster_size_bits;
 	if (unlikely(vcn >= end_vcn)) {
+		ntfs_error(ni->vol->sb, "vcn 0x%llx >= end_vcn 0x%llx for "
+				"inode 0x%lx, error %d.",
+				(unsigned long long)vcn,
+				(unsigned long long)end_vcn, ni->mft_no, err);
 		err = -ENOENT;
 		goto err_out;
 	}
 	rl = ntfs_mapping_pairs_decompress(ni->vol, a, ni->runlist.rl);
-	if (IS_ERR(rl))
+	if (IS_ERR(rl)) {
 		err = PTR_ERR(rl);
-	else
+		ntfs_error(ni->vol->sb, "ntfs_mapping_pairs_decompress() "
+				"failed for inode 0x%lx, vcn 0x%llx, error "
+				"%d.", ni->mft_no, (unsigned long long)vcn,
+				err);
+	} else
 		ni->runlist.rl = rl;
 err_out:
 	if (ctx_is_temporary) {

--Apple-Mail-1-609708939
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit




On 29 Oct 2007, at 13:39, Anton Altaparmakov wrote:

> Hi Mike,
>
> Thanks for the files.  That is really odd.  And you are sure this  
> just works with 2.6.22.10 on the exact same file?  Have you run   
> "chkdsk /f /v /x" on the NTFS volume from Windows?
>
> Would you be able to apply the attached patch to your 2.6.23.1  
> kernel and try again and then send me the NTFS error messages?  The  
> patch should cause more verbose error reporting to happen...  Thanks!
>
> Best regards,
>
> 	Anton
>
> On 29 Oct 2007, at 11:45, Mike Galbraith wrote:
>> On Mon, 2007-10-29 at 10:31 +0000, Anton Altaparmakov wrote:
>>
>>> Could you post the complete dmesg output, please?
>>
>> Attached.  This is after a reboot though, but a fresh attempt to  
>> sum the
>> 0 length file, so the NTFS message is there.
>>
>>> Nothing related has changed in the NTFS driver between 2.6.22.10 and
>>> 2.6.23 so I expect something else to be at fault here.
>>>
>>> Could you post your .config as well, please?
>>
>> Also attached.
>>
>> -Mike
>
> -- 
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
>

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


--Apple-Mail-1-609708939--
