Return-Path: <linux-kernel-owner+w=401wt.eu-S1751200AbZKCPWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbZKCPWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZKCPWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:22:54 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53850 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750778AbZKCPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:22:54 -0500
Date: Tue, 3 Nov 2009 10:22:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
cc: linux-pcmcia@lists.infradead.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep violation in pcmcia
In-Reply-To: <20091102213837.GA26200@isilmar.linta.de>
Message-ID: <Pine.LNX.4.44L0.0911031016210.10778-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Dominik Brodowski wrote:

> Hey,
> 
> On Mon, Nov 02, 2009 at 04:21:23PM -0500, Alan Stern wrote:
> > I've been getting these warnings for a long, long time, and finally 
> > decided to report them:
> 
> Thanks!
> 
> > [ 1893.036023] other info that might help us debug this:
> > [ 1893.036023] 2 locks held by cardmgr/1457:
> 
> Wow, cardmgr still in use... I had hoped it had already disappeared on
> non-embedded systems...

Yeah; this is on a very old laptop running an FC4 distribution.  I
haven't bothered to upgrade it because there's no point; the CPU speed,
the amount of RAM, and the size of the hard disk are all very limited.

But of course this doesn't affect the main point.  Lockdep violations 
shouldn't occur, no matter what userspace does.

> > The cause is easy enough to track down.  In pcmcia_ioctl.c,
> > pcmcia_adjust_resource_info() does a down_read() on
> > pcmcia_socket_list_rwsem.  While holding the rwsem, one of the pathways
> > calls the s->resource_ops->add_mem method.  On my system this method is
> > realized by adjust_memory() in rsrc_nonstatic.c, which does its own
> > down_read() on the same rwsem -- i.e., a recursive locking attempt.
> > 
> > The reason lockdep warns about this behavior is that it can lead to
> > deadlock in the wrong circumstances, namely, if another thread were to
> > do a down_write() in between the two down_read() calls.
> > 
> > Would it be correct simply to omit the down_read() in adjust_memory()?
> 
> No, for there are other code paths reaching adjust_memory() not holding a
> (read) lock on this semaphore. As pcmcia_ioctl.c is on its way out anyways:
> would you mind keeping it as it is, for a down_write() call is quite
> unlikely during the only time cardmgr actually does this call (system
> startup)?

(Actually the violation occurs during system shutdown.)

I don't mind.  It hasn't caused any problems.  I just wanted to make 
sure that it was recognized as a real issue and was being dealt with 
appropriately.

Alan Stern

