Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYICQ7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYICQ7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYICQ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:59:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:1142 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYICQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JSP2kLYYWyqRWCthbnVz5dzI0ISDchybACV3Xe7g16Mly7GSto6xF5oo9la2ow/vPa
         X1ugI/rVH1i2vT0koPF9lmNxqvgtt/n9IbUYXJSay2nSYsLcWKqH49uKLUL2DihGLcHV
         ZiETPPQ55ZmmSjPSxFR2bBh29BZway7NkxDnc=
Date: Wed, 3 Sep 2008 21:01:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080903170102.GC5604@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain> <20080826225519.GC27724@x200.localdomain> <20080903121127.2B368154228@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903121127.2B368154228@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 05:11:27AM -0700, Roland McGrath wrote:
> > Again, embed struct utrace directly into task_struct. task_struct
> > lifetime rules are way more tested than struct utrace ones.
> 
> The most consistent feedback I've seen to all new features is that they
> mustn't add overhead when they're not being used.

That's correct but shouldn't be taken to extreme as usual.

> So I never considered it an option to bloat task_struct by ~120 bytes.

By how many?

> Of course much more than that is entailed when a task is actually being
> traced somehow.

Engine part is irrelevant for deciding "struct utrace utrace;" vs
"struct utrace *utrace;"

> But the presumption is that most tasks most of the time aren't, and that's
> what not to bloat.

Let's actually measure something.

1) clean kernel (my usual config, x86_64, NR_CPUS=2, PREEMPT=y, SLUB_DEBUG=y)
2) struct utrace *utrace;
3) struct utrace utrace; (without rcu_head, without check_dead)

			taken from symlink
	cache		/object_size, bytes
----------------------------------------
1)	task_struct	1392/1384

2)	task_struct	1408/1400
	utrace		72/72

3)	task_struct	1456/1456


I don't know why "object_size" differs from to where symlink points to
but it's irrelevant.

So, your approach gives +16(+72) bytes, mine gives +72 bytes.

So all this complexity is for ~56 bytes in untraced case. In traced
case, more memory will be used.

For 32-bit difference should be smaller because pointers are smaller.

> The revamp of the API after the first prototype made some of the internals
> much simpler to implement, that had been very sticky in the old prototype
> code.  But the allocation and freeing of struct utrace is an area I did not
> fully revisit.  Buggy is buggy, and sure it needs to be tested and fixed.
> I'm still inclined to look into making it right rather than punting.
> 
> > Add simple spinlock guarding all accesses (OK, I haven't looked very
> > closely if it's possible)
> 
> I can't tell what you mean here.  Do you mean something different 
> from struct utrace.lock?  If there were no pointer and its allocation
> to synchronize, then what other lock would you be adding?

I mean sticking to simple locking rules if you agree to "struct utrace utrace;":
1) utrace_flags go into struct utrace
2) utrace.lock guards _everything_ under it, no exceptions.

If I understand correctly ->utrace_flags are under utrace->lock, BUT
struct utrace is reattachable itself. Of course you protect against it,
but this doesn't help in convincing someone that there are no problems.

Again, this is just general observation and an example. Checking for
bugs will be much, much simpler.

