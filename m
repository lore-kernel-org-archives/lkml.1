Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0BQTuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 14:50:22 -0500
Received: from mx.treblig.org ([80.68.94.177]:42372 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab0BQTuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 14:50:21 -0500
X-Greylist: delayed 1421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2010 14:50:21 EST
Date: Wed, 17 Feb 2010 19:20:58 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Extended error reporting to user space?
Message-ID: <20100217192058.GA8937@gallifrey>
References: <201002161520.26700@zigzag.lvk.cs.msu.su> <87r5ok5gl2.fsf@basil.nowhere.org> <201002171316.49165@zigzag.lvk.cs.msu.su> <20100217103504.GO21783@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217103504.GO21783@one.firstfloor.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.31.5-kvm-i386-2009-10-30 (i686)
X-Uptime: 18:42:13 up 94 days,  1:52,  2 users,  load average: 0.17, 0.08,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Wed, Feb 17, 2010 at 01:16:48PM +0300, Nikita V. Youshchenko wrote:
> > > "Nikita V. Youshchenko" <yoush@cs.msu.su> writes:
> > > > I'm developing a device driver that, in it's ioctl()s, accepts a
> > > > complex data structure. Before doing it's operation, it performs large
> > > > number of checks if data is valid. If one of those checks fail, driver
> > > > returns -EINVAL.
> > > >
> > > > Unfortunately this -EINVAL is not really useful. E.g. if a developer,
> > > > sitting in his IDE and debugging his code, will see ioctl()
> > > > returning -EINVAL, and will have hard times finding what exactly is
> > > > wrong.
> > > >
> > > > Before inventing driver-specific extended error reporting, I'd like to
> > > > ask if there is anything more or less generic for this.
> > > > I believe situation when -Exxx is too weak interface for error
> > > > reporting is common.
> > >
> > > This is a very common problem in Linux unfortunately.  I always
> > > describe that as a the "ed approach to error handling". Instead
> > > of giving a error message you just give ?. Just ? happens
> > > to be EINVAL in Linux.
> > >
> > > My favourite example of this is the configuration of the networking
> > > queueing disciplines, which configure complicated data structures and
> > > algorithms and in many cases have tens of different error conditions
> > > based on the input parameters -- and they all just report EINVAL.
> > >
> > > The standard way (standard kludge or standard workaround would be a
> > > better description) is to use printk; often guarded by a special
> > > kernel tunable or ifdef to avoid flooding the log in the normal case.
> > >
> > > IMHO it would be best to simply add a way to return strings directly
> > > in this case (a la plan9). This would be probably not too hard to
> > > implement. It's not there unfortunately.
> > >
> > > This could be done with one of the message oriented protocols,
> > > e.g. netlink or read/write on a special minor.
> > 
> > Why not create a generic solution for this, if one does not exist yet?
> 
> Someone would need to do it. Yes I think it would be a worthy project.
> 
> The trick is also get around the objections of the "but we always
> did it this way" Unix traditionalists.

I'd wondered about some form of halfway house where the error
value is expanded but could be truncated for compatibility - i.e.
if at the moment we had:

    return -EINVAL;

it would become:

    return ERRORNUM(EINVAL, BADLENGTH);

and that would expand to something like:
    return -(EINVAL + BADLENGTH << ESHIFT);
     
existing syscall handlers could mask the extended error bits out on the way
back, and a new entry could pass the whole error value back where user space
could separate out the other part of the error.

This still feels quite like stretching the traditional way; but at the cost
of it still having the same problems (e.g. having to define a list of error
values).

One hard problem is that often the thing that actually returns the error
has actually just got a failure from something that called it which didn't
return any diagnostics, so to do this properly errors have to be passed
around in a lot of places; you'll also have to figure out just how far
down you want to pass it - if a read() fails due to a SCSI error there
is a whole load of different levels of information that you have to chose
what to return.

<snip>

Dave (who has stared at mmap's that have returned EINVAL for way too long)

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
