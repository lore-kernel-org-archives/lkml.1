Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837Ab0BBFAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 00:00:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53583 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0BBFAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 00:00:38 -0500
Date: Tue, 2 Feb 2010 05:00:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100202050037.GE12882@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
 <20100201231847.GC12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002012018400.3664@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002012018400.3664@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 08:22:24PM -0800, Linus Torvalds wrote:

> > We probably can get away with that, but we'll have to be a lot more careful
> > with the order of updating these suckers in d_move_locked et.al.
> 
> I wouldn't worry about it too much. So what if we get a screwed up name? 
> If we use "%.*s" to print the name, we know that we won't overstep the old 
> name even if the NUL termination somehow went away (because we're busy 
> copying a new, longer, name over it or whatever).

Actually, I'm not sure.  We can get hit by a switch to inline name with
length still being that from a long earlier name.  And inline name is
in the end of struct dentry, so we could end up stepping off the end
of page.  Note that existing d_alloc() does put NUL in d_iname for a short
name, but it won't clean the end of array, so overwrite during memcpy()
can open up a whole lot of PITA.

And yes, it's theoretical and ought to be hard to hit - the sky isn't falling.
OTOH, something like rename() vs. close() race as in ocfs2 might make it
not all that theoretical.

We probably can get away with being careful with barriers and order of
->len vs. ->name updates (and being a bit more careful about cleaning the
crap in d_alloc()), but it'll take an accurate analysis.  I'd really like
to hear something from RCU folks, BTW; I still hope that it's one of the
more or less standard problems and "memory barriers" and "reinventing
the wheel" in the same sentence is something I'd rather avoid.

FWIW, speaking of fun printf extensions, there might be a completely
different way to deal with all that crap.  %s modification doing kfree().
I.e. "get char * from argument list, print it as %s would, then kfree() it".
With something along the lines of
	printk("... %<something>...", build_some_string(...));
as intended use, build_some_string() allocating a string and filling it.
Might or might not be a good idea, but it's interesting to consider.  And
yes, of course it's a deadlock if you do that under any kind of a spinlock,
but that's the damn caller's responsibility - after all, they explicitly
call a function that does allocation.  The real danger with that is that
somebody will use it with %s and get a leak from hell...
