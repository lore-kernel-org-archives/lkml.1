Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYKMLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYKMLsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYKMLsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:48:04 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35153 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYKMLsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:48:01 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <491BC87F.4050108@kernel.org> (message from Tejun Heo on Thu, 13
	Nov 2008 15:26:07 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org>
Message-Id: <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2008 12:47:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Tejun Heo wrote:
> Hello, Miklos.
> 
> Miklos Szeredi wrote:
> >   0006-FUSE-implement-unsolicited-notification.patch
> >   0007-FUSE-implement-poll-support.patch
> > 
> > This would be nice, but...  I don't really like the fact that it uses
> > the file handle.  Could we have a separate "poll handle" that is
> > returned in the POLL reply?
> 
> Eh... I replied too early for this.  I'm now trying to convert it to its
> own handle but there is a rather serious problem.  It's usually much
> easier to have the entity to be waken up registered before calling
> ->poll so that ->poll can use the same notification path from ->poll ans
> for later.
> 
> However, if we allocate poll handle from ->poll and tell it to kernel
> via reply, it creates two problem.  1. the entity which is to be waken
> up can't be registered prior to calling ->poll as there's nothing to
> identify it, 2. the interval from reply write and in-kernel polled
> entity registration must be made atomic so that no notification can come
> through inbetween.  #1 means that ->poll can't call the same
> notification path from ->poll itself and #2 means that there needs to be
> special provision from dev.c::fuse_dev_write() to
> file.c::fuse_file_poll() so that atomicity can be guaranteed.  Both of
> which can be done but I'm not really sure whether using a separate
> handle would be a good idea even with the involved cost.

Yeah, I see the problems.

> Why do you think using separate poll handle would be better?  And do you
> still think the overhead is justifiable?

Because it would be a change in the semantics of the file handle.
Previously it was just an opaque cookie that the kernel stored for the
filesystem, not making any assumptions about it (like uniqueness).

OK, we can say that if the filesystems wants to implement poll, it has
to make the file handle unique.  Also now the filesystem (or
something) has to deal with races between poll notification and
reuse of the file handle (release/open).

With a new poll handle we'd have more room to properly deal with these
without overloading the file handle with extra requirements.

How about this: the poll handle is allocated by the kernel, not by the
filesystem.  This guarantees uniqueness, so the filesystem cannot get
this wrong.  Releasing the poll handle is still tricky, there could be
various races... only the userspace filesystem knows if it has no
outstanding notificiatons on a poll handle, so the release has to come
after all outstanding notifications have been ack'ed.  Something like
this:

(userspace <- kernel)

<- POLL-request(pollhandle) (alloc handle)
-> POLL-reply
...
-> POLL-notification(pollhandle)
<- POLL-ack
...
<- POLL_RELEASE(pollhandle)
-> POLL_RELEASE-reply (free handle)

Thanks,
Miklos
