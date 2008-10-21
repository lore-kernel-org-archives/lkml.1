Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYJUNJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYJUNJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJUNJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:09:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54713 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbYJUNI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:08:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4310.1224548453@redhat.com>
References: <4310.1224548453@redhat.com>
To: torvalds@osdl.org
Cc: dhowells@redhat.com, jmorris@namei.org, viro@ZenIV.linux.org.uk,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT Pull Request] Copy on write credentials for Linux [ver #3]
Date: Tue, 21 Oct 2008 14:07:20 +0100
Message-ID: <18391.1224594440@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I should probably explain what these patch are about.  They detach the
credentials and other security information from the task_struct and store it
in a (mostly) copy-on-write struct that may then be shared between processes,
leaving only a couple of pointers in task_struct.  This means:

 (1) The kernel can cleanly override the current subjective security context
     of a task without affecting its objective security context.  This allows
     the kernel to perform privileged accessed on behalf of a task without
     affecting that task's ability to receive signals, be the target of
     ptrace() and be accessed through /proc.

 (2) The kernel can install multiple replacement credentials simultaneously
     without an intermediate state being seen.

 (3) The kernel can simply discard proposed replacement credentials if an
     error occurs during the process.  No reversion is required.

 (4) As a consequence of (2), execve() can keep its credential changes to
     itself until it's ready to commit all of them.  execve() no longer
     applies credential changes piecemeal.

 (5) If execve() returns an error, the task's current security state will not
     have been altered (currently some state may be lost by an unsuccessful
     execve()).

I'm intending to use this code to implement FS-Cache/CacheFiles, but it could
also perhaps be used for NFSD.

Note that some of the wrapping patches have already been incorporated upstream
and have been dropped from this set.


There are three parts to this project:

 (1) Implement COW credentials.

 (2) Pass the cred pointer through the vfs_xxx() functions and suchlike to all
     the places that need them.

 (3) Document it.

The associated patches implement (1) and part of (3).  Some things to note:

 (a) All of {,e,s,fs}{u,g}id and supplementary groups, capabilities, secure
     bits, keyrings, and the task security pointer have migrated into struct
     cred.

 (b) Changing a tasks credentials involves creating a new struct cred (call
     prepare_creds()) and then using RCU to change things over (call
     commit_creds()).

 (c) task_struct::cred is a const struct cred *, as are all pointers that
     aren't used specifically for creating new credentials.  This catches
     places that are changing creds when they shouldn't be at compile time.

     To get a new ref on a const cred, use get_cred() which casts away the
     const and calls atomic_inc().

 (d) It is no longer possible for a task to instantiate another task's
     keyrings.  The keyrings code tries to make sure that the required keyrings
     are present in request_key(), and redirects any attempt to nominate a
     process-specific keyring when instantiating a key to whatever keyring was
     suggested by sys_request_key() (or it uses the default).

 (e) sys_capset() is neutered: it can only affect the caller.

 (f) execve() is cleaner.  The changes are all worked out in a new set of
     credentials, then the whole lot is installed in install_exec_creds() (a
     replacement for compute_creds()) in three stages:

     (i) The LSM is called - security_bprm_committing_creds() - so that the LSM
     	 can do stuff that must be done before the new creds take effect.
     	 SELinux uses this to call flush_authorized_files() and to flush
     	 rlimits.

     (ii) commit_creds() is called to make the actual change.

     (iii) The LSM is called again - security_bprm_committed_creds() - so that
         the LSM can do stuff that must be done under the new creds.  SELinux
         uses this to flush signal handlers.

 (g) Most of the bprm LSM hooks have been replaced with simplified code
     arranged differently.

 (h) In struct file, f_uid and f_gid have been replaced by f_cred, which is a
     pointer to the opener's credentials at the time of opening.

 (i) Credentials are shared where possible.  More work should go into this as
     it plays it safe when sharing keyrings over non-CLONE_THREAD clones.

 (j) The reparent_to_init LSM hook for kernel threads is gone.  Kernel threads
     now made to share init_cred instead at the start of their life (they may
     change this later).

Most of the work is in the patch ensubjected "CRED: Inaugurate COW
credentials".  The description attached to this describes each of the logical
changes in more detail.  The preceding patches are preparation.


These patches compile for make allmodconfig, and I've built and run a kernel on
my x86_64 test box with these patches applied.

The patches are:

 (*) CRED: Wrap task credential accesses in the IA64 arch
 (*) CRED: Wrap task credential accesses in the MIPS arch
 (*) CRED: Wrap task credential accesses in the PA-RISC arch
 (*) CRED: Wrap task credential accesses in the PowerPC arch
 (*) CRED: Wrap task credential accesses in the S390 arch
 (*) CRED: Wrap task credential accesses in the x86 arch
 (*) CRED: Wrap task credential accesses in the block loopback driver
 (*) CRED: Wrap task credential accesses in the tty driver
 (*) CRED: Wrap task credential accesses in the ISDN drivers
 (*) CRED: Wrap task credential accesses in the network device drivers
 (*) CRED: Wrap task credential accesses in the USB driver
 (*) CRED: Wrap task credential accesses in 9P2000 filesystem
 (*) CRED: Wrap task credential accesses in the AFFS filesystem
 (*) CRED: Wrap task credential accesses in the autofs filesystem
 (*) CRED: Wrap task credential accesses in the autofs4 filesystem
 (*) CRED: Wrap task credential accesses in the BFS filesystem
 (*) CRED: Wrap task credential accesses in the CIFS filesystem
 (*) CRED: Wrap task credential accesses in the Coda filesystem
 (*) CRED: Wrap task credential accesses in the devpts filesystem
 (*) CRED: Wrap task credential accesses in the eCryptFS filesystem
 (*) CRED: Wrap task credential accesses in the Ext2 filesystem
 (*) CRED: Wrap task credential accesses in the Ext3 filesystem
 (*) CRED: Wrap task credential accesses in the Ext4 filesystem
 (*) CRED: Wrap task credential accesses in the FAT filesystem
 (*) CRED: Wrap task credential accesses in the FUSE filesystem
 (*) CRED: Wrap task credential accesses in the GFS2 filesystem
 (*) CRED: Wrap task credential accesses in the HFS filesystem
 (*) CRED: Wrap task credential accesses in the HFSplus filesystem
 (*) CRED: Wrap task credential accesses in the HPFS filesystem
 (*) CRED: Wrap task credential accesses in the hugetlbfs filesystem
 (*) CRED: Wrap task credential accesses in the JFS filesystem
 (*) CRED: Wrap task credential accesses in the Minix filesystem
 (*) CRED: Wrap task credential accesses in the NCPFS filesystem
 (*) CRED: Wrap task credential accesses in the NFS daemon
 (*) CRED: Wrap task credential accesses in the OCFS2 filesystem
 (*) CRED: Wrap task credential accesses in the OMFS filesystem
 (*) CRED: Wrap task credential accesses in the RAMFS filesystem
 (*) CRED: Wrap task credential accesses in the ReiserFS filesystem
 (*) CRED: Wrap task credential accesses in the SMBFS filesystem
 (*) CRED: Wrap task credential accesses in the SYSV filesystem
 (*) CRED: Wrap task credential accesses in the UBIFS filesystem
 (*) CRED: Wrap task credential accesses in the UDF filesystem
 (*) CRED: Wrap task credential accesses in the UFS filesystem
 (*) CRED: Wrap task credential accesses in the XFS filesystem
 (*) CRED: Wrap task credential accesses in the filesystem subsystem
 (*) CRED: Wrap task credential accesses in the SYSV IPC subsystem
 (*) CRED: Wrap task credential accesses in the AX25 protocol
 (*) CRED: Wrap task credential accesses in the IPv6 protocol
 (*) CRED: Wrap task credential accesses in the netrom protocol
 (*) CRED: Wrap task credential accesses in the ROSE protocol
 (*) CRED: Wrap task credential accesses in the SunRPC protocol
 (*) CRED: Wrap task credential accesses in the UNIX socket protocol
 (*) CRED: Wrap task credential accesses in the networking subsystem
 (*) CRED: Wrap task credential accesses in the key management code
 (*) CRED: Wrap task credential accesses in the capabilities code
 (*) CRED: Wrap task credential accesses in the core kernel

     Wrap accesses to most current->*[ug]id and some task->*[ug]id to use
     accessor macros to cut down the later patches and to hide RCU locking
     where it may be necessary later.

     Some of these patches are/may be upstream already.

 (*) KEYS: Disperse linux/key_ui.h

     Disperse the bits of <linux/key_ui.h> and delete the file.  The keyfs
     filesystem didn't happen, so this isn't necessary.

 (*) KEYS: Alter use of key instantiation link-to-keyring argument

     Alter the key instantiation code so as to remove the ability to directly
     access another process's credentials.  The contents of the keyrings
     themselves may still change, however.  I could implement a COW shadow of
     the subscribed keyrings, but I really don't think it's worth it.

 (*) CRED: Neuter sys_capset()

     Remove the ability of sys_capset() to affect other processes.

 (*) CRED: Constify the kernel_cap_t arguments to the capset LSM hooks

     As specified in the subject.

 (*) CRED: Separate task security context from task_struct

     Separate the credentials into cred struct, though that's still embedded in
     task_struct at this point.

 (*) CRED: Detach the credentials from task_struct

     Detach the struct cred from task_struct, though its lifetime still follows
     that of task_struct.

 (*) CRED: Wrap current->cred and a few other accessors
 (*) CRED: Use RCU to access another task's creds and to release a task's own creds
 (*) CRED: Wrap access to SELinux's task SID

     Wrap accesses to current's creds.  Wrap accesses to other tasks' creds to
     hide the RCU where possible.  Add in RCU directly where it is has to be.

 (*) CRED: Separate per-task-group keyrings from signal_struct

     Separate the process and session keyrings from signal_struct, and make
     them dangle shareably from struct cred instead.

 (*) CRED: Rename is_single_threaded() to is_wq_single_threaded()

     Rename is_single_threaded() to is_wq_single_threaded().

 (*) CRED: Make inode_has_perm() and file_has_perm() take a cred pointer

     As specified in the subject.

 (*) CRED: Pass credentials through dentry_open()

     Pass a cred pointer through dentry_open().

 (*) CRED: Inaugurate COW credentials

     Do the actual work of COW credentials.

 (*) CRED: Make execve() take advantage of copy-on-write credentials

     Make execve() take advantage of COW credentials.

 (*) CRED: Prettify commoncap.c

     Add comments in to commoncap.c and do some other stylistic cleanups.

 (*) CRED: Use creds in file structs

     Share the process's credentials with any files it opens.

 (*) CRED: Documentation

     Begin documenting the Linux credentials and the new API.

 (*) CRED: Differentiate objective and effective subjective credentials on a task

     Differentiate a task's objective and subjective credentials, thus allowing
     kernel services to override the latter.

 (*) CRED: Add a kernel_service object class to SELinux

     Add an SELinux class for kernel services and enumerate a couple of
     operations therein.

 (*) CRED: Allow kernel services to override LSM settings for task actions

     Provide helper functions for kernel services that want to override
     security details.

David
