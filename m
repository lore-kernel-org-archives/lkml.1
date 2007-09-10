Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbXIJFPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbXIJFPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 01:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbXIJFPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 01:15:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53645 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbXIJFPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 01:15:20 -0400
Date: Mon, 10 Sep 2007 10:45:10 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, hooanon05@yahoo.co.jp,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC] Union Mount: Readdir approaches
Message-ID: <20070910051510.GB6415@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070907173941.GB20360@filer.fsl.cs.sunysb.edu> <200709071754.l87HsIpR015803@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709071754.l87HsIpR015803@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 01:54:18PM -0400, Erez Zadok wrote:
> In message <20070907173941.GB20360@filer.fsl.cs.sunysb.edu>, "Josef 'Jeff' Sipek" writes:
> > On Fri, Sep 07, 2007 at 01:28:55PM +0530, Bharata B Rao wrote:
> > > On Fri, Sep 07, 2007 at 04:31:26PM +0900, hooanon05@yahoo.co.jp wrote:
> > > > 
> > > > When the first readdir is issued:
> > > > - call vfs_readdir for every underlying opened dir (file) object.
> > > > - store every entry to either the hash table for the result or the
> > > >   whiteout, when the same-named entry didn't exist in the tables.
> > > > - to improvement the performance, the allocated memory for the hash
> > > >   tables are managed in a pointer array. and the elements are
> > > >   concatinated logically by the pointer.
> > > > - the pointer for the result-table, the version, and the currect jiffies
> > > >   are set to vdir, which is a cache in an inode.
> > > > - all cache are copied to a member in a file object.
> > > > - the index of the cache memory block and the offset in an array is
> > > >   handled as the seek position.
> > > 
> > > Ok, interesting approach. So you define the seek behaviour on your
> > directory cache rather than allowing the underlying filesystems to
> > > interpret the seek. I guess we can do something similar with Union
> > > Mounts also.
> > 
> > Unless I missunderstood something, Unionfs uses the same approach. Even
> > Unionfs's ODF branch does the same thing. The major difference is that we
> > keep the cache in a file on a disk.
> 
> Yup.
> 
> Bharata, in the long run, storing a cache of the readdir state on disk, is
> the best approach by far.  Since you already spend the CPU and memory
> resources to create a merged view, storing it on disk as a contiguous file
> isn't that much more effort.  That effort pays off later on esp. if the
> directories don't change often:

Erez, I agree that there are positives in storing the readdir state
on disk, but ...

> 
> - you get a compatible behavior with seekdir/telldir (no matter how
>   braindead that interface is :-)

lseek problem can also be solved by defining the seek on the cached (in
memory) readdir state. (similar to aufs)

> 
> - for subsequent directory reading, your performance actually improves
>   because you don't have to repeat the duplicate elimination and whiteout
>   processing -- just read the cached file from disk as any other file.  You
>   then benefit from traditional readahead, and from not having to cache the
>   entire contents of the readdir state file, so it falls under normal
>   paging/flushing policies.

I guess, same performance benefits can be obtained if we leave the
readdir state in memory for sometime. In the Approach 2 which I
described in my original post, the readdir state was stored as part of
the file structure and it remained there until the last close of the
directory.

> 
> Any policy which merges the readdir info and keeps it in memory indefinitely
> is problematic -- you increase average memory pressure on the system over a
> longer period of time; and when you purge your readdir state from memory,
> you have to recreate it from scratch, re-consuming the same CPU/memory
> resources.

Yes, keeping the state in memory indefinitely is problematic.
But we can always purge it under memory pressure. If it comes
to that then it is a tradeoff between recreating the state after purging
and having the state stored in a separate physical file system.

Not related directly to readdir, but I had concerns about ODF:

- Creating/Replicating the entire directory tree of the union. So you
can potentially have a very large tree duplicated (ofcouse with zero
length files, but still) in ODF.

- Storing whiteouts in ODF might be a feasible solution for unionfs, but for
union mount it looks like an overhead. You can afford to have an
extra (whiteout) lookup into ODF from your unionfs lookup code, since
you do all this from unionfs filesystems code. But doing anything similar
with union mounts from VFS layer is going to look ugly.

Regards,
Bharata.
