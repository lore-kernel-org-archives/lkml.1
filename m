Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab0BEKO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 05:14:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0BEKOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 05:14:54 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH] ima: avoid null pointer deref in ima_main.c
Date: Fri,  5 Feb 2010 18:14:41 +0800
Message-Id: <1265364881-8140-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've met following oops when kernel is running ltp test pipe07.
Which is trying to open pipes until EMFILE is returned.

BUG: unable to handle kernel NULL pointer dereference at 00000000000000ae
IP: [<ffffffff811f4c75>] ima_file_free+0x2e/0x26d
PGD 21d7cc067 PUD 21b20b067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/kernel/mm/ksm/run
CPU 2
Pid: 1581, comm: pipe07 Not tainted 2.6.33-rc6-git #59 0M860N/OptiPlex 760
RIP: 0010:[<ffffffff811f4c75>]  [<ffffffff811f4c75>] ima_file_free+0x2e/0x26d
RSP: 0018:ffff88021d0bbe38  EFLAGS: 00010202
RAX: ffff88022b550700 RBX: ffff88021ac4e8c0 RCX: ffff88021d776300
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88021ac4e8c0
RBP: ffff88021d0bbe88 R08: ffff88021d0bbe18 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021ac4e8c0
R13: 0000000000000000 R14: 00000000ffffffe8 R15: ffff88021d0bbf38
FS:  00007ff0f45ed700(0000) GS:ffff88002fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000ae CR3: 000000021d7ff000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pipe07 (pid: 1581, threadinfo ffff88021d0ba000, task ffff88021801a400)
Stack:
 ffff88021d0bbe68 ffff88002fbd25b0 0000041c1d0bbe68 ffff88021ac4e8c0
<0> ffff88021ac4ea00 ffff88021ac4e8c0 ffff88021ac4ea00 ffff88021ac4e8c0
<0> 00000000ffffffe8 ffff88021d0bbf38 ffff88021d0bbea8 ffffffff811dc02d
Call Trace:
 [<ffffffff811dc02d>] security_file_free+0x2d/0x31
 [<ffffffff81115dfe>] put_filp+0x22/0x36
 [<ffffffff8111baf8>] free_write_pipe+0x2f/0x33
 [<ffffffff8111c74d>] do_pipe_flags+0xdc/0xf6
 [<ffffffff8111c788>] sys_pipe2+0x21/0x63
 [<ffffffff8111c7da>] sys_pipe+0x10/0x12
 [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 0f 1f 44 00 00 83 3d 94 0c 61 01 00 48 8b 47 18 49 89 fc 4c 8b 68 50 0f 84 2d 02 00 00 <41> 0f b7 85 ae 00 00 00 25 00 f0 00 00 3d 00 80 00 00 0f 85 15
RIP  [<ffffffff811f4c75>] ima_file_free+0x2e/0x26d
 RSP <ffff88021d0bbe38>
CR2: 00000000000000ae

With this patch, my system doesn't oops with ltp testcase pipe06/pipe07.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serue@us.ibm.com>
---
 security/integrity/ima/ima_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index a89f44d..7ea9c22 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -141,7 +141,7 @@ void ima_file_free(struct file *file)
 	struct inode *inode = file->f_dentry->d_inode;
 	struct ima_iint_cache *iint;
 
-	if (!ima_initialized || !S_ISREG(inode->i_mode))
+	if (!ima_initialized || !inode || !S_ISREG(inode->i_mode))
 		return;
 	iint = ima_iint_find_get(inode);
 	if (!iint)
@@ -221,7 +221,7 @@ int ima_path_check(struct path *path, int mask)
 	struct file *file = NULL;
 	int rc;
 
-	if (!ima_initialized || !S_ISREG(inode->i_mode))
+	if (!ima_initialized || !inode || !S_ISREG(inode->i_mode))
 		return 0;
 	iint = ima_iint_find_get(inode);
 	if (!iint)
@@ -277,7 +277,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 	struct ima_iint_cache *iint;
 	int rc;
 
-	if (!ima_initialized || !S_ISREG(inode->i_mode))
+	if (!ima_initialized || !inode || !S_ISREG(inode->i_mode))
 		return 0;
 	iint = ima_iint_find_get(inode);
 	if (!iint)
@@ -311,7 +311,7 @@ void ima_counts_get(struct file *file)
 	struct inode *inode = file->f_dentry->d_inode;
 	struct ima_iint_cache *iint;
 
-	if (!ima_initialized || !S_ISREG(inode->i_mode))
+	if (!ima_initialized || !inode || !S_ISREG(inode->i_mode))
 		return;
 	iint = ima_iint_find_get(inode);
 	if (!iint)
-- 
1.6.5.2

