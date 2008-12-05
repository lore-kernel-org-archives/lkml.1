Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYLEQxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYLEQxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYLEQxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:53:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbYLEQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:53:20 -0500
Date: Fri, 5 Dec 2008 08:52:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, bfields@fieldses.org,
       hugh@veritas.com, hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from fh_to_dentry()/fh_to_parent()
 [ver #4]
In-Reply-To: <20081205162318.20732.73054.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org>
References: <20081205162318.20732.73054.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2008, David Howells wrote:
>
> Returning NULL from fh_to_dentry() and fh_to_parent() is not permitted, so
> return -ESTALE instead.  exportfs_decode_fh() does not check for NULL, but
> will try to dereference it as IS_ERR() does not check for it.
> 
> The generic_fh_to_dentry() and generic_fh_to_parent() functions also no longer
> return NULL, but return -ESTALE instead.

I really don't like this one.

So just about every fh_to_dentry() returns NULL for some error case. 
Instead of considering that a problem, maybe it should tell us something.

There is _one_ single caller of that function afaik, why shouldn't we just 
teach the caller that dammit, lots of people want to just return NULL.

It's not like returning NULL doesn't make sense. Quite frankly, I think it 
makes a lot more sense than returning -ESTALE, which is a very unnatural 
error for most filesystems.

So quite frankly, I'd much rather just see the simpler patch. Have 
exportfs handle the case.

Are there other callers?

		Linus
---
 fs/exportfs/expfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 80246ba..e9b378c 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -369,6 +369,8 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
 	if (IS_ERR(result))
 		return result;
+	if (!result)
+		return ERR_PTR(-ESTALE);
 
 	if (S_ISDIR(result->d_inode->i_mode)) {
 		/*
