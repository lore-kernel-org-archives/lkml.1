Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbYLERnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbYLERnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYLERmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:42:53 -0500
Received: from mail.fieldses.org ([66.93.2.214]:33726 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYLERmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:42:51 -0500
Date: Fri, 5 Dec 2008 12:42:28 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from
	fh_to_dentry()/fh_to_parent() [ver #4]
Message-ID: <20081205174228.GC29227@fieldses.org>
References: <20081205162318.20732.73054.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 08:52:13AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 5 Dec 2008, David Howells wrote:
> >
> > Returning NULL from fh_to_dentry() and fh_to_parent() is not permitted, so
> > return -ESTALE instead.  exportfs_decode_fh() does not check for NULL, but
> > will try to dereference it as IS_ERR() does not check for it.
> > 
> > The generic_fh_to_dentry() and generic_fh_to_parent() functions also no longer
> > return NULL, but return -ESTALE instead.
> 
> I really don't like this one.
> 
> So just about every fh_to_dentry() returns NULL for some error case. 
> Instead of considering that a problem, maybe it should tell us something.
> 
> There is _one_ single caller of that function afaik, why shouldn't we just 
> teach the caller that dammit, lots of people want to just return NULL.
> 
> It's not like returning NULL doesn't make sense. Quite frankly, I think it 
> makes a lot more sense than returning -ESTALE, which is a very unnatural 
> error for most filesystems.
> 
> So quite frankly, I'd much rather just see the simpler patch. Have 
> exportfs handle the case.
>
> Are there other callers?

Not of fh_to_dentry(), but it looks like fh_to_parent() is the same.  So
you'd want the below.

This is partially reverting 440037287c5, which appears to have also do
some changing of NULLs to ESTALEs which we might also want to reconsider
at some point.  Maybe Christoph could explain what the rationale was.

--b.

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 80246ba..890e018 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -367,6 +367,8 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 	 * Try to get any dentry for the given file handle from the filesystem.
 	 */
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
+	if (!result)
+		result = ERR_PTR(-ESTALE);
 	if (IS_ERR(result))
 		return result;
 
@@ -420,6 +422,8 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 
 		target_dir = nop->fh_to_parent(mnt->mnt_sb, fid,
 				fh_len, fileid_type);
+		if (!target_dir)
+			goto err_result;
 		err = PTR_ERR(target_dir);
 		if (IS_ERR(target_dir))
 			goto err_result;
