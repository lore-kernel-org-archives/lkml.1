Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYBNQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYBNQFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbYBNQD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:03:57 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38994 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbYBNQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:03:55 -0500
To: menage@google.com
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	(menage@google.com)
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu> <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
Message-Id: <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Feb 2008 17:03:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Feb 14, 2008 at 12:30 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >  > For recursive bind mounts, only the root of the tree being bound
> >  > inherits the per-mount flags from the mount() arguments; sub-mounts
> >  > inherit their per-mount flags from the source tree as usual.
> >
> >  This is rather strange behavior.  I think it would be much better, if
> >  setting mount flags would work for recursive operations as well.  Also
> >  what we really need is not resetting all the mount flags to some
> >  predetermined values, but to be able to set or clear each flag
> >  individually.
> 
> This is certainly true, but as you observe below it's a fair bit more
> fiddly to specify in the API. I wasn't sure how much people recursive
> bind mounts, so I figured I'd throw out this simpler version first.
> 
> >
> >  For example, with the per-mount-read-only thing the most useful
> >  application would be to just set the read-only flag and leave the
> >  others alone.
> >
> >  And this is where we usually conclude, that a new userspace mount API
> >  is long overdue.  So for starters, how about a new syscall for bind
> >  mounts:
> >
> >  int mount_bind(const char *src, const char *dst, unsigned flags,
> >                  unsigned mnt_flags);
> 
> The "flags" argument could be the same as for regular mount, and
> contain the mnt_flags - so the extra argument could maybe usefully be
> a "mnt_flags_mask", to indicate which flags we actually care about
> overriding.

The way I imagined it, is that mnt_flags is a mask, and the operation
(determined by flags) is either:

 - set bits in mask
 - clear bits in mask (or not in mask)
 - set flags to mask

It doesn't allow setting some bits, clearing some others, and leaving
alone the rest.  But I think such flexibility isn't really needed.
> 
> What would happen when an existing super-block flag changes to become
> a per-mount flag (e.g. per-mount read-only)? I think that would just
> fit in with the "mask" idea, as long as we complained if any bits in
> mnt_flags_mask weren't actually per-mount settable.
> 
> Being able to mask/set mount flags might be useful on a remount too,
> since there's no clean way to get the existing mount flags for a mount
> other than by scanning /proc/mounts. So an alternative to a separate
> system call would be a new mnt_flag_mask argument to mount() (whose
> presence would be indicated by a flag bit being set in the main flags)
> which would be used to control which bits were set cleared for
> remount/bind calls. Seems a bit wasteful of bits though. If we turned
> "flags" into an (optionally) 64-bit argument then we'd have plenty of
> bits to be able to specify both a "set" bit and a "mask" bit for each,
> without needing a new syscall.

The big problem, is that current sys_mount() interface is a really big
pile of random things thrown together, and not a proper API.  And just
introducing a new mount64 syscall is really making the problem worse,
by allowing more random things to be added to it.

So while creating a new clean API is harder work, it should be worth
it in the long run.

Maybe instead of messing with masks, it's better to introduce a
get_flags() or a more general mount_stat() operation, and let
userspace deal with setting and clearing flags, just as we do for
stat/chmod?

So we'd have

  mount_stat(path, stat);
  mount_bind(from, to, flags);
  mount_set_flags(path, flags);
  mount_move(from, to);

and perhaps

  mount_remount(path, opt_string, flags);

And I'm not against doing it with the "at*" variants, as Trond
suggested.

Hmm?

Miklos
