Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYAGQwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYAGQwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYAGQws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:52:48 -0500
Received: from styx.suse.cz ([82.119.242.94]:39748 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754416AbYAGQwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:52:47 -0500
Date: Mon, 7 Jan 2008 17:52:43 +0100
From: Jan Kara <jack@suse.cz>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Handle i_size > s_maxbytes correctly
Message-ID: <20080107165243.GQ12589@duck.suse.cz>
References: <20071220175104.GA11911@duck.suse.cz> <20071222001206.9d34cc78.akpm@linux-foundation.org> <20071222200310.GQ13821@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222200310.GQ13821@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 22-12-07 12:03:10, Mark Fasheh wrote:
> On Sat, Dec 22, 2007 at 12:12:06AM -0800, Andrew Morton wrote:
> > This patch takes the total text size of the affected nine files from 74167
> > bytes up to 75066 on i386.  This is core, core kernel.  Ouch.
> 
> Yeah, as you note below - this should be un-inlined.
> 
> 
> > It's also pretty fragile.  We now have i_size_read()s and
> > i_size_read_trunc()s sprinkled all over the place with no obvious rules to
> > determine when we should use one versus the other.
> 
> Hmm, I hadn't thought about that one, but what you say makes sense. If I was
> a 3rd party looking at this, I'd be pretty confused as to which i_size
> function to use, etc.
> 
> 
> > uninlining i_size_read_trunc() is obviously the first thing to look at but
> > the cost is still appreciable and boy the problem which is being fixed here
> > is rare and obscure.
> > 
> > Can we look at alternatives please?  What about just failing the open
> > attempt?
> 
> The problem is that Ocfs2 can have this happen while a file is open (if a 64
> bit node extends it past what the 32 bit node can see while they both have
> open file descriptors). Even in Ocfs2 by the way, this is a bit rare - most
> of the time folks run nodes of the same architecture. We still allow mixed
> arch clusters though.
> 
> We could stop the VFS changes at some open checks and leave the rest
> internally in Ocfs2 [and GFS2 I'm betting]. Generally though, it seems like
> the type of thing that the VFS could help more with.
> 
> 
> Jan, what if we just define a helper function which checks that a particular
> file access is within the bounds allowed by the file system:
> 
> int check_file_access_offsets(struct inode *inode, loff_t pos, size_t count);
> 
> Something like that would be potentially better documenting than another
> i_size accessor. Also, we could try to just leave it in the higher level
> functions (write, read, splice, fault, mkwrite). I'm still not convinced
> that we'd need to do anything in readpage/writepage if we just catch the
> problem higher up.
  Actually there are two problems. The first one is calls from userspace
beyond s_maxbytes. Those can be (and are) easily handled. But then there
are places inside VFS which compute things like maximal page index in the
file (and they compute it regardless the actual place where we access the
file). These computations can overflow even if the access is perfectly
within s_maxbytes and cause nasty things. That's why I've introduced that
i_size_read_trunc() function and we really need to fix them somehow for
OCFS2 or we have to make sure that these functions are never called on
files larger than s_maxbytes. I'll try to come up with more obvious
alternative to i_size_read_trunc() and if I fail I'll investigate how hard
it would be to handle the problems inside OCFS2.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
