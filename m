Return-Path: <linux-kernel-owner+w=401wt.eu-S1765374AbYEHQtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765374AbYEHQtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765120AbYEHQtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:49:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765051AbYEHQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:49:16 -0400
Date: Thu, 8 May 2008 12:49:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 04/24] reiserfs: dont call notify_change
Message-ID: <20080508164910.GA13914@infradead.org>
References: <20080506091327.259950960@szeredi.hu> <20080506091410.380189145@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506091410.380189145@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 11:13:31AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Reiserfs calls notify_change() on it's private extended attribute
> files to resize and change ownership of these files.  Replace with
> reiserfs_setattr().
> 
> This is equivalent, except that:
> 
>  - i_alloc_sem locking is not performed around reiserfs_setattr() when
>    the size is changed
>  - security_inode_setattr() is not called before reiserfs_setattr()
>  - fsnotify_change() is not called after reiserfs_setattr()
> 
> None of the above is necessary, since the files are private to
> reiserfs and inaccessible from userspace.
> 
> Also remove setting of ctime on the xattr files.

I think splitting out the ATTR_SIZE case of reiserfs_setattr into
a separate helper would be better.  That would a) avoid the useless
c and mtime updates on the attribue inode and b) clean up
reiserfs_setattr a little bit.

