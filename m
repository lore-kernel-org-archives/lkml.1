Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0BBEW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 23:22:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab0BBEW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 23:22:27 -0500
Date: Mon, 1 Feb 2010 20:22:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
In-Reply-To: <20100201231847.GC12882@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1002012018400.3664@localhost.localdomain>
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Al Viro wrote:
> 
> Ehh...  RCU will save you from stepping on freed memory, but it still will
> leave the joy of half-updated string with length out of sync with it, etc.

Sure. But do we care?

Every printk _should_ be on a dentry that we have a reference to, anyway. 
Otherwise, how did we find it?

So yeah, then there is the race with rename(), but (a) it's not going to 
happen, (b) if we race with rename there is no "one" correct solution 
anyway, so (c) what we really want to protect against is the printk 
causing problems (like an oops from DEBUG_PAGEALLOC and freeing the old 
name).

> We probably can get away with that, but we'll have to be a lot more careful
> with the order of updating these suckers in d_move_locked et.al.

I wouldn't worry about it too much. So what if we get a screwed up name? 
If we use "%.*s" to print the name, we know that we won't overstep the old 
name even if the NUL termination somehow went away (because we're busy 
copying a new, longer, name over it or whatever).

So I would not worry too much about sometimes showing a nonsensical name 
that may be the result of a concurrent rename. I'd only worry about it not 
oopsing or stepping on memory that hasn't had _either_ the old or the new 
name in it.

That's why I think an RCU solution should be sufficient..

			Linus
