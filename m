Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbXJaVF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbXJaVF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXJaVFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:05:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43041 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753985AbXJaVFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:05:21 -0400
Date: Wed, 31 Oct 2007 14:05:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071031131949.b91bf383.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
 <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
 <20071031131949.b91bf383.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Paul Jackson wrote:

> > Make both policy and the mode char?
> 
> Well, the mpol_nodemask_mode already is char.  So I guess you're
> asking if we should change 'policy' to type char as well.

Right.

> > Could we shorten the mpol_nodemask_mode to mode?
> 
> Huh - I don't know what "shorten ... to mode" means.  If it means
> "shorten ... to char", then see my previous comment above.

No it means shorted the identifier which is a bit long for a structure 
member.

> > Hmmm... I would rather have numactl manage this flag
> 
> Well, numactl is a command line utility.  It doesn't manage this flag
> as an -alternative- to some sort of changes to the mbind, set_mempolicy
> and get_mempolicy calls, but rather layers on top of changes to those
> system calls.  So I'm not sure what you mean, but I guess it is not
> relevant to this patch discussion.

s/numactl/libnuma/

> The question is:
> 
>     Should this mode be per-task, or per-system call?
> 
> The basic reason that I went with an additional per-task modal
> state, rather than a modal flag for each mbind, set_mempolicy and
> get_mempolicy call was to reduce the likely rate of bugs in user
> level C code using this API.

What bugs?

>     Programs that code to this API in C usually first spend some number
>     of lines of code preparing bitmasks that represent sets of nodes,
>     which they will then pass into these mempolicy system calls.
> 
>     The bits are numbered differently between Choices A and B.    

Right.

>     If a piece of code adapts Choice B numbering, because it is
>     better suited to that codes needs, and if we used your suggested
>     per-system call flag, then if they miss passing in the new special
>     flag on -even-one- mbind, set_mempolicy or get_mempolicy system
>     call, they have an obscure code bug.  They will be passing in
>     a bitmask that they calculated using Choice B node numbering,
>     but (implicitly) telling the kernel to interpret that bitmask
>     using Choice A semantics.

But that is only done in libnuma. User code does not call this directly.

> Why do you prefer a per-system call modal flag, rather than a per-task
> modal flag?

It is a change of behavior of the function call. If some mysterious flag 
somewhere influences that behavior then we have difficulties finding bugs. 
The presence of the flag makes it obvious to the reviewer that we do 
something special here.

