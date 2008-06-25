Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYFYQmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYFYQmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYFYQmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:42:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47204 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYFYQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:42:11 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, hugh@veritas.com, nickpiggin@yahoo.com.au
In-reply-to: <alpine.LFD.1.10.0806250928460.4769@hp.linux-foundation.org>
	(message from Linus Torvalds on Wed, 25 Jun 2008 09:30:50 -0700 (PDT))
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in
 invalidate_complete_page2()
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu> <alpine.LFD.1.10.0806250757150.4733@hp.linux-foundation.org> <E1KBWwW-0006nf-Qp@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806250928460.4769@hp.linux-foundation.org>
Message-Id: <E1KBY4N-0007YD-5n@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Jun 2008 18:42:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > We discussed this yesterday.  My conclusion was (which I still think
> > is true) that it can't be fixed in page_cache_pipe_buf_confirm(),
> > because due to current practice of not setting PG_error for I/O errors
> > for read, it is impossible to distinguish between a never-been-uptodate
> > page and a was-uptodate-before-invalidation page.
> 
> Umm. The regular read does this quite well. If something isn't up-to-date, 
> it tries a synchronous read. Once.

Exactly.  And if page_cache_pipe_buf_confirm() could do a synchronous
re-read of the page, that would work.  But it can't, because it only
has the page and not the file.

> > And it's not just an nfsd issue.  Userspace might also expect that if
> > a zero count is returned, that means it went beyond EOF, and not that
> > it should retry the splice, maybe it has better luck this time.
> 
> You're totally ignoring the real issue - user space that uses splice() 
> *knows* that it uses splice(). It's a private mmap(). 
> 
> NFSD, on the other hand, is supposed to act as NFSD. I think that 
> currently it assumes that nobody else modifies the files, which is 
> reasonable, but breaks with FUSE.

Not so.  Why couldn't someone modify an ext3 file, while nfsd is
holding the page?  Is that wrong?  I don't know, but it's not fuse
specific.

> But do you see? That's a NFSD/FUSE issue, not a splice one!

No, I think you are wrong.

Miklos
