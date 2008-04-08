Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYDHWB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYDHWB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 18:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYDHWBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 18:01:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47454 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYDHWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 18:01:15 -0400
Date: Tue, 8 Apr 2008 15:00:00 -0700
From: sukadev@us.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Containers <containers@lists.osdl.org>, clg@fr.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: [RFC][PATCH 5/7]: Implement get_pts_ns() and put_pts_ns()
Message-ID: <20080408220000.GE9034@us.ibm.com>
References: <20080408215333.GA8799@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408215333.GA8799@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [RFC][PATCH 5/7]: Implement get_pts_ns() and put_pts_ns()

Implement get_pts_ns() and put_pts_ns() interfaces.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 include/linux/devpts_fs.h |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

Index: 2.6.25-rc8-mm1/include/linux/devpts_fs.h
===================================================================
--- 2.6.25-rc8-mm1.orig/include/linux/devpts_fs.h	2008-04-08 09:18:23.000000000 -0700
+++ 2.6.25-rc8-mm1/include/linux/devpts_fs.h	2008-04-08 13:36:31.000000000 -0700
@@ -27,13 +27,26 @@ struct pts_namespace {
 extern struct pts_namespace init_pts_ns;
 
 #ifdef CONFIG_UNIX98_PTYS
-
 int devpts_new_index(void);
 void devpts_kill_index(int idx);
 int devpts_pty_new(struct tty_struct *tty);      /* mknod in devpts */
 struct tty_struct *devpts_get_tty(int number);	 /* get tty structure */
 void devpts_pty_kill(int number);		 /* unlink */
 
+static inline void free_pts_ns(struct kref *ns_kref) { }
+
+static inline struct pts_namespace *get_pts_ns(struct pts_namespace *ns)
+{
+	if (ns && (ns != &init_pts_ns))
+		kref_get(&ns->kref);
+	return ns;
+}
+static inline void put_pts_ns(struct pts_namespace *ns)
+{
+	if (ns && (ns != &init_pts_ns))
+		kref_put(&ns->kref, free_pts_ns);
+}
+
 #else
 
 /* Dummy stubs in the no-pty case */
@@ -43,6 +56,12 @@ static inline int devpts_pty_new(struct 
 static inline struct tty_struct *devpts_get_tty(int number) { return NULL; }
 static inline void devpts_pty_kill(int number) { }
 
+static inline struct pts_namespace *get_pts_ns(struct pts_namespace *ns)
+{
+	return &init_pts_ns;
+}
+
+static inline void put_pts_ns(struct pts_namespace *ns) { }
 #endif
 
 
