Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYLaD2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYLaD2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 22:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYLaD20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 22:28:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58334 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbYLaD2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 22:28:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081230134248.GA30124@lst.de>
References: <20081230134248.GA30124@lst.de>
To: Christoph Hellwig <hch@lst.de>, jmorris@namei.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] CRED: Fix regression in cap_capable() as shown up by sys_faccessat()
Date: Wed, 31 Dec 2008 03:28:13 +0000
Message-ID: <24959.1230694093@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Since the merge of the current git tree into the xfs tree I see a
> regression in XFSQA 088:
> ...
> Given that XFS uses bog-standard generic_permission and the creds merge
> just happened I'd look for the cause there.

I've found the problem.  cap_capable() ignores the fact that if tsk is the
current process, then it should perhaps be using the effective/subjective
creds of the current process.  Instead it always uses the real/objective creds
of whatever process it is given.

I've attached a patch to fix it, but I think that this patch is probably the
wrong fix.  It attempts to divine whether the caller of cap_capable() meant to
use the objective or the subjective creds depending on whether the task
specified is current or not.

A better way to do things would be to differentiate capable() from
has_capability() all the way down to cap_capable().  Thus capable() would use
the subjective creds and has_capability() the objective.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix regression in cap_capable() as shown up by sys_faccessat()

Fix a regression in cap_capable() due to:

	commit 5ff7711e635b32f0a1e558227d030c7e45b4a465
	Author: David Howells <dhowells@redhat.com>
	Date:   Wed Dec 31 02:52:28 2008 +0000

	    CRED: Differentiate objective and effective subjective credentials on a task


The problem is that the above patch allows a process to have two sets of
credentials, and for the most part uses the subjective credentials when
accessing current's creds.

There is, however, one exception: cap_capable(), and thus capable(), uses the
real/objective credentials of the target task, whether or not it is the current
task.

Ordinarily this doesn't matter, since usually the two cred pointers in current
point to the same set of creds.  However, sys_faccessat() makes use of this
facility to override the credentials of the calling process to make its test,
without affecting the creds as seen from other processes.

One of the things sys_faccessat() does is to make an adjustment to the
effective capabilities mask, which cap_capable(), as it stands, then ignores.

The affected capability check is in generic_permission():

	if (!(mask & MAY_EXEC) || execute_ok(inode))
		if (capable(CAP_DAC_OVERRIDE))
			return 0;

This can be tested by compiling the following program from the XFS testsuite:

/* 
 *  t_access_root.c - trivial test program to show permission bug.
 *
 *  Written by Michael Kerrisk - copyright ownership not pursued.
 *  Sourced from: http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-10/6030.html  
 */
#include <limits.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>

#define UID 500
#define GID 100
#define PERM 0
#define TESTPATH "/tmp/t_access"

static void
errExit(char *msg)
{
    perror(msg);
    exit(EXIT_FAILURE);
} /* errExit */

static void
accessTest(char *file, int mask, char *mstr)
{
    printf("access(%s, %s) returns %d\n", file, mstr, access(file, mask));
} /* accessTest */

int
main(int argc, char *argv[])
{
    int fd, perm, uid, gid;
    char *testpath;
    char cmd[PATH_MAX + 20];

    testpath = (argc > 1) ? argv[1] : TESTPATH;
    perm = (argc > 2) ? strtoul(argv[2], NULL, 8) : PERM;
    uid = (argc > 3) ? atoi(argv[3]) : UID;
    gid = (argc > 4) ? atoi(argv[4]) : GID;

    unlink(testpath);

    fd = open(testpath, O_RDWR | O_CREAT, 0);
    if (fd == -1) errExit("open");

    if (fchown(fd, uid, gid) == -1) errExit("fchown");
    if (fchmod(fd, perm) == -1) errExit("fchmod");
    close(fd);

    snprintf(cmd, sizeof(cmd), "ls -l %s", testpath);
    system(cmd);

    if (seteuid(uid) == -1) errExit("seteuid");

    accessTest(testpath, 0, "0");
    accessTest(testpath, R_OK, "R_OK");
    accessTest(testpath, W_OK, "W_OK");
    accessTest(testpath, X_OK, "X_OK");
    accessTest(testpath, R_OK | W_OK, "R_OK | W_OK");
    accessTest(testpath, R_OK | X_OK, "R_OK | X_OK");
    accessTest(testpath, W_OK | X_OK, "W_OK | X_OK");
    accessTest(testpath, R_OK | W_OK | X_OK, "R_OK | W_OK | X_OK");

    exit(EXIT_SUCCESS);
} /* main */


This can be run against an Ext3 filesystem as well as against an XFS
filesystem.  If successful, it will show:

	[root@andromeda src]# ./t_access_root /tmp/xxx 0 4043 4043
	---------- 1 dhowells dhowells 0 2008-12-31 03:00 /tmp/xxx
	access(/tmp/xxx, 0) returns 0
	access(/tmp/xxx, R_OK) returns 0
	access(/tmp/xxx, W_OK) returns 0
	access(/tmp/xxx, X_OK) returns -1
	access(/tmp/xxx, R_OK | W_OK) returns 0
	access(/tmp/xxx, R_OK | X_OK) returns -1
	access(/tmp/xxx, W_OK | X_OK) returns -1
	access(/tmp/xxx, R_OK | W_OK | X_OK) returns -1

If unsuccessful, it will show:

	[root@andromeda src]# ./t_access_root /tmp/xxx 0 4043 4043
	---------- 1 dhowells dhowells 0 2008-12-31 02:56 /tmp/xxx
	access(/tmp/xxx, 0) returns 0
	access(/tmp/xxx, R_OK) returns -1
	access(/tmp/xxx, W_OK) returns -1
	access(/tmp/xxx, X_OK) returns -1
	access(/tmp/xxx, R_OK | W_OK) returns -1
	access(/tmp/xxx, R_OK | X_OK) returns -1
	access(/tmp/xxx, W_OK | X_OK) returns -1
	access(/tmp/xxx, R_OK | W_OK | X_OK) returns -1

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/commoncap.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/security/commoncap.c b/security/commoncap.c
index 19cb398..527218e 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -58,11 +58,16 @@ EXPORT_SYMBOL(cap_netlink_recv);
  */
 int cap_capable(struct task_struct *tsk, int cap, int audit)
 {
+	const struct cred *cred;
 	__u32 cap_raised;
 
 	/* Derived from include/linux/sched.h:capable. */
 	rcu_read_lock();
-	cap_raised = cap_raised(__task_cred(tsk)->cap_effective, cap);
+	if (tsk == current)
+		cred = current_cred();
+	else
+		cred = __task_cred(tsk);
+	cap_raised = cap_raised(cred->cap_effective, cap);
 	rcu_read_unlock();
 	return cap_raised ? 0 : -EPERM;
 }
