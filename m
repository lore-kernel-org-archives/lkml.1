Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbXHBTSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbXHBTSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbXHBTSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:18:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbXHBTSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:18:44 -0400
Date: Thu, 2 Aug 2007 12:18:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Ken Chen <kenchen@google.com>
Subject: Re: kupdate weirdness
Message-Id: <20070802121806.d7071ba1.akpm@linux-foundation.org>
In-Reply-To: <E1IGcyd-00025s-00@dorka.pomaz.szeredi.hu>
References: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
	<20070801141439.ff1c29f9.akpm@linux-foundation.org>
	<E1IGcyd-00025s-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Aug 2007 17:52:39 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > The following strange behavior can be observed:
> > > 
> > > 1. large file is written
> > > 2. after 30 seconds, nr_dirty goes down by 1024
> > > 3. then for some time (< 30 sec) nothing happens (disk idle)
> > > 4. then nr_dirty again goes down by 1024
> > > 5. repeat from 3. until whole file is written
> > > 
> > > So basically a 4Mbyte chunk of the file is written every 30 seconds.
> > > I'm quite sure this is not the intended behavior.
> > > 
> > > The reason seems to be that __sync_single_inode() will move the
> > > partially written inode from s_io onto s_dirty, and sync_sb_inode()
> > > will not splice it back onto s_io until the rest of the inodes on s_io
> > > has been processed.
> > 
> > It does all sorts of weird crap.
> > 
> > > Since there will probably be a recently dirtied inode on s_io, this
> > > will take some of time, but always less than 30 sec.
> > > 
> > > I don't know what's the easiest solution.
> > > 
> > > Any ideas?
> > 
> > Try 2.6.23-rc1-mm2.
> 
> Much better, but still not perfect.

I've kinda lost track of the status of all these patches.  I _think_ Ken
has identified a remaining problem even after his
writeback-fix-periodic-superblock-dirty-inode-flushing.patch, but maybe I
misremember.

Ken, can you remind us of the status there, please?

> Now it writes out 1024 pages after 30 seconds and then the rest after
> another 30s.

Bah.

> If my analysis is correct, this is because when it first gets onto
> s_io other inodes will get there too (with up-to 30s later dirying
> time), and the contents of s_more_io won't be recycled until the
> current contents of s_io are processed.
> 
> Maybe this is OK, the previous weird stuff didn't seem to bother a lot
> of people either.

There were heaps of problems in there and it is surprising how few people
were hitting them.  Ordered-mode journalling filesystems will fix it all up
behind the scenes, of course.

I just have a bad feeling about that code - list_heads are the wrong data
structure and it all needs to be ripped and redone using some indexable
data structure.  There has been desultory discussion, but nothing's
happening and nothing will happen in the medium term, so we need to keep
on whapping bandainds on it.

