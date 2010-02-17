Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab0BQKfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:35:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34589 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0BQKfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:35:08 -0500
Date: Wed, 17 Feb 2010 11:35:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Extended error reporting to user space?
Message-ID: <20100217103504.GO21783@one.firstfloor.org>
References: <201002161520.26700@zigzag.lvk.cs.msu.su> <87r5ok5gl2.fsf@basil.nowhere.org> <201002171316.49165@zigzag.lvk.cs.msu.su>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002171316.49165@zigzag.lvk.cs.msu.su>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 01:16:48PM +0300, Nikita V. Youshchenko wrote:
> > "Nikita V. Youshchenko" <yoush@cs.msu.su> writes:
> > > I'm developing a device driver that, in it's ioctl()s, accepts a
> > > complex data structure. Before doing it's operation, it performs large
> > > number of checks if data is valid. If one of those checks fail, driver
> > > returns -EINVAL.
> > >
> > > Unfortunately this -EINVAL is not really useful. E.g. if a developer,
> > > sitting in his IDE and debugging his code, will see ioctl()
> > > returning -EINVAL, and will have hard times finding what exactly is
> > > wrong.
> > >
> > > Before inventing driver-specific extended error reporting, I'd like to
> > > ask if there is anything more or less generic for this.
> > > I believe situation when -Exxx is too weak interface for error
> > > reporting is common.
> >
> > This is a very common problem in Linux unfortunately.  I always
> > describe that as a the "ed approach to error handling". Instead
> > of giving a error message you just give ?. Just ? happens
> > to be EINVAL in Linux.
> >
> > My favourite example of this is the configuration of the networking
> > queueing disciplines, which configure complicated data structures and
> > algorithms and in many cases have tens of different error conditions
> > based on the input parameters -- and they all just report EINVAL.
> >
> > The standard way (standard kludge or standard workaround would be a
> > better description) is to use printk; often guarded by a special
> > kernel tunable or ifdef to avoid flooding the log in the normal case.
> >
> > IMHO it would be best to simply add a way to return strings directly
> > in this case (a la plan9). This would be probably not too hard to
> > implement. It's not there unfortunately.
> >
> > This could be done with one of the message oriented protocols,
> > e.g. netlink or read/write on a special minor.
> 
> Why not create a generic solution for this, if one does not exist yet?

Someone would need to do it. Yes I think it would be a worthy project.

The trick is also get around the objections of the "but we always
did it this way" Unix traditionalists.

> 
> For example, have a "last error" string associated with task_struct, that:
> - will clean on each syscall entry,
> - while syscall is running, may be filled with printf-style routines,
> - may be accessible from userspace with additional syscall [that obviously 
> should not reset error]?
> 
> This will give driver writers a common interface for extended error 
> reporting...

You would need a way to save/restore that string too (like it works
with errno) otherwise libraries cannot use it safely. Also
it would be good to have something that does not impact the system
call fast path for a non error call.

>From the basic semantics I think I would prefer a way
associated with each syscall. It could be probably fit into 
many syscall ABIs, but that would need architecture specific
changes, which are difficult to coordinate (Linux has too many
architectures and many of them with inactive maintainers)

One way to do that would be a "extended ioctl" syscall that supports
this in a generic way (and perhaps could fix some of the other problems
of ioctl too, like better type safety). 

Designing such a thing might end up being a rat-hole (and you would
probably need to be very careful to avoid the second system effect)

Of course the qdiscs and other code who uses netlink instead would also 
need something equivalent. 

Also I expect someone would come up with localization issues, although
the the classical "translation database" approach would probably work
anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
