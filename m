Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbYFYPMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbYFYPMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYFYPMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:12:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbYFYPMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:12:20 -0400
Date: Wed, 25 Jun 2008 08:11:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in
 invalidate_complete_page2()
In-Reply-To: <20080625124121.839734708@szeredi.hu>
Message-ID: <alpine.LFD.1.10.0806250757150.4733@hp.linux-foundation.org>
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jun 2008, Miklos Szeredi wrote:
> 
> Clearing the uptodate page flag will cause page_cache_pipe_buf_confirm()
> to return -ENODATA if that page was in the buffer.  This in turn will cause
> splice() to return a short or zero count.

I really think we should just change splice itself at this point.

The VM people may end up removing the clearing of the uptodate bit for 
other reasons, but there's no way I'll do this kind of thing which affects 
unknown number of cases for just the splice kind of reason, when we could 
just change the one place you care about right now - which is just
FUSE/NFSD/page_cache_pipe_buf_confirm.

I also really don't think this even fixes the problems you have with 
FUSE/NFSD - because you'll still be reading zeroes for a truncated file. 
Yes, you get the rigth counts, but you don't get the right data.

(And no, your previous patch that removed the asnchronous stuff and the 
pipe_buf_confirm entirely didn't fix it _either_ - it's simply unavoidable 
when you just pass unlocked pages around. There is no serialization with 
other people doing truncates etc)

That's "correct" from a splice() kind of standpoint (it's essentially a 
temporary mmap() with MAP_PRIVATE), but the thing is, it just sounds like 
the whole "page went away" thing is a more fundamental issue. It sounds 
like nfds should hold a read-lock on the file while it has any IO in 
flight, or something like that.

IOW, I don't think your patch really is in the right area. I *do* agree 
that page_cache_pipe_buf_confirm() itself probably is worth changing, but 
I think you're trying to treat some of the individual symptoms here (and 
not even all), and there's a more fundamental underlying issue that you're 
not loooking at.

Maybe.

		Linus
