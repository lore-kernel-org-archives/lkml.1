Return-Path: <linux-kernel-owner+w=401wt.eu-S1423154AbXBISfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423154AbXBISfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423182AbXBISfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:35:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49140 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423154AbXBISfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:35:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>
	<20070116063030.761795000@bull.net>
	<20070122115638.835b26a1.akpm@osdl.org> <45B61E50.6020607@bull.net>
	<m1mz3poeda.fsf@ebiederm.dsl.xmission.com> <45CC68BA.4010403@bull.net>
Date: Fri, 09 Feb 2007 11:35:21 -0700
In-Reply-To: <45CC68BA.4010403@bull.net> (Nadia Derbey's message of "Fri, 09
	Feb 2007 13:27:38 +0100")
Message-ID: <m11wkz5gd2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey <Nadia.Derbey@bull.net> writes:

> I do not fully agree with you:
> It is true that some ipc tunables play the role of DoS limits.
> But IMHO the *mni ones (semmni, msgmni, shmmni) are used by the ipc subsystem to
> adapt its data structures sizes to what is being asked for through the tunable
> value. I think this is how they manage to take into account a new tunable value
> without a need for rebooting the system: reallocate some more memory on demand.

Yes, they do.  However if you are constantly having to play with shmmni or
the others that is the problem and the array should be replaced with
a hash table or some form of radix tree, so it changes it's size to fit
the need.  Once that is done, shmmni does become a simple DOS limit.

So what I'm asking is please fix the problem at the source don't plaster over
it.

> Now, what the akt framework does, is that it takes advantage of this concept of
> "on demand memory allocation" to replace a user (or a daemon) that would
> periodically check its ipcs consumptions and manually adjust the ipcs tunables:
> Doing this from the user space would imply a latency that makes it difficult to
> react fast enough to resources running out.

There may be some sense in this but you haven't found something that inherently
needs tuning.  You have found something that has a poor data structure,
and can more easily be fixed by simply fixing the data structure.

I'm guessing that we have a disconnect somewhere with kernel developers thinking
shm is an old legacy api and doing minimal maintenance, expecting serious users
to use tmpfs or hugetlbfs and users not used to the old stuff using the SYSV apis.

If we have serious users it makes sense to fix these things properly, in a backwards
compatible way, so existing users and applications don't need to be changed.


> Now, talking about DoS limits, akt implements them in a sense: each tunable
> managed by akt has 3 attributes exported to sysfs:
> . autotune: enable / disable auto-tuning
> . min: min value the tunable can ever reach
> . max: max value the tunable can ever reach
>
> Enabling a sysadmin to play with these min and max values makes it possible to
> refine the dynamic adjustment, and avoid that the tunable reaches really huge
> values.

This just shifts the location where you have your DOS limit and could
be done transparently under the covers with shmmni being the maximum.
If we can't get users to switch to something that doesn't need tuning
that has been available for years, I doubt even more user tunables
that tune the tunables will make the situation any better.  I suspect
your changes would just confuse the landscape even more and give us
more weird legacy cases to support that we can never get rid of?

Eric
