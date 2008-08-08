Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYHHEsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYHHEsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 00:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYHHEsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 00:48:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54509 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbYHHEsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 00:48:23 -0400
X-Sasl-enc: nkbytYcQOzGNLWHsxcwO1EHTMTJ8LIKwHqxgp/s6QzeS 1218170900
Subject: Re: [PATCH 2/4] autofs4 - track uid and gid of last mount requester
From: Ian Kent <raven@themaw.net>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org
In-Reply-To: <1218167314.17093.79.camel@raven.themaw.net>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
	 <20080807114012.4142.83607.stgit@web.messagingengine.com>
	 <20080807134650.a6a51f7d.akpm@linux-foundation.org>
	 <20080807221242.GA27032@us.ibm.com>
	 <1218167314.17093.79.camel@raven.themaw.net>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 12:44:02 +0800
Message-Id: <1218170643.17093.88.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-08 at 11:48 +0800, Ian Kent wrote:
> > > 
> > > Please remind me again why autofs's use of current->uid and
> > > current->gid is not busted in the presence of PID namespaces, where
> > > these things are no longer system-wide unique?
> > 
> > I actually don't see what the autofs4_waitq->pid is used for.  It's
> > copied from current into wq->pid at autofs4_wait, and into a packet to
> > send to userspace (I assume) at autofs4_notify_daemon.
> > 
> > So as long as a daemon can serve multiple pid namespaces (which
> > doubtless it can), the pid could be confusing (or erroneous) for the
> > daemon.
> 
> Your point is well taken.
> 
> The pid is used purely for logging purposes to aid in debugging in user
> space. I'm not sure it is worth worrying about it too much as the daemon
> has no business interfering with user space processes it is not the
> owner of.
> 
> > 
> > If I'm remotely right about how the pid is being used, then the thing to
> > do would be to 
> > 	1. store the daemon's pid namespace  (would that belong in
> > 	the autofs_sb_info?)
>  
> Yep.
> 
> > 	2. store the task_pid(current) in the waitqueue
> > 	3. retrieve the pid_t for the waiting task in the daemon's
> > 	pid namespace, and put that into the packet at
> > 	autofs4_notify_daemon.
> > 
> > I realize this patch was about the *uids*, but the pids seem more
> > urgent.
> 
> OK, I get it.
> I'll have a go at doing this for completeness.

On second thoughts I'm not sure about this.

The pid that is logged needs to relate to a process in the name space of
the one that caused the mount to be done.

For example, suppose a GUI user finds mounts never expiring, then we get
a debug log to try and identify the culprit. So the pid should
correspond to a process that the user sees (So I guess in the namespace
of that user).

This is the only reason I added the pid to the request packet in the
first place.

Please correct me if my understanding of this is not right.

Ian


> 
> Ian
> 

