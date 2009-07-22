Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZGVXwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZGVXwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZGVXwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:52:41 -0400
Received: from cobra.newdream.net ([66.33.216.30]:38265 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZGVXwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:52:40 -0400
Date: Wed, 22 Jul 2009 16:52:40 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] ceph: ioctls
In-Reply-To: <878wig2vhe.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0907221636260.8312@cobra.newdream.net>
References: <1248292313-31326-1-git-send-email-sage@newdream.net>
 <1248292313-31326-3-git-send-email-sage@newdream.net>
 <1248292313-31326-4-git-send-email-sage@newdream.net>
 <1248292313-31326-5-git-send-email-sage@newdream.net>
 <1248292313-31326-6-git-send-email-sage@newdream.net>
 <1248292313-31326-7-git-send-email-sage@newdream.net>
 <1248292313-31326-8-git-send-email-sage@newdream.net>
 <1248292313-31326-9-git-send-email-sage@newdream.net>
 <1248292313-31326-10-git-send-email-sage@newdream.net>
 <1248292313-31326-11-git-send-email-sage@newdream.net>
 <1248292313-31326-12-git-send-email-sage@newdream.net>
 <1248292313-31326-13-git-send-email-sage@newdream.net>
 <1248292313-31326-14-git-send-email-sage@newdream.net>
 <1248292313-31326-15-git-send-email-sage@newdream.net>
 <1248292313-31326-16-git-send-email-sage@newdream.net>
 <1248292313-31326-17-git-send-email-sage@newdream.net>
 <1248292313-31326-18-git-send-email-sage@newdream.net> <878wig2vhe.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Andi Kleen wrote:
> Sage Weil <sage@newdream.net> writes:
> 
> > A few Ceph ioctls for getting and setting file layout (striping)
> > parameters.
> 
> It would be good if you posted manpages for these ioctls
> so that the interface can be reviewed. After all
> that's intended to be used by applications, isn't it?

Is there some existing manpage I might use as a reference?  e.g., an XFS 
ioctl manpage or something similar?

I'm also happy to replace these ioctls with a virtual xattr interface 
along the lines of what Andreas proposed.  That would make it much easier 
to maintain compatibility if the support layout parameters changes 
going forward.

> There don't seem to be compat ioctl handlers?

Oops,

diff --git a/src/kernel/file.c b/src/kernel/file.c
index fbf02c3..fbb5f94 100644
--- a/src/kernel/file.c
+++ b/src/kernel/file.c
@@ -810,5 +810,8 @@ const struct file_operations ceph_file_fops = {
        .splice_read = generic_file_splice_read,
        .splice_write = generic_file_splice_write,
        .unlocked_ioctl = ceph_ioctl,
+#ifdef CONFIG_COMPAT
+       .compat_ioctl   = ceph_ioctl,
+#endif
 };

The structs are all packed.

> > diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
> > new file mode 100644
> > index 0000000..537c27b
> > --- /dev/null
> > +++ b/fs/ceph/ioctl.h
> > @@ -0,0 +1,12 @@
> > +#ifndef FS_CEPH_IOCTL_H
> > +#define FS_CEPH_IOCTL_H
> > +
> > +#include <linux/ioctl.h>
> > +#include "types.h"
> > +
> > +#define CEPH_IOCTL_MAGIC 0x97
> > +
> > +#define CEPH_IOC_GET_LAYOUT _IOR(CEPH_IOCTL_MAGIC, 1, struct ceph_file_layout)
> > +#define CEPH_IOC_SET_LAYOUT _IOW(CEPH_IOCTL_MAGIC, 2, struct ceph_file_layout)
> 
> How should the application use that if the include file is in fs/ceph?
> Should be in include/linux I guess
> 
> Also this file should define all the types needed for the interface,
> especialy struct ceph_file_layout, but no kernel internal types.

The type is defined in ceph_fs.h, which is shared/synced with the userland 
code.  It's not specific to the ioctl interface.

My understanding (IIRC after reading comments from a recent fs merge) was 
that these sorts of headers normally shouldn't go in include/linux, since 
any userland (admin) progs will have their own version anyway while being 
built, and may not be synced with the installed kernel.  I also see 
autofs, btrfs, ext4, ocfs2, xfs ioctls defined in fs/*, not include/linux?

Thanks-
sage
