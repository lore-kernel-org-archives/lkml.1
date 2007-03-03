Return-Path: <linux-kernel-owner+w=401wt.eu-S1750760AbXCCXfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750760AbXCCXfC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 18:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXCCXfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 18:35:01 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49414 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXCCXfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 18:35:00 -0500
Date: Sat, 3 Mar 2007 15:34:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ray-gmail@madrabbit.org
Cc: "Ray Lee" <madrabbit@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303153454.6548e562.akpm@linux-foundation.org>
In-Reply-To: <2c0942db0703031458i540c496fib892240619faa9b2@mail.gmail.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<2c0942db0703031458i540c496fib892240619faa9b2@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007 14:58:48 -0800 "Ray Lee" <madrabbit@gmail.com> wrote:

> On 3/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > It is to address the "waah, backups fill my memory with pagecache" and the
> > "waah, updatedb swapped everything out" and the "waah, copying a DVD
> > gobbled all my memory" problems.
> 
> Is the updatedb problem really due to pagecache?

It's a combination of pagecache, slab cache and of course contention for
the disk.  In my experience the latter preponderates: the disk is sekeing
like mad and I can't get its attention.  Others report lots of swapout,
which will be a combination of slab and pagecache, varying degrees of each.

> > When running
> >
> >         pagecache-management.sh dd if=100-mb-file of=foo
> >         or
> >         pagecache-management.sh cp -a /usr/src/linux-2.6.20 /usr/src/foo
> >
> > the amount of pagecache in the machine is pretty much unaltered.  Maybe a
> > megabyte of additional cache in the second case, because of ext3 indirect
> > blocks.
> 
> ray@phoenix:~/work/home/pagecache-management$ grep ext3_i
> /proc/slabinfo; ./pagecache-management.sh sudo updatedb; grep ext3_i
> /proc/slabinfo
> ext3_inode_cache   21024  23722   1584    2    1 : tunables   24   12
>   0 : slabdata  11861  11861      0
> ext3_inode_cache   41332  41332   1584    2    1 : tunables   24   12
>   0 : slabdata  20666  20666      0
> ray@phoenix:~/work/home/pagecache-management$ echo $(( 1584 * (41332-21024) ))
> 32167872

If 32 MB is the whole lot then by eliminating pagecache, we just solved the
problem.  But perhaps you instantiated a lot more VFS cache and all you're
seeing there is the leftovers.

> Or is there a /proc/sys/vm/* knob that can be tweaked for this
> before/after the updatedb?

/proc/sys/vm/vfs_cache_pressure should help.  I don't recall anyone
reporting its effects with updatedb.

> But yeah, I for one would happily submit patches to upstream authors
> to address this there. There's no reason code should be making the
> kernel guess its intention on these things.

I think so.  We're dealing with super-special cases here and often trying
to fix those in-kernel will degrade other, often more common cases.

<wonders about sys_reclaim_dentry(const char *pathname)>
