Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbYADL1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbYADL1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYADL0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:26:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYADL0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:26:44 -0500
Date: Fri, 4 Jan 2008 11:26:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080104112642.GY27894@ZenIV.linux.org.uk>
References: <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI> <477CEE1C.7020005@gmail.com> <20080104104755.GX27894@ZenIV.linux.org.uk> <20080104111357.GA3429@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104111357.GA3429@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 07:13:57PM +0800, Dave Young wrote:
> > 	iget-stop-isofs-from-using-read_inode-fix*
> > 
> > Callers in fs/isofs/namei.c are missed.
> 
> Yes, some isofs_iget return value should be handled, it is missed.
> 
> Maybe this:

Not enough.  isofs_iget() still can return NULL; that needs to be converted to
ERR_PTR().

BTW, ERR_CAST is there for purpose...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff -urN foo1/fs/isofs/export.c foo2/fs/isofs/export.c
--- foo1/fs/isofs/export.c	2008-01-04 06:23:10.000000000 -0500
+++ foo2/fs/isofs/export.c	2008-01-04 06:18:52.000000000 -0500
@@ -26,11 +26,9 @@
 	if (block == 0)
 		return ERR_PTR(-ESTALE);
 	inode = isofs_iget(sb, block, offset);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode)
-	    || (generation && inode->i_generation != generation))
-	{
+	if (ERR_PTR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -110,7 +108,7 @@
 	parent_inode = isofs_iget(child_inode->i_sb,
 				  parent_block,
 				  parent_offset);
-	if (parent_inode == NULL) {
+	if (ERR_PTR(parent_inode)) {
 		rv = ERR_PTR(-EACCES);
 		goto out;
 	}
diff -urN foo1/fs/isofs/inode.c foo2/fs/isofs/inode.c
--- foo1/fs/isofs/inode.c	2008-01-04 06:23:33.000000000 -0500
+++ foo2/fs/isofs/inode.c	2008-01-04 06:15:43.000000000 -0500
@@ -1408,7 +1408,7 @@
 	long ret;
 
 	if (offset >= 1ul << sb->s_blocksize_bits)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	data.block = block;
 	data.offset = offset;
@@ -1418,7 +1418,10 @@
 	inode = iget5_locked(sb, hashval, &isofs_iget5_test,
 				&isofs_iget5_set, &data);
 
-	if (inode && (inode->i_state & I_NEW)) {
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	if (inode->i_state & I_NEW) {
 		ret = isofs_read_inode(inode);
 		if (ret < 0) {
 			iget_failed(inode);
diff -urN foo1/fs/isofs/namei.c foo2/fs/isofs/namei.c
--- foo1/fs/isofs/namei.c	2008-01-04 06:23:10.000000000 -0500
+++ foo2/fs/isofs/namei.c	2008-01-04 06:19:20.000000000 -0500
@@ -179,9 +179,9 @@
 	inode = NULL;
 	if (found) {
 		inode = isofs_iget(dir->i_sb, block, offset);
-		if (!inode) {
+		if (ERR_PTR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
diff -urN foo1/fs/isofs/rock.c foo2/fs/isofs/rock.c
--- foo1/fs/isofs/rock.c	2008-01-04 06:23:10.000000000 -0500
+++ foo2/fs/isofs/rock.c	2008-01-04 06:20:41.000000000 -0500
@@ -474,7 +474,7 @@
 			    isofs_iget(inode->i_sb,
 				       ISOFS_I(inode)->i_first_extent,
 				       0);
-			if (!reloc)
+			if (ERR_PTR(reloc))
 				goto out;
 			inode->i_mode = reloc->i_mode;
 			inode->i_nlink = reloc->i_nlink;
