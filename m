Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYKSVhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYKSVhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYKSVhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:37:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbYKSVho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:37:44 -0500
Date: Wed, 19 Nov 2008 13:37:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] udf: reduce stack usage of udf_get_filename
Message-Id: <20081119133705.afd20f32.akpm@linux-foundation.org>
In-Reply-To: <20081119210123.GF29820@duck.suse.cz>
References: <20081116180240.GB6282@joi>
	<20081118161938.e415c6bc.akpm@linux-foundation.org>
	<20081119152622.GB29820@duck.suse.cz>
	<20081119093515.9c807f71.akpm@linux-foundation.org>
	<20081119210123.GF29820@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 22:01:23 +0100
Jan Kara <jack@suse.cz> wrote:

> On Wed 19-11-08 09:35:15, Andrew Morton wrote:
> > On Wed, 19 Nov 2008 16:26:22 +0100 Jan Kara <jack@suse.cz> wrote:
> > 
> > > On Tue 18-11-08 16:19:38, Andrew Morton wrote:
> > > > On Sun, 16 Nov 2008 19:02:45 +0100
> > > > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > > 
> > > > > +	filename = kmalloc(sizeof(struct ustr), GFP_NOFS);
> > > > 
> > > > I suspect that we could have used the superior GFP_KERNEL everywhere in
> > > > both these patches.  But I'll let Jan worry about that ;)
> > >   Definitely not in the second case - that one is called from inside
> > > readdir, lookup and symlink resolution code so that could lead to deadlocks
> > > IMHO.
> > >   Regarding the first case in process_sequence, that is called only from
> > > udf_fill_super(). So there it might be safe to use GFP_KERNEL but I'm not
> > > quite sure either... So I'd leave GFP_NOFS there.
> > > 
> > 
> > The reason for using GFP_NOFS is to prevent deadlocks when direct
> > memory reclaim reenters the filesystem code.  But I don't think there's
> > ever a case when direct reclaim would enter the namespace part of a
> > filesystem - it is only expected to touch the pagecache (ie: data)
> > operations: writepage(), block allocator, etc.
>   Hmm, but I see for example:
> static int shrink_icache_memory(int nr, gfp_t gfp_mask)
> {
>         if (nr) {
>                 /*
>                  * Nasty deadlock avoidance.  We may hold various FS locks,
>                  * and we don't want to recurse into the FS that called us
>                  * in clear_inode() and friends..
>                  */
>                 if (!(gfp_mask & __GFP_FS))
>                         return -1;
>                 prune_icache(nr);
>         }
>         return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
> }
>   So it seems that with GFP_KERNEL, prune_icache() can be called as well
> (and similarly prune_dcache()) and that could in theory block on other
> locks, couldn't it?
> 

hm, yeah, OK, true.

iirc this only applies to weird filessytems which do complex things
(ie: take locks) in their destroy_inode/clear_inode/etc handlers.

udf_clear_inode() looks pretty complex.

