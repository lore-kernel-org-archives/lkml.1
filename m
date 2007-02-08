Return-Path: <linux-kernel-owner+w=401wt.eu-S965743AbXBHXFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965743AbXBHXFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933359AbXBHXFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:05:05 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37166 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbXBHXFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:05:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
Subject: [PATCH 5/5] sysctl:  Hide the sysctl proc inodes from selinux.
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
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
	<m1ps8k6yn1.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 08 Feb 2007 16:04:20 -0700
In-Reply-To: <m1ps8k6yn1.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 08 Feb 2007 16:02:58 -0700")
Message-ID: <m1lkj86ykr.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since the security checks are applied on each read and write of a
sysctl file, just like they are applied when calling sys_sysctl, they
are redundant on the standard VFS constructs.  Since it is difficult
to compute the security labels on the standard VFS constructs we just
mark the sysctl inodes in proc private so selinux won't even bother
with them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index bb16a1e..20e8cbb 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -47,6 +47,7 @@ static struct inode *proc_sys_make_inode(struct inode *dir, struct ctl_table *ta
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode->i_op = &proc_sys_inode_operations;
 	inode->i_fop = &proc_sys_file_operations;
+	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
 	proc_sys_refresh_inode(inode, table);
 out:
 	return inode;
-- 
1.4.4.1.g278f

