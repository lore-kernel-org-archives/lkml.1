Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYCNISp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYCNISp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYCNIS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:18:27 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43006 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYCNISZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:18:25 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080313155315.6eb9942e.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 13 Mar 2008 15:53:15 -0700)
Subject: Re: [patch 0/6] vfs: mountinfo update
References: <20080313212641.989467982@szeredi.hu> <20080313155315.6eb9942e.akpm@linux-foundation.org>
Message-Id: <E1Ja56h-0003MU-Ok@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Mar 2008 09:17:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diffstat for all seven patches is:
> 
>  Documentation/filesystems/proc.txt |   35 +++++
>  fs/dcache.c                        |  101 +++++++++++---
>  fs/namespace.c                     |  182 ++++++++++++++++++++++-----
>  fs/pnode.c                         |  131 ++++++++++++++++++-
>  fs/pnode.h                         |   15 +-
>  fs/proc/base.c                     |  121 +++++++++--------
>  fs/seq_file.c                      |   92 +++++++++++--
>  include/linux/dcache.h             |    5 
>  include/linux/mnt_namespace.h      |   12 +
>  include/linux/mount.h              |    2 
>  include/linux/seq_file.h           |    7 +
>  11 files changed, 559 insertions(+), 144 deletions(-)
> 
> that's a mountain of tricksy new core-kernel code just for some /proc file.
> 
> Is this all really justifiable?

This is an approximate order of added features from most complex to
least complex:

 1) basic info about mount propagation
 2) root of the mount (source directory of bind)
 3) disambiguating reachable mounts from unreachable (/proc/mounts
    under chroot is a mess, and people are afraid to fix it:
    http://lkml.org/lkml/2007/4/17/271)
 4) showing "dominating group" which intersects with current namespace/root
 5) allocating ID's from IDR pools instead of ever increasing 64bit counters
 6) showing ID of mount and parent mount
 7) st_dev of mount

1, 2, 3 and 6 we definitely want.  Al wants 4.  I think 5 is useful
for readability, but not absolutely necessary.

All in all, I think there's very little that we can do, without
throwing out the baby with the bathwater.

Also compare this with the number of lines and mind boggling
complexity added for the mount propagation stuff, which is still very
little used years after it's introduction.  Possibly because some of
the infrastructure is still missing from kernel as well as userspace
to make it all really useful.  And I think this patch set goes towards
getting that infrastructure in place.

Possibly mount propagation will remain on the fringe for ever, in
which case a big chunk of this patch set (1 and 4) also end up being
useless.  The worst that can happen is that we end up adding some
#ifdef CONFIG_MOUNT_PROPAGATION clutter to namespace.c.

Miklos
