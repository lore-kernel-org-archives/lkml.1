Return-Path: <linux-kernel-owner+w=401wt.eu-S1030525AbYHFPtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525AbYHFPtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbYHFPhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:37:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbYHFPhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:37:37 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/24] Introduce credentials [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:14 +0100
Message-ID: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I've brought my patchset up to date with regards the recent merge melee and
built the patches on top of the next branch of James's security testing tree as
per his request.

A tarball of these patches can be retrieved from:

	http://people.redhat.com/~dhowells/cow-creds-7.tar.bz2

I've been testing these patches with the LTP syscalls and SELinux test scripts.

---
There are three parts to this project:

 (1) Implement COW credentials.

 (2) Pass the cred pointer through the vfs_xxx() functions and suchlike to all
     the places that need them.

 (3) Document it.

I'm intending to use this code to implement FS-Cache/CacheFiles, but it could
also be used for NFSD.


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

Most of the work is in patch 15 [Subject: CRED: Inaugurate COW credentials].
The description attached to this describes each of the logical changes in more
detail.  The preceding patches are preparation.


I'm working on (2) and (3).

These patches compile for make allmodconfig, and I've built and run a kernel on
my x86_64 test box with these patches applied.

The patches are:

 (*) 01-fix-PF_SUPERPRIV.diff

     Fix PF_SUPERPRIV handling.

 (*) 02-keys-disperse-key_ui_h.diff

     Disperse the bits of <linux/key_ui.h> and delete the file.  The keyfs
     filesystem didn't happen, so this isn't necessary.

 (*) 03-keys-alter-key-instantiation.diff

     Alter the key instantiation code so as to remove the ability to directly
     access another process's credentials.  The contents of the keyrings
     themselves may still change, however.  I could implement a COW shadow of
     the subscribed keyrings, but I really don't think it's worth it.

 (*) 04-cred-neuter-sys_capset.diff

     Remove the ability of sys_capset() to affect other processes.

 (*) 05-cred-constify-capset-hooks.diff

 (*) 06-cred-current-fsugid.diff
 (*) 07-cred-current-ugid-eugid.diff

     Wrap accesses to most current->*[ug]id and some task->*[ug]id to use
     accessor macros to cut down the later patches and to hide RCU locking
     where it may be necessary later.

 (*) 08-cred-separate-creds.diff

     Separate the credentials into cred struct, though that's still embedded in
     task_struct at this point.

 (*) 09-cred-detach-creds.diff

     Detach the struct cred from task_struct, though its lifetime still follows
     that of task_struct.

 (*) 10-cred-current-wrappers.diff
 (*) 11-cred-task-rcu-wrappers.diff
 (*) 12-cred-selinux-wrappers.diff

     Wrap accesses to current's creds.  Wrap accesses to other tasks' creds to
     hide the RCU where possible.  Add in RCU directly where it is has to be.

 (*) 13-cred-pertg-keyrings.diff

     Separate the process and session keyrings from signal_struct, and make
     them dangle shareably from struct cred instead.

 (*) 14-cred-is_single_threaded.diff

     Rename is_single_threaded() to is_wq_single_threaded().

 (*) 15-cred-selinux-xxx_has_perm.diff

     Make {file,inode}_has_perm() take a cred pointer.

 (*) 16-cred-dentry_open.diff

     Pass a cred pointer through dentry_open().

 (*) 17-cred-cow-creds.diff

     Do the actual work of COW credentials.

 (*) 18-cred-improve-execve.diff

     Make execve() take advantage of COW credentials.

 (*) 19-cred-prettify-commoncap.diff

     Add comments in to commoncap.c and do some other stylistic cleanups.

 (*) 20-cred-file-creds.diff

     Share the process's credentials with any files it opens.

 (*) 21-cred-document.diff

     Begin documenting the Linux credentials and the new API.

 (*) 22-cred-objsubj-split.diff

     Differentiate a task's objective and subjective credentials, thus allowing
     kernel services to override the latter.

 (*) 23-cred-kernel_service-class.diff

     Add an SELinux class for kernel services and enumerate a couple of
     operations therein.

 (*) 24-cred-kernel-service.diff

     Provide helper functions for kernel services that want to override
     security details.
