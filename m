Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbXJEEqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbXJEEqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 00:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXJEEqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 00:46:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57466 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXJEEqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 00:46:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
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
	<m17im2pc7x.fsf@ebiederm.dsl.xmission.com>
	<15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>
Date: Thu, 04 Oct 2007 22:45:17 -0600
In-Reply-To: <15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com> (Kyle Moffett's
	message of "Thu, 4 Oct 2007 23:04:08 -0400")
Message-ID: <m1zlyymaoy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <mrmacman_g4@mac.com> writes:

> On Oct 04, 2007, at 21:44:02, Eric W. Biederman wrote:
>> What we want from the LSM is the ability to say -EPERM when we can clearly
>> articulate that we want to disallow something.
>
> This sort of depends on perspective; typically with security infrastructure you
> actually want "... the ability to return success when we can clearly articulate
> that we want to *ALLOW* something".   File permissions work this way; we don't
> have a list of forbidden  users attached to each file, we have an owner, a
> group, and a mode representing positive permissions.  With that said in certain
> high-
> risk environments you need something even stronger that cannot be changed by the
> "owner" of the file, if we don't entirely trust them,

Yes.  However last I looked at the LSM hooks we first do the normal unix
permission checks.  Then we run the hook.  So it can only increase the
number of times we say -EPERM.

>> SElinux is not all encompassing or it is generally incomprehensible I don't
>> know which.  Or someone long ago would have said a better  way to implement
>> containers was with a selinux ruleset, here is a  selinux ruleset that does
>> that.  Although it is completely possible  to implement all of the isolation
>> with the existing LSM hooks as  Serge showed.
>
> The difference between SELinux and containers is that SELinux (and LSM as a
> whole) returns -EPERM to operations outside the scope of the  subject, whereas
> containers return -ENOENT (because it's not even in  the same namespace).

Yes.  However if you look at what the first implementations were.  Especially
something like linux-vserver.  All they provided was isolation.  So perhaps
you would not see every process ps but they all had unique pid values.

I'm pretty certain Serge at least prototyped a simplified version
of that using the LSM hooks.  Is there something I'm not remember in
those hooks that allows hiding of information like processes?

Yes. Currently with containers we are taking that one step farther as
that solves a wider set of problems.

>> We also have in the kernel another parallel security mechanism (for what is
>> generally a different class of operations) that has been  quite successful,
>> and different groups get along quite well, and  ordinary mortals can
>> understand it.   The linux firewalling code.
>
> Well, I wouldn't go so far as the "ordinary mortals can understand it" part;
> it's still pretty high on the obtuse-o-meter.

True.  Probably a more accurate statement is:`unix command line power
users can and do handle it after reading the docs.  That's not quite
ordinary mortals but it feels like it some days.  It might all be
perception...

>> The linux firewalling codes has hooks all throughout the networking stack,
>> just like the LSM has hooks all throughout the rest of linux  kernel.  There
>> is a difference however.  The linux firewalling code in addition to hooks has
>> tables behind those hooks that it  consults. There is generic code to walk
>> those tables and consult with different kernel modules to decide if we should
>> drop a packet.  Each of those kernel modules provides a different capability
>> that can be used to generate a firewall.
>
> This is almost *EXACTLY* what SELinux provides as an LSM module.  The one
> difference is that with SELinux some compromises and restrictions  have been
> made so that (theoretically) the resulting policy can be  exhaustively analyzed
> to *prove* what it allows and disallows.  It  may be that SELinux should be
> split into 2 parts, one that provides  the underlying table-matching and the
> other that uses it to provide  the provability guarantees.  Here's a direct
> comparison:
>
> netfilter:
>   (A) Each packet has src, dst, port, etc that can be matched
>   (B) Table of rules applied sequentially (MATCH => ACTION)
>   (C) Rules may alter the properties of packets as they are routed/
> bridged/etc
>
> selinux:
>   (A) Each object has user, role, and type that can be matched
>   (B) Table of rules searched by object parameters (MATCH => allow/
> auditallow/transition)
>   (C) Rules may alter the properties of objects through transition rules.

Ok.  There is something here.

However in a generic setup, at least role would be an extended match
criteria provided by the selinux module.  It would not be a core
attribute.  It would need to depend on some extra functionality being
compiled in.

>> I'm not yet annoyed enough to go implement an iptables like interface to the
>> LSM enhancing it with more generic mechanism to make the problem simpler, but
>> I'm getting there.  Perhaps next time  I'm bored.
>
> I think a fair amount of what we need is already done in SELinux, and efforts
> would be better spent in figuring out what seems too complicated in SELinux and
> making it simpler.  Probably a fair amount  of that just means better tools.

How about thinking of it another way.  

Perform the split up you talked about above and move the table
matching into the LSM hooks.

Use something like the iptables action and match to module mapping
code so we can have multiple modules compiled in and useable at the
same time with the LSM hooks.

I think it is firmly established that selling SElinux to everyone is
politically untenable.  However enhancing the LSM (even if it is
mostly selinux code movement down a layer) I think can be sold.

If I could run Serge's isolation code and selinux rules at the same
time that would be interesting. 

My impression is that selinux is one monolithic blob that doesn't
allow me to incrementally add matching or action features that I
find interesting.

Eric
