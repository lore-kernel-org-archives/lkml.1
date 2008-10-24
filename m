Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYJXD5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYJXD5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 23:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYJXD5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 23:57:41 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10999 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYJXD5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:57:40 -0400
From: Andrey Mirkin <major@openvz.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a process
Date: Fri, 24 Oct 2008 07:57:36 +0400
User-Agent: KMail/1.8.2
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Louis.Rilling@kerlabs.com,
       Cedric Le Goater <clg@fr.ibm.com>, Pavel Emelyanov <xemul@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org> <200810231300.50628.amirkin@parallels.com> <1224770277.12673.21.camel@nimitz>
In-Reply-To: <1224770277.12673.21.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240757.38012.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 17:57 Dave Hansen wrote:
> On Thu, 2008-10-23 at 13:00 +0400, Andrey Mirkin wrote:
> > > >>> It is not related to the freezer code actually.
> > > >>> That is needed to restart syscalls. Right now I don't have a code
> > > >>> in my patchset which restarts a syscall, but later I plan to add
> > > >>> it. In OpenVZ checkpointing we restart syscalls if process was
> > > >>> caught in syscall during checkpointing.
> > > >>
> > > >> Do you checkpoint uninterruptible syscalls as well? If only
> > > >> interruptible syscalls are checkpointed, I'd say that either this
> > > >> syscall uses ERESTARTSYS or ERESTART_RESTARTBLOCK, and then signal
> > > >> handling code already does the trick, or this syscall does not
> > > >> restart itself when interrupted, and well, this is life, userspace
> > > >> just sees -EINTR, which is allowed by the syscall spec.
> > > >> Actually this is how we checkpoint/migrate tasks in interruptible
> > > >> syscalls in Kerrighed and this works.
> > > >
> > > > We checkpoint only interruptible syscalls. Some syscalls do not
> > > > restart themself, that is why after restarting a process we restart
> > > > syscall to complete it.
> > >
> > > Can you please elaborate on this ?  I don't recall having had issues
> > > with that.
> >
> > Right now in 2.6.18 kernel we restarts in such a way pause,
> > rt_sigtimedwait and futex syscalls. Recently futex syscall was reworked
> > and we will not need such hooks for it.
>
> Could you elaborate on this a bit?
>
> If the futex syscall was reworked, perhaps we can do the same for
> rt_sigtimedwait() and get rid of this code completely.

Well, we can try to rework rt_sigtimedwait(), but we will still need this code 
in the future to restart pause syscall from kernel without returning to user 
space. Also this code will be needed to restore some complex states.
As concerns pause syscall I have already written to Louis about the problem we 
are trying to solve with this code. There is a gap when process will be in 
user space just before entering syscall again. At this time a signal can be 
delivered to process and it even can be handled. So, we will miss a signal 
which must interrupt pause syscall.

Andrey
