Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXKOJi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXKOJi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 04:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbXKOJit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 04:38:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:16226 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbXKOJir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 04:38:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=i2M+ZL4Mn4e1dKML52fYu+B0KV9QoQkTWjH2AmW2TEfXZdmMAt/kZZR1Pw/9HJN4AHyWw9mbRi3BBWex/DUNF+kR0boDAIdAprKFrVNtrNPmloY8yFdg6QEY7m+LdhEqF0Py345iW9Vje+FlNketG8vw2uaGAEExFxoJNsXX14Y=
Message-ID: <473C0594.6030304@gmail.com>
Date: Thu, 15 Nov 2007 09:38:44 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: kernel-janitors@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       joel.becker@oracle.com
Subject: [PATCH] fs: remove dead config CONFIG_HAS_COMPAT_EPOLL_EVENT symbol
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove dead config CONFIG_HAS_COMPAT_EPOLL_EVENT symbol
Signed-off-by: Jiri Olsa <olsajiri@gmail.com>

---
 fs/compat.c            |   49 ------------------------------------------------
 include/linux/compat.h |    8 -------
 2 files changed, 0 insertions(+), 57 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 15078ce..009109d 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -2087,51 +2087,6 @@ long asmlinkage compat_sys_nfsservctl(int cmd, void *notused, void *notused2)
 
 #ifdef CONFIG_EPOLL
 
-#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
-asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
-			struct compat_epoll_event __user *event)
-{
-	long err = 0;
-	struct compat_epoll_event user;
-	struct epoll_event __user *kernel = NULL;
-
-	if (event) {
-		if (copy_from_user(&user, event, sizeof(user)))
-			return -EFAULT;
-		kernel = compat_alloc_user_space(sizeof(struct epoll_event));
-		err |= __put_user(user.events, &kernel->events);
-		err |= __put_user(user.data, &kernel->data);
-	}
-
-	return err ? err : sys_epoll_ctl(epfd, op, fd, kernel);
-}
-
-
-asmlinkage long compat_sys_epoll_wait(int epfd,
-			struct compat_epoll_event __user *events,
-			int maxevents, int timeout)
-{
-	long i, ret, err = 0;
-	struct epoll_event __user *kbuf;
-	struct epoll_event ev;
-
-	if ((maxevents <= 0) ||
-			(maxevents > (INT_MAX / sizeof(struct epoll_event))))
-		return -EINVAL;
-	kbuf = compat_alloc_user_space(sizeof(struct epoll_event) * maxevents);
-	ret = sys_epoll_wait(epfd, kbuf, maxevents, timeout);
-	for (i = 0; i < ret; i++) {
-		err |= __get_user(ev.events, &kbuf[i].events);
-		err |= __get_user(ev.data, &kbuf[i].data);
-		err |= __put_user(ev.events, &events->events);
-		err |= __put_user_unaligned(ev.data, &events->data);
-		events++;
-	}
-
-	return err ? -EFAULT: ret;
-}
-#endif	/* CONFIG_HAS_COMPAT_EPOLL_EVENT */
-
 #ifdef TIF_RESTORE_SIGMASK
 asmlinkage long compat_sys_epoll_pwait(int epfd,
 			struct compat_epoll_event __user *events,
@@ -2157,11 +2112,7 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
-	err = compat_sys_epoll_wait(epfd, events, maxevents, timeout);
-#else
 	err = sys_epoll_wait(epfd, events, maxevents, timeout);
-#endif
 
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 0e69d2c..27143be 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -242,16 +242,8 @@ asmlinkage long compat_sys_migrate_pages(compat_pid_t pid,
 /*
  * epoll (fs/eventpoll.c) compat bits follow ...
  */
-#ifndef CONFIG_HAS_COMPAT_EPOLL_EVENT
 struct epoll_event;
 #define compat_epoll_event	epoll_event
-#else
-asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
-			struct compat_epoll_event __user *event);
-asmlinkage long compat_sys_epoll_wait(int epfd,
-			struct compat_epoll_event __user *events,
-			int maxevents, int timeout);
-#endif
 asmlinkage long compat_sys_epoll_pwait(int epfd,
 			struct compat_epoll_event __user *events,
 			int maxevents, int timeout,
