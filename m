Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbXC2OlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbXC2OlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 10:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXC2OlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 10:41:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:20271 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbXC2OlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 10:41:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FihSrDOAj6HIhppTeRnNc4Y5EufEd2d1kvYHAS83SeIdQDs1+nAMs/fvpGwSWqVLB6pJVsMFjBikiiBAIbbue/VIVH1L5UEd/l/bPJozpNlToupWS2oiqPaYkqUOp7fV4w2sfeisj03BFzhRkVt1E/koCTqsFfcb1hm0L6f3RvM=
Message-ID: <4ae3c140703290741p58199472u3bf9f3f58e4d1db1@mail.gmail.com>
Date: Thu, 29 Mar 2007 10:41:01 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: "Jan Kara" <jack@suse.cz>
Subject: Re: Linux page cache issue?
Cc: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20070329092745.GA14616@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
	 <1175091028.12882.15.camel@kleikamp.austin.ibm.com>
	 <4ae3c140703280839q72164accic94666d7801243c1@mail.gmail.com>
	 <20070329092745.GA14616@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Many thanks for your kind reply.

I know we can use device inode's radix tree to achieve the same goal.
The only downside could be: First, by default, Linux will not add the
data pages into that radix tree. Only when a file is opened in
O_DIRECT, the data pages will be put into dev's radix tree. Moreover,
if the partition is big, I am not sure whether the lookup overhead is
an issue. So it might need some optimization.

Can you elaborate more about the aliasing issues mentioned in your
email? I do have some mechanisms to handle the following situation:
suppose two files share same data blocks. Now two processes open the
two files separately. If one process writes a file, the other file
will be affected. Is this the aliasing issue you referred to?

Thanks,
xin



On 3/29/07, Jan Kara <jack@suse.cz> wrote:
>   Hello,
>
> > Now I want to explain the problem that leads me to explore the Linux
> > disk cache management.  This is actually from my project. In a file
> > system I am working on, two files may have different inodes, but share
> > the same data blocks. Of course additional block-level reference
> > counting and copy-on-write mechanisms are needed to prevent operations
> > on one file from disrupting the other file. But the point is, the two
> > files share the same data blocks.
> >
> > I hope that consequential reads to the two files can benefit from disk
> > cache, since they have the same data blocks. But I noticed that Linux
> > splits disk buffer cache into many small parts and associate a file's
> > data with its mapping object. Linux determines whether a data page is
> > cached or not by lookup the file's mapping radix tree. So this is a
> > per-file radix tree. This design obviously makes each tree smaller and
> > faster to look up. But this design eliminates the possibility of
> > sharing disk cache across two files. For example, if a process reads
> > file 2 right after file 1 (both file 1 and 2 share the same data block
> > set). Even if the data blocks are already loaded in memory, but they
> > can only be located via file 1's mapping object. When Linux reads file
> > 2, it still think the data is not present in memory.  So the process
> > still needs to load the data from disk again.
>   Actually, there is one inode - the device inode - whose mapping can
> contain all the blocks of the filesystem. That is basically the radix
> tree you are looking for. ext3 for example uses it for accessing its
> metadata (indirect blocks etc.). But you have to be really careful to
> avoid aliasing issues and such when you'd like to map copies of those
> pages into mappings of several different inodes (BTW ext3cow filesystem
> may be interesting for you www.ext3cow.com).
>
>                                                                 Honza
>
> > On 3/28/07, Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> > >On Wed, 2007-03-28 at 02:45 -0400, Xin Zhao wrote:
> > >> Hi,
> > >>
> > >> If a Linux process opens and reads a file A, then it closes the file.
> > >> Will Linux keep the file A's data in cache for a while in case another
> > >> process opens and reads the same in a short time? I think that is what
> > >> I heard before.
> > >
> > >Yes.
> > >
> > >> But after I digged into the kernel code, I am confused.
> > >>
> > >> When a process closes the file A, iput() will be called, which in turn
> > >> calls the follows two functions:
> > >> iput_final()->generic_drop_inode()
> > >
> > >A comment from the top of fs/dcache.c:
> > >
> > >/*
> > > * Notes on the allocation strategy:
> > > *
> > > * The dcache is a master of the icache - whenever a dcache entry
> > > * exists, the inode will always exist. "iput()" is done either when
> > > * the dcache entry is deleted or garbage collected.
> > > */
> > >
> > >Basically, as long a a dentry is present, iput_final won't be called on
> > >the inode.
> > >
> > >> But from the following calling chain, we can see that file close will
> > >> eventually lead to evict and free all cached pages. Actually in
> > >> truncate_complete_page(), the pages will be freed.  This seems to
> > >> imply that Linux has to re-read the same data from disk even if
> > >> another process B read the same file right after process A closes the
> > >> file. That does not make sense to me.
> > >>
> > >> /***calling chain ***/
> > >> generic_delete_inode/generic_forget_inode()->
> > >> truncate_inode_pages()->truncate_inode_pages_range()->
> > >> truncate_complete_page()->remove_from_page_cache()->
> > >> __remove_from_page_cache()->radix_tree_delete()
> > >>
> > >> Am I missing something? Can someone please provide some advise?
> > >>
> > >> Thanks a lot
> > >> -x
> > >
> > >Shaggy
> > >--
> > >David Kleikamp
> > >IBM Linux Technology Center
> > >
> > >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> Jan Kara <jack@suse.cz>
> SuSE CR Labs
>
