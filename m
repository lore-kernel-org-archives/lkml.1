Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYKZDpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYKZDpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYKZDo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:44:57 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36475 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYKZDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:44:56 -0500
Date: Tue, 25 Nov 2008 19:44:42 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 1/5] pid: Implement ns_of_pid
Message-ID: <20081126034442.GA23238@us.ibm.com>
References: <20081126034242.GA23120@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126034242.GA23120@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f3dd53544a8a7a1c43009f686cbadec561e5a489 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Mon, 10 Nov 2008 19:03:56 -0800
Subject: [PATCH 1/5] pid: Implement ns_of_pid

A current problem with the pid namespace is that it is
easy to do pid related work after exit_task_namespaces which
drops the nsproxy pointer.

However if we are doing pid namespace related work we are
always operating on some struct pid which retains the pid_namespace
pointer of the pid namespace it was allocated in.

So provide ns_of_pid which allows us to find the pid
namespace a pid was allocated in.

Using this we have the needed infrastructure to do pid
namespace related work at anytime we have a struct pid,
removing the chance of accidentally having a NULL
pointer dereference when accessing current->nsproxy.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/pid.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index d7e98ff..e9aec85 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -122,6 +122,17 @@ int next_pidmap(struct pid_namespace *pid_ns, int last);
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
 
+/* ns_of_pid returns the pid namespace in which the specified
+ * pid was allocated.
+ */
+static inline struct pid_namespace *ns_of_pid(struct pid *pid)
+{
+	struct pid_namespace *ns = NULL;
+	if (pid)
+		ns = pid->numbers[pid->level].ns;
+	return ns;
+}
+
 /*
  * the helpers to get the pid's id seen from different namespaces
  *
-- 
1.5.2.5

