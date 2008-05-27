Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYE0Rsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYE0Rsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYE0Rsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:48:42 -0400
Received: from sous-sol.org ([216.99.217.87]:47632 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbYE0Rsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:48:42 -0400
Date: Tue, 27 May 2008 10:47:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Message-ID: <20080527174738.GZ30402@sequoia.sous-sol.org>
References: <20080526143422.GA3203@alice> <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> On Mon, May 26, 2008 at 5:34 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> > i enabled CONFIG_SECURITY on current git and get tons of
> > Redzone overwritten errors during early boot, even
> > with CONFIG_SECURITY_CAPABILITIES and CONFIG_SECURITY_NETWORK
> > disabled. After a while it ends with a kernel panic
> > saying: not syncing: Out of memory and no killable process...
> > Root partition is ext3 format.
> 
> So what kernel version is this and what's the last known version that
> worked? As it's early boot crash, maybe you can try to do git bisect
> on it?
> 
> >
> > At the moment i dont have a camera at hand, so i'll try
> > to write down everything which looks interesting, please tell
> > me if i missed something.
> >
> > The first 24 Bytes of the overwritten section contain
> > zeros. Then we have a constant 0x18, and three changing
> > values. the next three bites contain exactly the same
> > values, first the 0x18, then the two changing ones.
> >
> > The only value i found so far matching the 0x18 and
> > which might be related to CONFIG_SECURITY is CAP_SYS_RESOURCE
> > defined in /include/linux/capability.h
> >
> > BUG hugetlbfs_inode_cache: Redzone overwritten
> >
> > INFO: 0xccd8e250-0xccd8e253. First byte 0x0 instead of 0xbb
> > Info: Slab 0xc119d1c0 objects=12 used=0 fs=0xccd8e000 flags=0x400020c3
> > Info: Object 0xccd8e00 offset=0 fp=0xccd8e280
> >
> > Object 0xccd8e00: 00 00 00 ...
> > Object 0xccd8e10: 00 00 00 00 00 00 00 00 00 18 e0 d8 cc 18 e0 d8 cc
> > Object 0xccd8e20  00 00 00 ...

That looks like an addr within the object, like an INIT_LIST_HEAD.

> > Pid: 1, comm:swapper Not tainted 2.6.26-rc3-00436-gb373303 #42
> > print_trailer
> > check_bytes_and_report
> > check_object
> > __slab_alloc
> > kmem_cache_alloc
> > ? hugetlbfs_alloc_inode
> > ? hugetlbfs_alloc_inode
> > hugetlbfs_alloc_inode
> > alloc_inote
> > new_inode
> > hugetlbs_get_inote
> > hugetlbfs_fill_super
> > ? sget
> > ? set_anon_super
> > get_sb_node
> > hugetlbfs_get_sb
> > ? hugetlbfs_fill_super
> > vfs_kern_mount
> > kern_mount_data
> > init_hugetlbfs_fs
> > ? init_once
> > ? kernel_init
> > kernel_init

ok, do_init_calls time frame with that config...CONFIG_SECURITY isn't
really doing any allocations, nor much in the way of memory writes.
It would get called into via the:

 hugetlbs_get_inode
   new_inode
     alloc_inode
       security_inode_alloc <-- and that'd be basically a no-op

> > Config follows:

I couldn't recreate with that config.
