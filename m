Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbXHOLlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbXHOLlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbXHOLlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:41:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbXHOLlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:41:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org, viro@ftp.linux.org.uk
cc: dhowells@redhat.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Adding a security parameter to VFS functions
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 15 Aug 2007 12:40:55 +0100
Message-ID: <29015.1187178055@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus, Al,

Would you object greatly to functions like vfs_mkdir() gaining a security
parameter?  What I'm thinking of is this:

	int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
		      struct security *security)

Where the security context is the state of the context at the time the call
was issued:

	struct security {
		uid_t			fsuid;
		git_t			fsgid;
		struct group_info	*group_info;
		void			*security;
		struct key		*session_keyring;
		struct key		*process_keyring;
		struct key		*thread_keyring;

And perhaps:

		struct audit_context	*audit_context;
		seccomp_t		seccomp;
	};

This would, for the most part, be a temporary affair, being set up by such as
sys_mkdir()/sys_mkdirat() from data held in task_struct.

This information would then be passed into the filesystem and LSM layers so
that files, directories, etc. can be created, opened, deleted, or otherwise
mangled based on these security items, rather than the one in whichever
task_struct is current.


The reason for doing this would be to support an act-as interface, so that
services such as nfsd and cachefiles could act with different security details
to the ones attached to the task.  This would have a couple of potential
benefits:

 (1) nfsd threads don't have to keep changing their security contexts.

 (2) cachefiles can act on behalf of a process without changing its security
     context.


Note that I/O operations such as read, write and ioctl would *not* be passed
this data as the file struct should contain the relevant security information.
Similarly, page I/O operations would also not need alteration as the VMA
covering the region points to a file struct, which holds the appropriate
security.

David
