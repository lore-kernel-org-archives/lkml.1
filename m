Return-Path: <linux-kernel-owner+w=401wt.eu-S1161439AbXBGV6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161439AbXBGV6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422778AbXBGV6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:58:42 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:56931 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161439AbXBGV6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:58:41 -0500
Subject: Re: [PATCH 2/2] sysctl: Restore the selinux path based label
	lookup for sysctls.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       jmorris@namei.org
In-Reply-To: <1170882738.11912.144.camel@moss-spartans.epoch.ncsc.mil>
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
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 07 Feb 2007 16:54:04 -0500
Message-Id: <1170885244.11912.168.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 16:12 -0500, Stephen Smalley wrote:
> On Wed, 2007-02-07 at 13:24 -0500, Stephen Smalley wrote:
> > On Tue, 2007-02-06 at 14:21 -0700, Eric W. Biederman wrote:
> > > This time instead of generating the generating the paths from proc_dir_entries
> > > generate the labels from the names in the sysctl ctl_tables themselves.  This
> > > removes an unnecessary layer of indirection, allows this to work even when
> > > procfs support is not compiled into the kernel, and especially allows it
> > > to work now that ctl_tables no longer have a proc_dir_entry field.
> > 
> > Thanks, looks sane.
> > 
> > > I continue passing "proc" into genfs sid although that is complete nonsense
> > > to allow existing selinux policies to work without modification.
> > > 
> > > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
> 
> Hmmm...but in testing the patch, I don't seem to (consistently) reach
> these checks when accessing via /proc/sys.  I see that you are caching
> the mode information and using it in some cases rather than calling the
> sysctl_perm function.

Actually, on further inspection, it looks like the real issue is the
"path" name generation; "cat /proc/sys/kernel/modprobe" yields a call to
security_genfs_sid() with just "/modprobe" rather than the expected
"/sys/kernel/modprobe".  Which likewise leaves us with the generic proc
label, just as with the inode permission check, so I end up seeing
checks against it only.

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

-- 
Stephen Smalley
National Security Agency

