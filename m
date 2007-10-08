Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbXJHRVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbXJHRVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXJHRVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:21:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46544 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXJHRVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:21:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
References: <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
	<1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
	<alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
	<4702B1D5.5050502@tmr.com>
	<alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
	<4703126D.70703@tmr.com>
	<alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org>
	<m17im2pc7x.fsf@ebiederm.dsl.xmission.com>
	<15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>
	<m1zlyymaoy.fsf@ebiederm.dsl.xmission.com>
	<20071008160611.GA7106@vino.hallyn.com>
Date: Mon, 08 Oct 2007 11:20:22 -0600
In-Reply-To: <20071008160611.GA7106@vino.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 8 Oct 2007 11:06:11 -0500")
Message-ID: <m11wc5a5gp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> Perform the split up you talked about above and move the table
>> matching into the LSM hooks.
>> 
>> Use something like the iptables action and match to module mapping
>> code so we can have multiple modules compiled in and useable at the
>> same time with the LSM hooks.
>> 
>> I think it is firmly established that selling SElinux to everyone is
>> politically untenable.  However enhancing the LSM (even if it is
>> mostly selinux code movement down a layer) I think can be sold.
>> 
>> If I could run Serge's isolation code and selinux rules at the same
>> time that would be interesting. 
>
> But given that namespaces are making it upstream, what else is to be
> gained from the bsdail module?  What exactly are you looking for?

Good question.  I keep tripping over the LSM hooks, and I have the
distinct impression that part of the current contention and lack of
agreement is simply the way things are current factored.  So I'm
putting for a constructive suggestion that has the possibility of
going somewhere.

> 1. are you looking to cover all the corner cases - i.e. prevent killing
> a process in another namespace through F_SETOWN or mqueue, etc?

I'm looking towards this yes.  There are times when we deliberately
allow mixing of things by the definition of what namespaces are and
there are some use cases where people don't want this.

> 2. are you looking for a potentially easier fix to the current absence
> of isolation in the user namespace?

No.  I'm not even worrying about the user namespace until it resembles
complete.  Currently I just view it as a stub because as is, the
security namespace is pretty much useless for any case I think about.
We still have way to many cases where the kernel treats different
names as the same name.

> 3. are you just generally looking to make lsm/selinux easier for
> yourself to configure?

Well.  I'm trying to make the LSM more useful to hack on and configure,
and much less contentions for ordinary people to use.

There is one issue with sockets that has come up where there are
people who really want to filter things at connect and bind time.
The LSM is so inflexible the only sane suggestion at the time was
to duplicate the LSM hooks and add an new iptable style table
for making that decision.

Also I'm thinking towards what do we have to do isolate the security
module stuff in the context of a namespace.  So that a person in
a container can setup their own rules that further restrict the
system.

So far I'm not ready to do anything yet but I'm keeping a weather eye
on the situation so I have a clue what I'm go.

> If 1, an selinux policy should cover you.  So you can then skip to 3.
> Or, alternatively, I do plan - as soon as my free time clears up a bit -
> on demonstrating how to write some selinux policy to create a secure
> container based on current -mm + your experimental network namespace
> patches.

Thanks that sounds interesting.

> If 3, then selinux policy modules may actually help you, else either
> a new LSM (maybe like LIDS) or a userspace tool which is a front-end to
> selinux policy, emulating the iptables rules formats, may be what you
> want?

I don't want to have to choose my LSM at compile time.  I want to
add support into the kernel at compile time and be able to configure
it before I go multi-user.  I know this kind of architecture is
achievable because iptables allows it.

When I conceive as the security modules as just a firewall between
applications on my own box I think, oh yeah this is no big deal,
I might want to limit something that way some time.  These are just
some additional rules on when to return -EPERM.  So I ask myself why
is this situation much less flexible and much harder to use then our
network firewall code?

>> My impression is that selinux is one monolithic blob that doesn't
>> allow me to incrementally add matching or action features that I
>> find interesting.
>
> Actually with policy modules it gets much much better.  I have in fact
> been able to pretty easily write a short policy module to, say, create
> an selinux user which ran as root and had full access to the system to
> do system setup for automated testing.  There is a learning curve in
> having to look at existing modules for maybe a few days to get started,
> but once you get started the policy modules do make it very easy to
> add to current policy.

Ok. Interesting.  Are these kernel modules?

Still while I get the general impression that selinux seems to be
very close to a generic solution, and that selinux more or less has
the architecture we might want.  I don't get the impression that
selinux does this at a level that is open to other people doing
interesting things.

So I still ask the question can we move this functionality down to
the LSM in a way that will solve the composition problem between
multiple security modules?

It really seems to me that the LSM as currently structured creates
a large barrier to entry for people who have just this little thing
they want to do that is not possible with any existing security
module.

Eric
