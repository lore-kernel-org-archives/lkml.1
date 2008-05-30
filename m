Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYE3TXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYE3TXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYE3TW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:22:59 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43764 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYE3TW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:22:58 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, drepper@redhat.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com>
	(mtk.manpages@googlemail.com)
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
	 <E1K27bZ-0002Gk-3b@pomaz-ex.szeredi.hu> <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com>
Message-Id: <E1K2ABK-0002ck-UT@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 May 2008 21:22:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Here's a further version of the patch, against 2.6.26rc2, with the
> >> 2008-05-19 git changes you sent me applied.  This patch is based on
> >> the draft patch you sent me.  I've tested this version of the patch,
> >> and it works as for all cases except the one mentioned below.  But
> >> note the following points:
> >>
> >> 1) I didn't make use of the code in notify_change() that checks
> >> IS_IMMUTABLE() and IS_APPEND() (i.e., I did not add
> >> ATTR_OWNER_CHECK to the mask in the controlling if statement).
> >> Doing this can't easily be made to work for the
> >> do_futimes() case without reworking the arguments passed to
> >> notify_change().  Actually, I'm inclined to doubt whether it
> >> is a good idea to try to roll that check into notify_change() --
> >> at least for utimensat() it seems simpler to not do so.
> >
> > Ugh...  Could we just omit this part (the if !times and write error
> > then check owner)?  I know it was my idea, but
> >
> >  a) my ideas are often stupid
> >  b) one patch should ideally do just one thing
> >
> > After we fixed the original issue, we can still think about this other
> > thing :)
> 
> Okay, by now quite a bit of my time has been wasted, and my patience
> is starting to get a little thin.

I understand your frustration, but actually I did say this the last
time as well:

  "Sorry, that was just an idea, but since it's not as simple as it
   should be, I guess we should leave that till later.  My main
   objection was against introducing more is_owner_or_cap() checks.
   Just doing the times == NULL case with ATTR_OWNER_CHECK should be
   fine."

Yeah, I may have been more explicit...

> The relevant interfaces here are:
> 
> utimensat()
> futimesat()
> utime()
> utimes()
> futimens() -- because implemented in glibc via utimensat() with path==NULL.
> 
> * utime() and utimes() can't be affected by this point: they don't use
> file descriptors.

OK, you're right.  I've overlooked this point.

So as long as we believe that nobody is using the futime*() interfaces
in the way you described, which is highly probable, then we can fix
that as well.  Which is actually a nice thing, because it means the
permission checking for the times == NULL case can move from both
do_utimes_name() and do_futimes() into utimes_common().

So let's make two patches, and let's forget about the write_error
thing for now:

1)
  - turn UTIME_NOW/UTIME_NOW into times = NULL
  - for times != NULL set ATTR_OWNER_CHECK

2)
  - move times == NULL permission check into utimes_common.

For 2) you can just use permission() instead of vfs_permission() which
is exactly the same in this case (and consolidated into a common
function later in the vfs-cleanups tree).

OK?

Thanks,
Miklos
