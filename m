Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZFHJ3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZFHJ3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZFHJ3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:29:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:51043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZFHJ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:29:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,323,1241420400"; 
   d="scan'208";a="151756317"
Date: Mon, 8 Jun 2009 17:29:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] writeback: skip new or to-be-freed inodes
Message-ID: <20090608092930.GA13846@localhost>
References: <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost> <4A244A5B.7070605@sandeen.net> <20090602085523.GC7161@localhost> <20090602113736.GB15010@duck.suse.cz> <20090603141021.GB5738@localhost> <20090603141636.GC5650@duck.suse.cz> <20090603144711.GC5738@localhost> <20090606030725.GA12852@localhost> <4A2CB7AE.6080909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2CB7AE.6080909@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Mon, Jun 08, 2009 at 03:03:10PM +0800, Artem Bityutskiy wrote:
> Wu Fengguang wrote:
> > The above race and warning didn't turn up because writeback_inodes() holds
> > the s_umount lock, so generic_forget_inode() finds MS_ACTIVE and returns
> > early. But we are not sure the UBIFS calls and future callers will guarantee
> > that. So skip I_WILL_FREE inodes for the sake of safety.
>
> The inode states are a bit vague for me, but vs. UBIFS - feel
> free to ask questions.

Thank you. Basically I'm not sure if UBIFS guarantees it won't be
unmounted (hence the MS_ACTIVE bit is on) when calling
generic_sync_sb_inodes() in shrink_liability() and ubifs_sync_fs().

Thanks,
Fengguang

PS: our previous discussions

        > > Another possibility:
        > >
        > > generic_forget_inode
        > >   inode->i_state |= I_WILL_FREE;
        > >   spin_unlock(&inode_lock);
        > >                                                 generic_sync_sb_inodes()
        > >                                                   spin_lock(&inode_lock);
        > >                                                   __iget(inode);
        > >                                                   __writeback_single_inode
        > >                                                     // see non zero i_count
        > >                                                     WARN_ON(inode->i_state & I_WILL_FREE);
        > >
        > > I'm wondering why didn't we saw reports on the last WARN_ON()?
        > > Did we missed something?
        >   I meant the above race in my description ;-). Anyway, the race can happen
        > only if we are unmounting the filesystem (normally, we bail out on
        > sb->s_flags & MS_ACTIVE check - yes, it's a bit hidden and it also took me
        > a while to understand why we weren't seeing tons of warnings...).

        Ah OK. Just checked that all three callers of generic_sync_sb_inodes():
        - writeback_inodes(): umount prevented
        - pohmelfs_kill_super(): just before umount
        - ubifs calls: too complex to be obvious..
        At least the first two cases are safe, so we didn't see the error report ;)

