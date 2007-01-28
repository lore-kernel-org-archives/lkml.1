Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbXA1TWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbXA1TWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXA1TWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:22:43 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35211 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbXA1TWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:22:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       <linux-kernel@vger.kernel.org>, selinux@tycho.nsa.gov,
       sds@tycho.nsa.gov, jmorris@namei.org
Subject: [PATCH] sysctl selinux: Don't look at table->de
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070127172410.2b041952.akpm@osdl.org>
	<1169972718.17469.164.camel@localhost.localdomain>
	<20070128003549.2ca38dc8.akpm@osdl.org>
	<20070128093358.GA2071@elte.hu> <20070128095712.GA6485@elte.hu>
	<20070128100627.GA8416@elte.hu>
	<20070128104548.a835d859.akpm@osdl.org>
Date: Sun, 28 Jan 2007 12:21:24 -0700
In-Reply-To: <20070128104548.a835d859.akpm@osdl.org> (Andrew Morton's message
	of "Sun, 28 Jan 2007 10:45:48 -0800")
Message-ID: <m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With the sysctl cleanups sysctl is not really a part of proc
it just shows up there, and any path based approach will not
adequately describe the data as sysctl is essentially a
union mount underneath the covers.  As designed this mechanism
is viewer dependent so trying to be path based gets even worse.

However the permissions in sys_sysctl are currently immutable
and going through proc does not change the permission checks
when accessing sysctl.  So we might as well stick with the well
defined sysctl sid, as that is what selinux uses when proc is
not compiled in.

I.e.  I see no hope for salvaging the selinux_proc_get_sid call
in selinux_sysctl so I'm removing it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 security/selinux/hooks.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7b38372..3a36057 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1438,12 +1438,8 @@ static int selinux_sysctl(ctl_table *table, int op)
 
 	tsec = current->security;
 
-	rc = selinux_proc_get_sid(table->de, (op == 001) ?
-	                          SECCLASS_DIR : SECCLASS_FILE, &tsid);
-	if (rc) {
-		/* Default to the well-defined sysctl SID. */
-		tsid = SECINITSID_SYSCTL;
-	}
+	/* Use the well-defined sysctl SID. */
+	tsid = SECINITSID_SYSCTL;
 
 	/* The op values are "defined" in sysctl.c, thereby creating
 	 * a bad coupling between this module and sysctl.c */
-- 
1.4.4.1.g278f

