Return-Path: <linux-kernel-owner+w=401wt.eu-S1423191AbXBHPGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423191AbXBHPGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423207AbXBHPGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:06:10 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:64247 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423191AbXBHPGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:06:09 -0500
Subject: Re: [PATCH 2/2] sysctl: Restore the selinux path based label
	lookup for sysctls.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
In-Reply-To: <m17iutmmwh.fsf@ebiederm.dsl.xmission.com>
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	 <20070127172410.2b041952.akpm@osdl.org>
	 <1169972718.17469.164.camel@localhost.localdomain>
	 <20070128003549.2ca38dc8.akpm@osdl.org> <20070128093358.GA2071@elte.hu>
	 <20070128095712.GA6485@elte.hu> <20070128100627.GA8416@elte.hu>
	 <20070128104548.a835d859.akpm@osdl.org>
	 <m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	 <1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
	 <m17iuvrnpk.fsf_-_@ebiederm.dsl.xmission.com>
	 <m13b5jrngt.fsf_-_@ebiederm.dsl.xmission.com>
	 <1170872654.11912.87.camel@moss-spartans.epoch.ncsc.mil>
	 <1170882738.11912.144.camel@moss-spartans.epoch.ncsc.mil>
	 <m17iutmmwh.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 08 Feb 2007 10:01:11 -0500
Message-Id: <1170946871.11912.250.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 18:57 -0700, Eric W. Biederman wrote:
> Stephen Smalley <sds@tycho.nsa.gov> writes:
> 
> >
> > One related but separate issue is that the /proc/sys inode labeling is
> > also affected by the sysctl patch series.  Those inodes used to be
> > labeled by selinux_proc_get_sid (from selinux_d_instantiate), but that
> > no longer works, so they now fall back to the superblock SID (generic
> > proc label).  That changes the inode permission checks on an attempt to
> > access a /proc/sys node and will likely cause denials under current
> > policy for confined domains since one wouldn't generally be writing to
> > the generic proc label. If you always called sysctl_perm from the proc
> > sysctl code, we could possibly dispense with inode permission checking
> > on those inodes, e.g. marking them private.
> 
> Like this?
> 
> It seems a little weird but I'm happy with it if you are.
> 
> Eric
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index b9d59c0..7d6f7c7 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -47,6 +47,7 @@ static struct inode *proc_sys_make_inode(struct inode *dir, struct ctl_table *ta
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
>  	inode->i_op = &proc_sys_inode_operations;
>  	inode->i_fop = &proc_sys_file_operations;
> +	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
>  	proc_sys_refresh_inode(inode, table);
>  out:
>  	return inode;

Hmmm...turns out to not be quite enough, as the /proc/sys inodes aren't
truly private to the fs, so we can run into them in a variety of
security hooks beyond just the inode hooks, such as
security_file_permission (when reading and writing them via the vfs
helpers), security_sb_mount (when mounting other filesystems on
directories in proc like binfmt_misc), and deeper within the security
module itself (as in flush_unauthorized_files upon inheritance across
execve).  So I think we have to add an IS_PRIVATE() guard within
SELinux, as below.  Note however that the use of the private flag here
could be confusing, as these inodes are _not_ private to the fs, are
exposed to userspace, and security modules must implement the sysctl
hook to get any access control over them.

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 65fb5e8..21bf2f0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1078,6 +1077,9 @@ static int inode_has_perm(struct task_st
 	struct inode_security_struct *isec;
 	struct avc_audit_data ad;
 
+	if (unlikely (IS_PRIVATE (inode)))
+		return 0;
+
 	tsec = tsk->security;
 	isec = inode->i_security;
 


-- 
Stephen Smalley
National Security Agency

