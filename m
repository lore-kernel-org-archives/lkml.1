Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbXJaUUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbXJaUUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXJaUTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:19:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59449 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbXJaUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:19:52 -0400
Date: Wed, 31 Oct 2007 13:19:49 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
Message-Id: <20071031131949.b91bf383.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
	<Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> >  	short policy; 	/* See MPOL_* above */
> > +	char mpol_nodemask_mode; /* See MPOL_MODE_* above; union c below */
> 
> Make both policy and the mode char?

Well, the mpol_nodemask_mode already is char.  So I guess you're
asking if we should change 'policy' to type char as well.

Changing 'policy' from a short to a char would reduce the sizeof
(struct mempolicy) on 16-bit systems, as both chars would fit in one
word.  But this code doesn't run on 16-bit systems.

> Could we shorten the mpol_nodemask_mode to mode?

Huh - I don't know what "shorten ... to mode" means.  If it means
"shorten ... to char", then see my previous comment above.

> Hmmm... I would rather have numactl manage this flag

Well, numactl is a command line utility.  It doesn't manage this flag
as an -alternative- to some sort of changes to the mbind, set_mempolicy
and get_mempolicy calls, but rather layers on top of changes to those
system calls.  So I'm not sure what you mean, but I guess it is not
relevant to this patch discussion.

> and specify it in calls to set memory policies.

This suggestion I do think I understand - good.  However I disagree.
Here's what I think you meant, and why I disagree.

My current patch adds a new per-task modal state, that is manipulated
by additional get_mempolicy calls and options.

I think you are stating a preference for passing an additional flag on
each mbind, set_mempolicy and get_mempolicy call, to be used when you
want to use this new way (so called "Choice B") of numbering nodes.

The question is:

    Should this mode be per-task, or per-system call?

The basic reason that I went with an additional per-task modal
state, rather than a modal flag for each mbind, set_mempolicy and
get_mempolicy call was to reduce the likely rate of bugs in user
level C code using this API.

    Programs that code to this API in C usually first spend some number
    of lines of code preparing bitmasks that represent sets of nodes,
    which they will then pass into these mempolicy system calls.

    The bits are numbered differently between Choices A and B.    

    If a piece of code adapts Choice B numbering, because it is
    better suited to that codes needs, and if we used your suggested
    per-system call flag, then if they miss passing in the new special
    flag on -even-one- mbind, set_mempolicy or get_mempolicy system
    call, they have an obscure code bug.  They will be passing in
    a bitmask that they calculated using Choice B node numbering,
    but (implicitly) telling the kernel to interpret that bitmask
    using Choice A semantics.

    Essentially, a per-task modal flag, rather than a per-system call
    modal flag, is a better fit for the typical C code usage of this
    Choice, because it will be an entire chunk of user level code
    manipulating these bitmasks that either has to be all Choice A,
    or all Choice B (except in special cases, carefully coded.)

Why do you prefer a per-system call modal flag, rather than a per-task
modal flag?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
