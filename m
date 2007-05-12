Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXELQam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXELQam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbXELQag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:30:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35514 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbXELQaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:30:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 18:35:20 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <200705121245.50715.rjw@sisk.pl> <20070512141813.GA98@tv-sign.ru>
In-Reply-To: <20070512141813.GA98@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705121835.21333.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 16:18, Oleg Nesterov wrote:
> On 05/12, Rafael J. Wysocki wrote:
> >
> > ... user space tasks that call deamonize() can also be frozen prematurely.
> > We didn't take this possibility into consideration before, which was obviously
> > wrong.
> 
> No, no, sorry for the confusion. User space tasks never call deamonize().
> 
> Kernel threads call daemonize, because when we are doing kernel_thread()
> on behalf of user-space task, the new kernel thread (child) shares its
> ->mm with the caller (parent). So it is considered as "is_user_space()"
> until it does daemonize().

Ah, I see.  We spawn a kernel thread from a code path that belongs to a
user space task and we need to call deamonize() to make it become a
'real' kernel thread.

Still, this means that is_user_space() may return 'true' for this thread
before it calls daemonize() and then the scenario described by me in the
previous message may occur.  It seems.

> Definitely, is_user_space() should have another name.

Well, I have no (better) idea ...
 
> When a user space task exits, it does exit_mm() and becomes "a kernel thread"
> from the freezer POV. In its current from, freezer can do nothing with this.
> The exiting task won't call try_to_freeze() after that, so try_to_freeze_tasks()
> will wait until it dissapears (actually, until it calls exit_notify(), note
> the ->exit_state check in freezeable()).
> 
> I do not think we can improve things if exit_mm() clears TIF_FREEZING.

I think we can avoid the above scenario (in which a kernel thread that has
called daemonize() "too late" ends up with TIF_FREEZE set and goes to
refrigerator() while we're freezing the user space).

> We should clear TIF_FREEZING when we set PF_NOFREEZE, I think. This was
> discussed before iirc, but I forgot the result.

It's in freezer-fix-pf_nofreeze-vs-freezeable-race.patch (appended for
convenience, white space may be broken).

Greetings,
Rafael

---
--- a/include/linux/freezer.h~freezer-fix-pf_nofreeze-vs-freezeable-race
+++ a/include/linux/freezer.h
@@ -63,8 +63,10 @@ static inline int thaw_process(struct ta
  */
 static inline void frozen_process(struct task_struct *p)
 {
-       p->flags |= PF_FROZEN;
-       wmb();
+       if (!unlikely(p->flags & PF_NOFREEZE)) {
+               p->flags |= PF_FROZEN;
+               wmb();
+       }
        clear_tsk_thread_flag(p, TIF_FREEZE);
 }
 
