Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbXIGFqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbXIGFqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 01:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXIGFqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 01:46:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59871 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXIGFq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 01:46:28 -0400
Date: Fri, 7 Sep 2007 11:16:18 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC] Union Mount: Readdir approaches
Message-ID: <20070907054618.GD1692@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any filesystem namespace unification solution (Union Mount, Unionfs) needs to
provide a unified or merged view of directory contents. Typically this is
done by reading the directory entries of all the union'ed layers (starting
from the top and working downwards) and merging the result by eliminating
the duplicate entries. This is done by extending the getdents/readdir system
calls to support the notion of union'ed directories.

Here I try to describe briefly the approaches we have tried with Union Mount
and the issues we are facing. The intention is to solicit feedback and
suggestions on how to solve this problem of merging directory contents.

Approach 1
----------
This is the approach which is present in the current Union Mount patches.

In this approach, the directory entries are read starting from the topmost
directory and they are maintained in a cache. Subsequently, when the entries
from the lower directories are read, they are checked for duplicates (in the
cache) before being passed out to the user space. There can be multiple calls
to readdir/getdents routines for reading the entries of a single directory.
But union directory cache is not maitained across these calls. Instead
for every call, the previously read entries are re-read into the cache
and newly read entires are compared against these for duplicates before
being they are returned to user space.

Since Union Mount does unioning at VFS layer, the file descriptor
of the topmost directory represents all the underlying directories. So
even though readdir() happens on the same file struct, it needs to internally
obtain file structs for lower directories and issue readdir() on them
separately. While this itself is fine, it causes a problem when the
directory is lseek'ed.

In this approach, the file position of the topmost directory is linearly
scaled to accommodate the (inode) sizes of the underlying directories.
For eg, if the union has two layers (with inode sizes 100 each), then
at the end of reading the lower directory, the file->f_pos of the topmost
directory would be 200.  So, it is possible for the file position
(of the topmost directory) to exceed it's inode size.

This approach works only if all the layers of the union have flat file
directories (like ext2). And it fails for those filesystems which return
a directory offset (dirent->d_off) greater than the inode size. And it allows
a sane lseek() behaviour on union'ed directories (only for flat file
directories).

Ref: http://lkml.org/lkml/2007/7/30/174

Approach 2
----------
This approach was part of a few versions of Union Mount patches.

Like Approach 1, this also maintains a cache of directory
entries, but this cache persists across readdir calls. So unlike the
previous approach, here the cache is not destroyed and rebuilt for
every readdir(). Instead the cache information is left hanging off
the file structure of the topmost directory. In addition to the
cached entries, it also stores information about the current
directory(vfsmnt, dentry) in the union stack on which last readdir() was done
and also the offset (file->f_pos) at which the readdir() stopped.
Subsequent readdir() will fetch this information from file struct (of the top
layer) and start reading the entries at where the previous readdir() had
stopped. And this approach doesn't try to interpret or change file->f_pos.

Since the information about the directory and the offset within it is
stored separately when the readdir() ends, this approach works for all
filesystems, irrespective of the method used by them to encode directory's
file->f_pos. But again, this can't support a sane lseek() on union'ed
directories in its current form.

Ref: http://lkml.org/lkml/2007/6/20/21

Approach 3
----------
Chistoph Hellwig suggested that to avoid a single file struct representing
multiple objects, ->readdir() which is currently a file operation should
instead be changed to inode operation. But it is not sure atm how this could
help because getdents(2) and readdir(2) restrict us to use a open file
descriptor and there is one fd for union'ed directories. Moreover we need
a single offset element to correctly represent the offset into lower
directories so as to support lseek(2) correctly.

Ref: http://lkml.org/lkml/2007/6/20/107

Questions
---------
The main problem in getting a sane readdir() implementation in Union Mount
is the fact that a single vfs object (file structure) is used to represent
more than one (underlying) directory. Because of this, it is unclear as to
how lseek(2) needs to behave in such cases.

First of all, should we even expect a sane lseek(2) on union mounted
directories ? If not, will the Approach 2, which works uniformly for
all filesystem types be acceptable ?

If lseek(2) needs to be supported, then how do we define the seek behaviour
when two different types of directories are union'ed ? For eg. how do we define
lseek(2) on a union of ext2 directory on top of a nfs directory ? Since both
of them use different encoding methods for filp->f_pos, how do we establish
a common lseek(2) behaviour here ?

And finally, what is the use case for directory seek ? Would anybody walk
directory by directory by seeking into a directory file ?

Regards,
Bharata.
