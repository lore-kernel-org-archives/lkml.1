Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYKSVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYKSVBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYKSVB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:01:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:57367 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137AbYKSVBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:01:25 -0500
Date: Wed, 19 Nov 2008 22:01:23 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] udf: reduce stack usage of udf_get_filename
Message-ID: <20081119210123.GF29820@duck.suse.cz>
References: <20081116180240.GB6282@joi> <20081118161938.e415c6bc.akpm@linux-foundation.org> <20081119152622.GB29820@duck.suse.cz> <20081119093515.9c807f71.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119093515.9c807f71.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-11-08 09:35:15, Andrew Morton wrote:
> On Wed, 19 Nov 2008 16:26:22 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > On Tue 18-11-08 16:19:38, Andrew Morton wrote:
> > > On Sun, 16 Nov 2008 19:02:45 +0100
> > > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > 
> > > > +	filename = kmalloc(sizeof(struct ustr), GFP_NOFS);
> > > 
> > > I suspect that we could have used the superior GFP_KERNEL everywhere in
> > > both these patches.  But I'll let Jan worry about that ;)
> >   Definitely not in the second case - that one is called from inside
> > readdir, lookup and symlink resolution code so that could lead to deadlocks
> > IMHO.
> >   Regarding the first case in process_sequence, that is called only from
> > udf_fill_super(). So there it might be safe to use GFP_KERNEL but I'm not
> > quite sure either... So I'd leave GFP_NOFS there.
> > 
> 
> The reason for using GFP_NOFS is to prevent deadlocks when direct
> memory reclaim reenters the filesystem code.  But I don't think there's
> ever a case when direct reclaim would enter the namespace part of a
> filesystem - it is only expected to touch the pagecache (ie: data)
> operations: writepage(), block allocator, etc.
  Hmm, but I see for example:
static int shrink_icache_memory(int nr, gfp_t gfp_mask)
{
        if (nr) {
                /*
                 * Nasty deadlock avoidance.  We may hold various FS locks,
                 * and we don't want to recurse into the FS that called us
                 * in clear_inode() and friends..
                 */
                if (!(gfp_mask & __GFP_FS))
                        return -1;
                prune_icache(nr);
        }
        return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
}
  So it seems that with GFP_KERNEL, prune_icache() can be called as well
(and similarly prune_dcache()) and that could in theory block on other
locks, couldn't it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
