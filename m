Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYJ3OkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYJ3OkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYJ3Ojt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:39:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60195 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbYJ3Ojt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:39:49 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
In-reply-to: <Pine.LNX.4.44L0.0810300943001.2401-100000@iolanthe.rowland.org>
	(message from Alan Stern on Thu, 30 Oct 2008 09:54:28 -0400 (EDT))
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
References: <Pine.LNX.4.44L0.0810300943001.2401-100000@iolanthe.rowland.org>
Message-Id: <E1KvYgR-0002Cx-AZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 30 Oct 2008 15:39:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Alan Stern wrote:
> On Thu, 30 Oct 2008, Miklos Szeredi wrote:
> 
> > On Wed, 29 Oct 2008, Alan Stern wrote:
> > > I discussed this last summer with Rafael.  It's a lot harder than it 
> > > looks, for all sorts of reasons.  For example, what about user tasks 
> > > that have access to memory-mapped I/O regions?
> > 
> > What about them?  Freezing doesn't seem to help with that.
> 
> Sure it does.  A frozen process can't touch a memory-mapped I/O region, 
> whereas a non-frozen process can.

But it can be in the middle of I/O by your definition.

> > > I don't know.  There are other interfaces too, like sysfs attributes, 
> > > that would have to be handled specially.  On the whole, the freezer 
> > > seems much, much simpler.
> > 
> > OK, then non-device files on "regular" filesystems.
> 
> Would you like to write a first-pass patch?  I don't think it will 
> work.

If somebody doesn't beat me to it, I'll do that (first implemented
with a global rw-sem).

> Doing that seems like a lot of work, just as modifying every driver 
> does.  Changing a few kernel entry points is simpler, but I'm pretty
> sure it won't work.  For instance, tasks can block arbitrarily long on 
> read calls (waiting for data to arrive); you can't allow such things to 
> prevent the system from suspending.

But we already do: either

 a) it's in interruptible sleep (I/O on sockets, pipes, etc), and
    freezing simply interrupts it, or

 b) it's in uninterruptible sleep and suspend will wait it out (or
    time out).

In the new scheme we could retain that part of the freezer: interrupt
all tasks which are inside the critical region and wait for them to
exit the critical region.

To put it in another way: it's still the freezer, it does all the same
things as the old freezer, except that the condition for freezing is
not that the task is out of the kernel, rather that it's out of the
disable_supend - enable_suspend region.  As such it's not a big change
to the whole suspend system, and so there shouldn't be anything big
going wrong there.

Miklos
