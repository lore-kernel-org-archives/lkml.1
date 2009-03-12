Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZCLFjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZCLFjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZCLFjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:39:02 -0400
Received: from phunq.net ([64.81.85.152]:39233 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751238AbZCLFi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:38:59 -0400
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Wed, 11 Mar 2009 22:38:55 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090311114211.89eed5b8.akpm@linux-foundation.org>
In-Reply-To: <20090311114211.89eed5b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903112238.55864.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Andrew Morton wrote:
> On Wed, 11 Mar 2009 09:25:37 -0700
> Daniel Phillips <phillips@phunq.net> wrote:
> 
> > The full patch is 191KB.  We could try patchbombing lkml with that, one
> > patch per file, say.
> 
> One patch per file is OK.

OK, the next iteration will be that.  For today there is a new patch
here:

   http://tux3.org/patches/tux3-2.6.29-rc7-2

and the Git repository is updated:

   git://git.kernel.org/pub/scm/linux/kernel/git/daniel/linux-tux3.git

Any idea how I make this appear on the web interface at git.kernel.org?
The Mercurial version of the changes (identical except for applying to
tux3/user/kernel instead of linux/fs/tux3) are here:

   http://hg.tux3.org/tux3

> Two considerations:
> 
> - It should be reviewable!  People don't want to spend all their
>   review time scratching their heads wondering "wtf is this piece of
>   code supposed to do".
> 
>   Thoughtfully commented data structures and functions are valuable
>   during the code-review stage.  If you try to retrofit them later then
>   reviewers get justifiably grumpy about all the time they wasted
>   ineffectually trying to review the uncommented stuff.

The next round of checkins will be a batch of informative comments.  A
bit late to tackle that today.

> - Send the code for review when it's ready for linux-next
>   integration.  I don't think it's a good idea to have it reviewed,
>   then you all disappear and spend three months changing it and then
>   put it up for linux-next integration.
> 
>   OTOH, there may well be large changes as a result of review, so
>   don't leave it too late and avoid the temptation to think of it as
>   "finished", because it won't be!

Will do.  I think it is about ready for review now, with mainly cosmetic
issues between here and there.  It is hard indeed, but we have resisted
the temptation to jump into the shiny optimizing work, or even get some
of the major functionality like recovery fully working.  By now, it is
pretty clear how we intend to go at these things and the important code
structure is in place and mostly working.  But no useful purpose is
served by taking several more weeks to make it all work perfectly at the
cost of missing out on the thousand eyeballs effect.  OK sure, in the
real workd it is more like the two dozen eyeballs effect, but that is
still two dozen more than we had yesterday.

> Drive-by review:
> 
> - please prefer to leave a blank line between end-of-locals and
>   start-of-code in each fucntion.

Done.

> - C++ comments make checkpatch (and kernel developers) whine.

Each of those C++ comments is meant to cause sufficient pain to force
Tux3 devs to fix the commented issues, in the full knowledge that the
alternative is an eternity of suffering the slings and arrows of
outraged hacker whining.

Not all are fixed in this round of updates, but they will surely all be
gone before "official" review begins.

> - The non-tux3-specific bitmap-handling functions in balloc.c
>   shouldn't exist, I suspect.  Use core kernel helpers.  If they don't
>   exist, add them.

It looks like lib/bitmap.c has something serviceable, though the endian
issues are a little less than clear on a quick reading.

By the way, the endian comment in bitmap.c needs some loving:

   http://lxr.linux.no/linux+v2.6.28.7/lib/bitmap.c#L35

The s390 file needs to be config-independent:

-	include/asm-s390/bitops.h
+	arch/s390/include/asm/bitops.h

and the ppc file is nowhere to be seen.  I will put a driveby patch on
the to.do list.

A more substantive point:  The claim that "the byte ordering of bitmaps
is more natural on little endian architectures... see the big-endian
headers" is not actually supported in any obvious way.  This is an
important question for us, because the bitmap format is the only endian
issue in Tux3 not completely nailed down.  We use big endian format for
everything except bitmaps, which are currently little endian.  This does
not make any difference until we start optimizing by using multi-byte
loads and stores.  At that point, bits get scrambled in registers.

This is a disk format issue, so we need to get started on resolving it.
For perfect consistency, we should assume bit 0 at the most significant
end of a big-endian byte.  But if little endian bytes really are "more
natural", which is not at all clear, then maybe we should settle on a
mixed format with littled endian bytes that have to be byteswapped when
loaded as words.  I dunno.  In a perfect world I would know the answer
just from reading the headers above, but this world isn't perfect and
neither am I, so hopefully somebody can enlighten me.

As an intermediate step, all our generic bit range operations are now
moved to tux3/utility.c and soon we will try to use the lib/bitmap.c
code, endian issues notwithstanding (does anybody really know what that
word means?)

> - bytebits() should use hweight8()

Done.

> - No new typedefs, please.  That means block_t.  If there is some
>   real need to make block_t a typedef (such as: its size varies
>   according to Kconfig options) then grumble, OK.  But it should then
>   be called tux3_block_t.

Not done yet (biggish).

> - count_range() is an unsuitable identifier for a kernel-wide symbol.
>   Please review all global symbols in the fs, ensure that they are
>   prefixed with "tux3_".  Or make them static, of course.

This symbol is only supposed to be shared between separate compilation
units within fs/tux3, not be visible outside our module.  How do we do
that?

Anyway, this isn't used by kernel code at all right now, though it
should be.  For now, it has been made #ifndef __KERNEL__ until we
figure out what to do about this general class of symbols.

> - It uses printf() and assert()?  Kernel code uses printk() and
>   BUG_ON().  Confused.

That is the dual userspace/kernel personality showing.  Userspace code
really looks odd when filled with printfs, and BUG_ON is essentially a
nontraditional incarnation of Posix assert.  So please just declare on
this: assert and printf are banned from kernel code or not?  I have a
slight preference for not banned, given the prior art of the Posix
flavors, but however you want it is how it will be.  Not changed for
now.

> - There's a lot of this:
> 
> 	int ended = 0, any = 0;
> 	struct buffer_head *buffer = blockread(mapping(inode), block);
> 	if (!buffer)
> 		return -1;
> 	unsigned bytes = blocksize - offset;
> 	if (bytes > tail)
> 		bytes = tail;
> 	unsigned char *p = bufdata(buffer) + offset, *top = p + bytes;
> 
>   Which will spew compilation warnings due to local variable
>   definitions coming after code.

We compile without warnings in kernel by putting this in our Makefile:

   EXTRA_CFLAGS += -Werror -std=gnu99 -Wno-declaration-after-statement

Obviously, that raises the question of whether C99 syntax is banned in
kernel.  Well, C99 comments have a long tradition of attracting flames,
so all those are on their way out of Tux3 code (though not out yet) but
inline declarations actually serve a useful purpose in code that is in
process of continuous refactoring.  So I think we would like to keep
these in some files for the time being, that are in heavy development,
and change some of the "traditional" usage like VFS glue to K&R style.

Naturally I would prefer that this matter be left up to the individual
artist for non-core kernel code, but please just make a ruling on it.
If the ruling is "we don't brook none of that filthy new C syntax"
then we will start converting all the kernel code.  Not started yet.

>   Maybe this code is never to be compiled into the kernel image, but
>   we might as well be consistent.

Almost all of it is compiled by both userspace and kernel.
 
> - What's "L"?
> 
> 		printf("%Lx-", (L)begin);

A very handy way of working around 32/64 bit format string issues.  We
just cast all the messy cases to (long long), aka (L).  All other
solutions to this messy problem are worse in my opinion, but whatever
the ruling is, is what we will do.  This is used heavily in tracing and
dumping code, which can all be turned off with ifdefs, so it doesn't
affect production kernel text.

> - When 'bh' is known to be non-NULL, use put_bh() rather than brelse().

We have wrapped nearly all buffer operations with a view to getting rid
of buffers entirely, which we are not that far away from.  Brelse is
one we didn't get around to.  Now changed to blockput(buffer), a wrapper
that calls put_bh in kernel and our buffer emulation code in userspace,
which never did allow null buffers.

By the way, getting rid of buffers is an example of a process we really
want to do "in public", to avoid the danger of getting too far out on
some shaky limb.

> - Use __packed, not PACKED.

Done, and I noticed that we are missing some packed struct attributes,
to be fixed.

> - Run `checkpatch --file', enjoy the result.

Surely you meant "enjoy" the result.

> - get_buffer() looks like it's racy against truncate.  Needs to lock
>   the page.

Thankyou.  That is ground zero for current development.

> - eh?
> 
> 	typedef u64 fixed32; /* Tux3 time values */

That is 32.32 fixed point format.  Tux3 uses fixed point rather than
decimal-encoded representation of sub-second time fields, with a view
to supporting configurable time precision with shifts rather that yucky
decimal conversions.   We want the yucky decimal conversions only at
the VFS interface points, not in the disk representation code.  Anyway,
32.32 is just a placeholder for some parameterized shift/mask code that
is not yet implemented.  To be done.

> - link_entry() looks dangerous.

Live fast, die young.  It's an evolving interface.  Suggestions?

I came up with some code for using single linked lists in much the same
way as traditional generic double linked lists, but saving a word per
pointer.  Which Hirofumi adopted and got busy generalizing, thinking
that kernel could use this in a few bazillion places to save metric
truckloads of cache memory.  Anyway, a work in progress, suggestions
welcome.

> - Move SB_MAGIC to magic.h, change name.

Done.

> - remove private hexdump(), use lib/hexdump.c
> 
> 
> Generally: the code is _very_ namespace-piggy.  Lots and lots of very
> generic-sounding identifiers.

Righto.  A way of sandboxing external symbols just to our own module
would be very helpful, otherwise we will get busy tux3_ing those.

Regards,

Daniel
