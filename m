Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXC1PjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXC1PjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXC1PjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:39:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:21011 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbXC1PjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZuncBxuSxkQq1YOJ84d7S2ADIjYzevRDEWXT0b8D1Cf/fzkp6f9rpCp15/bmT9ZKRhTsMQKyzAjNO+Axz3lYCRCfBCchy7jl2Ted+o/XbXLKSWXuSBPutvMs/r/wpsCF66/iz6rSEx0UjlVlLBZ8gPazQplinKwq/WzlXDiYe68=
Message-ID: <4ae3c140703280839q72164accic94666d7801243c1@mail.gmail.com>
Date: Wed, 28 Mar 2007 11:39:20 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: Linux page cache issue?
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1175091028.12882.15.camel@kleikamp.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
	 <1175091028.12882.15.camel@kleikamp.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot! Folks!

Your reply addressed my concern.

Now I want to explain the problem that leads me to explore the Linux
disk cache management.  This is actually from my project. In a file
system I am working on, two files may have different inodes, but share
the same data blocks. Of course additional block-level reference
counting and copy-on-write mechanisms are needed to prevent operations
on one file from disrupting the other file. But the point is, the two
files share the same data blocks.

I hope that consequential reads to the two files can benefit from disk
cache, since they have the same data blocks. But I noticed that Linux
splits disk buffer cache into many small parts and associate a file's
data with its mapping object. Linux determines whether a data page is
cached or not by lookup the file's mapping radix tree. So this is a
per-file radix tree. This design obviously makes each tree smaller and
faster to look up. But this design eliminates the possibility of
sharing disk cache across two files. For example, if a process reads
file 2 right after file 1 (both file 1 and 2 share the same data block
set). Even if the data blocks are already loaded in memory, but they
can only be located via file 1's mapping object. When Linux reads file
2, it still think the data is not present in memory.  So the process
still needs to load the data from disk again.

Would it make sense to build a per-device radix tree indexed by (dev,
sect_no)?  The loaded data pages can still be associated with a
per-file radix tree in the file's mapping object, but it is also
associated with the per-device radix tree. When looking up cached
pages, Linux can first check the per-file radix tree. The per-device
radix tree is checked only if Linux fails to find a cached page in the
per-file radix tree. The lookup of the per-device radix tree may incur
some overhead. But compared to the slow disk access, looking up an
in-memory radix tree is much cheaper and should be trivial, I guess.

Any thought about this?

Thanks,
-x

On 3/28/07, Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> On Wed, 2007-03-28 at 02:45 -0400, Xin Zhao wrote:
> > Hi,
> >
> > If a Linux process opens and reads a file A, then it closes the file.
> > Will Linux keep the file A's data in cache for a while in case another
> > process opens and reads the same in a short time? I think that is what
> > I heard before.
>
> Yes.
>
> > But after I digged into the kernel code, I am confused.
> >
> > When a process closes the file A, iput() will be called, which in turn
> > calls the follows two functions:
> > iput_final()->generic_drop_inode()
>
> A comment from the top of fs/dcache.c:
>
> /*
>  * Notes on the allocation strategy:
>  *
>  * The dcache is a master of the icache - whenever a dcache entry
>  * exists, the inode will always exist. "iput()" is done either when
>  * the dcache entry is deleted or garbage collected.
>  */
>
> Basically, as long a a dentry is present, iput_final won't be called on
> the inode.
>
> > But from the following calling chain, we can see that file close will
> > eventually lead to evict and free all cached pages. Actually in
> > truncate_complete_page(), the pages will be freed.  This seems to
> > imply that Linux has to re-read the same data from disk even if
> > another process B read the same file right after process A closes the
> > file. That does not make sense to me.
> >
> > /***calling chain ***/
> > generic_delete_inode/generic_forget_inode()->
> > truncate_inode_pages()->truncate_inode_pages_range()->
> > truncate_complete_page()->remove_from_page_cache()->
> > __remove_from_page_cache()->radix_tree_delete()
> >
> > Am I missing something? Can someone please provide some advise?
> >
> > Thanks a lot
> > -x
>
> Shaggy
> --
> David Kleikamp
> IBM Linux Technology Center
>
>
