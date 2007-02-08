Return-Path: <linux-kernel-owner+w=401wt.eu-S1422714AbXBHXDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714AbXBHXDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933346AbXBHXDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:03:34 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37158 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161390AbXBHXDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:03:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
Subject: [PATCH 4/5] selinux: Enhance selinux to always ignore private inodes.
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070128003549.2ca38dc8.akpm@osdl.org>
	<20070128093358.GA2071@elte.hu> <20070128095712.GA6485@elte.hu>
	<20070128100627.GA8416@elte.hu>
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
Date: Thu, 08 Feb 2007 16:02:58 -0700
In-Reply-To: <m1wt2s6yz6.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 08 Feb 2007 15:55:41 -0700")
Message-ID: <m1ps8k6yn1.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephen Smalley <sds@tycho.nsa.gov>

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

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

---
 security/selinux/hooks.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index de16b9f..ff9fccc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1077,6 +1077,9 @@ static int inode_has_perm(struct task_struct *tsk,
 	struct inode_security_struct *isec;
 	struct avc_audit_data ad;
 
+	if (unlikely (IS_PRIVATE (inode)))
+		return 0;
+
 	tsec = tsk->security;
 	isec = inode->i_security;
 
-- 

