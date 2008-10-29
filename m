Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbYJ2Nvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbYJ2Nvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYJ2Nvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:51:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57494 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753854AbYJ2Nve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:51:34 -0400
Date: Wed, 29 Oct 2008 09:51:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: rjw@sisk.pl, <linux-kernel@vger.kernel.org>, <ncunningham@crca.org.au>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
In-Reply-To: <E1Kv688-0007Kp-SN@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0810290944240.2515-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Miklos Szeredi wrote:

> Not all callbacks.  I don't know what the current model is but AFAIR
> it should be something like this:
> 
>   1) call drivers to prepare for suspend (allocate space, etc)
>   2) stop all driver activity (plug queues, disable interrupts, etc)
>   3) call drivers to actually save state and power down
>   4) suspend
> 
> The part we are concerned is stopping driver activity.  It could be
> done with a mutex, or it could be done by freezing tasks.  Adding a
> mutex or other mechanism is the one I most like, but it's probably the
> biggest work, so lets look at how to fix the freezing:

Not only is adding a mutex the biggest amount of work, it has has the 
largest impact.  Every I/O pathway would have to acquire the 
appropriate mutex.  That's a significant additional load on the system.

> Currently the criteria for freezing is that userspace task has to exit
> kernelspace, and kernel task has to hit a specific "freeze point".
> This causes problems where we want to freeze tasks which are "stuck"
> inside filesystems or other non-driver parts of the kernel.  We can
> fix this two ways:
> 
>   a) mark additional places to freeze for userspace tasks as
>   well. This is the direction Nigel seems to be taking.
> 
>   b) or instead we could allow freezing anywhere in uninterruptible
>   sleep, _except_ where explicity marked.
> 
> Which is easier?  I don't know.  But I very storgly feel that marking
> un-freezable places instead of marking freezable places is a much
> cleaner solution.  It only affects parts of the kernel which have
> something to do with suspend, instead of affecting parts of the kernel
> which have absolutely nothing to do with suspend.

The problem with unrestricted freezing shows up when you freeze tasks
that hold a mutex or other sort of lock.  If this mutex is needed later
on for suspending a device then the suspend will hang, because a frozen
task can't release any mutexes.

I suppose you could try to categorize mutexes as "freezable" and 
"non-freezable".  Ones used by device drives would generally be 
non-freezable, whereas others (such as those used by VFS) would be 
freezable.  Still, it would be pretty difficult.  Among other things, 
it would be necessary to verify that a task holding a non-freezable 
mutex never tries to acquire a freezable mutex.

Alan Stern

