Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYLETD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYLETD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 14:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYLETDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 14:03:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862AbYLETDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 14:03:19 -0500
Date: Fri, 5 Dec 2008 11:02:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, bfields@fieldses.org,
       hugh@veritas.com, hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from fh_to_dentry()/fh_to_parent()
 [ver #4]
In-Reply-To: <23235.1228502954@redhat.com>
Message-ID: <alpine.LFD.2.00.0812051053190.3386@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org> <20081205162318.20732.73054.stgit@warthog.procyon.org.uk> <23235.1228502954@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2008, David Howells wrote:
> 
> The d_obtain_alias() function will immediately return -ESTALE if given a NULL
> inode, though, and sometimes it'll return some other error.
> 
> It would also seem odd to sometimes return NULL to indicate an error, and
> sometimes return a -ve error code to indicate an error.  Perhaps one or the
> other should be selected for consistency.

Well, the thing is, returning NULL is probably the most natural thing to 
do for a filesystem that doesn't really _have_ a valid error code for the 
situation. It's more of a "I can't do this" thing, than an error. 

Sure, we can make all filesystems return -ESTALE, but not only is the 
patch fairly big, it really doesn't look at all better or make any more 
sense. ESTALE is really strictly a NFS thing - it doesn't tend to make 
sense for other filesystems (well, sure, other filesystems may have inode 
versions too and decide to use ESTALE for things, so I'm not claiming that 
it's _purely_ a NFS thing, but I think you see my point).

So it really seems to make more sense to just make the ESTALE handling be 
a NFS issue. 

And notice that I'm not arguing that "fh_to_dentr/parent()" should 
_always_ return NULL for errors. There may be real reasons why a 
filesystem might want to return some actual error, like EIO. And maybe a 
filesystem actually wants to return an explicit ESTALE when that makes 
sense (ie when the filesystem _does_ find an inode that matches, but the 
generation doesn't match).

But I'm just looking at your patch, and seeing things like

	        if (fh_len <= 2)
	-               return NULL;
	+               return ERR_PTR(-ESTALE);

and going "That really didn't make the code any prettier or easier to 
understand".

			Linus
