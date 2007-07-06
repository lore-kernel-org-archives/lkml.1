Return-Path: <linux-kernel-owner+w=401wt.eu-S1763254AbXGFHIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763254AbXGFHIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763095AbXGFHIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:08:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763091AbXGFHIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:08:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:16:15 +0200
User-Agent: KMail/1.9.5
Cc: Miklos Szeredi <miklos@szeredi.hu>, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705220444.GD3881@elf.ucw.cz>
In-Reply-To: <20070705220444.GD3881@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707060916.16368.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 00:04, Pavel Machek wrote:
> Hi!
> 
> > > > > > > I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> > > > > > > you still observe them if you use the version of the freezer which 
> > > > > > > doesn't freeze kernel threads?
> > > > > > 
> > > > > > In general the only way to guarantee there are no deadlocks is to
> > > > > > construct the graph of dependencies between tasks.  Those dependencies
> > > > > > are not in practice observable from outside the tasks, so it is
> > > > > > virtually impossible to construct the graph.
> > > > > 
> > > > > In which way can user space tasks depend on each other in a way that
> > > > > allows a them members of that cycle to be in uninterruptible sleep?
> > > > 
> > > >  - process A calls rename() on a fuse fs
> > > >  - process B, the fuse server, starts to process the rename request
> > > >  - process B is frozen before it can reply
> > > > 
> > > > Now process A is unfreezable.  We cannot make rename() restartable,
> > > > hence it cannot be interruptible.
> > > 
> > > Yes, we are claiming fuse is very special in this regard, and perhaps
> > > even broken.
> > > 
> > > Let's see. If I SIGSTOP the fuse server, I can get unrelated tasks
> > > unkillable (even for SIGKILL!) forever.
> > 
> > Actually fuse allows SIGKILL, because it's always fatal, and the
> > syscall may not be restarted.
> 
> Okay, and you should handle refrigerator in the same paths where you
> handle SIGKILL. Just add try_to_freeze() there...

In fact the problem is more complicated than that, because some tasks may
be waiting on VFS locks related to FUSE.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
