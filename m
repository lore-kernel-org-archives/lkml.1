Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXJWBia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXJWBia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXJWBiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:38:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbXJWBiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:38:22 -0400
Date: Mon, 22 Oct 2007 21:38:12 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, xemul@openvz.org,
       raven@themaw.net
Subject: Re: futex strangeness in 2.6.23-mm1/UML
Message-ID: <20071022213812.32bdac03@bree.surriel.com>
In-Reply-To: <20071022211143.5f69d790@bree.surriel.com>
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>
	<20071022145321.195d929b@bree.surriel.com>
	<E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>
	<20071022172926.03ca122a@bree.surriel.com>
	<20071022200742.6f3acbb2@bree.surriel.com>
	<20071022171624.0c00f8da.akpm@linux-foundation.org>
	<20071022211143.5f69d790@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 21:11:43 -0400
Rik van Riel <riel@redhat.com> wrote:

> I have my systems set up to automount my home directory over
> NFS when I log in.  When trying to log in to the system with
> 2.6.23-mm1, I get the messages from above in my syslog, and
> the NFS filesystem is not automounted.
> 
> I am thinking something in autofs or the pid-namespace* patches
> does not match up and uses a wrong PID number or process pointer
> when trying to lock things.
> 
> Which code is at fault I have no idea...

I still do not know for sure, but I have found some code that
puzzles me.

At fork() time, task->pid is set to task->pid->numbers[0].nr

On the other hand, fork() returns to the parent process:

task->pid[PIDTYPE_PID]->numbers[task->pid->level].nr

I have not unravelled the code enough yet to be sure whether
this is always the same number, but having a wrong PID number
somewhere could certainly explain these autofs4 errors:

Oct 22 14:39:01 kenny automount[2299]: cache_readlock: mapent cache
rwlock lock failed
Oct 22 14:39:01 kenny automount[2299]: unexpected pthreads error: 11 at
65 in cache.c

After all, autofs4 puts various kinds of PID information of the
daemon into the autofs4 waitqueue:

fs/autofs4/waitq.c:296:
                wq->uid = current->uid;
                wq->gid = current->gid;
                wq->pid = current->pid;
                wq->tgid = current->tgid;

Could this be related?

Wrt. the UML failures that Miklos is seeing, I imagine UML needs
to do some similar tricks.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
