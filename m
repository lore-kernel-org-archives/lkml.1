Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZE1MMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZE1MMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbZE1MMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:12:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:58035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbZE1MMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:12:24 -0400
Date: Thu, 28 May 2009 14:12:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090528121222.GK6920@wotan.suse.de>
References: <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI> <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com> <20090525114127.GE24071@wotan.suse.de> <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0905250930530.3435@localhost.localdomain> <4A1AE5CC.1000209@cs.helsinki.fi> <20090526073813.GE21496@wotan.suse.de> <1243512400.11533.33.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243512400.11533.33.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 03:06:40PM +0300, Pekka Enberg wrote:
> On Tue, 2009-05-26 at 09:38 +0200, Nick Piggin wrote:
> > On Mon, May 25, 2009 at 09:39:08PM +0300, Pekka Enberg wrote:
> > > Linus Torvalds wrote:
> > > >And vfs_caches_init_early() is actually doing some rather strange things, 
> > > >like doing a "alloc_large_system_hash()" but not unconditionally: it does 
> > > >it in the "late" initialization too, if not done early. inode_init_early 
> > > >does soemthing very similar (ie a _conditional_ early init).
> > > >
> > > >So none of this seems to really get a huge advantage from the early init. 
> > > >There seems to be some subtle NUMA issues, but do we really want that? I 
> > > >get the feeling that nobody ever wanted to do it early, and then the NUMA 
> > > >people said "I don't wnt to do this early, but I don't want to touch the 
> > > >non-NUMA case, so I'll do it early for non-numa, and late for numa".
> > > 
> > > SLUB does sysfs setup in kmem_cache_init() and if I saw some oopses if I 
> > > don't call vfs_caches_init_early() first. I didn't look too closely, though.
> > 
> > Did you also test the NUMA/hashdist case? vfs_caches_init_early doesn't
> > do much in that case.
> 
> No, I tested UMA only.
> 
> On Tue, 2009-05-26 at 09:38 +0200, Nick Piggin wrote:
> > I would say it is much more robust to do sysfs setup later if we move
> > the slab setup so early. Probably it is just quite lucky not to explode
> > in the !numa case because the vfs needs quite a bit of setting up...
> 
> That should not be an issue. SLUB already defers sysfs registration
> until slab_sysfs_init() initcall has been run. So my patches have zero
> change in how SLUB interracts with sysfs, actually.

Oh right, I didn't actually look. An initcall should be fine, but
I wonder why it is crashing if you move it before vfs_caches_init_early?
Those just allocate inode and dentry hash tables...

