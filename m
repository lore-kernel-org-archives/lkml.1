Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbXBHRxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbXBHRxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXBHRxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:53:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51375 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbXBHRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:53:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
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
	<m17iutmmwh.fsf@ebiederm.dsl.xmission.com>
	<1170946871.11912.250.camel@moss-spartans.epoch.ncsc.mil>
Date: Thu, 08 Feb 2007 10:53:00 -0700
In-Reply-To: <1170946871.11912.250.camel@moss-spartans.epoch.ncsc.mil>
	(Stephen Smalley's message of "Thu, 08 Feb 2007 10:01:11 -0500")
Message-ID: <m14ppwa64j.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> writes:

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

Agreed, the naming is confusing, and using private here doesn't quite
feel right.

A practical question is: Will we ever encounter these inodes
in the inode_init() path from superblock_init?  If all of the accesses
that we care about go through inode_doinit_with_dentry we can just
walk the dcache to get the names, and that should work for the normal
proc case as well.

A somewhat related question: How do you handle security labels for
sysfs?  No fine grained security yet.

If it doesn't look easy to solve this another way I will certainly
go with marking the inodes private.

Eric
