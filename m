Return-Path: <linux-kernel-owner+w=401wt.eu-S935773AbXGLV6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935773AbXGLV6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 17:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761346AbXGLV62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 17:58:28 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:42534 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759635AbXGLV61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 17:58:27 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <20070712153112.GB5139@ucw.cz> (message from Pavel Machek on Thu,
	12 Jul 2007 15:31:12 +0000)
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz> <E1I7vx0-0002Fn-00@dorka.pomaz.szeredi.hu> <20070712153112.GB5139@ucw.cz>
Message-Id: <E1I96eW-00059M-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 12 Jul 2007 23:56:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Actually there's also a non-malicious case in which waiting for
> > requests to finish won't work: when one fuse filesystem is accessing
> > another.
> > 
> > Since we are blocking new fuse requests, that might block a fuse
> > daemon, which in turn makes it impossible to finish the pending
> > request.
> 
> Hmm, yes, this is ugly. But will it hurt? We'll just wait for number
> of active fuse requests to go down to 0 before proceeding.

I'm thinking of the following situation, immediately after we begin to
wait for fuse requests to subside:

  - task A is performing file operation O1
  - O1 is being served by task B
  - task B needs to perform O2 before finishing O1

Since we don't allow new requests, O2 will never start.  So O1 will
never finish.  So the number of fuse requests will never go to 0.

> It may still livelock on system with busy fused-s, but we'll detect
> that with timeout, and I believe it is 'don't do that' situation.

There are no busy fused's.  If we allowed O2 to go through, everything
would be nice and dandy.  But we cannot know that O2 needs to be let
through, and other fuse requests must not.

> > And this is not at all theoretical, I know that encfs is used over
> > various other fuse filesystems like sshfs or ntfs-3g.
> > 
> > Yeah, stacking userspace filesystems could be done entirely in
> > userspace, and I'm actually working on that (with fuse-2.7.0 already
> > supporting some basic stacking).
> 
> Great.
> 
> > But the point is, that the "wait for fuse to quiescence" hack would
> > not work in todays environment.
> 
> Ok, I'll just blame fuse here. 'You have to write to /sys
> files for SIGKILL to work' is not funny.

SIGKILL won't work on a stopped task.  Neither on a traced task.
Neither on a zombie (how many newbies are thoroughly confused about
that ;)

And it won't work on a task that is hanging on an NFS mount, when the
network broke.

Oh, and it won't work on a deadlocked fuse filesystem.  How many of
these have you met?  How many of the others?

Miklos
