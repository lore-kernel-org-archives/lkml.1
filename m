Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYJ3UNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYJ3UNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYJ3UNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:13:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbYJ3UNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:13:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Date: Thu, 30 Oct 2008 21:17:48 +0100
User-Agent: KMail/1.9.9
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0810300943001.2401-100000@iolanthe.rowland.org> <E1KvYgR-0002Cx-AZ@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KvYgR-0002Cx-AZ@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810302117.49419.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 30 of October 2008, Miklos Szeredi wrote:
> On Thu, 30 Oct 2008, Alan Stern wrote:
> > On Thu, 30 Oct 2008, Miklos Szeredi wrote:
> > 
> > > On Wed, 29 Oct 2008, Alan Stern wrote:
> > > > I discussed this last summer with Rafael.  It's a lot harder than it 
> > > > looks, for all sorts of reasons.  For example, what about user tasks 
> > > > that have access to memory-mapped I/O regions?
> > > 
> > > What about them?  Freezing doesn't seem to help with that.
> > 
> > Sure it does.  A frozen process can't touch a memory-mapped I/O region, 
> > whereas a non-frozen process can.
> 
> But it can be in the middle of I/O by your definition.
> 
> > > > I don't know.  There are other interfaces too, like sysfs attributes, 
> > > > that would have to be handled specially.  On the whole, the freezer 
> > > > seems much, much simpler.
> > > 
> > > OK, then non-device files on "regular" filesystems.
> > 
> > Would you like to write a first-pass patch?  I don't think it will 
> > work.
> 
> If somebody doesn't beat me to it, I'll do that (first implemented
> with a global rw-sem).
> 
> > Doing that seems like a lot of work, just as modifying every driver 
> > does.  Changing a few kernel entry points is simpler, but I'm pretty
> > sure it won't work.  For instance, tasks can block arbitrarily long on 
> > read calls (waiting for data to arrive); you can't allow such things to 
> > prevent the system from suspending.
> 
> But we already do: either
> 
>  a) it's in interruptible sleep (I/O on sockets, pipes, etc), and
>     freezing simply interrupts it, or
> 
>  b) it's in uninterruptible sleep and suspend will wait it out (or
>     time out).
> 
> In the new scheme we could retain that part of the freezer: interrupt
> all tasks which are inside the critical region and wait for them to
> exit the critical region.
> 
> To put it in another way: it's still the freezer, it does all the same
> things as the old freezer, except that the condition for freezing is
> not that the task is out of the kernel, rather that it's out of the
> disable_supend - enable_suspend region.  As such it's not a big change
> to the whole suspend system, and so there shouldn't be anything big
> going wrong there.

I like this idea.

I was thinking about using task flags to mark processes as "not freezable
at the moment", which would make the freezer to wait for such tasks
(currently a task may only be always freezable or not freezable at all,
which is not very flexible).

Unfortunately, I didn't have the time to implement this.

Thanks,
Rafael
