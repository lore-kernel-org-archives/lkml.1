Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbXBHSSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbXBHSSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXBHSSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:18:18 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:50399 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752373AbXBHSSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:18:17 -0500
Subject: Re: [PATCH 2/2] sysctl: Restore the selinux path based label
	lookup for sysctls.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <m14ppwa64j.fsf@ebiederm.dsl.xmission.com>
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
	 <1170946871.11912.250.camel@moss-spartans.epoch.ncsc.mil>
	 <m14ppwa64j.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 08 Feb 2007 13:13:24 -0500
Message-Id: <1170958404.11912.313.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 10:53 -0700, Eric W. Biederman wrote:
> Stephen Smalley <sds@tycho.nsa.gov> writes:
> 
> >
> > Hmmm...turns out to not be quite enough, as the /proc/sys inodes aren't
> > truly private to the fs, so we can run into them in a variety of
> > security hooks beyond just the inode hooks, such as
> > security_file_permission (when reading and writing them via the vfs
> > helpers), security_sb_mount (when mounting other filesystems on
> > directories in proc like binfmt_misc), and deeper within the security
> > module itself (as in flush_unauthorized_files upon inheritance across
> > execve).  So I think we have to add an IS_PRIVATE() guard within
> > SELinux, as below.  Note however that the use of the private flag here
> > could be confusing, as these inodes are _not_ private to the fs, are
> > exposed to userspace, and security modules must implement the sysctl
> > hook to get any access control over them.
> 
> Agreed, the naming is confusing, and using private here doesn't quite
> feel right.
> 
> A practical question is: Will we ever encounter these inodes
> in the inode_init() path from superblock_init?

Possibly, during setup upon initial policy load (initiated by /sbin/init
these days) from selinux_complete_init, as early userspace may have
already been accessing them.

>   If all of the accesses
> that we care about go through inode_doinit_with_dentry we can just
> walk the dcache to get the names, and that should work for the normal
> proc case as well.

Walking the proc_dir_entry tree (or the ctl_table tree) is preferable as
it is a stable, user-immutable representation.  Also avoids taking the
dcache lock.

> A somewhat related question: How do you handle security labels for
> sysfs?  No fine grained security yet.

Right, they are all mapped to a single label presently.  I was thinking
of handling that from userspace after introducing a setxattr handler for
sysfs and a way to preserve the SID on the entry (likely caching it in
the sysfs_dirent and propagating that to the inode when the inode is
populated from the sysfs_dirent).  Then early userspace could walk sysfs
and apply finer-grained labeling from a configuration.

> If it doesn't look easy to solve this another way I will certainly
> go with marking the inodes private.

-- 
Stephen Smalley
National Security Agency

