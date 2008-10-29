Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYJ2P2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYJ2P2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYJ2P2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:28:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56107 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752980AbYJ2P2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:28:35 -0400
Date: Wed, 29 Oct 2008 11:28:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: rjw@sisk.pl, <linux-kernel@vger.kernel.org>, <ncunningham@crca.org.au>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
In-Reply-To: <E1KvCN9-00081i-KF@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0810291122220.2189-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Miklos Szeredi wrote:

> Actually I was thinking of an rw-semaphore, not a mutex.  But yeah
> that still has scalability problems.  But it could be done with custom
> locking primitives, optimized for this case:
> 
>    suspend_disable();
>    /* driver stuff */
>    suspend_enable();

Yes, it could be done.  And the overhead could be minimized by using
per-CPU variables.  It would still be an awful lot of work, and easy to
get wrong.

> > The problem with unrestricted freezing shows up when you freeze tasks
> > that hold a mutex or other sort of lock.  If this mutex is needed later
> > on for suspending a device then the suspend will hang, because a frozen
> > task can't release any mutexes.
> 
> I did a random sampling of ->suspend() callbacks, and they don't seem
> to be taking mutexes.  Does that happen at all?

It does, particularly among drivers that do runtime PM, which is 
becoming more and more important.

Besides, suspend has to synchronize with I/O somehow.  Right now that 
is handled by making suspend wait until no tasks are doing I/O (because 
they are all frozen).  If you allow tasks to be frozen at more or less 
arbitrary times, while holding arbitrary locks, then you may end up 
freezing a task that's in the middle of I/O.  That should certainly 
block the suspend (not to mention messing up the I/O operation).

> Did anybody ever try modifying the freezer for suspend (not
> hibernate), so that it allows tasks not in running state to freeze?
> If not, I think that's an experiment worth doing.

What happens if the reason the task isn't running is because it's 
waiting for I/O to complete?  I just don't think this can be made to 
work.

Alan Stern

