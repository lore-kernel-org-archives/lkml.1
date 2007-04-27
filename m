Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbXD0RMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbXD0RMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbXD0RMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:12:09 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:20622 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbXD0RMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:12:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AY4qeo+eFVop1UIfpuQzNpL3vW9LN4uUKE2CSD5DVpIbVFDAaZe3XmGYeAyC0gX7nTzVpJdqNG/b2g5ZD+77a8sZbaJ8FHzCEsxmBa0jCM/xbc4XVxa6GDUsIQ+j8XjqclpYaRHrYNvtRbqjYRjYwcYPOPttr0ycEzkC+UxSsao=
Subject: Re: 2.6.21 reiserfs -- cicular locking?
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jeff Mahoney <jeffm@suse.de>
Cc: Jeff Mahoney <jeffm@suse.com>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       reiserfs-dev@namesys.com
In-Reply-To: <463222F5.7080209@suse.de>
References: <200704261640.15068.david-b@pacbell.net>
	 <20070426224408.fd525b46.akpm@linux-foundation.org>
	 <s5hy7kew2m8.wl%tiwai@suse.de>	<s5hbqhaytph.wl%tiwai@suse.de>
	 <4631D9CD.4050106@suse.com> <s5h8xceypoe.wl%tiwai@suse.de>
	 <463213FD.3060401@suse.com>  <463222F5.7080209@suse.de>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 01:11:54 +0800
Message-Id: <1177693914.4622.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 12:21 -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Jeff Mahoney wrote:
> > Takashi Iwai wrote:
> >>> At Fri, 27 Apr 2007 07:09:01 -0400,
> >>> Jeff Mahoney wrote:
> >>>> -----BEGIN PGP SIGNED MESSAGE-----
> >>>> Hash: SHA1
> >>>>
> >>>> Takashi Iwai wrote:
> >>>>> At Fri, 27 Apr 2007 12:09:03 +0200,
> >>>>> I wrote:
> >>>>>> I got a similar bug right now at the fresh boot of 2.6.21.
> >>>>>>
> >>>>>>
> >>>>>> ReiserFS: sda2: found reiserfs format "3.6" with standard journal
> >>>>>> ReiserFS: sda2: using ordered data mode
> >>>>>> ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> >>>>>> ReiserFS: sda2: checking transaction log (sda2)
> >>>>>> ReiserFS: sda2: Using r5 hash to sort names
> >>>>>> ReiserFS: sda2: Removing [3613 1354701 0x0 SD]..done
> >>>>>> ReiserFS: sda2: There were 1 uncompleted unlinks/truncates. Completed
> >>>>>>
> >>>>>> =======================================================
> >>>>>> [ INFO: possible circular locking dependency detected ]
> >>>>>> 2.6.21-work #1
> >>>>>> -------------------------------------------------------
> >>>>>> mktemp/1459 is trying to acquire lock:
> >>>>>>  (&REISERFS_I(inode)->xattr_sem){..--}, at: [<e08a5236>] reiserfs_cache_default_acl+0x2a/0x9c [reiserfs]
> >>>>>>
> >>>>>> but task is already holding lock:
> >>>>>>  (&inode->i_mutex){--..}, at: [<c016d7dc>] open_namei+0xe2/0x5a2
> >>>>>>
> >>>>>> which lock already depends on the new lock.
> >>>>> The message disappears when I revert the patch:
> >>>>>
> >>>>> commit 9b7f375505f5611efb562065b57814b28a81abc3
> >>>>> Author: Jeff Mahoney <jeffm@suse.com>
> >>>>> Date:   Mon Apr 23 14:41:17 2007 -0700
> >>>>>
> >>>>>     reiserfs: fix xattr root locking/refcount bug
> >>>>>     
> >>>>>
> >>>>> So, likely a newly introduced bug after rc7...
> >>>> I got a message with a trace similar to this from Vladimir before I
> >>>> submitted that patch. I'm not sure how to annotate this, since the
> >>>> xattr_sem can never be taken in the manner described. Internal inodes
> >>>> are protected by I_PRIVATE.
> >>> Hm, then maybe my case was just a coincidence.
> >>>
> >>> FWIW, I can reproduce the deadlock warning at each time I boot
> >>> non-patched 2.6.21, and after reverting the patch, it disappeared.
> > 
> > Ok, so I took another look at the report Vladimir sent me. The trace he
> > ran into was in the delete inode path, but was still a race between the
> > xattr_sem and the inode sem. Since we're locking the xattr root on the
> > xattr read path now, this condition arises more freqently, but it's
> > really the same one he reported.
> > 
> > I'm using the default openSUSE config, which doesn't enable mutex
> > debugging. I'll rebuild with it, and hopefully come up with a way to
> > kill the warning.
> 
> I still didn't get the warning, but can you try this and let me know
> if it fixes it?

I also reported this in another thread.  With this patch, I haven't seen
the tracing anymore.

Tony


