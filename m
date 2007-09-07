Return-Path: <linux-kernel-owner+w=401wt.eu-S965085AbXIGHkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbXIGHkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 03:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964931AbXIGHk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 03:40:27 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:40684 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928AbXIGHk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 03:40:26 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 03:40:26 EDT
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Union Mount: Readdir approaches 
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
In-Reply-To: <20070907054618.GD1692@in.ibm.com>
References: <20070907054618.GD1692@in.ibm.com>
Date: Fri, 07 Sep 2007 16:31:26 +0900
Message-Id: <E1ITYJK-0000xP-8h@jroun>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Bharata,
I am developing a linux stackable/unification filesystem too.

Bharata B Rao:
> Questions
> ---------
	:::
> First of all, should we even expect a sane lseek(2) on union mounted
> directories ? If not, will the Approach 2, which works uniformly for
> all filesystem types be acceptable ?
> 
> If lseek(2) needs to be supported, then how do we define the seek behaviour
> when two different types of directories are union'ed ? For eg. how do we define
> lseek(2) on a union of ext2 directory on top of a nfs directory ? Since both
> of them use different encoding methods for filp->f_pos, how do we establish
> a common lseek(2) behaviour here ?
> 
> And finally, what is the use case for directory seek ? Would anybody walk
> directory by directory by seeking into a directory file ?

Although I don't remember exactly, NFS or smbfs seek for a
directory. Additionally, any user process can call seekdir or
something. So I believe any stackable/unification filesystem should
support it.

Here is my approach. While I don't think it is the best approach since
it consumes much memory and cpu, I hope it help you. (or assist
you? Sorry, I don't know correct English word)

- the stackable fs has its own inode, file, dentry object, which has an
  array for the underlying inode pointers. and the whiteout is a regular
  file with a special name, instead of a flag in inode. this is the most
  different architecture from your unification embeded in VFS.
- the vritual dir inode object has a cache for its child entries. it is
  called vdir. the cache has a version and a customizlable lifetime too.
- all the existing underlying (same-named) dir are opened too. the file
  objects are stored in the virtual file object as an array.
- the virtual file object has a cache for its child entries too. it is a
  copy of the one in the inode object.

When the first readdir is issued:
- call vfs_readdir for every underlying opened dir (file) object.
- store every entry to either the hash table for the result or the
  whiteout, when the same-named entry didn't exist in the tables.
- to improvement the performance, the allocated memory for the hash
  tables are managed in a pointer array. and the elements are
  concatinated logically by the pointer.
- the pointer for the result-table, the version, and the currect jiffies
  are set to vdir, which is a cache in an inode.
- all cache are copied to a member in a file object.
- the index of the cache memory block and the offset in an array is
  handled as the seek position.

In the case of the application issued this sequence:
- opendir()
- readdir()
- creat or unlink an entry under the dir
- readdir()

When an entry under the dir was removed or added, the inode version will
be updated. Since readdir can compare it with the cached version or the
lifetime (jiffies) in the file object, it can refresh the entries. But
in this case, it doesn't, since the file position is not 0. If the
application needs the latest entries, it has to call rewinddir.
The cache in the file object will updated only the case of obsoleted AND
the file position is 0.

When a dir who has already its vdir is opened, the cache in the inode
object will be used without calling vfs_readdir, after checking the
version and the lifetime which are stored in the inode object. If it is
obsoleted, vfs_readdir will be called again in order to update the cache
in the inode.


If you are interested in this approach, please refer to
http://aufs.sf.net. It is working and used by several people.


Junjiro Okajima
