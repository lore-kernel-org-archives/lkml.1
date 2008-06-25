Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbYFYQbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbYFYQbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYFYQbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:31:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbYFYQbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:31:37 -0400
Date: Wed, 25 Jun 2008 09:30:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in
 invalidate_complete_page2()
In-Reply-To: <E1KBWwW-0006nf-Qp@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0806250928460.4769@hp.linux-foundation.org>
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu> <alpine.LFD.1.10.0806250757150.4733@hp.linux-foundation.org> <E1KBWwW-0006nf-Qp@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jun 2008, Miklos Szeredi wrote:
> 
> We discussed this yesterday.  My conclusion was (which I still think
> is true) that it can't be fixed in page_cache_pipe_buf_confirm(),
> because due to current practice of not setting PG_error for I/O errors
> for read, it is impossible to distinguish between a never-been-uptodate
> page and a was-uptodate-before-invalidation page.

Umm. The regular read does this quite well. If something isn't up-to-date, 
it tries a synchronous read. Once.

> And it's not just an nfsd issue.  Userspace might also expect that if
> a zero count is returned, that means it went beyond EOF, and not that
> it should retry the splice, maybe it has better luck this time.

You're totally ignoring the real issue - user space that uses splice() 
*knows* that it uses splice(). It's a private mmap(). 

NFSD, on the other hand, is supposed to act as NFSD. I think that 
currently it assumes that nobody else modifies the files, which is 
reasonable, but breaks with FUSE.

But do you see? That's a NFSD/FUSE issue, not a splice one!

		Linus
