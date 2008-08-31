Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYHaRfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYHaRfD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYHaRey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:34:54 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:52516 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbYHaRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:34:53 -0400
Message-ID: <48BAD637.2050505@fr.ibm.com>
Date: Sun, 31 Aug 2008 19:34:47 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>	<Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu>	<1219437422.20559.146.camel@nimitz>	<48B0F449.2000006@cs.columbia.edu>	<1219768406.8680.17.camel@nimitz>	<48B49C61.1040003@cs.columbia.edu>	<1219851696.8680.67.camel@nimitz>	<20080827203427.GA1158@us.ibm.com>	<1219869510.8680.90.camel@nimitz>	<20080827204853.GA4189@us.ibm.com>	<1219870576.8680.96.camel@nimitz> <48BA454F.7050308@cs.columbia.edu>
In-Reply-To: <48BA454F.7050308@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan wrote:
> Dave, Serge:
> 
> I'm currently away so I must keep this short. I think we have so far
> more discussion than an actual problem. I'm happy to coordinate with
> every interested party to eventually see this work go into main stream.

thanks. We do need a moderator and federator.

> My only concerns are twofold: first, to get more feedback I believe we
> need to get the code a bit more usable; including FDs is an excellent
> way to actually do that. That will add significant value to the patch.

hmm, yes and no.

fd's are a must have but I would be more interested to see an external
checkpoint/restart and signal support first. why ? because it would be 
already usable for most computational programs in HPC, like this stupid 
one :

	https://www.ccs.uky.edu/~bmadhu/pi/pi1.c

signals are required because it's how 'load' and/or 'system' managers
interact with the jobs they spawn. external checkpoint/restart for the
same reason.

for files, I would first only care about stdios (make sure they're 
relinked to something safe on restart) and file states of regular files. 
contents is generally handled externally (deleted files being an annoying 
exception)

then, support for openmp application is a nice to have, so I'd probably 
go on with thread support.

> I think it's important to demonstrate how shared resources and multiple
> processes are handled. FDs demonstrate the former (with a fixed version
> of the recent patchset - I will post soon).

shared resources are only useful in a multiprocess/multitask context. 
I'd start working on this first. here we jump directly in the pid namespace
issues, how we start a set of process in a pidnamespace ? how do we 
relink it to its parent pidnamespace ? are signals well propagated ? etc. 
but hey, we'll have to solve it one day.

FD's are shared but have many types which are pain to handle. (it would 
interesting to see if we can add checkpoint() and restart() operations in 
fileops) So, for shared resources demonstration, I'd work on sysvipc, 
there are less types to handle and they force us to think how we are going 
to merge with the sysvipc namespaces. 

> The latter will increase the size of the patchset significantly, so 
> perhaps can indeed wait for now.

hmm, that depends how you do it.

If you restart all the hierarchy in the kernel, It will increase for sure 
the patch footprint. However if you restore the hierarchy from user space 
and then let each process restore itself from some binary blob, it should
not. This, of course, means that the binary blob representing the state of 
the container (we call it statefile) is not totally opaque. It see it a bit 
like  /proc, a directory containing shared states (all namespaces) and tasks 
states. That's something to discuss.

I do prefer the second option for many reasons: 

. each process restarts itself from its current context, this makes it easier 
  to reuse kernel services depending on current. 

. user tools can evaluate more precisely what they are going to restart from 
  the statefile. see this as a generalised 'readelf' that would be run on 
  the statefile, like we do on a core file today.
   

> It should not be hard for me to add functionality on top of a more
> basic patchset. The question is, what is "basic" ?  Anyway, I will be
> back towards the end of the week. Let's try to discuss this over IRC
> then (e.g. Friday afternoon ?).

IHMO, the first one is to support a 'basic' computational program in 
a real environment (under a load manager HPC). your POC nearly reaches
it but the user space API (how to launch, checkpoint, restart) needs to 
be worked on.


There are some big steps in the development.

Multi-task is a big step which opens plenty of other big steps with
shared resources : mem, ipc, fds, etc. Not all have to be solved
but at least detected if we don't have the support.

Network is another one. This is an interesting step to support 
distributed application using MPI over TCP. May be a priority.

there are also plenty of funky kernel resources used by misc servers,
database that will need special attention.



I'll be happy to start with the basic menu first as I know that it will
be useful for many applications ! 

Thanks,

C.
 
