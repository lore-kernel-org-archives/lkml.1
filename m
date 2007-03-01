Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbXCAD0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbXCAD0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 22:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXCAD0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 22:26:30 -0500
Received: from sitemail2.everyone.net ([216.200.145.36]:59731 "EHLO
	omta16.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbXCAD03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 22:26:29 -0500
X-Greylist: delayed 1251 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 22:26:29 EST
X-Eon-Dm: dm42
X-Eon-Sig: AQHOS7NF5kMBc3MaKgIAAAAJ,e8b55b4af11c977a298f11be3c4d2bc6
Date: Wed, 28 Feb 2007 22:05:33 -0500
From: "Kevin O'Connor" <kevin@koconnor.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Zach Brown <zach.bro@NONE.mta.everyone.net>
Subject: Re: [patch 02/12] syslets: add syslet.h include file, user API/ABI definitions
Message-ID: <20070301030533.GA26381@double.lan>
References: <20070228213938.GA945@elte.hu> <20070228214117.GB2305@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228214117.GB2305@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 10:41:17PM +0100, Ingo Molnar wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> add include/linux/syslet.h which contains the user-space API/ABI
> declarations. Add the new header to include/linux/Kbuild as well.

Hi Ingo,

I'd like to propose a simpler userspace API for syslets.  I believe
this revised API is just as capable as yours (anything done purely in
kernel space with the existing API can also be done with this one).

An "atom" would look like:

struct syslet_uatom {
	u32		nr;
	u64		ret_ptr;
	u64		next;
	u64		arg_nr;
	u64		args[6];
};

The sys_nr, ret_ptr, and next fields would be unchanged.  The args
array would directly store the arguments to the system call.  To
optimize the case where only a few arguments are necessary, an
explicit argument count would be set in the arg_nr field.

The above is very similar to what Linus and Davide described as a
"single submission" syslet interface - it differs only with the
addition of the next parameter.  As with your API, a null next field
would immediately stop the syslet.  So, a user wishing to run a single
system call asynchronously could use the above interface with the next
field set to null.

Of course, the above lacks the syscall return testing capabilities in
your atoms.  To obtain that capability, one could add a new syscall:

long sys_syslet_helper(long flags, long *ptr, long inc, u64 new_next)

The above is effectively a combination of sys_umem_add and the "flags"
field from the existing syslet_uatom.  The system call would only be
available from syslets.  It would add "inc" to the integer stored in
"ptr" and return the result.  The "flags" field could optionally
contain one of:
 SYSLET_BRANCH_ON_NONZERO
 SYSLET_BRANCH_ON_ZERO
 SYSLET_BRANCH_ON_NEGATIVE
 SYSLET_BRANCH_ON_NON_POSITIVE
If the flag were set and the return result of the syscall met the
specified condition, then the code would arrange for the calling
syslet to branch to "new_next" instead of the normal "next".

I would also change the event ring notification system.  Instead of
building that support into all syslets, one could introduce an "add to
head" syscall specifically for that purpose.  If done this way,
userspace could arrange for this new sys_addtoring call to always be
the last uatom executed in a syslet.  This would make the support
optional - those userspace applications that prefer to use a futex or
signal as an event system could arrange to have those system calls as
the last one in the chain instead.  With this change, the
sys_async_exec would simplify to:

long sys_async_exec(struct syslet_uatom *uatom);

As above, I believe this API has as much power as the existing system.
The general idea is to make the system call / atoms simpler and use
more atoms when building complex chains.

For example, the open & stat case could be done with a chain like the
following:

atom1: &atom3->args[1] = sys_open(...)
atom2: sys_syslet_helper(SYSLET_BRANCH_ON_NON_POSITIVE,
                         &atom3->args[1], 0, atom4)
atom3: sys_stat([arg1 filled above], ...)
atom4: sys_futex(...)   // alert parent of completion

It is also possible to use sys_syslet_helper to push a return value to
multiple syslet parameters (for example, propagating an fd from open
to multiple reads).  For example:

atom1: &atom3->args[1] = sys_open(...)
atom2: &atom4->args[1] = sys_syslet_helper(0, &atom3->args[1], 0, 0)
atom3: sys_read([arg1 filled in atom1], ...)
atom4: sys_read([arg1 filled in atom2], ...)
...

Although this is a bit ugly, I must wonder how many times one would
build chains complex enough to require it.

Cheers,
-Kevin
