Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbXLOCgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbXLOCgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 21:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXLOCg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 21:36:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbXLOCg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 21:36:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Linux 2.6.23.10
Date: Sat, 15 Dec 2007 03:55:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
References: <20071214194952.GA15765@kroah.com> <47633028.20503@redhat.com> <200712150315.22568.rjw@sisk.pl>
In-Reply-To: <200712150315.22568.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712150355.41763.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 of December 2007, Rafael J. Wysocki wrote:
> On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> > On 12/14/2007 08:52 PM, Rafael J. Wysocki wrote:
> > > On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> > >> On 12/14/2007 02:49 PM, Greg Kroah-Hartman wrote:
> > >>>       Freezer: Fix APM emulation breakage
> > >> drivers/char/apm-emulation.c: In function 'apm_ioctl':
> > >> drivers/char/apm-emulation.c:370: error: implicit declaration of function 'wait_event_freezable'
> > >> make[2]: *** [drivers/char/apm-emulation.o] Error 1
> > >> make[1]: *** [drivers/char] Error 2
> > > 
> > > This is my fault, sorry.
> > > 
> > > I though the 2.6.24-rc fix would be suitable for 2.6.23.x, but that's not the
> > > case.
> > > 
> > > Greg, please revert the "Freezer: Fix APM emulation breakage" patch, I'll
> > > prepare a separate fix suitable for -stable.
> > > 
> > 
> > It works if you add the changes to freezer.h made in commit
> > e42837bcd35b75bb59ae5d3e62f87be1aeeb05c3
> 
> Yes, exactly, but a new patch is needed anyway.
> 
> Hmm, perhaps it's better to add a new patch on top of "Freezer: Fix APM
> emulation breakage"?  Would that be preferred?

For convenience, below is the patch that should fix the breakage when applied
on top of the "Freezer: Fix APM emulation breakage" patch.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

This patch is needed to fix the compilation breakage in the
APM emulation driver in 2.6.23.10 caused by the
"Freezer: Fix APM emulation breakage" patch.

The changes introduced by this patch are already in the
mainline (commit e42837bcd35b75bb59ae5d3e62f87be1aeeb05c3).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

Index: linux-2.6.23.y/include/linux/freezer.h
===================================================================
--- linux-2.6.23.y.orig/include/linux/freezer.h
+++ linux-2.6.23.y/include/linux/freezer.h
@@ -4,6 +4,7 @@
 #define FREEZER_H_INCLUDED
 
 #include <linux/sched.h>
+#include <linux/wait.h>
 
 #ifdef CONFIG_PM_SLEEP
 /*
@@ -126,6 +127,36 @@ static inline void set_freezable(void)
 	current->flags &= ~PF_NOFREEZE;
 }
 
+/*
+ * Freezer-friendly wrappers around wait_event_interruptible() and
+ * wait_event_interruptible_timeout(), originally defined in <linux/wait.h>
+ */
+
+#define wait_event_freezable(wq, condition)				\
+({									\
+	int __retval;							\
+	do {								\
+		__retval = wait_event_interruptible(wq, 		\
+				(condition) || freezing(current));	\
+		if (__retval && !freezing(current))			\
+			break;						\
+		else if (!(condition))					\
+			__retval = -ERESTARTSYS;			\
+	} while (try_to_freeze());					\
+	__retval;							\
+})
+
+
+#define wait_event_freezable_timeout(wq, condition, timeout)		\
+({									\
+	long __retval = timeout;					\
+	do {								\
+		__retval = wait_event_interruptible_timeout(wq,		\
+				(condition) || freezing(current),	\
+				__retval); 				\
+	} while (try_to_freeze());					\
+	__retval;							\
+})
 #else /* !CONFIG_PM_SLEEP */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
@@ -143,6 +174,13 @@ static inline void freezer_do_not_count(
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
+
+#define wait_event_freezable(wq, condition)				\
+		wait_event_interruptible(wq, condition)
+
+#define wait_event_freezable_timeout(wq, condition, timeout)		\
+		wait_event_interruptible_timeout(wq, condition, timeout)
+
 #endif /* !CONFIG_PM_SLEEP */
 
 #endif	/* FREEZER_H_INCLUDED */
