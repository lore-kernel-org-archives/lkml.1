Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYHLNjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYHLNjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYHLNjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:39:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbYHLNjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:39:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] CRED: Introduce credential access wrappers
To: sfr@canb.auug.org.au, jmorris@namei.org, hch@infradead.org
Cc: dhowells@redhat.com, davem@davemloft.net, sfrench@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Tue, 12 Aug 2008 14:28:50 +0100
Message-ID: <20080812132850.5472.5131.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080812132840.5472.25856.stgit@warthog.procyon.org.uk>
References: <20080812132840.5472.25856.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches that are intended to introduce copy-on-write credentials for 2.6.28
require abstraction of access to some fields of the task structure,
particularly for the case of one task accessing another's credentials where RCU
will have to be observed.

Introduced here are trivial no-op versions of the desired accessors for current
and other tasks so that other subsystems can start to be converted over more
easily.

Wrappers are introduced into a new header (linux/cred.h) for UID/GID,
EUID/EGID, SUID/SGID, FSUID/FSGID, cap_effective and current's subscribed
user_struct.

linux/cred.h is #included from linux/sched.h.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/cred.h  |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h |    1 +
 2 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/cred.h


diff --git a/include/linux/cred.h b/include/linux/cred.h
new file mode 100644
index 0000000..b69222c
--- /dev/null
+++ b/include/linux/cred.h
@@ -0,0 +1,50 @@
+/* Credentials management
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_CRED_H
+#define _LINUX_CRED_H
+
+#define get_current_user()	(get_uid(current->user))
+
+#define task_uid(task)		((task)->uid)
+#define task_gid(task)		((task)->gid)
+#define task_euid(task)		((task)->euid)
+#define task_egid(task)		((task)->egid)
+
+#define current_uid()		(current->uid)
+#define current_gid()		(current->gid)
+#define current_euid()		(current->euid)
+#define current_egid()		(current->egid)
+#define current_suid()		(current->suid)
+#define current_sgid()		(current->sgid)
+#define current_fsuid()		(current->fsuid)
+#define current_fsgid()		(current->fsgid)
+#define current_cap()		(current->cap_effective)
+
+#define current_uid_gid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->uid;			\
+	*(_gid) = current->gid;			\
+} while(0)
+
+#define current_euid_egid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->euid;		\
+	*(_gid) = current->egid;		\
+} while(0)
+
+#define current_fsuid_fsgid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->fsuid;		\
+	*(_gid) = current->fsgid;		\
+} while(0)
+
+#endif /* _LINUX_CRED_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5270d44..9fd5694 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -87,6 +87,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/kobject.h>
 #include <linux/latencytop.h>
+#include <linux/cred.h>
 
 #include <asm/processor.h>
 

