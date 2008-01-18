Return-Path: <linux-kernel-owner+w=401wt.eu-S1763381AbYARSAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763381AbYARSAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYARSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:00:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbYARSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:00:10 -0500
Date: Fri, 18 Jan 2008 09:58:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, salikhmetov@gmail.com,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
In-Reply-To: <1200651958.5920.12.camel@twins>
Message-ID: <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>  <12006091211208-git-send-email-salikhmetov@gmail.com>  <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>  <1200651337.5920.9.camel@twins> <1200651958.5920.12.camel@twins>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jan 2008, Peter Zijlstra wrote:
> 
> Bah, and will break on s390... so we'd need a page_mkclean() variant
> that doesn't actually clear dirty.

No, we simply want to not play all these very expensive games with dirty 
in the first place.

Guys, mmap access times aren't important enough for this. It's not 
specified closely enough, and people don't care enough.

Of the patches around so far, the best one by far seems to be the simple 
four-liner from Miklos.

And even in that four-liner, I suspect that the *last* two lines are 
actually incorrect: there's no point in updating the file time when the 
page *becomes* dirty, we should update the file time when it is marked 
clean, and "msync(MS_SYNC)" should update it as part of *that*.

So I think the file time update should be part of just the page writeout 
logic, not by msync() or page faulting itself or anything like that.

		Linus
