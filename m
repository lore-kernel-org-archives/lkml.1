Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbXIZDMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbXIZDMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXIZDMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:12:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXIZDMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:12:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=YikygbiwpyYsaoBW7NrYn9ZHL8M4e37aaMTpz09eperIfipBslrFK0b9P9CKamWae
	FIFQ2BmpcKBlYMer/t3Rg==
Message-ID: <46F9CE16.9080302@google.com>
Date: Tue, 25 Sep 2007 20:12:22 -0700
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Add cgroup write_uint() helper method
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add write_uint() helper method for cgroup subsystems

This helper is analagous to the read_uint() helper method for
reporting u64 values to userspace. It's designed to reduce the amount
of boilerplate requierd for creating new cgroup subsystems.

Signed-off-by: Paul Menage <menage@google.com>

---
 include/linux/cgroup.h |    8 ++++++++
 kernel/cgroup.c        |   42 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 4 deletions(-)

Index: container-2.6.23-rc8-mm1/include/linux/cgroup.h
===================================================================
--- container-2.6.23-rc8-mm1.orig/include/linux/cgroup.h
+++ container-2.6.23-rc8-mm1/include/linux/cgroup.h
@@ -196,6 +196,14 @@ struct cftype {
 	ssize_t (*write) (struct cgroup *cont, struct cftype *cft,
 			  struct file *file,
 			  const char __user *buf, size_t nbytes, loff_t *ppos);
+
+	/*
+	 * write_uint() is a shortcut for the common case of accepting
+	 * a single integer (as parsed by simple_strtoull) from
+	 * userspace. Use in place of write(); return 0 or error.
+	 */
+	int (*write_uint) (struct cgroup *cont, struct cftype *cft, u64 val);
+
 	int (*release) (struct inode *inode, struct file *file);
 };
 
Index: container-2.6.23-rc8-mm1/kernel/cgroup.c
===================================================================
--- container-2.6.23-rc8-mm1.orig/kernel/cgroup.c
+++ container-2.6.23-rc8-mm1/kernel/cgroup.c
@@ -1274,6 +1274,39 @@ enum cgroup_filetype {
 	FILE_RELEASE_AGENT,
 };
 
+static ssize_t cgroup_write_uint(struct cgroup *cont, struct cftype *cft,
+				 struct file *file,
+				 const char __user *userbuf,
+				 size_t nbytes, loff_t *unused_ppos)
+{
+	char buffer[64];
+	int retval = 0;
+	u64 val;
+	char *end;
+
+	if (!nbytes)
+		return -EINVAL;
+	if (nbytes >= sizeof(buffer))
+		return -E2BIG;
+	if (copy_from_user(buffer, userbuf, nbytes))
+		return -EFAULT;
+
+	buffer[nbytes] = 0;     /* nul-terminate */
+
+	/* strip newline if necessary */
+	if (nbytes && (buffer[nbytes-1] == '\n'))
+		buffer[nbytes-1] = 0;
+	val = simple_strtoull(buffer, &end, 0);
+	if (*end)
+		return -EINVAL;
+
+	/* Pass to subsystem */
+	retval = cft->write_uint(cont, cft, val);
+	if (!retval)
+		retval = nbytes;
+	return retval;
+}
+
 static ssize_t cgroup_common_file_write(struct cgroup *cont,
 					   struct cftype *cft,
 					   struct file *file,
@@ -1357,10 +1390,11 @@ static ssize_t cgroup_file_write(struct 
 
 	if (!cft)
 		return -ENODEV;
-	if (!cft->write)
-		return -EINVAL;
-
-	return cft->write(cont, cft, file, buf, nbytes, ppos);
+	if (cft->write)
+		return cft->write(cont, cft, file, buf, nbytes, ppos);
+	if (cft->write_uint)
+		return cgroup_write_uint(cont, cft, file, buf, nbytes, ppos);
+	return -EINVAL;
 }
 
 static ssize_t cgroup_read_uint(struct cgroup *cont, struct cftype *cft,
