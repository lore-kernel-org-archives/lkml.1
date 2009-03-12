Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZCLLDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZCLLDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZCLLDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:03:37 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:33335 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753633AbZCLLDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:03:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dkC8obFdheopEPztPLM3pMyMoHGEgy2a9t3Q8dR8Lk7cogyiScYv+leGb5dTJRwtk7vx/cSdOfIs+yfUAGphPtsQLLfIUDxQi8SGx6OP+7hJk5LjODX/YXuIvgcIapXFIdMN7oBLzfIILYOoFw9o6qGRyhekTZfBs+r2L4jq9us=  ;
X-YMail-OSG: r1PRXPwVM1nxjS9cGldAqLUwlaoCXHGrDxN8A7.rc1uGvPR3GQiR0BiT4fIqSLtiNFkLqC1p0igwJaR4C13YlX19FCI9qyVxkR.3CoODA2xYbQrmdUBJ8LRqh4aHIC0Anfi8zOfAPUFHYYe8Q1fk7QEiEeYFjryugRCDD5HlY.QYYDUcREFA5u3110J.kw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 22:03:31 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903122010.31282.nickpiggin@yahoo.com.au> <200903120315.07610.phillips@phunq.net>
In-Reply-To: <200903120315.07610.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903122203.31502.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 21:15:06 Daniel Phillips wrote:

> By the way, I just spotted your fsblock effort on LWN, and I should
> mention there is a lot of commonality with a side project we have
> going in Tux3, called "block handles", which aims to get rid of buffers
> entirely, leaving a tiny structure attached to the page->private that
> just records the block states.  Currently, four bits per block.  This
> can be done entirely _within_ a filesystem.  We are already running
> some of the code that has to be in place before switching over to this
> model.
>
> Tux3 block handles (as prototyped, not in the current code base) are
> 16 bytes per page, which for 1K block size on a 32 bit arch is a factor
> of 14 savings, more on 64 bit arch.  More importantly, it saves lots of
> individual slab allocations, a feature I gather is part of fsblock as
> well.

That's interesting. Do you handle 1K block sizes with 64K page size? :)

fsblock isn't quite as small. 20 bytes per block on a 32-bit arch. Yeah,
so it will do a single 80 byte allocation for 4K page 1K block.

That's good for cache efficiency. As far as total # slab allocations
themselves go, fsblock probably tends to do more of them than buffer.c
because it frees them proactively when their refcounts reach 0 (by
default, one can switch to a lazy mode like buffer heads).

That's one of the most important things, so we don't end up with lots
of these things lying around.

eg. I could make it 16 bytes I think, but it would be a little harder
and would make support for block size > page size much harder so I
wouldn't bother. Or share the refcount field for all blocks in a page
and just duplicate state etc, but it just makes code larger and slower
and harder.


> We represent up to 8 block states in one 16 byte object.  To make this
> work, we don't try to emulate the behavior of the venerable block
> library, but first refactor the filesystem data flow so that we are
> only using the parts of buffer_head that will be emulated by the block
> handle.  For example, no caching of physical block address.  It keeps
> changing in Tux3 anyway, so this is really a useless thing to do.

fsblocks in their refcount mode don't tend to _cache_ physical block addresses
either, because they're only kept around for as long as they are required
(eg. to write out the page to avoid memory allocation deadlock problems).

But some filesystems don't do very fast block lookups and do want a cache.
I did a little extent map library on the side for that.


> Anyway, that is more than I meant to write about it.  Good luck to you,
> you will need it.  Keep in mind that some of the nastiest kernel bugs
> ever arose from interactions between page and buffer state bits.  You

Yes, I even fixed several of them too :)

fsblock simplifies a lot of those games. It protects pagecache state and
fsblock state for all assocated blocks under a lock, so no weird ordering
issues, and the two are always kept coherent (to the point that I can do
writeout by walking dirty fsblocks in block device sector-order, although
that requires bloat to fsblock struct and isn't straightforward with
delalloc).

Of course it is new code so it will have more bugs, but it is better code.


> may run into understandable reluctance to change stable filesystems
> over to the new model.  Even if it reduces the chance for confusion,
> the fact that it touches cache state at all is going to make people
> jumpy.  I would suggest that you get Ext3 working perfectly to prove
> your idea, no small task.  One advantage: Ext3 uses block handles for
> directories, as opposed to Ext2 which operates on pages.  So Ext3 will
> be easier to deal with in that one area.  But with Ext3 you have to
> deal with jbd too, which is going to keep you busy for a while.

It is basically already proven. It is faster with ext2 and it works with
XFS delalloc, unwritten etc blocks (mostly -- except where I wasn't
really able to grok XFS enough to convert it). And works with minix
with larger block size than page size (except some places where core
pagecache code needs some hacking that I haven't got around to).

Yes an ext3 conversion would probably reveal some tweaks or fixes to
fsblock. I might try doing ext3 next. I suspect most of the problems
would be fitting ext3 to much stricter checks and consistency required
by fsblock, rather than adding ext3-required features to fsblock.

ext3 will be a tough one to convert because it is complex, very stable,
and widely used so there are lots of reasons not to make big changes to
it.


> The block handles patch is one of those fun things we have on hold for
> the time being while we get the more mundane

Good luck with it. I suspect that doing filesystem-specific layers to
duplicate basically the same functionality but slightly optimised for
the specific filesystem may not be a big win. As you say, this is where
lots of nasty problems have been, so sharing as much code as possible
is a really good idea.

I would be very interested in anything like this that could beat fsblock
in functionality or performance anywhere, even if it is taking shortcuts
by being less generic.

If there is a significant gain to be had from less generic, perhaps it
could still be made into a library usable by more than 1 fs.

