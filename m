Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYBNRcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYBNRcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYBNRbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:31:50 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56654 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYBNRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:31:49 -0500
To: menage@google.com
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <6599ad830802140813n71b56dccud33e19642a0d7647@mail.gmail.com>
	(menage@google.com)
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu> <6599ad830802140813n71b56dccud33e19642a0d7647@mail.gmail.com>
Message-Id: <E1JPhvt-0002qE-Da@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Feb 2008 18:31:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  Maybe instead of messing with masks, it's better to introduce a
> >  get_flags() or a more general mount_stat() operation, and let
> >  userspace deal with setting and clearing flags, just as we do for
> >  stat/chmod?
> >
> >  So we'd have
> >
> >   mount_stat(path, stat);
> >   mount_bind(from, to, flags);
> >   mount_set_flags(path, flags);
> >   mount_move(from, to);
> >
> >  and perhaps
> >
> >   mount_remount(path, opt_string, flags);
> 
> Sounds reasonable to me. But it wouldn't directly solve the "do a
> recursive bind mount setting the MS_READONLY flag on all children"
> problem, so we'd need some of the earlier suggestions too.

Doh, you're right.

Let's try the original idea, but a bit cleaner:

/* flags: */
#define MNT_CTRL_RECURSE (1 << 0)

/* mnt_flags: */
#define MNT_NOSUID	0x01
#define MNT_NODEV	0x02
#define MNT_NOEXEC	0x04
#define MNT_NOATIME	0x08
#define MNT_NODIRATIME	0x10
#define MNT_RELATIME	0x20

#define MNT_SHARED	0x1000
#define MNT_UNBINDABLE	0x2000
#define MNT_PNODE_MASK	0x3000

struct mount_param {
	u64 flags;		/* control flags */
	u64 mnt_flags;		/* new mount flags */
	u64 mnt_flags_mask;	/* mask for new mount flags */
};

int mount_bindat(int fromfd, const char *frompath,
		int tofd, const char *topath,
		struct mount_param *param);

int mount_setflagsat(int fd, const char *path,
		struct mount_param *param);

int mount_moveat(int fromfd, const char *frompath,
		 int tofd, const char *topath);

...

I deliberately not used the MS_* flags, which is currently a messy mix
of things with totally different meanings.

Does this solve all the issues?

Miklos
