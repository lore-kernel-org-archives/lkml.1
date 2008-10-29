Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYJ2QKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYJ2QKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYJ2QKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:10:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47334 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYJ2QKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:10:35 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
In-reply-to: <Pine.LNX.4.44L0.0810291122220.2189-100000@iolanthe.rowland.org>
	(message from Alan Stern on Wed, 29 Oct 2008 11:28:34 -0400 (EDT))
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
References: <Pine.LNX.4.44L0.0810291122220.2189-100000@iolanthe.rowland.org>
Message-Id: <E1KvDcp-0008B7-SR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Oct 2008 17:10:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Alan Stern wrote:
> On Wed, 29 Oct 2008, Miklos Szeredi wrote:
> 
> > Actually I was thinking of an rw-semaphore, not a mutex.  But yeah
> > that still has scalability problems.  But it could be done with custom
> > locking primitives, optimized for this case:
> > 
> >    suspend_disable();
> >    /* driver stuff */
> >    suspend_enable();
> 
> Yes, it could be done.  And the overhead could be minimized by using
> per-CPU variables.  It would still be an awful lot of work, and easy to
> get wrong.

OK, getting back to this, as it seems to be the only way that we agree
is doable.

How about this,

 a) identify syscalls that may make drivers do I/O:

 - read
 - write
 - ioctl
 ???

 b) add the suspend_disable/enable() primitives to these syscalls

 c) push primitives inside the implementation

c) is slightly tricky, but could be done for example by setting a flag
on open: FMODE_NO_SUSPEND_DISABLE (better name required), saying that
implementation is responsible for getting the suspend disable magic
right.

For starters this flag could be set for all non-device opens (maybe all
non-char-dev opens?), solving the fuse vs. freezer issues without any
complicated trickery.

Miklos
