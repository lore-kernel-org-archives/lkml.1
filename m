Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbXKAErk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbXKAErk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXKAErX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:47:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41437 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753521AbXKAErW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:47:22 -0400
Date: Wed, 31 Oct 2007 21:47:19 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
Message-Id: <20071031214719.81f8293a.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
	<Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
	<20071031131949.b91bf383.pj@sgi.com>
	<Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph, replying to pj:
> > Well, the mpol_nodemask_mode already is char.  So I guess you're
> > asking if we should change 'policy' to type char as well.
> 
> Right.

Ok - but why?

I don't see that it matters whether policy is short or char.


> > > Could we shorten the mpol_nodemask_mode to mode?
> > 
> > Huh - I don't know what "shorten ... to mode" means.  If it means
> > "shorten ... to char", then see my previous comment above.
> 
> No it means shorted the identifier which is a bit long for a structure 
> member.

Well, I called it "mpol_nodemask_mode" in the mempolicy struct because
I called it that same thing in the task_struct struct, where the longer
name is quite useful (the task struct covers alot of ground; a brief
'mode' field name for this purpose would be too vague and short.

I guess the 'mpol_' prefix part of this struct mempolicy field name is
unnecessary.  It's needed in the task struct, but not in the mempolicy
struct.  So I can imagine shorting this mempolicy struct name from
"mpol_nodemask_mode" down to "nodemask_mode".  But it really isn't a
generic "mode" field, so I'd be reluctant to make it that short.

Whether names should be long or short depends more to me on how they
are used in the code.  I want the code to be easy to read.  Sometimes
I use 30+ char names; sometimes 1 char names.  There is a tendency for
external function names to be longer than local variable names or
structure field names, but that's not the only criteria.

> > > Hmmm... I would rather have numactl manage this flag
> > ..
> 
> s/numactl/libnuma/

So you would rather have libnuma manage this flag?

As opposed to what else managing it?  I'm still a tad confused on
what you're suggesting on this one.

> What bugs?

The ones I described further on in that message, involving computing
bitmasks using one Choice then making some of the mbind/set_mempolicy
calls with flags indicating the other Choice.

> But that is only done in libnuma. User code does not call this directly.

I disagree.

There are several mempolicy interfaces in use, including at least:
 1) libnuma, which in turn is based on (5), below
 2) the numactl command line utility (based on libnuma)
 3) libcpuset (which has its own modest mempolicy interface)
 4) the glibc mbind/set_mempolicy/get_mempolicy wrappers, in C code
 5) roll your own mbind/*_mempolicy system call wrappers, in C code


> > Why do you prefer a per-system call modal flag, rather than a per-task
> > modal flag?
> 
> It is a change of behavior of the function call.

Hmmm ... yes ... that's a problem.  Either way seems to be a problem.

With the mode bit as in my patch, there are fewer places in the user
code that have to be gotten just right.  With your way, each and
every mbind and *_mempolicy call has to be hacked with the new flag
if one is going to use the new nodemask bit numbering.  Some of these
calls might be inside other routines or libraries that aren't readily
available to be examined or changed.  If you miss one, or forget to
add one when adding more mbind or *_mempolicy calls in the future,
then you have a nasty lurking hidden performance bug due to misplaced
pages in certain configurations.  That too is a serious maintenance
nightmare, as I've already tried to describe.

Looking at past history and prior examples, the closest I can think of
are the wait/wait2/wait3/wait4, mmap/mmap2, umount/umount2 and dup/dup2
calls.  When these system calls changed, a new variant was introduced,
with a 2, 3, 4, ... suffix.

Perhaps that's the way to go:
    mbind2, get_mempolicy2, and set_mempolicy2.

Then I could look at proposing a change to another detail of this
interface that has long seemed suboptimal to me, as described in:

    http://lkml.org/lkml/2004/8/10/14
    Subject: Re: [PATCH] get_nodes mask miscalculation

    http://lkml.org/lkml/2004/9/12/250
    Subject: more numa maxnode confusions

===

Unfortunately, I have a personal conflict with this work.  I need to
start a three week vacation.  Well, it should have started a few hours
ago.

So far as I can tell, there is no pressing emergency that this patch,
or its ancestor is addressing:

    http://lkml.org/lkml/2007/10/25/449
    Subject: [patch 2/2] cpusets: add interleave_over_allowed option
    
My access will be intermittent -- I'll be unplugging my setup in
California, and driving to Denton, Texas to work from there, still
for SGI.  This internet thing that Mr. Gore invented is cool -- one
can work from most anywhere with power and a network connection.

I was hoping to put this effort to bed before this time off, but it
has gotten complicated enough that I won't be able to do that.  Sorry.


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
