Return-Path: <linux-kernel-owner+w=401wt.eu-S1422822AbXBHB6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422822AbXBHB6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422864AbXBHB6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:58:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34572 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422822AbXBHB6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:58:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       jmorris@namei.org
Subject: Re: [PATCH 2/2] sysctl: Restore the selinux path based label lookup for sysctls.
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070127172410.2b041952.akpm@osdl.org>
	<1169972718.17469.164.camel@localhost.localdomain>
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
Date: Wed, 07 Feb 2007 18:57:34 -0700
In-Reply-To: <1170882738.11912.144.camel@moss-spartans.epoch.ncsc.mil>
	(Stephen Smalley's message of "Wed, 07 Feb 2007 16:12:18 -0500")
Message-ID: <m17iutmmwh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> writes:

>
> One related but separate issue is that the /proc/sys inode labeling is
> also affected by the sysctl patch series.  Those inodes used to be
> labeled by selinux_proc_get_sid (from selinux_d_instantiate), but that
> no longer works, so they now fall back to the superblock SID (generic
> proc label).  That changes the inode permission checks on an attempt to
> access a /proc/sys node and will likely cause denials under current
> policy for confined domains since one wouldn't generally be writing to
> the generic proc label. If you always called sysctl_perm from the proc
> sysctl code, we could possibly dispense with inode permission checking
> on those inodes, e.g. marking them private.

Like this?

It seems a little weird but I'm happy with it if you are.

Eric

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index b9d59c0..7d6f7c7 100644
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
