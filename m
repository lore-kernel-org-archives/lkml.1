Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYCKFzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYCKFzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYCKFzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:55:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40567 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbYCKFzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:55:31 -0400
Date: Tue, 11 Mar 2008 11:25:27 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: libc-alpha@sourceware.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Ulrich Drepper <drepper@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [RFC] Union mount readdir support in glibc
Message-ID: <20080311055527.GA7256@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extending glibc readdir() to support union mounted directories
==============================================================

Any filesystem namespace unification solution needs to merge the
directory contents by eliminating duplicate(1) and whiteout(2) directory
entries. We (as part of Union Mount(3) effort) have been trying to do this
inside readdir/getdents system call in the kernel(4), but have found the
approach to be not very feasible. The effort of maintaining a cache of dirents
within the kernel turned out to be expensive on memory and cpu.
In this approach, we discuss about the feasibility of achieving
duplicate elimination and whiteout supression by extending the readdir
implementation of glibc.

Before actually going ahead with the implementation, this is an effort
to build consensus about the approach within the glibc community.

readdir/getdents in kernel
--------------------------
readdir/getdents system call on a union mounted directory would just return
all the entries of the union starting from the topmost directory.

readdir in glibc
----------------
glibc readdir would maintain a cache of dirents returned by readdir/getdents
system call to perform duplicate elimination and whiteout supression.

glibc readdir would need the following information from the kernel:

- Indication that this directory is a union mounted directory.
	With this indication, glibc need not build and maintain
dirent cache for normal non-union directories. Need to check if glibc
can live without such indication, which means that glibc readdir would
build dirent cache for _all_ directories. Need to check the overhead
incurred by doing this.

- Indication that kernel has finished returning the dirents from the
topmost directory of the union.
	This would tell glibc readdir to start eliminating the duplicates
for the subsequent dirents returned from the bottom directories of the union.
Can kernel pass a special dirent like a "." whiteout to indicate this ?
Any other methods ? Or should glibc not bother about dirents from
different directories and start duplicate elimination right from the
beginning ? Ofcourse this would result in some extra comparisions
(comparisions against d_name to determine the duplicates) for the dirents
from topmost directory.

- Indication that this directory entry is a whiteout entry.
	DT_WHT(which already exists in linux) value for d_type will be
used to identify whiteouts.

- Indication that one of the directories of the union got modified(removal
or addition of a directory entry) during readdir.
	Ideally any change to the directories should result in
dirent cache invalidation. But, should we be even bothered about this ?
Should we just ignore directory modifications happening between glibc opendir
and closedir and just live with whatever entries the kernel returns ?

Downsides of this approach

- Applications using readdir/getdents system calls directly would have
to handle duplicate elimination and whiteout supression themselves.
- Applications linked statically with glibc would have problems with
union mounted directories.

Directory seek support
----------------------
Can we just don't support seek on a union mounted directory ?

But if directory seek support on a union mounted directory is a necessity,
my current thinking is that we can define the seek behaviour on the
dirent cache maintained by glibc readdir. With this, glibc would be
defining the seek behaviour for union mounted directories instead of
getting it from kernel. But again this would work only for applications
that make use of seekdir() and friends and not for applications that
use lseek(2) directly. I am yet to look at glibc seekdir in detail to
ascertain if the above approach is doable.

Regards,
Bharata.
--

(1) Duplicates: With filesystem namespace unification, it is possible to
have same-named entries in multiple layers/branches/directories of the union.
In such cases only the entry from the topmost layer/branch/directory is
made available.

(2) Whiteouts: Whiteouts are place holders for the entries that don't exist
logically in the union. Typically, deletion of an entry present only in
the (read-only) lower layer of a union would result in a whiteout getting
created in the topmost layer of the union. Whiteout lookup would return
-ENOENT.

(3) Union Mount: http://lkml.org/lkml/2007/7/30/193

(4) Directory lising approaches in the kernel:
    http://lkml.org/lkml/2007/12/5/147
