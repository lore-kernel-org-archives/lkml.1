Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbYADLV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbYADLV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYADLVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:21:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:14688 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYADLVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:21:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qW9EKC4tzufZ6o/L4ZodCpKXo/FDrtWGyocbeiXxHko0PFw2n6h6M3f9xTd4tFnO82/FQ6iYfZaMraVNevGXDeJqPCBTconGOoXFNCLoOY+xhcBn+zD9QqBn67bMU+T3C3eogUR2xPk1jL/I35R6Gr+soBor6rlC1ffkiY2PCbg=
Date: Fri, 4 Jan 2008 19:25:22 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080104112522.GA4415@darkstar.te-china.tietoenator.com>
References: <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI> <477CEE1C.7020005@gmail.com> <20080104104755.GX27894@ZenIV.linux.org.uk> <20080104111357.GA3429@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104111357.GA3429@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 07:13:57PM +0800, Dave Young wrote:
> On Fri, Jan 04, 2008 at 10:47:55AM +0000, Al Viro wrote:
> > On Thu, Jan 03, 2008 at 03:15:56PM +0100, Jiri Slaby wrote:
> > 
> > > Can't say, the DVD seems to be OK, I don't know what was wrong (as I can say,
> > > this happened several times in the past yet and after reboot everything OK; I
> > > suspect gnome auto mounter -- multiple machines, several DVD ROMs, same disk
> > > with OS, similar errors, but that's too few to report).
> > 
> > It is -mm-specific, all right - fallout from
> > 	iget-stop-isofs-from-using-read_inode.patch
> > not covered in
> > 	iget-stop-isofs-from-using-read_inode-fix*
> > 
> > Callers in fs/isofs/namei.c are missed.
> 
> Yes, some isofs_iget return value should be handled, it is missed.
> 
> Maybe this:
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> ---
> fs/isofs/export.c |    8 ++++----
> fs/isofs/namei.c  |    4 ++--
> fs/isofs/rock.c   |    4 +++-
> 3 files changed, 9 insertions(+), 7 deletions(-)
> 
[snip]

I'm sorry for patch of building error, following one instead:

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
fs/isofs/export.c |    8 ++++----
fs/isofs/namei.c  |    4 ++--
fs/isofs/rock.c   |    4 +++-
3 files changed, 9 insertions(+), 7 deletions(-)

diff -upr linux/fs/isofs/export.c linux.new/fs/isofs/export.c
--- linux/fs/isofs/export.c	2008-01-04 18:54:40.000000000 +0800
+++ linux.new/fs/isofs/export.c	2008-01-04 19:18:45.000000000 +0800
@@ -26,8 +26,8 @@ isofs_export_iget(struct super_block *sb
 	if (block == 0)
 		return ERR_PTR(-ESTALE);
 	inode = isofs_iget(sb, block, offset);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(inode))
+		return (struct dentry *)inode;
 	if (is_bad_inode(inode)
 	    || (generation && inode->i_generation != generation))
 	{
@@ -110,8 +110,8 @@ static struct dentry *isofs_export_get_p
 	parent_inode = isofs_iget(child_inode->i_sb,
 				  parent_block,
 				  parent_offset);
-	if (parent_inode == NULL) {
-		rv = ERR_PTR(-EACCES);
+	if (IS_ERR(parent_inode)) {
+		rv = (struct dentry *)parent_inode;
 		goto out;
 	}
 
diff -upr linux/fs/isofs/namei.c linux.new/fs/isofs/namei.c
--- linux/fs/isofs/namei.c	2008-01-04 18:54:40.000000000 +0800
+++ linux.new/fs/isofs/namei.c	2008-01-04 19:18:45.000000000 +0800
@@ -179,9 +179,9 @@ struct dentry *isofs_lookup(struct inode
 	inode = NULL;
 	if (found) {
 		inode = isofs_iget(dir->i_sb, block, offset);
-		if (!inode) {
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return inode;
 		}
 	}
 	unlock_kernel();
diff -upr linux/fs/isofs/rock.c linux.new/fs/isofs/rock.c
--- linux/fs/isofs/rock.c	2008-01-04 18:54:40.000000000 +0800
+++ linux.new/fs/isofs/rock.c	2008-01-04 19:18:45.000000000 +0800
@@ -474,8 +474,10 @@ repeat:
 			    isofs_iget(inode->i_sb,
 				       ISOFS_I(inode)->i_first_extent,
 				       0);
-			if (!reloc)
+			if (IS_ERR(reloc)) {
+				ret = PTR_ERR(reloc);
 				goto out;
+			}
 			inode->i_mode = reloc->i_mode;
 			inode->i_nlink = reloc->i_nlink;
 			inode->i_uid = reloc->i_uid;
