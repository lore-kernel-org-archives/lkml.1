Return-Path: <linux-kernel-owner+w=401wt.eu-S1946417AbXBIMay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946417AbXBIMay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946421AbXBIMay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:30:54 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:44212 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946417AbXBIMax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:30:53 -0500
Subject: Re: [PATCH 4/5] selinux: Enhance selinux to always ignore private
	inodes.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
In-Reply-To: <m1ps8k6yn1.fsf_-_@ebiederm.dsl.xmission.com>
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
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
	 <1170958404.11912.313.camel@moss-spartans.epoch.ncsc.mil>
	 <m1mz3o8fbf.fsf@ebiederm.dsl.xmission.com>
	 <m1abzo8dr0.fsf_-_@ebiederm.dsl.xmission.com>
	 <m164ac8dnv.fsf_-_@ebiederm.dsl.xmission.com>
	 <m11wl08dlg.fsf_-_@ebiederm.dsl.xmission.com>
	 <m1wt2s6yz6.fsf_-_@ebiederm.dsl.xmission.com>
	 <m1ps8k6yn1.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 09 Feb 2007 07:26:17 -0500
Message-Id: <1171023977.11912.350.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 16:02 -0700, Eric W. Biederman wrote:
> From: Stephen Smalley <sds@tycho.nsa.gov>
> 
> Hmmm...turns out to not be quite enough, as the /proc/sys inodes aren't
> truly private to the fs, so we can run into them in a variety of
> security hooks beyond just the inode hooks, such as
> security_file_permission (when reading and writing them via the vfs
> helpers), security_sb_mount (when mounting other filesystems on
> directories in proc like binfmt_misc), and deeper within the security
> module itself (as in flush_unauthorized_files upon inheritance across
> execve).  So I think we have to add an IS_PRIVATE() guard within
> SELinux, as below.  Note however that the use of the private flag here
> could be confusing, as these inodes are _not_ private to the fs, are
> exposed to userspace, and security modules must implement the sysctl
> hook to get any access control over them.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> 
> ---
>  security/selinux/hooks.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index de16b9f..ff9fccc 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1077,6 +1077,9 @@ static int inode_has_perm(struct task_struct *tsk,
>  	struct inode_security_struct *isec;
>  	struct avc_audit_data ad;
>  
> +	if (unlikely (IS_PRIVATE (inode)))
> +		return 0;
> +
>  	tsec = tsk->security;
>  	isec = inode->i_security;
>  
-- 
Stephen Smalley
National Security Agency

