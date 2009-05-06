Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZEFB2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZEFB2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 21:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZEFB2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 21:28:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbZEFB2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 21:28:11 -0400
Date: Tue, 5 May 2009 18:24:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: chrisw@sous-sol.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
 exit_state instead of ->mm
Message-Id: <20090505182444.de4e0143.akpm@linux-foundation.org>
In-Reply-To: <20090505235736.GA7526@redhat.com>
References: <20090505224722.GA954@redhat.com>
	<20090505164733.54cd4ca4.akpm@linux-foundation.org>
	<20090505235736.GA7526@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 01:57:36 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/05, Andrew Morton wrote:
> >
> > On Wed, 6 May 2009 00:47:22 +0200
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > - Add PF_KTHREAD check to prevent attaching to the kernel thread
> > >   with a borrowed ->mm.
> > >
> > >   With or without this change we can race with daemonize() which
> > >   can set PF_KTHREAD or clear ->mm after ptrace_attach() does the
> > >   check, but this doesn't matter because reparent_to_kthreadd()
> > >   does ptrace_unlink().
> > >
> > > - Kill "!task->mm" check. We don't really care about ->mm != NULL,
> > >   and the task can call exit_mm() right after we drop task_lock().
> > >   What we need is to make sure we can't attach after exit_notify(),
> > >   check task->exit_state != 0 instead.
> > >
> >
> > These patches make a mess of utrace-core.patch.  Do we really want to do that?
> 
> Aaaah. Sorry! forgot to clearify...
> 
> These patches depend on
> 
> 	utrace-core-kill-exclude_xtrace-logic.patch
> 
> which hopefully can be folded into utrace-core.patch. In that case these
> changes do not depend on utrace, and they can go ahead of utrace.
> 

oic.  Strange that the patches applied, but utrace didn't apply on them.

I now have:

#
# ptrace
#
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
#
# utrace
#
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
utrace-core-kill-exclude_xtrace-logic.patch
#
ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
ptrace-do-not-use-task_lock-for-attach.patch
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch

