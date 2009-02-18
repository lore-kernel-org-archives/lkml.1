Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbZBRWen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbZBRWen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbZBRWbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:31:53 -0500
Received: from kroah.org ([198.145.64.141]:34677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757780AbZBRWbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:52 -0500
Date: Wed, 18 Feb 2009 14:28:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Bastian Blank <bastian@waldi.eu.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>, Serge Hallyn <serue@us.ibm.com>
Subject: [patch 01/36] pid: implement ns_of_pid
Message-ID: <20090218222857.GB10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pid-implement-ns_of_pid.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

commit f9fb860f67b9542cd78d1558dec7058092b57d8e upstream.

A current problem with the pid namespace is that it is easy to do pid
related work after exit_task_namespaces which drops the nsproxy pointer.

However if we are doing pid namespace related work we are always operating
on some struct pid which retains the pid_namespace pointer of the pid
namespace it was allocated in.

So provide ns_of_pid which allows us to find the pid namespace a pid was
allocated in.

Using this we have the needed infrastructure to do pid namespace related
work at anytime we have a struct pid, removing the chance of accidentally
having a NULL pointer dereference when accessing current->nsproxy.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/pid.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -123,6 +123,24 @@ extern struct pid *alloc_pid(struct pid_
 extern void free_pid(struct pid *pid);
 
 /*
+ * ns_of_pid() returns the pid namespace in which the specified pid was
+ * allocated.
+ *
+ * NOTE:
+ * 	ns_of_pid() is expected to be called for a process (task) that has
+ * 	an attached 'struct pid' (see attach_pid(), detach_pid()) i.e @pid
+ * 	is expected to be non-NULL. If @pid is NULL, caller should handle
+ * 	the resulting NULL pid-ns.
+ */
+static inline struct pid_namespace *ns_of_pid(struct pid *pid)
+{
+	struct pid_namespace *ns = NULL;
+	if (pid)
+		ns = pid->numbers[pid->level].ns;
+	return ns;
+}
+
+/*
  * the helpers to get the pid's id seen from different namespaces
  *
  * pid_nr()    : global id, i.e. the id seen from the init namespace;

