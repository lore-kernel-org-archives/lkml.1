Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXJWCy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXJWCy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXJWCyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:54:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60546 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbXJWCyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:54:19 -0400
X-Sasl-enc: GhyNMOQJ4VNjQ8AIty/UvxIQJdw1Te1RDiBTLbsMvRZQ 1193108058
Subject: Re: futex strangeness in 2.6.23-mm1/UML
From: Ian Kent <raven@themaw.net>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, miklos@szeredi.hu,
       linux-kernel@vger.kernel.org, xemul@openvz.org
In-Reply-To: <20071022213812.32bdac03@bree.surriel.com>
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>
	 <20071022145321.195d929b@bree.surriel.com>
	 <E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>
	 <20071022172926.03ca122a@bree.surriel.com>
	 <20071022200742.6f3acbb2@bree.surriel.com>
	 <20071022171624.0c00f8da.akpm@linux-foundation.org>
	 <20071022211143.5f69d790@bree.surriel.com>
	 <20071022213812.32bdac03@bree.surriel.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 10:54:11 +0800
Message-Id: <1193108052.3082.21.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-22 at 21:38 -0400, Rik van Riel wrote:
> On Mon, 22 Oct 2007 21:11:43 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> > I have my systems set up to automount my home directory over
> > NFS when I log in.  When trying to log in to the system with
> > 2.6.23-mm1, I get the messages from above in my syslog, and
> > the NFS filesystem is not automounted.
> > 
> > I am thinking something in autofs or the pid-namespace* patches
> > does not match up and uses a wrong PID number or process pointer
> > when trying to lock things.
> > 
> > Which code is at fault I have no idea...
> 
> I still do not know for sure, but I have found some code that
> puzzles me.
> 
> At fork() time, task->pid is set to task->pid->numbers[0].nr
> 
> On the other hand, fork() returns to the parent process:
> 
> task->pid[PIDTYPE_PID]->numbers[task->pid->level].nr
> 
> I have not unravelled the code enough yet to be sure whether
> this is always the same number, but having a wrong PID number
> somewhere could certainly explain these autofs4 errors:
> 
> Oct 22 14:39:01 kenny automount[2299]: cache_readlock: mapent cache
> rwlock lock failed
> Oct 22 14:39:01 kenny automount[2299]: unexpected pthreads error: 11 at
> 65 in cache.c
> 
> After all, autofs4 puts various kinds of PID information of the
> daemon into the autofs4 waitqueue:
> 
> fs/autofs4/waitq.c:296:
>                 wq->uid = current->uid;
>                 wq->gid = current->gid;
>                 wq->pid = current->pid;
>                 wq->tgid = current->tgid;
> 
> Could this be related?

Probably not wrt the pthreads lock fail.
The value passed to the daemon are used for information purposes.

The pid is used only to log who is asking for the mount.
The uid and gid are used to find user name and group name and the four
bits of user information are used to set values in the environment for
use as macros within the map.

If the values in the wait request are wrong then we probably wouldn't
even know as few people will be even aware they are available.

Ian


