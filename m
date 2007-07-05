Return-Path: <linux-kernel-owner+w=401wt.eu-S1760655AbXGEJdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbXGEJdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbXGEJcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:32:52 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52108 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbXGEJcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:32:51 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <20070705091801.GB3084@elf.ucw.cz> (message from Pavel Machek on
	Thu, 5 Jul 2007 11:18:01 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 11:31:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> > > > > you still observe them if you use the version of the freezer which 
> > > > > doesn't freeze kernel threads?
> > > > 
> > > > In general the only way to guarantee there are no deadlocks is to
> > > > construct the graph of dependencies between tasks.  Those dependencies
> > > > are not in practice observable from outside the tasks, so it is
> > > > virtually impossible to construct the graph.
> > > 
> > > In which way can user space tasks depend on each other in a way that
> > > allows a them members of that cycle to be in uninterruptible sleep?
> > 
> >  - process A calls rename() on a fuse fs
> >  - process B, the fuse server, starts to process the rename request
> >  - process B is frozen before it can reply
> > 
> > Now process A is unfreezable.  We cannot make rename() restartable,
> > hence it cannot be interruptible.
> 
> Yes, we are claiming fuse is very special in this regard, and perhaps
> even broken.
> 
> Let's see. If I SIGSTOP the fuse server, I can get unrelated tasks
> unkillable (even for SIGKILL!) forever.

Actually fuse allows SIGKILL, because it's always fatal, and the
syscall may not be restarted.

> That's very special, and maybe even a FUSE bug. And that is also
> what makes FUSE special w.r.t. s2ram.

What makes fuse special is that some file operations are synchronous
and non-restartable.  That's just how the UNIX filesystem API works
and is hardly a bug in fuse.

> So no, you can't claim "FUSE is just IPC". It is very special IPC.

I did say it's special.  Sure, it has some "interesting" properties,
and with a bit of malice you can do very ugly things with it.  If you
are interested, read Documentation/filesystems/fuse.txt, especially
the "Tricky deadlock" section ;)

Miklos
