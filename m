Return-Path: <linux-kernel-owner+w=401wt.eu-S1765570AbXHOQXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765570AbXHOQXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759843AbXHOQX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:23:26 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:46514 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756986AbXHOQXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:23:24 -0400
X-YMail-OSG: aB.oB84VM1nfTclOVuaHkwpkPVOKaialHf3n9DaU9tYo.By7wRurkjVWKMzbCxL_PQ--
X-RocketYMMF: rancidfat
Date: Wed, 15 Aug 2007 09:23:22 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Adding a security parameter to VFS functions
To: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <29015.1187178055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <45343.31878.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> 
> Hi Linus, Al,
> 
> Would you object greatly to functions like vfs_mkdir() gaining a security
> parameter?

Could you describe how this compares to the proposal that the
AppArmor developers suggested recently? I expect that we can 
reduce the amount of discussion required, and maybe avoid some
confusion if you could do that.

Thank you.

> What I'm thinking of is this:
> 
> 	int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
> 		      struct security *security)
> 
> Where the security context is the state of the context at the time the call
> was issued:
> 
> 	struct security {
> 		uid_t			fsuid;
> 		git_t			fsgid;
> 		struct group_info	*group_info;
> 		void			*security;
> 		struct key		*session_keyring;
> 		struct key		*process_keyring;
> 		struct key		*thread_keyring;
> 
> And perhaps:
> 
> 		struct audit_context	*audit_context;
> 		seccomp_t		seccomp;
> 	};
> 
> This would, for the most part, be a temporary affair, being set up by such as
> sys_mkdir()/sys_mkdirat() from data held in task_struct.
> 
> This information would then be passed into the filesystem and LSM layers so
> that files, directories, etc. can be created, opened, deleted, or otherwise
> mangled based on these security items, rather than the one in whichever
> task_struct is current.
> 
> 
> The reason for doing this would be to support an act-as interface, so that
> services such as nfsd and cachefiles could act with different security
> details
> to the ones attached to the task.  This would have a couple of potential
> benefits:
> 
>  (1) nfsd threads don't have to keep changing their security contexts.
> 
>  (2) cachefiles can act on behalf of a process without changing its security
>      context.
> 
> 
> Note that I/O operations such as read, write and ioctl would *not* be passed
> this data as the file struct should contain the relevant security
> information.
> Similarly, page I/O operations would also not need alteration as the VMA
> covering the region points to a file struct, which holds the appropriate
> security.
> 
> David
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
