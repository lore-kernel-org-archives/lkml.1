Return-Path: <linux-kernel-owner+w=401wt.eu-S1750827AbXBRMUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827AbXBRMUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXBRMUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:20:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48510 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbXBRMUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:20:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Sun, 18 Feb 2007 13:12:21 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702181132.41264.rjw@sisk.pl> <20070218113259.GB100@tv-sign.ru>
In-Reply-To: <20070218113259.GB100@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181312.24633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 12:32, Oleg Nesterov wrote:
> On 02/18, Rafael J. Wysocki wrote:
> >
> > On Sunday, 18 February 2007 00:42, Oleg Nesterov wrote:
> > > On 02/17, Rafael J. Wysocki wrote:
> > > >
> > > > On Saturday, 17 February 2007 22:34, Oleg Nesterov wrote:
> > > > > 
> > > > > 	static inline int is_user_space(struct task_struct *p)
> > > > > 	{
> > > > > 		return p->mm && !(p->flags & PF_BORROWED_MM);
> > > > > 	}
> > > > > 
> > > > > This doesn't look right. First, an exiting task has ->mm == NULL after
> > > > > do_exit()->exit_mm(). Probably not a problem. However, PF_BORROWED_MM
> > > > > check is racy without task_lock(), so we can have a false positive as
> > > > > well. Is it ok? We can freeze aio_wq prematurely.
> > > > 
> > > > Right now aio_wq is not freezeable (PF_NOFREEZE).
> > > 
> > > Right now yes, but we are going to change this?
> > 
> > Well, is there any more reliable (and not racy) method of differentiating
> > between kernel threads and user space processes?
> 
> Not that I know of. At least, we can take task_lock() to really rule out
> kernel threads at FREEZER_USER_SPACE stage.

Something like this?

---
 kernel/power/process.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c
+++ linux-2.6.20-mm2/kernel/power/process.c
@@ -8,6 +8,7 @@
 
 #undef DEBUG
 
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
@@ -92,7 +93,12 @@ static void cancel_freezing(struct task_
 
 static inline int is_user_space(struct task_struct *p)
 {
-	return p->mm && !(p->flags & PF_BORROWED_MM);
+	int ret;
+
+	task_lock(p);
+	ret = p->mm && !(p->flags & PF_BORROWED_MM);
+	task_unlock(p);
+	return ret;
 }
 
 static unsigned int try_to_freeze_tasks(int freeze_user_space)
