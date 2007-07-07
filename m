Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbXGGUhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbXGGUhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXGGUhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:37:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34240 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXGGUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:37:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sat, 7 Jul 2007 22:44:45 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <200707061012.48998.rjw@sisk.pl> <200707071913.43482.nigel@nigel.suspend2.net> <20070707113118.GA2789@elf.ucw.cz>
In-Reply-To: <20070707113118.GA2789@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707072244.46645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 July 2007 13:31, Pavel Machek wrote:
> Hi!
> 
> > > I don't think we can do that. I suspect rename looks like:
> > > 
> > > 	write directory entry in source
> > > A)	(uninterruptible wait for write)
> > > 	write directory entry in destination
> > > 	(uninterruptible wait for write)
> > > 	write something else
> > > 
> > > If we freeze some task in place "A)", we'll write to the disk when the
> > > directory write is finished :-(.
> > 
> > Renaming is a single syscall, so won't the process get frozen when the syscall 
> > finishes? 
> 
> It would be frozen when syscall finishes. But if we freeze it at A)
> point, we have a problem.

With this patch, we don't freeze it. :-)

We do something like "send a freeze request to this task, but don't care if it
doesn't freeze".

Now, IMHO, the correctness here is the question of for how long a task can be
in TASK_UNINTERRUPTIBLE it it's not stuck (eg. the resource needed is gone
indefinitely, like in NFS) and I think that's not very long.

For example, if the tasks sleeps on a mutex, then it waits for another task to
release the mutex (interrupt handlers don't use mutexes) and I don't know of
any realistic scenario in which it can last in that state throughout
freeze_processes().

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
