Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbYBGOg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbYBGOg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbYBGOgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:36:18 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40963 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYBGOgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:36:16 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, serue@us.ibm.com, akpm@linux-foundation.org,
       hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080207140521.GC4058@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 07/10] unprivileged mounts: add sysctl tunable for
	"safe" property
References: <20080205213616.343721693@szeredi.hu> <20080205213705.120219893@szeredi.hu> <20080206202110.GA20528@sergelap.ibm.com> <E1JMrXw-0000qq-O9@pomaz-ex.szeredi.hu> <20080206224527.GB24246@sergelap.austin.ibm.com> <E1JN1p3-0001zF-4l@pomaz-ex.szeredi.hu> <20080207140521.GC4058@sergelap.austin.ibm.com>
Message-Id: <E1JN7r7-0002sE-Be@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 07 Feb 2008 15:36:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Maybe sysctls just need to check capabilities, instead of uids.  I
> > > > think that would make a lot of sense anyway.
> > > 
> > > Would it be as simple as tagging the inodes with capability sets?  One
> > > set for writing, or one each for reading and writing?
> > 
> > Yes, or something even simpler, like mapping the owner permission bits
> > to CAP_SYS_ADMIN.  There seem to be very few different permissions
> > under /proc/sys:
> > 
> > --w-------
> > -r--r--r--
> > -rw-------
> > -rw-r--r--
> > 
> > As long as the group and other bits are always the same, and we accept
> > that the owner bits really mean CAP_SYS_ADMIN and not something else,
> 
> But I would assume some things under /proc/sys/net/ipv4 or
> /proc/sys/net/ath0 require CAP_NET_ADMIN rather than CAP_SYS_ADMIN?

I guess so.  I'm not very familiar with the different capabilities :)

How about this patch then: a hybrid solution between just relying on
permission bits, and specifying separate capability sets for read and
write in addition to the permission bits.

Untested, the 'cap' field obviously still needs to be filled in where
appropriate.

Miklos
----

Index: linux/include/linux/sysctl.h
===================================================================
--- linux.orig/include/linux/sysctl.h	2008-02-04 12:29:01.000000000 +0100
+++ linux/include/linux/sysctl.h	2008-02-07 15:19:06.000000000 +0100
@@ -1041,6 +1041,7 @@ struct ctl_table 
 	void *data;
 	int maxlen;
 	mode_t mode;
+	int cap;			/* Capability needed to read/write */
 	struct ctl_table *child;
 	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c	2008-02-05 22:17:05.000000000 +0100
+++ linux/kernel/sysctl.c	2008-02-07 15:30:45.000000000 +0100
@@ -1527,14 +1527,26 @@ out:
  * some sysctl variables are readonly even to root.
  */
 
-static int test_perm(int mode, int op)
+static int test_perm(struct ctl_table *table, int op)
 {
-	if (!current->euid)
-		mode >>= 6;
-	else if (in_egroup_p(0))
-		mode >>= 3;
+	int cap = table->cap;
+	mode_t mode = table->mode;
+
+	if (!cap)
+		cap = CAP_SYS_ADMIN;
+
+	if ((op & MAY_READ) && !(mode & S_IRUGO))
+		return -EACCES;
+
+	if ((op & MAY_WRITE) && !(mode & S_IWUGO))
+		return -EACCES;
+
+	if (capable(cap))
+		return 0;
+
 	if ((mode & op & 0007) == op)
 		return 0;
+
 	return -EACCES;
 }
 
@@ -1544,7 +1556,7 @@ int sysctl_perm(struct ctl_table *table,
 	error = security_sysctl(table, op);
 	if (error)
 		return error;
-	return test_perm(table->mode, op);
+	return test_perm(table, op);
 }
 
 #ifdef CONFIG_SYSCTL_SYSCALL
