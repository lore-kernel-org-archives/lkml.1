Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbYJ2Oug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbYJ2Oug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 10:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYJ2Ou2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 10:50:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39042 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYJ2Ou1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 10:50:27 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
In-reply-to: <Pine.LNX.4.44L0.0810290944240.2515-100000@iolanthe.rowland.org>
	(message from Alan Stern on Wed, 29 Oct 2008 09:51:34 -0400 (EDT))
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
References: <Pine.LNX.4.44L0.0810290944240.2515-100000@iolanthe.rowland.org>
Message-Id: <E1KvCN9-00081i-KF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Oct 2008 15:50:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Alan Stern wrote:
> On Wed, 29 Oct 2008, Miklos Szeredi wrote:
> 
> > Not all callbacks.  I don't know what the current model is but AFAIR
> > it should be something like this:
> > 
> >   1) call drivers to prepare for suspend (allocate space, etc)
> >   2) stop all driver activity (plug queues, disable interrupts, etc)
> >   3) call drivers to actually save state and power down
> >   4) suspend
> > 
> > The part we are concerned is stopping driver activity.  It could be
> > done with a mutex, or it could be done by freezing tasks.  Adding a
> > mutex or other mechanism is the one I most like, but it's probably the
> > biggest work, so lets look at how to fix the freezing:
> 
> Not only is adding a mutex the biggest amount of work, it has has the 
> largest impact.  Every I/O pathway would have to acquire the 
> appropriate mutex.  That's a significant additional load on the system.

Actually I was thinking of an rw-semaphore, not a mutex.  But yeah
that still has scalability problems.  But it could be done with custom
locking primitives, optimized for this case:

   suspend_disable();
   /* driver stuff */
   suspend_enable();

> The problem with unrestricted freezing shows up when you freeze tasks
> that hold a mutex or other sort of lock.  If this mutex is needed later
> on for suspending a device then the suspend will hang, because a frozen
> task can't release any mutexes.

I did a random sampling of ->suspend() callbacks, and they don't seem
to be taking mutexes.  Does that happen at all?

Did anybody ever try modifying the freezer for suspend (not
hibernate), so that it allows tasks not in running state to freeze?
If not, I think that's an experiment worth doing.

Miklos
