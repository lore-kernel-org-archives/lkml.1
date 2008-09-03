Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYICLks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYICLks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYICLkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:40:40 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:48887 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbYICLkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:40:39 -0400
From: Andrey Mirkin <amirkin@parallels.com>
To: devel@openvz.org
Subject: Re: [Devel] Re: [RFC v2][PATCH 4/9] Memory management - dump state
Date: Wed, 3 Sep 2008 15:43:21 +0400
User-Agent: KMail/1.8.2
Cc: Cedric Le Goater <clg@fr.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, jeremy@goop.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <48BA454F.7050308@cs.columbia.edu> <48BAD637.2050505@fr.ibm.com>
In-Reply-To: <48BAD637.2050505@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031543.24001.amirkin@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 August 2008 21:34 Cedric Le Goater wrote:
> Oren Laadan wrote:
> > Dave, Serge:
> >
> > I'm currently away so I must keep this short. I think we have so far
> > more discussion than an actual problem. I'm happy to coordinate with
> > every interested party to eventually see this work go into main stream.
>
> thanks. We do need a moderator and federator.
>
> > My only concerns are twofold: first, to get more feedback I believe we
> > need to get the code a bit more usable; including FDs is an excellent
> > way to actually do that. That will add significant value to the patch.
>
> hmm, yes and no.
>
> fd's are a must have but I would be more interested to see an external
> checkpoint/restart and signal support first. why ? because it would be
> already usable for most computational programs in HPC, like this stupid
> one :
>
> 	https://www.ccs.uky.edu/~bmadhu/pi/pi1.c
>
> signals are required because it's how 'load' and/or 'system' managers
> interact with the jobs they spawn. external checkpoint/restart for the
> same reason.

I'm sorry for being out of discussion for so long time.
I've just sent a patchset with external checkpoint/restart as it is 
implemented in OpenVZ.
External checkpoint/restart also is very usefull if we will have container's 
infrastructure in mainstream.
It won't be very hard to add support for signals in my patchset. I'll wait for 
some time for comments and will add support for signals in next version.

Regards,
Andrey

>
> for files, I would first only care about stdios (make sure they're
> relinked to something safe on restart) and file states of regular files.
> contents is generally handled externally (deleted files being an annoying
> exception)
>
> then, support for openmp application is a nice to have, so I'd probably
> go on with thread support.
>
> > I think it's important to demonstrate how shared resources and multiple
> > processes are handled. FDs demonstrate the former (with a fixed version
> > of the recent patchset - I will post soon).
>
> shared resources are only useful in a multiprocess/multitask context.
> I'd start working on this first. here we jump directly in the pid namespace
> issues, how we start a set of process in a pidnamespace ? how do we
> relink it to its parent pidnamespace ? are signals well propagated ? etc.
> but hey, we'll have to solve it one day.
>
> FD's are shared but have many types which are pain to handle. (it would
> interesting to see if we can add checkpoint() and restart() operations in
> fileops) So, for shared resources demonstration, I'd work on sysvipc,
> there are less types to handle and they force us to think how we are going
> to merge with the sysvipc namespaces.
>
> > The latter will increase the size of the patchset significantly, so
> > perhaps can indeed wait for now.
>
> hmm, that depends how you do it.
>
> If you restart all the hierarchy in the kernel, It will increase for sure
> the patch footprint. However if you restore the hierarchy from user space
> and then let each process restore itself from some binary blob, it should
> not. This, of course, means that the binary blob representing the state of
> the container (we call it statefile) is not totally opaque. It see it a bit
> like  /proc, a directory containing shared states (all namespaces) and
> tasks states. That's something to discuss.
>
> I do prefer the second option for many reasons:
>
> . each process restarts itself from its current context, this makes it
> easier to reuse kernel services depending on current.
>
> . user tools can evaluate more precisely what they are going to restart
> from the statefile. see this as a generalised 'readelf' that would be run
> on the statefile, like we do on a core file today.
>
> > It should not be hard for me to add functionality on top of a more
> > basic patchset. The question is, what is "basic" ?  Anyway, I will be
> > back towards the end of the week. Let's try to discuss this over IRC
> > then (e.g. Friday afternoon ?).
>
> IHMO, the first one is to support a 'basic' computational program in
> a real environment (under a load manager HPC). your POC nearly reaches
> it but the user space API (how to launch, checkpoint, restart) needs to
> be worked on.
>
>
> There are some big steps in the development.
>
> Multi-task is a big step which opens plenty of other big steps with
> shared resources : mem, ipc, fds, etc. Not all have to be solved
> but at least detected if we don't have the support.
>
> Network is another one. This is an interesting step to support
> distributed application using MPI over TCP. May be a priority.
>
> there are also plenty of funky kernel resources used by misc servers,
> database that will need special attention.
>
>
>
> I'll be happy to start with the basic menu first as I know that it will
> be useful for many applications !
>
> Thanks,
>
> C.
>
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
>
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel
