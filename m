Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXKAGeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXKAGeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 02:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXKAGd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 02:33:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51728 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752873AbXKAGdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 02:33:55 -0400
Date: Wed, 31 Oct 2007 23:33:52 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
Message-Id: <20071031233352.959c32d0.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
	<Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
	<20071031131949.b91bf383.pj@sgi.com>
	<Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
	<20071031214719.81f8293a.pj@sgi.com>
	<Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You are managing it in the task struct. No need to. libnuma can handle it.

No - as noted, not all mempolicy system calls go via libnuma.

> No current version of libcpuset is available.

Wrong.  It has not received wide publication yet, but it has been
provided to various others under LGPL license.

> Those exist? Never seen that.

I've seen such go by.

    David R - is your use of the mbind and *_mempolicy system calls
    via libnuma, or direct system calls?

    I've fielded questions from others on how to use these system
    calls (directly, not via libnuma) for several years now, both
    from within and without of SGI.

    The glibc folks have spent some effort on refining the system
    call wrappers they provide for these calls, which are not used by
    libnuma (libnuma doesn't use the glibc wrappers for these calls.)
    I presume that glibc work has at least some actual users.

    Andi has encouraged everyone to use libnuma, but there is no
    serious reason why others have to.  It is not like it takes
    thousands of lines of elaborate code to perform basic operations
    using these calls.

    A search of some old SGI release software sitting on an internal
    server just now suggests that products with names including histx,
    gru, libmpi and pcp might be directly invoking these system calls
    ... I didn't actually examine the source to determine whether
    they really use these direct calls -- just got a grep hit.

    I would not be surprised if some of the big batch schedulers
    directly invoke these system calls, but don't know for sure.

In any event, we must assume that some use these system calls
directly.  They have been available in Linux for several years.

> > With the mode bit as in my patch, there are fewer places in the user
> > code that have to be gotten just right.  With your way, each and
> > every mbind and *_mempolicy call has to be hacked with the new flag
> > if one is going to use the new nodemask bit numbering.  Some of these
> 
> Yes and that makes sure it is thought through and done right.

Maybe for you.  Not for the rest of us error prone mere mortals.

Forcing coders to specify the same detail in multiple places, when
there is no way to validate their consistency, doesn't force them
to think or do it right.  It increases the error rate due to
inconsistencies.  If you have to select a binary mode once, you've got
a 50-50 chance of getting it correct with just a random try, and a
half-way decent chance of noticing an error, since it would affect all
such calls.  If you have to say it ten times scattered about your code
and the code of others you are calling and working with, that is being
maintained by various people coming and going over many years, and all
must be consistent, and there is -no- feedback on errors short of subtle
performance issues that only show up on certain non-trivial
configurations doing the particular sequence of calls that hit
the necessary miscoded places, then you've got about one chance in
2**10 of getting them all the same and correct, given random poking,
and close to zero chance of noticing that error in a timely fashion
when it does occur.  Admittedly, humans aren't random; but we're no
model of perfection either.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
