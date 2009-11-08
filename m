Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZKHMW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZKHMW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZKHMW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:22:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49534 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZKHMWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:24 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 04/23] sysctl: Neuter the generic sysctl strategy routines.
Date: Sun,  8 Nov 2009 04:21:51 -0800
Message-Id: <1257682930-31401-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a compatibility layer on top of /proc/sys
these routines are never called but are still put in sysctl
tables so I have reduced them to stubs until they can be
removed entirely.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sysctl.c |  198 -------------------------------------------------------
 1 files changed, 0 insertions(+), 198 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6a642d7..f82e955 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2835,201 +2835,6 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 
 #endif /* CONFIG_PROC_FS */
 
-
-#ifdef CONFIG_SYSCTL_SYSCALL
-/*
- * General sysctl support routines 
- */
-
-/* The generic sysctl data routine (used if no strategy routine supplied) */
-int sysctl_data(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	size_t len;
-
-	/* Get out of I don't have a variable */
-	if (!table->data || !table->maxlen)
-		return -ENOTDIR;
-
-	if (oldval && oldlenp) {
-		if (get_user(len, oldlenp))
-			return -EFAULT;
-		if (len) {
-			if (len > table->maxlen)
-				len = table->maxlen;
-			if (copy_to_user(oldval, table->data, len))
-				return -EFAULT;
-			if (put_user(len, oldlenp))
-				return -EFAULT;
-		}
-	}
-
-	if (newval && newlen) {
-		if (newlen > table->maxlen)
-			newlen = table->maxlen;
-
-		if (copy_from_user(table->data, newval, newlen))
-			return -EFAULT;
-	}
-	return 1;
-}
-
-/* The generic string strategy routine: */
-int sysctl_string(struct ctl_table *table,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen)
-{
-	if (!table->data || !table->maxlen) 
-		return -ENOTDIR;
-	
-	if (oldval && oldlenp) {
-		size_t bufsize;
-		if (get_user(bufsize, oldlenp))
-			return -EFAULT;
-		if (bufsize) {
-			size_t len = strlen(table->data), copied;
-
-			/* This shouldn't trigger for a well-formed sysctl */
-			if (len > table->maxlen)
-				len = table->maxlen;
-
-			/* Copy up to a max of bufsize-1 bytes of the string */
-			copied = (len >= bufsize) ? bufsize - 1 : len;
-
-			if (copy_to_user(oldval, table->data, copied) ||
-			    put_user(0, (char __user *)(oldval + copied)))
-				return -EFAULT;
-			if (put_user(len, oldlenp))
-				return -EFAULT;
-		}
-	}
-	if (newval && newlen) {
-		size_t len = newlen;
-		if (len > table->maxlen)
-			len = table->maxlen;
-		if(copy_from_user(table->data, newval, len))
-			return -EFAULT;
-		if (len == table->maxlen)
-			len--;
-		((char *) table->data)[len] = 0;
-	}
-	return 1;
-}
-
-/*
- * This function makes sure that all of the integers in the vector
- * are between the minimum and maximum values given in the arrays
- * table->extra1 and table->extra2, respectively.
- */
-int sysctl_intvec(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-
-	if (newval && newlen) {
-		int __user *vec = (int __user *) newval;
-		int *min = (int *) table->extra1;
-		int *max = (int *) table->extra2;
-		size_t length;
-		int i;
-
-		if (newlen % sizeof(int) != 0)
-			return -EINVAL;
-
-		if (!table->extra1 && !table->extra2)
-			return 0;
-
-		if (newlen > table->maxlen)
-			newlen = table->maxlen;
-		length = newlen / sizeof(int);
-
-		for (i = 0; i < length; i++) {
-			int value;
-			if (get_user(value, vec + i))
-				return -EFAULT;
-			if (min && value < min[i])
-				return -EINVAL;
-			if (max && value > max[i])
-				return -EINVAL;
-		}
-	}
-	return 0;
-}
-
-/* Strategy function to convert jiffies to seconds */ 
-int sysctl_jiffies(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	if (oldval && oldlenp) {
-		size_t olen;
-
-		if (get_user(olen, oldlenp))
-			return -EFAULT;
-		if (olen) {
-			int val;
-
-			if (olen < sizeof(int))
-				return -EINVAL;
-
-			val = *(int *)(table->data) / HZ;
-			if (put_user(val, (int __user *)oldval))
-				return -EFAULT;
-			if (put_user(sizeof(int), oldlenp))
-				return -EFAULT;
-		}
-	}
-	if (newval && newlen) { 
-		int new;
-		if (newlen != sizeof(int))
-			return -EINVAL; 
-		if (get_user(new, (int __user *)newval))
-			return -EFAULT;
-		*(int *)(table->data) = new*HZ; 
-	}
-	return 1;
-}
-
-/* Strategy function to convert jiffies to seconds */ 
-int sysctl_ms_jiffies(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	if (oldval && oldlenp) {
-		size_t olen;
-
-		if (get_user(olen, oldlenp))
-			return -EFAULT;
-		if (olen) {
-			int val;
-
-			if (olen < sizeof(int))
-				return -EINVAL;
-
-			val = jiffies_to_msecs(*(int *)(table->data));
-			if (put_user(val, (int __user *)oldval))
-				return -EFAULT;
-			if (put_user(sizeof(int), oldlenp))
-				return -EFAULT;
-		}
-	}
-	if (newval && newlen) { 
-		int new;
-		if (newlen != sizeof(int))
-			return -EINVAL; 
-		if (get_user(new, (int __user *)newval))
-			return -EFAULT;
-		*(int *)(table->data) = msecs_to_jiffies(new);
-	}
-	return 1;
-}
-
-
-
-#else /* CONFIG_SYSCTL_SYSCALL */
-
-
 int sysctl_data(struct ctl_table *table,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
@@ -3065,9 +2870,6 @@ int sysctl_ms_jiffies(struct ctl_table *table,
 	return -ENOSYS;
 }
 
-#endif /* CONFIG_SYSCTL_SYSCALL */
-
-
 /*
  * No sense putting this after each symbol definition, twice,
  * exception granted :-)
-- 
1.6.5.2.143.g8cc62

