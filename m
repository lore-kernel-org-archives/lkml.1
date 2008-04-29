Return-Path: <linux-kernel-owner+w=401wt.eu-S1763600AbYD2Nhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763600AbYD2Nhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbYD2Nhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:37:34 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:53257 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYD2Nhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=tLwv10UZe7l9++p3LtBpcuyUrzgdCxQxqlZkPaLLd0tUafjzTwrFA9naMHzRNk4qBppFeU+cyV/3vYt6sdvu9sjDT1anFcD9Y2Tjg4W5e7a8Qf3naIn8rtjqHBDN1qeMPI+KO+wrNC0OutecgSCZCFOd9LNEH0JRkt6wbcqFwos=
Date: Tue, 29 Apr 2008 19:02:01 +0530
To: libc-alpha@sourceware.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Ulrich Drepper <drepper@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
Subject: [RFC PATCH 0/2] Union Mount: Directory listing in glibc
Message-ID: <20080429133201.GA9938@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: bsn.0007@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I went through Bharata's RFC post on glibc based Union Mount readdir solution
(http://lkml.org/lkml/2008/3/11/34) and have come up with patches
against glibc to implement the same.

The RFC discussed about the information glibc readdir needs to get about
union mounted directories and I have assumed the following information
to be available from the kernel for this implementation.

- Kernel would return all the dirents (including duplicates and whiteouts)
starting from the topmost directory of the union.

- Indication that this directory is a union mounted directory
	I have assumed that kernel would return a "." whiteout as the first
directory entry of the union. This would tell glibc readdir(3) that it is
working with a union mounted directory and it needs to do duplicate
elimination and whiteout suppression. It starts building a dirent cache
for this purpose.

Ulrich had suggested that we could use the fstat call to recognize union
mounts. But looking at the stat structure from stat(2), it was not obvious
as to which field in there could be used for this purpose. Hence for this
prototype implementation, I decided to go with what Al Viro suggested, which
is about using a "." whiteout.

- Indication that kernel is done with returning entries from the topmost
directory.
	I have assumed that kernel would return a "." whiteout at the beginning
of each directory of the union. So when glibc gets a 2nd "." whiteout, it
will start performing duplicate elimination.

- Whiteout indication
	glibc will depend on dirent->d_type to be set to DT_WHT on a whiteout
file.

With this post, I am sending two patches:

Patch 1. readdir support for union mounted directories.
	I am caching the dirent names in a list to aid duplicate elimination.
And this cache is stored in DIRP. For duplicate elimination I am using
strcmp(). I am not sure if this works universally with different types
of filesystems. Any suggestions here would be welcome.

Patch 2. seekdir support.
	The seekdir works on the cache maintained by readdir. Since after a
seekdir, it might become necessary for readdir to return dirents from cache
(as against getting them from readdir(2)/getdents(2)), I had to cache the
entire dirent structure in readdir. I understand that this is expensive, but
not sure if this is avoidable if we have to support seekdir.

To support seekdir on a union mounted directory, the seek is applied
to the cache of dirents. The offsets (dirent->d_off) returned by readdir(3) has
been modified to return linearly increasing offsets like 0,1,2,... rather
than returning filesystem-returned offsets. This helps us to have a uniform
seek across all the directories of the union.

With seekdir modified, I had to modify telldir also not to return
filesystem-returned offsets for union mounted directories.

With seekdir support, it becomes necessary in readdir to check if we need
to return dirents from cache. And this adds a bit of overhead to readdir
as we have to do this check for every directory.

Compatibility issues
--------------------
There are many versions of dirent structure in glibc and I have tried my
best to take care of compatibility issues. But I have not really tested
readdir64 or old_readdir64. Also atleast one version of dirent structure
doesn't have d_type field and my whiteout suppression logic depends on it
and uses it in the generic __READDIR routine which gets used by various
version of readdir and I think this would break that readdir version which
uses dirent structure w/o d_type. I will be taking care of such compatibility
issues more cleanly/thoroughly in subsequent posts.

Testing
-------
I have done very minimal testing of these patches on a Intel machine which
uses 32 bit readdir. There might be some corner cases in readdir, seekdir
and telldir which I might not have taken care of and would be happy to fix them
if pointed to. I have tested these patches together with Union Mount
patches for 2.6.24-rc2-mm1. These patches are for glibc-2.7.

I request you to reveiw the patches. Any comments and suggestions are
greatly welcome.

Regards
Nagabhushan
