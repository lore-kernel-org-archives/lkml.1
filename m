Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbYCBAx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbYCBAx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 19:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYCBAxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 19:53:19 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52324 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYCBAxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 19:53:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
References: <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
	<20080227204546.72e16e8d.akpm@linux-foundation.org>
	<1204179747.3501.21.camel@raven.themaw.net>
	<20080227223734.caab0165.akpm@linux-foundation.org>
	<1204182500.3501.49.camel@raven.themaw.net>
	<20080227232339.af6e904a.akpm@linux-foundation.org>
	<1204185623.3501.84.camel@raven.themaw.net>
	<x494pbtxaup.fsf@segfault.boston.devel.redhat.com>
	<20080228195118.GA16634@sergelap.austin.ibm.com>
	<1204255932.3969.86.camel@raven.themaw.net>
	<20080229160921.GA24296@sergelap.ibm.com>
Date: Sat, 01 Mar 2008 17:49:58 -0700
In-Reply-To: <20080229160921.GA24296@sergelap.ibm.com> (Serge E. Hallyn's
	message of "Fri, 29 Feb 2008 10:09:21 -0600")
Message-ID: <m1fxva3q6h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> The way the user namespaces work right now is similar to say the IPC
> namespace - a task belongs to one user, that user belongs to precisely
> one user namespace.
>
> Even in my additional userns patches, I was changing uid to store the
> (uid, userns) so a struct user still belonged to just one user
> namespace.
>
> In contrast, with pid namespaces a task is associated with a 'struct
> pid' which links it to multiple process ids, one in each pid namespace
> to which it belongs.
>
> Perhaps we should be treating user namespaces like pid namespaces?

I definitely think we should have some support like that.

We already have code in nfsv4 and p9fs if I remember correctly to make
between the user namespace of the server (which is string based) and
the uids of the local machine.

We also have a similar issue with security keys.

I don't know if the strict hierarchical nature we have makes a lot of
sense.  One of the things that we should account for is that
frequently user namespaces are kept in sync between multiple machines
by system administrators.  So in the real world user namespaces are a
system administrator boundary.

> For autofs this would mean that when autofs wants a uid for some task,
> it would be given the uid in the user namespace which autofs
> 'knows'.

Yes.  The user namespace of the process that opened the pipe I believe
is the right choice there.

> It would also help me fix the siginfo problems I haven't solved yet -
> rather than having to worry about user namespace lifetimes with siginfos
> (which last a little while but have no clearly defined lifespan) we
> could send the uid in an init user namespace or the uid in the target
> uid namespace, or just a lightweight user struct proxy akin to 'struct
> pid'.

Yes.  For the pids we have been looking at sending the pid in the
target namespace and sending the uid in the target namespace should be
no more difficult.

> And it also obviates the need for any sort of delegation.
>
> So if I'm user 500 in what I think is the initial user namespace, I can
> create a container with a new user namespace, the init task of which is
> both uid 0 in the child userns, and uid 500 in the higher level,
> automatically giving the container access to any files I own.

Right.

Long term we want to look at making this an unprivileged operation.
Allowing a user to run less privileged processes.

My impression has always been that going from comparing (userns, uid)
to a more sophisticated mapping approach was a compatible extension.
However if it looks like we need user namespace mapping support up
front to get the semantics clean I have no problem with that.

> Eric, when you get a chance (I know you're overloaded atm) I'd love to
> hear your thoughts on this...

I think you are on the right track.  In a lot of ways the user
namespace is the trickiest, as this is where we change the security
rules.  If it is only at the level of who is who.

Since we already have user namespace mapping infrastructure in the
kernel and ways to call back to user space to ask what the mapping
should be, I feel performing mapping in the user namespace
and generalizing the existing capability is a good idea.

We still want to tell users if you can get away with it synchronize
your user namespaces across file systems, and kernels, and machines.

If they can't having good general tools in the kernel that you only
need to learn once and not once per instance sounds good.

Eric
