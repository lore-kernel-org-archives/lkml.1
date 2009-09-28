Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZI1QhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZI1QhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZI1QhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:37:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35791 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZI1QhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:37:12 -0400
Date: Mon, 28 Sep 2009 11:37:04 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oren Laadan <orenl@librato.com>, torvalds@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org, mingo@elte.hu,
       xemul@openvz.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Message-ID: <20090928163704.GA3327@us.ibm.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <20090924154139.2a7dd5ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924154139.2a7dd5ec.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 23 Sep 2009 19:50:40 -0400
> Oren Laadan <orenl@librato.com> wrote:
> > Q: What about namespaces ?
> > A: Currrently, UTS and IPC namespaces are restored. They demonstrate
> >    how namespaces are handled. More to come.
> 
> Will this new code muck up the kernel?

Actually user namespaces are handled as well.  Pid namespaces will
be named and recorded by kernel at checkpoint, and re-created in
userspace using clone(CLONE_NEWPID).  This shouldn't muck up the
kernel at all.  The handling of network and mounts namespaces is
at this point undecided.  Well, mounts namespaces themselves are
pretty simple, but not so much for mountpoints.  There it's mainly
a question of how to predict what a user wants to have automatically
recreated.  All mounts which differ between the root checkpoint task
and its parent?  Do we do no mounts for the restarted init task at
all, and only recreate mounts in private child namespaces (i.e. if a
task did a unshare(CLONE_NEWNS); mount --make-private /var; 
mount --bind /container2/var/run /var/run)?

I hear a decision was made at plumber's about how to begin
handling them, so I'll let someone (Oren? Dave?) give that info.

For network namespaces i think it's clearer that a wrapper
program should set up the network for the restarted init task,
while the usrspace code should recreate any private network
namespaces and veth's which were created by the application.
But it still needs discussion.

> > Q: What additional work needs to be done to it?
> > A: Fill in the gory details following the examples so far. Current WIP
> >    includes inet sockets, event-poll, and early work on inotify, mount
> >    namespace and mount-points, pseudo file systems
> 
> Will this new code muck up the kernel, or will it be clean?
> 
> > and x86_64 support.
> 
> eh?  You mean the code doesn't work on x86_64 at present?

There have been patches for it, but I think the main problem is noone
involved has hw to test.

> What is the story on migration?  Moving the process(es) to a different
> machine?

Since that's basically checkpoint; recreate container on remote
machine; restart on remote machine; that will mainly be done by
userspace code exploiting the c/r kernel patches.

The main thing we may want to add is a way to initiate pre-dump
of large amounts of VM while the container is still running.
I suspect Oren and Dave can say a lot more about that than I can
right now.

thanks,
-serge
