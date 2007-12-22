Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbXLVUE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbXLVUE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXLVUEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:04:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:44473 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbXLVUEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:04:48 -0500
Date: Sat, 22 Dec 2007 12:03:10 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Handle i_size > s_maxbytes correctly
Message-ID: <20071222200310.GQ13821@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20071220175104.GA11911@duck.suse.cz> <20071222001206.9d34cc78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222001206.9d34cc78.akpm@linux-foundation.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 12:12:06AM -0800, Andrew Morton wrote:
> This patch takes the total text size of the affected nine files from 74167
> bytes up to 75066 on i386.  This is core, core kernel.  Ouch.

Yeah, as you note below - this should be un-inlined.


> It's also pretty fragile.  We now have i_size_read()s and
> i_size_read_trunc()s sprinkled all over the place with no obvious rules to
> determine when we should use one versus the other.

Hmm, I hadn't thought about that one, but what you say makes sense. If I was
a 3rd party looking at this, I'd be pretty confused as to which i_size
function to use, etc.


> uninlining i_size_read_trunc() is obviously the first thing to look at but
> the cost is still appreciable and boy the problem which is being fixed here
> is rare and obscure.
> 
> Can we look at alternatives please?  What about just failing the open
> attempt?

The problem is that Ocfs2 can have this happen while a file is open (if a 64
bit node extends it past what the 32 bit node can see while they both have
open file descriptors). Even in Ocfs2 by the way, this is a bit rare - most
of the time folks run nodes of the same architecture. We still allow mixed
arch clusters though.

We could stop the VFS changes at some open checks and leave the rest
internally in Ocfs2 [and GFS2 I'm betting]. Generally though, it seems like
the type of thing that the VFS could help more with.


Jan, what if we just define a helper function which checks that a particular
file access is within the bounds allowed by the file system:

int check_file_access_offsets(struct inode *inode, loff_t pos, size_t count);

Something like that would be potentially better documenting than another
i_size accessor. Also, we could try to just leave it in the higher level
functions (write, read, splice, fault, mkwrite). I'm still not convinced
that we'd need to do anything in readpage/writepage if we just catch the
problem higher up.

Thanks,
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
