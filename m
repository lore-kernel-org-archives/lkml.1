Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbXIZOVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbXIZOVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXIZOVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:21:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXIZOVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:21:21 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/24] Introduce credential record
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 26 Sep 2007 15:20:59 +0100
Message-ID: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Al, Christoph, Trond, Stephen, Casey,

Here's a set of patches that implement a very basic set of COW credentials.  It
compiles, links and runs for x86_64 with EXT3, (V)FAT, NFS, AFS, SELinux and
keyrings all enabled.  I've included a patch that should make most of the other
archs and filesystems work, but I haven't yet merged it into the primary
patches.

A tarball of the patches can be retrieved from:

	http://people.redhat.com/~dhowells/nfs/nfs+fscache-24.tar.bz2


The cred struct contains the credentials that the kernel needs to act upon
something or to create something.  Credentials that govern how a task may be
acted upon remain in the task struct.

In essence, the introduction of the cred struct separates a task's subjective
context (the authority with which it acts) from its objective context (the
authorisation required by others that want to act upon it), and permits
overriding of the subjective context by a kernel service so that the service
can act on the task's behalf to do something the task couldn't do on its own
authority.

Because keyrings and effective capabilities can be installed or changed in one
process by another process, they are shadowed by the cred structure rather than
residing there.  Additionally, the session and process keyrings are shared
between all the threads of a process.  The shadowing is performed by
update_current_cred() which is invoked on entry to any system call that might
need it.

A thread's cred struct may be read by that thread without any RCU precautions
as only that thread may replace the its own cred struct.  To change a thread's
credentials, dup_cred() should be called to create a new copy, the copy should
be changed, and then set_current_cred() should be called to make it live.  Once
live, it may not be changed as it may then be shared with file descriptors, RPC
calls and other threads.  RCU will be used to dispose of the old structure.


The six patches are:

 (1) Introduce struct cred and migrate fsuid, fsgid, the groups list and the
     keyrings pointer to it.

 (2) Introduce a security pointer into the cred struct and add LSM hooks to
     duplicate the information pointed to thereby and to free it.

     Make SELinux implement the hooks, splitting out some the task security
     data to be associated with struct cred instead.

 (3) Make the security functions that permit task SID retrieval return both the
     objective and subjective SIDs as required.

 (4) Migrate the effective capabilities mask into the cred struct.

 (5) Fix up all the other archs and filesystems that I can manage to compile.
     This should be merged into the preceding patches at some point.

 (6) Provide a pair of LSM hooks so that a kernel service can (a) get a
     credential record representing the authority with which it is permitted to
     act, and (b) alter the file creation context in a credential record.

In addition, as this works with cachefiles, I've included all the FS-Cache,
CacheFiles, NFS and AFS patches.

To substitute a temporary set of credentials, the cred struct attached to the
task should be altered, like so:

	int get_privileged_creds(...)
	{
		/* get special privileged creds */
		my_special_cred = get_kernel_cred("cachefiles", current);
		change_create_files_as(my_special_cred, my_cache_dir);
	}

	int do_stuff(...)
	{
		struct cred *cred;

		/* rotate in the new creds, saving the old */
		cred = __set_current_cred(get_cred(my_special_cred));

		do_privileged_stuff();

		/* restore the old creds */
		set_current_cred(cred);
	}

One thing I'm not certain about is how this should interact with /proc, which
can display some of the stuff in the cred struct.  I think it may be necessary
to have a real cred pointer and an effective cred pointer, with the contents of
/proc coming from the real, but the effective governing what actually goes on.

Furthemore, I was thinking that it was a good idea to move the setting of i_uid
and i_gid to current->cred->i_[ug]id into new_inode(), but now I'm not so sure,
since the kernel special filesystems may assume that the i_uid and i_gid
default to 0.  Any thoughts on this?

The NFS FS-Cache sharing patch still needs fixing up to correctly do the
sharing thing when local caching is enabled.

David
