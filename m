Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYJ2Xn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYJ2Xn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYJ2XnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:43:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33234 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYJ2XnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:43:19 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
In-reply-to: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
	(message from Alan Stern on Wed, 29 Oct 2008 16:37:30 -0400 (EDT))
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
References: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
Message-Id: <E1KvKgv-0000bf-RS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 30 Oct 2008 00:43:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Alan Stern wrote:
> I discussed this last summer with Rafael.  It's a lot harder than it 
> looks, for all sorts of reasons.  For example, what about user tasks 
> that have access to memory-mapped I/O regions?

What about them?  Freezing doesn't seem to help with that.

> > c) is slightly tricky, but could be done for example by setting a flag
> > on open: FMODE_NO_SUSPEND_DISABLE (better name required), saying that
> > implementation is responsible for getting the suspend disable magic
> > right.
> > 
> > For starters this flag could be set for all non-device opens (maybe all
> > non-char-dev opens?), solving the fuse vs. freezer issues without any
> > complicated trickery.
> 
> I don't know.  There are other interfaces too, like sysfs attributes, 
> that would have to be handled specially.  On the whole, the freezer 
> seems much, much simpler.

OK, then non-device files on "regular" filesystems.

> Regarding fuse, something like Nigel's scheme for preventing new 
> requests and then waiting for old requests to complete might work out.  
> Especially if you combine it with a strategy for making the freezer 
> back and retry after a delay when something goes wrong.

I don't think it will work out, because to be able to do this some
ordering between freezing the filesystems must be done.  But this is
basically impossible, for all the same reasons it's impossible to
order the freezing of userspace tasks.

Also this is not just a fuse issue: we have userspace network devices,
we have userspace USB drivers, etc, affected by this problem.

If there _is_ a solution with the freezer that does solve all of this,
I haven't yet heard it.  But yeah, in the end the simpler solution
should win.

Miklos
