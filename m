Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZFSVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZFSVdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbZFSVc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:32:59 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41956 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbZFSVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:32:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 19 Jun 2009 14:26:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3C004B.8010706@novell.com>
Message-ID: <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Fri, 19 Jun 2009, Gregory Haskins wrote:
> >
> >   
> >> eventfd currently emits a POLLHUP wakeup on f_ops->release() to generate a
> >> notifier->release() callback.  This lets notification clients know if
> >> the eventfd is about to go away and is very useful particularly for
> >> in-kernel clients.  However, as it stands today it is not possible to
> >> use the notification API in a race-free way.  This patch adds some
> >> additional logic to the notification subsystem to rectify this problem.
> >>
> >> Background:
> >> -----------------------
> >> Eventfd currently only has one reference count mechanism: fget/fput.  This
> >> in of itself is normally fine.  However, if a client expects to be
> >> notified if the eventfd is closed, it cannot hold a fget() reference
> >> itself or the underlying f_ops->release() callback will never be invoked
> >> by VFS.  Therefore we have this somewhat unusual situation where we may
> >> hold a pointer to an eventfd object (by virtue of having a waiter registered
> >> in its wait-queue), but no reference.  This makes it nearly impossible to
> >> design a mutual decoupling algorithm: you cannot unhook one side from the
> >> other (or vice versa) without racing.
> >>     
> >
> > And why is that?
> >
> > struct xxx {
> > 	struct mutex mtx;
> > 	struct file *file;
> > 	...
> > };
> >
> > struct file *xxx_get_file(struct xxx *x) {
> > 	struct file *file;
> >
> > 	mutex_lock(&x->mtx);
> > 	file = x->file;
> > 	if (!file)
> > 		mutex_unlock(&x->mtx);
> > 	return file;
> > }
> >
> > void xxx_release_file(struct xxx *x) {
> > 	mutex_unlock(&x->mtx);
> > }
> >
> > void handle_POLLHUP(struct xxx *x) {
> > 	struct file *file;
> >
> > 	file = xxx_get_file(x);
> > 	if (file) {
> > 		unhook_waitqueue(file, ...);
> > 		x->file = NULL;
> > 		xxx_release_file(x);
> > 	}
> > }
> >
> >
> > Every time you need to "use" file, you call xxx_get_file(), and if you get 
> > NULL, it means it's gone and you handle it accordigly to your IRQ fd 
> > policies. As soon as you done with the file, you call xxx_release_file().
> > Replace "mtx" with the lock that fits your needs.
> >   
> 
> Consider what would happen if the f_ops->release() was preempted inside
> the wake_up_locked_polled() after it dereferenced the xxx from the list,
> but before it calls the callback(POLLHUP).  The xxx object, and/or the
> .text for the xxx object may be long gone by the time it comes back
> around.  Afaict, there is no way to guard against that scenario unless
> you do something like 2/3+3/3.  Or am I missing something?

Right. Don't you see an easier answer to that, instead of adding 300 lines 
of code to eventfd?
For example, turning wake_up_locked() into a nornal wake_up().



- Davide


