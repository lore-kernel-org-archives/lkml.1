Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYJ2PvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYJ2PvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYJ2Pu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:50:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41100 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYJ2Pu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:50:58 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
In-reply-to: <Pine.LNX.4.44L0.0810291122220.2189-100000@iolanthe.rowland.org>
	(message from Alan Stern on Wed, 29 Oct 2008 11:28:34 -0400 (EDT))
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
References: <Pine.LNX.4.44L0.0810291122220.2189-100000@iolanthe.rowland.org>
Message-Id: <E1KvDJp-00088f-2b@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Oct 2008 16:50:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Alan Stern wrote:
> On Wed, 29 Oct 2008, Miklos Szeredi wrote:
> > I did a random sampling of ->suspend() callbacks, and they don't seem
> > to be taking mutexes.  Does that happen at all?
> 
> It does, particularly among drivers that do runtime PM, which is 
> becoming more and more important.
> 
> Besides, suspend has to synchronize with I/O somehow.  Right now that 
> is handled by making suspend wait until no tasks are doing I/O (because 
> they are all frozen).

What about async I/O?

>  If you allow tasks to be frozen at more or less 
> arbitrary times, while holding arbitrary locks, then you may end up 
> freezing a task that's in the middle of I/O.  That should certainly 
> block the suspend (not to mention messing up the I/O operation).

What is the middle of I/O?  Depending the type of I/O it could be
messed up regardless of whether tasks happen to be in userspace or not
(e.g. printing).

And some types of I/O are already mostly decoupled from userspace
(file I/O, networking), so the userspace freezing shoudln't make any
difference.

> > Did anybody ever try modifying the freezer for suspend (not
> > hibernate), so that it allows tasks not in running state to freeze?
> > If not, I think that's an experiment worth doing.
> 
> What happens if the reason the task isn't running is because it's 
> waiting for I/O to complete?  I just don't think this can be made to 
> work.

Don't know.  I've never written a driver, and I'm not familiar with
runtime PM, etc.  So I can't come up with a detailed design for
solving the freezer issues there.

But I do think that the solution does not lie in "fixing" the VFS.

Miklos
