Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYJ3Nyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYJ3Nyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYJ3Nyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:54:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58830 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753717AbYJ3Nyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:54:31 -0400
Date: Thu, 30 Oct 2008 09:54:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: rjw@sisk.pl, <linux-kernel@vger.kernel.org>, <ncunningham@crca.org.au>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
In-Reply-To: <E1KvKgv-0000bf-RS@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0810300943001.2401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Miklos Szeredi wrote:

> On Wed, 29 Oct 2008, Alan Stern wrote:
> > I discussed this last summer with Rafael.  It's a lot harder than it 
> > looks, for all sorts of reasons.  For example, what about user tasks 
> > that have access to memory-mapped I/O regions?
> 
> What about them?  Freezing doesn't seem to help with that.

Sure it does.  A frozen process can't touch a memory-mapped I/O region, 
whereas a non-frozen process can.  Although as Matthew pointed out, 
this is rapidly becoming a moot point.

> > > c) is slightly tricky, but could be done for example by setting a flag
> > > on open: FMODE_NO_SUSPEND_DISABLE (better name required), saying that
> > > implementation is responsible for getting the suspend disable magic
> > > right.
> > > 
> > > For starters this flag could be set for all non-device opens (maybe all
> > > non-char-dev opens?), solving the fuse vs. freezer issues without any
> > > complicated trickery.
> > 
> > I don't know.  There are other interfaces too, like sysfs attributes, 
> > that would have to be handled specially.  On the whole, the freezer 
> > seems much, much simpler.
> 
> OK, then non-device files on "regular" filesystems.

Would you like to write a first-pass patch?  I don't think it will 
work.

> > Regarding fuse, something like Nigel's scheme for preventing new 
> > requests and then waiting for old requests to complete might work out.  
> > Especially if you combine it with a strategy for making the freezer 
> > back and retry after a delay when something goes wrong.
> 
> I don't think it will work out, because to be able to do this some
> ordering between freezing the filesystems must be done.  But this is
> basically impossible, for all the same reasons it's impossible to
> order the freezing of userspace tasks.
> 
> Also this is not just a fuse issue: we have userspace network devices,
> we have userspace USB drivers, etc, affected by this problem.
> 
> If there _is_ a solution with the freezer that does solve all of this,
> I haven't yet heard it.  But yeah, in the end the simpler solution
> should win.

To do this properly, it is necessary to categorize sleeping states.  
Some should count as frozen and others shouldn't.  So for instance, all 
the mutexes and wait queues involved in VFS would count as frozen; a 
process waiting on one of them can simply be kept from waking up until 
the suspend is over.  Others (those involved in device I/O) wouldn't 
count as frozen; a task waiting on one of them would have to wake up 
and move forward before the system could suspend.

Doing that seems like a lot of work, just as modifying every driver 
does.  Changing a few kernel entry points is simpler, but I'm pretty
sure it won't work.  For instance, tasks can block arbitrarily long on 
read calls (waiting for data to arrive); you can't allow such things to 
prevent the system from suspending.

Alan Stern

