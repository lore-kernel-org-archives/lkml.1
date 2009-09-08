Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbZIHOVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbZIHOVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZIHOVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:21:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54125 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZIHOVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:21:33 -0400
Date: Tue, 8 Sep 2009 09:01:40 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/8] VFS name lookup permission checking cleanup
Message-ID: <20090908140140.GB873@us.ibm.com>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (torvalds@linux-foundation.org):
> 
> This is a series of eight trivial patches that I'd like people to take a 
> look at, because I am hoping to eventually do multiple path component 
> lookups in one go without taking the per-dentry lock or incrementing (and 
> then decrementing) the per-dentry atomic count for each component.
> 
> The aim would be to try to avoid getting that annoying cacheline ping-pong 
> on the common top-level dentries that everybody looks up (ie root and home 
> directories, /usr, /usr/bin etc).
> 
> Right now I have some simple (but real) loads that show the contention on 
> dentry->d_lock to be a roughly 3% performance hit on a single-socket 
> nehalem, and I assume it can be much worse on multi-socket machines.
> 
> And the thing is, it should be entirely possible to do everything but the 
> last component lookup with just a single read_seqbegin()/read_seqretry() 
> around the whole lookup. Yes, the last component is special and absolutely 
> needs locking and counting - but the last component also doesn't tend to 
> be shared, so locking it is fine.
> 
> Now, I may never actually get there, but when looking at it, the biggest 
> problem is actually not so much the path lookup itself, as the security 
> tests that are done for each path component. And it should be noted that 
> in order for a lockless seq-lock only lookup make sense, any such 
> operations would have to be totally lock-free too. They certainly can't 
> take mutexes etc, but right now they do.
> 
> Those security tests fall into two categories:
> 
>  - actual security layer callouts: ima_path_check().
> 
>    This one looks totally pointless. Path component lookup is a horribly 
>    timing-critical path, and we will only do a successful lookup on a 
>    directory (inode needs to have a ->lookup operation), yet in the middle 
>    of that is a call to "ima_path_check()".
> 
>    Now, it looks like ima_path_check() is very much designed to only check 
>    the _final_ path anyway, and was never meant to be used to check the 
>    directories we hit on the way. In fact, the whole function starts with
> 
> 	if (!ima_initialized || !S_ISREG(inode->i_mode))
> 		return 0;
> 
>    so it's totally pointless to do that thing on a directory where 
>    that !S_ISREG() test will trigger.
> 
>    So just remove it. IMA should never have put that check in there to 
>    begin with, it's just way too performance-sensitive.
> 
>  - the real filesystem permission checks. 
> 
>    We used to do the common case entirely in the VFS layer, but these days 
>    the common case includes POSIX ACL checking, and as a result, the 
>    trivial short-circuit code in the VFS layer almost never triggers in
>    practice, and we call down to the low-level filesystem for each 
>    component. 
> 
>    We can't fix that by just removing the call, but what we _can_ do is to 
>    at least avoid the silly calling back-and-forth: most filesystems will 
>    just call back to the VFS layer to do the "generic_permission()" with 
>    their own ACL-checking routines.
> 
>    That way we can flatten the call-chain out a bit, and avoid one 
>    unnecessary indirect call in that timing-critical region. And 
>    eventually, if we make the whole ACL caching thing be something that we 
>    do at a VFS layer (Al Viro already worked on _some_ of that), we'll be 
>    able to avoid the calls entirely when we can see the cached ACL 
>    pointers directly.
> 
> So this series of 8 patches do all these preliminary things. As shown by 
> the diffstat below, it actually reduces the lines of code (mainly by just 
> removing the silly per-filesystem wrappers around "generic_permission()") 
> and it also makes it a _lot_ clearer what actually gets called in that 
> whole 'exec_permission_lite()' function that we use to check the 
> permission of a pathname lookup.
> 
> Comments?  Especially from the IMA people (first patch) and from generic 
> VFS, security and low-level FS people (the 'Simplify exec_permission_lite' 
> series, and then the check_acl + per-filesystem changes).
> 
> Al?
> 
> I'm looking to merge these shortly after 2.6.31 is released, but comments 
> welcome.

All of them seem good, and I don't see any thinkos, no resulting skipped
checks or anything.

Acked-by: Serge Hallyn <serue@us.ibm.com>

-serge
