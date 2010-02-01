Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0BAWhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:37:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab0BAWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:37:35 -0500
Date: Mon, 1 Feb 2010 14:37:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
In-Reply-To: <20100201222511.GA12882@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Al Viro wrote:
>
> 	I propose to add a new format - %pd.  It would print dentry name.
> However, unlike everything else in vsnprintf, it would NOT be locking-agnostic.
> It would grab and release dentry->d_lock.  And yes, I hate that as much as
> anyone.  I don't see any sane alternative.

So I do hate it a lot too, and one of the main reasons I hate it is that 
that format is then subtly but horribly broken inside sections that 
already hold the lock.

And I can hear you say "What *subtle*? It's an instant deadlock!", but the 
most likely reason for such a printk would be some debug statement etc 
that would seldom/ever trigger - like a BUG_ON or whatever. And that "we 
take the lock while printing" would thus become a rather nasty "machine 
died silently" issue.

So I _really_ hate taking locks in the printk paths. We've had serious 
problems with that in the past. It has made for some very annoying issues.

> * don't use %pd under dentry->d_lock, use dentry->d_name.name instead; in
> that case it *is* safe.  Incidentally, ->d_lock isn't held a lot.

I realize we can just call it a rule, and yes, d_lock is held much less 
than something like console_lock etc that we've had ABBA issues with, but 
still..

> 	Comments?

Quite frankly, I'd _much_ rather see something like just always freeing 
the dentry names (when they aren't inlined) using RCU. The VFS layer quite 
possibly would want to do that anyway at some point (eg Nick's VFS 
scalability patches), and then we could make it just a RCU read-lock or 
whatever (interrupt disable, what-not) instead.

And I'm much happier with printk doing that kind of thing, and wouldn't 
have issues with that kind of much weaker locking.

		Linus
