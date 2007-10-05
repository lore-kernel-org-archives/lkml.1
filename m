Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbXJEBqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbXJEBqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 21:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760516AbXJEBqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 21:46:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54698 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760477AbXJEBqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 21:46:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
References: <46FEEBD4.5050401@schaufler-ca.com>
	<20070930011618.ccb8351b.akpm@linux-foundation.org>
	<Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
	<alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
	<1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
	<alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
	<4702B1D5.5050502@tmr.com>
	<alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
	<4703126D.70703@tmr.com>
	<alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org>
Date: Thu, 04 Oct 2007 19:44:02 -0600
In-Reply-To: <alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 2 Oct 2007 21:52:06 -0700 (PDT)")
Message-ID: <m17im2pc7x.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> To get back to security: I didn't want pluggable security because I 
> thought that was a technically good solution. No, the reason Linux has LSM 
> (and yes, I was the one who pushed hard for the whole thing, even if I 
> didn't actually write any of it) was because the problem wasn't technical 
> to begin with.
>
> It was social/political and administrative.
>
> See? Another fundamental difference between schedulers and security 
> modules. 

>
> But no, that's not really why we have LSM. I'd have *much* preferred to 
> have one unified security module setup that we could all agree on, and no 
> pluggable security modules. It was not to be - and the reason we have LSM 
> is not because "it makes more sense than a CPU scheduler", but simply 
> because "people didn't actually get anything done at all, because they 
> just argued about what to do".
>
> In the CPU schedulers, Ingo still gets work done, even though people argue 
> about it. So we haven't needed to go to the extreme of an "LSM for CPU 
> schedulers", because the arguments don't actually hold up the work.
>
> And THAT is what matters in the end.

Sounds good.

I want to inject some fresh ideas into this discussion from a completely
different viewpoint, who knows I might get lucky and make things
better.

All you can do with the LSM is return -EPERM when the normal unix
permissions would not have allowed an operation.  I don't see where
there is any magic or mystery in that, or any need for deep
understanding.


What we want from the LSM is the ability to say -EPERM when we can
clearly articulate that we want to disallow something.


SElinux is not all encompassing or it is generally incomprehensible I
don't know which.  Or someone long ago would have said a better
way to implement containers was with a selinux ruleset, here is a
selinux ruleset that does that.  Although it is completely possible to
implement all of the isolation with the existing LSM hooks as Serge
showed.

It is a legitimate criticism of the LSM that we are not improving our
in-kernel abstractions to allow better concepts to base decisions
upon when to return -EPERM.  My first dealing with selinux and the lsm
was when I fixed a security issue in /proc fixed the abstractions we
were using and the default selinux security policy had a fit.  If
don't have good concepts in /proc/pid/xxx which is heavily used it
would not surprise me at all if there are lots of other places in the
kernel where our abstractions holes that have not yet been shorn up.

We also have in the kernel another parallel security mechanism (for
what is generally a different class of operations) that has been quite
successful, and different groups get along quite well, and ordinary
mortals can understand it.   The linux firewalling code.


The linux firewalling codes has hooks all throughout the networking
stack, just like the LSM has hooks all throughout the rest of linux
kernel.  There is a difference however.  The linux firewalling code in
addition to hooks has tables behind those hooks that it consults.
There is generic code to walk those tables and consult with different
kernel modules to decide if we should drop a packet.  Each of those
kernel modules provides a different capability that can be used to
generate a firewall.

Meanwhile composition of a policy using code from different clients
of the LSM hooks is impossible, and thus cooperation or wider use of
the LSM hooks is difficult.

So I propose that if people want to work towards a one true linux
solution for additional security checks, then they should look towards
the linux firewalling code.  It works and it seems to very nicely
allow cooperations between different groups.  For the people who will
scream mixing security models causes problems, the answer is simple
recommend users don't set up their policies that way.


I know we can't solve human problems with technical measures but
perhaps a technical suggestion can open the way to the solution to
some human problems.

I'm not yet annoyed enough to go implement an iptables like interface
to the LSM enhancing it with more generic mechanism to make the
problem simpler, but I'm getting there.  Perhaps next time I'm bored.

Eric
