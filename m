Return-Path: <linux-kernel-owner+w=401wt.eu-S965712AbXIGRyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712AbXIGRyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 13:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbXIGRye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 13:54:34 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52308 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbXIGRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 13:54:33 -0400
Date: Fri, 7 Sep 2007 13:54:18 -0400
Message-Id: <200709071754.l87HsIpR015803@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, hooanon05@yahoo.co.jp,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC] Union Mount: Readdir approaches 
In-reply-to: Your message of "Fri, 07 Sep 2007 13:39:41 EDT."
             <20070907173941.GB20360@filer.fsl.cs.sunysb.edu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070907173941.GB20360@filer.fsl.cs.sunysb.edu>, "Josef 'Jeff' Sipek" writes:
> On Fri, Sep 07, 2007 at 01:28:55PM +0530, Bharata B Rao wrote:
> > On Fri, Sep 07, 2007 at 04:31:26PM +0900, hooanon05@yahoo.co.jp wrote:
> > > 
> > > When the first readdir is issued:
> > > - call vfs_readdir for every underlying opened dir (file) object.
> > > - store every entry to either the hash table for the result or the
> > >   whiteout, when the same-named entry didn't exist in the tables.
> > > - to improvement the performance, the allocated memory for the hash
> > >   tables are managed in a pointer array. and the elements are
> > >   concatinated logically by the pointer.
> > > - the pointer for the result-table, the version, and the currect jiffies
> > >   are set to vdir, which is a cache in an inode.
> > > - all cache are copied to a member in a file object.
> > > - the index of the cache memory block and the offset in an array is
> > >   handled as the seek position.
> > 
> > Ok, interesting approach. So you define the seek behaviour on your
> directory cache rather than allowing the underlying filesystems to
> > interpret the seek. I guess we can do something similar with Union
> > Mounts also.
> 
> Unless I missunderstood something, Unionfs uses the same approach. Even
> Unionfs's ODF branch does the same thing. The major difference is that we
> keep the cache in a file on a disk.

Yup.

Bharata, in the long run, storing a cache of the readdir state on disk, is
the best approach by far.  Since you already spend the CPU and memory
resources to create a merged view, storing it on disk as a contiguous file
isn't that much more effort.  That effort pays off later on esp. if the
directories don't change often:

- you get a compatible behavior with seekdir/telldir (no matter how
  braindead that interface is :-)

- for subsequent directory reading, your performance actually improves
  because you don't have to repeat the duplicate elimination and whiteout
  processing -- just read the cached file from disk as any other file.  You
  then benefit from traditional readahead, and from not having to cache the
  entire contents of the readdir state file, so it falls under normal
  paging/flushing policies.

Any policy which merges the readdir info and keeps it in memory indefinitely
is problematic -- you increase average memory pressure on the system over a
longer period of time; and when you purge your readdir state from memory,
you have to recreate it from scratch, re-consuming the same CPU/memory
resources.

Our ODF code implements the readdir state caching policy, as described in
the ODF design document here:

	<http://www.filesystems.org/unionfs-odf.txt>

Finally, I don't think it'll be so easy to get rid of seekdir/telldir, b/c
some of it is the default behavior of non-linux NFS/smb clients (we've seen
it with Solaris NFS clients).

Erez.
