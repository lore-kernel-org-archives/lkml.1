Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXLEOiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXLEOiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXLEOiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:38:05 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46815 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXLEOiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:38:03 -0500
Date: Wed, 5 Dec 2007 20:07:18 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [RFC PATCH 0/5] Union Mount: A Directory listing approach with
	lseek support
Message-ID: <20071205143718.GC2471@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In Union Mount, the merged view of directories of the union is obtained
by enhancing readdir(2)/getdents(2) to read and merge the entries of
all the directories  by eliminating the duplicates. While we have tried
a few approaches for this, none of them could perfectly solve all the problems.
One of the challenges has been to provide a correct directory seek support for
the union mounted directories. Sometime back when I posted an
RFC (http://lkml.org/lkml/2007/9/7/22) on this problem, one of the
suggestions I got was to have the dirents stored in a cache (which we
already do for duplicate elimination) and define the directory seek
behaviour on this cache constructed out of unioned directories.

I set out to try this and the result is this set of patches. I am myself
not impressed by the implementation complexity in these patches but posting
them here only to get further comments and suggestions. Moreover I haven't
debugged them thoroughly to uncover all the problems. While I don't expect
anybody try these patches, for the completeness sake I have to mention that
these apply on top of Jan Blunck's patches on 2.6.24-rc2-mm1
(ftp://ftp.suse.com/pub/people/jblunck/patches/).

In this approach, the cached dirents are given offsets in the form of
linearly increasing indices/cookies (like 0, 1, 2,...). This helps us to
uniformly define offsets across all the directories of the union
irrespective of the type of filesystem involved. Also this is needed to
define a seek behaviour on the union mounted directory. This cache is stored
as part of the struct file of the topmost directory of the union and will
remain as long as the directory is kept open.

While this approach works, it has the following downsides:

- The cache can grow arbitrarily large in size for big directories thereby
consuming lots of memory. Pruning individual cache entries is out of question
as entire cache is needed for subsequent readdirs for duplicate elimination.

- When an exising union gets overlaid by a new directory, there is a
possibility of the cache getting duplicated for the new union, thereby wasting
more space.

- Whenever _any_ directory that is part of the union gets
modified (addition/deletion of entries), the dirent cache of all the unions
which this directory is part of, needs to be purged and rebuilt. This is
expensive not only due to re-reads of dirents but also because
readdir(2)/getdents(2) needs to be synchronized with other operations
like mkdir/mknod/link/unlink etc.

- Since lseek(2) of the unioned directory also works on the same dirent
cache, it too needs to be invalidated when the directory gets modified.

- Supporting SEEK_END of lseek(2) is expensive as it involves reading in
all the dirents to know the EOF of the directory file.

After all this, I am beginning to think if it would be better to delegate
this readdir and whiteout processing to userspace. Can this be better handled
by readdir(3) in glibc ? But even with this, I am not sure if correct seek
behaviour (from lseek(2) or seekdir(3))  can be achieved in an easy manner.
Any thoughts on this ?

Earlier Erez Zodak had suggested that things will become easier if readdir
state is stored as a disk file (http://lkml.org/lkml/2007/9/7/114). This
approach simplifies directory seek support in Unionfs. But I am not sure if
such an approach would go well with VFS based unification approach like
Union Mount.

Regards,
Bharata.
