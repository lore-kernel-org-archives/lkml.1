Return-Path: <linux-kernel-owner+w=401wt.eu-S933508AbZKYS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbZKYS7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933365AbZKYS7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:59:22 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49162 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098AbZKYS7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:59:19 -0500
Date: Wed, 25 Nov 2009 10:59:03 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, hpa@zytor.com,
       Nathan Lynch <nathanl@austin.ibm.com>, haveblue@us.ibm.com,
       Matt Helsley <matthltc@us.ibm.com>, arnd@arndb.de, roland@redhat.com,
       mtk.manpages@googlemail.com, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>
Subject: [v13][PATCH 06/12] Check invalid clone flags
Message-ID: <20091125185903.GG30858@us.ibm.com>
References: <20091125185543.GA30858@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125185543.GA30858@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 06/12] Check invalid clone flags

As pointed out by Oren Laadan, we want to ensure that unused bits in the
clone-flags remain unused and available for future. To ensure this, define
a mask of clone-flags and check the flags in the clone() system calls.

Changelog[v9]:
	- Include the unused clone-flag (CLONE_UNUSED) to VALID_CLONE_FLAGS
	  to avoid breaking any applications that may have set it. IOW, this
	  patch/check only applies to clone-flags bits 33 and higher.

Changelog[v8]:
	- New patch in set

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 include/linux/sched.h |   12 ++++++++++++
 kernel/fork.c         |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..a4d2c23 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -29,6 +29,18 @@
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
 #define CLONE_IO		0x80000000	/* Clone io context */
 
+#define CLONE_UNUSED        	0x00001000	/* Can be reused ? */
+
+#define VALID_CLONE_FLAGS	(CSIGNAL | CLONE_VM | CLONE_FS | CLONE_FILES |\
+				 CLONE_SIGHAND | CLONE_UNUSED | CLONE_PTRACE |\
+				 CLONE_VFORK  | CLONE_PARENT | CLONE_THREAD  |\
+				 CLONE_NEWNS  | CLONE_SYSVSEM | CLONE_SETTLS |\
+				 CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID  |\
+				 CLONE_DETACHED | CLONE_UNTRACED             |\
+				 CLONE_CHILD_SETTID | CLONE_STOPPED          |\
+				 CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER |\
+				 CLONE_NEWPID | CLONE_NEWNET | CLONE_IO)
+
 /*
  * Scheduling policies
  */
diff --git a/kernel/fork.c b/kernel/fork.c
index 72c76a1..317adcf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -982,6 +982,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
 
+	if (clone_flags & ~VALID_CLONE_FLAGS)
+		return ERR_PTR(-EINVAL);
+
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
 
-- 
1.6.0.4

