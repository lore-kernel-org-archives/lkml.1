Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbXFAH2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbXFAH2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbXFAH2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:28:32 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41089 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbXFAH2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:28:31 -0400
Message-ID: <465FCA79.70207@in.ibm.com>
Date: Fri, 01 Jun 2007 12:57:53 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@sgi.com, clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777 warning
Content-Type: multipart/mixed;
 boundary="------------050605060102060909010202"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050605060102060909010202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


 When number of tasks assigned to the specified cpuset becomes zero and
if we try to read tasks file, We get this warning on 2.6.22-rc3 kernel.

=======================================================
------------[ cut here ]------------
Badness at mm/slab.c:777
Call Trace:
[c000000071ebb4a0] [c00000000000eb30] .show_stack+0x68/0x1b0 (unreliable)
[c000000071ebb540] [c00000000021d7b0] .report_bug+0x94/0xe8
[c000000071ebb5d0] [c00000000048eb4c] __kprobes_text_start+0x164/0x5a0
[c000000071ebb650] [c000000000004a84] program_check_common+0x104/0x180
--- Exception: 700 at .__kmalloc+0x44/0x178
    LR = .cpuset_tasks_open+0x90/0x1e8
[c000000071ebb940] [c000000071ebb9e0] 0xc000000071ebb9e0 (unreliable)
[c000000071ebb9e0] [c0000000000812b0] .cpuset_tasks_open+0x90/0x1e8
[c000000071ebbaa0] [c0000000000811fc] .cpuset_file_open+0x70/0x94
[c000000071ebbb30] [c0000000000c2578] .__dentry_open+0x13c/0x278
[c000000071ebbbe0] [c0000000000c2828] .do_filp_open+0x50/0x70
[c000000071ebbd00] [c0000000000c28bc] .do_sys_open+0x74/0x130
[c000000071ebbdb0] [c000000000101108] .compat_sys_open+0x24/0x38
[c000000071ebbe30] [c00000000000862c] syscall_exit+0x0/0x40
=====================================================

This is because "npids"(represnets number of pids in that cpuset) in
"cpu_task_open" is zero and it tries allocate 0 bytes through kmalloc.

Below patch fixes this problem. Please let me know your comments on this.

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>



--------------050605060102060909010202
Content-Type: text/x-patch;
 name="cpuset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpuset.patch"

---
 kernel/cpuset.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.22-rc3/kernel/cpuset.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/cpuset.c
+++ linux-2.6.22-rc3/kernel/cpuset.c
@@ -1741,6 +1741,15 @@ static int cpuset_tasks_open(struct inod
 	 * show up until sometime later on.
 	 */
 	npids = atomic_read(&cs->count);
+	if (!npids) {
+		ctr->buf = kmalloc(2, GFP_KERNEL);
+		if (!ctr->buf)
+			goto err2;
+		ctr->bufsz = snprintf(ctr->buf, 2, " ");
+		file->private_data = ctr;
+		return 0;
+	}
+
 	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
 	if (!pidarray)
 		goto err1;

--------------050605060102060909010202--
