Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYFYPaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYFYPaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYFYPaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:30:01 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60140 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYFYPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:30:01 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, hugh@veritas.com, nickpiggin@yahoo.com.au
In-reply-to: <alpine.LFD.1.10.0806250757150.4733@hp.linux-foundation.org>
	(message from Linus Torvalds on Wed, 25 Jun 2008 08:11:07 -0700 (PDT))
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in
 invalidate_complete_page2()
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu> <alpine.LFD.1.10.0806250757150.4733@hp.linux-foundation.org>
Message-Id: <E1KBWwW-0006nf-Qp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Jun 2008 17:29:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Clearing the uptodate page flag will cause page_cache_pipe_buf_confirm()
> > to return -ENODATA if that page was in the buffer.  This in turn will cause
> > splice() to return a short or zero count.
> 
> I really think we should just change splice itself at this point.

We discussed this yesterday.  My conclusion was (which I still think
is true) that it can't be fixed in page_cache_pipe_buf_confirm(),
because due to current practice of not setting PG_error for I/O errors
for read, it is impossible to distinguish between a never-been-uptodate
page and a was-uptodate-before-invalidation page.

And it's not just an nfsd issue.  Userspace might also expect that if
a zero count is returned, that means it went beyond EOF, and not that
it should retry the splice, maybe it has better luck this time.

So no, this is not just a fuse/nfsd issue, it applies to all
filesystems that do invalidate_inode_pages2 (there are 4-5 of them I
think).

And I don't see what I would be ignoring.  This is _not_ about
truncate(2), that is shared by all filesystems, and bugs wrt splice
would affect not just fuse.

Miklos
