Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654Ab0AHBWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0AHBWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646Ab0AHBWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:22:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624Ab0AHBWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:22:41 -0500
Date: Thu, 7 Jan 2010 17:22:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
In-Reply-To: <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001071718040.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>  <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>  <20100107235149.GD16076@basil.fritz.box>  <1262909682.2659.45.camel@localhost>  <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
 <1262912601.2659.89.camel@localhost> <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Linus Torvalds wrote:
> 
> A filesystem that depends on the different phases would be a fundamentally 
> buggy filesystem. Right now mmap is "atomic", and you can pre-populate (or 
> pre-verify, like NFS does) the mapping in the _knowledge_ that there are 
> no page faults that will populate it concurrently. Exactly because we hold 
> the mmap_sem for writing.

Side note: I realize that a filesystem could add its own lock, but that 
doesn't _help_ anything. In that case, it needs to take the lock while 
under the mmap_sem, and release it later in the "post-mmap-sem" callback, 
but not only is that ugly, it means that there is a mmap_sem -> newlock 
dependency between the two, which means that any lock dependency of code 
that runs under the new lock will not really have changed. You might as 
well have run it under the mmap_lock to begin with.

That's why I claim it's buggy. 

I'm sure you can do clever things for special cases, but it all sounds 
like you really need to fix the lockdep chain some way.

If you absolutely have to do the revalidation at mmap() time, then the 
lock chain needs to be broken somewhere else. Since this is a filesystem, 
and mmap_sem is involved, I can only assume that the other part of the 
chain is "readdir()" as usual.

See the whole sysfs discussion about that (look for sysfs and filldir on 
the kernel list a week or two ago).

		Linus
