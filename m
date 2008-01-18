Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbYARTh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbYARTh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYARThS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:37:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbYARThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:37:16 -0500
Date: Fri, 18 Jan 2008 11:35:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: peterz@infradead.org, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
In-Reply-To: <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>  <12006091211208-git-send-email-salikhmetov@gmail.com>  <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>  <1200651337.5920.9.camel@twins> <1200651958.5920.12.camel@twins>
 <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org> <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org> <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801181106340.2957@woody.linux-foundation.org>
 <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jan 2008, Miklos Szeredi wrote:
> 
> What I'm saying is that the times could be left un-updated for a long
> time if program doesn't do munmap() or msync(MS_SYNC) for a long time.

Sure.

But in those circumstances, the programmer cannot depend on the mtime 
*anyway* (because there is no synchronization), so what's the downside?

Let's face it, there's exactly three possible solutions:

 - the insane one: trap EVERY SINGLE instruction that does a write to the 
   page, and update mtime each and every time.

   This one is so obviously STUPID that it's not even worth discussing 
   further, except to say that "yes, there is an 'exact' algorithm, but 
   no, we are never EVER going to use it".

 - the non-exact solutions that don't give you mtime updates every time 
   a write to the page happens, but give *some* guarantees for things that 
   will update it.

   This is the one I think we can do, and the only things a programmer can 
   impact using it is "msync()" and "munmap()", since no other operations 
   really have any thing to do with it in a programmer-visible way (ie a 
   normal "sync" operation may happen in the background and has no 
   progam-relevant timing information)

   Other things *may* or may not update mtime (some filesystems - take
   most networked one as an example - will *always* update mtime on the 
   server on writeback, so we cannot ever guarantee that nothing but 
   msync/munmap does so), but at least we'll have a minimum set of things 
   that people can depend on.

 - the "we don't care at all solutions".

   mmap(MAP_WRITE) doesn't really update times reliably after the write 
   has happened (but might do it *before* - maybe the mmap() itself does).

Those are the three choices, I think. We currently approximate #3. We 
*can* do #2 (and there are various flavors of it). And even *aiming* for 
#1 is totally insane and stupid.

			Linus
