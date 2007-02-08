Return-Path: <linux-kernel-owner+w=401wt.eu-S1423338AbXBHW4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423338AbXBHW4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423342AbXBHW4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:56:36 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35009 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423338AbXBHW4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:56:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
Subject: [PATCH 3/5] sysctl:  Fix the selinux_sysctl_get_sid
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
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
	<m14ppwa64j.fsf@ebiederm.dsl.xmission.com>
	<1170958404.11912.313.camel@moss-spartans.epoch.ncsc.mil>
	<m1mz3o8fbf.fsf@ebiederm.dsl.xmission.com>
	<m1abzo8dr0.fsf_-_@ebiederm.dsl.xmission.com>
	<m164ac8dnv.fsf_-_@ebiederm.dsl.xmission.com>
	<m11wl08dlg.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 08 Feb 2007 15:55:41 -0700
In-Reply-To: <m11wl08dlg.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 08 Feb 2007 15:54:35 -0700")
Message-ID: <m1wt2s6yz6.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I goofed and when reenabling the fine grained selinux labels for
sysctls and forgot to add the "/sys" prefix before consulting
the policy database.  When computing the same path using
proc_dir_entries we got the "/sys" for free as it was part
of the tree, but it isn't true for clt_table trees.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 security/selinux/hooks.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 47fb937..de16b9f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1445,6 +1445,12 @@ static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
 		path = end;
 		table = table->parent;
 	}
+	buflen -= 4;
+	if (buflen < 0)
+		goto out_free;
+	end -= 4;
+	memcpy(end, "/sys", 4);
+	path = end;
 	rc = security_genfs_sid("proc", path, tclass, sid);
 out_free:
 	free_page((unsigned long)buffer);
-- 
1.4.4.1.g278f

