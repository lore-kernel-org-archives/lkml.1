Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbYF3SXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbYF3SXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYF3SX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:23:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33497 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYF3SX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:23:26 -0400
Date: Mon, 30 Jun 2008 14:19:27 -0400
Message-Id: <200806301819.m5UIJRhv030310@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Erez Zadok <ezk@cs.sunysb.edu>,
       Andrew Morton <akpm@linux-foundation.org>, mhalcrow@us.ibm.com,
       hooanon05@yahoo.co.jp, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking 
In-reply-to: Your message of "Sun, 29 Jun 2008 12:56:24 BST."
             <Pine.LNX.4.64.0806291244440.32708@blonde.site> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0806291244440.32708@blonde.site>, Hugh Dickins writes:
> On Sun, 29 Jun 2008, Christoph Hellwig wrote:
> > 
> > Btw, I hope fsstack doesn't rely on i_size having any particular
> > meaning.  As far as the VFS is concerned i_size is field only used by
> > the filesystem (or library routines like generic_file_*).
> 
> Interesting point.  I can't speak for fsstack itself (I'm not even
> sure if it's anything beyond fs/stack.c and the tag I used to identify
> where this patch lies); but certainly fs/stack.c doesn't use i_size
> for anything, just duplicates it from the lower filesystem.
> 
> unionfs (which I think you don't care for at all in general) does
> look as if it assumes it's the lower file size in a few places,
> when copying up or truncating.  Isn't that reasonable?  Wouldn't
> users make the same assumption?
> 
> Or are you saying that filesystems which don't support the usual
> meaning of inode->i_size (leave it 0?) would supply their own
> equivalent to vmtruncate() if they support truncation, and their
> own getattr which fills in stat->size from somewhere else.
> 
> Yes, I think you are saying that: unionfs may not play well with them.
> 
> Hugh

Hugh, yes, the only place in fsstack where i_size is used is to copy the
lower i_size to the upper one verbatim.  If this assumption is incorrect for
some lower file systems, then stackable file systems in general may have a
problem with this assumption; in that case, we'll need an alternative way to
"interpret" the lower i_size, and report the i_size in the upper inode (and
hence to the user).

Is there such an alternative?

BTW, ecryptfs may have a problem with this, b/c it uses i_size_read/write
b/t the lower and upper inodes.  If some filesystems have a different
interpretation for i_size, then stacking ecryptfs on top of them could be an
issue.  Mike?

Erez.
