Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0BCWwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:52:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38086 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab0BCWwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OOpl5aujuWoKbS7XWGIEH9/wAzXCjuSJfvlSDTrFovgwl4nCYiPqXmm+jznivtsGaS
         dFbQ/s0IimuAXpL0UwOnomKzyloT8MnxWbQQUDt4IaW5tIofNxVDc00i2NQKqZHIBojn
         sbtzcx0Cr4z6b5y93XGENo7V9Hvk46qSL+P4c=
Date: Wed, 3 Feb 2010 23:52:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: reiserfs deadlock
Message-ID: <20100203225232.GI5068@nowhere>
References: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com> <a4423d671002031108x6c2682edl9a147c35ac9c2815@mail.gmail.com> <20100203202909.GA5068@nowhere> <a4423d671002031443q283bab49wd15cd4de556d9557@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d671002031443q283bab49wd15cd4de556d9557@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 01:43:53AM +0300, Alexander Beregalov wrote:
> On 3 February 2010 23:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Wed, Feb 03, 2010 at 10:08:57PM +0300, Alexander Beregalov wrote:
> >> On 3 February 2010 22:03, Alexander Beregalov <a.beregalov@gmail.com> wrote:
> >> > Hi Frederic
> >> >
> >> > I do not have previous messages and do not know how to reproduce it.
> >> > Kernel was 2.6.33-rc5-00237-g9a3cbe3
> >> >
> >>
> >> Hm, I have the same after reboot.
> >>
> >> Do you need me to do anything before I try to fsck ?
> >
> >
> > Yeah. Rebooting again makes your kernel soft lockup?
> Yes, reboot does not help. I even can't login, agetty and sshd are frozen.
> 
> INFO: task sshd:1863 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sshd          D 6f60ec44  6576  1863   1810 0x00000000
>  f633dd78 00000046 ffffffff 6f60ec44 0000000f f7306b30 f73068b0 00000000
>  f7306d84 7fffffff 00000000 f633de70 f633dde8 c134da45 00000000 f633dd8c
>  c104ca3b 00000000 7fffffff 0000000f 6f618f50 f73068b0 00000000 00000000
> Call Trace:
>  [<c134da45>] schedule_timeout+0x125/0x1b0
>  [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
>  [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
>  [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
>  [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
>  [<c134d7d0>] wait_for_common+0xd0/0x130
>  [<c1024850>] ? default_wake_function+0x0/0x10
>  [<c134d8c2>] wait_for_completion+0x12/0x20
>  [<c1039709>] call_usermodehelper_exec+0x89/0xb0
>  [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
>  [<c134d730>] ? wait_for_common+0x30/0x130
>  [<c10398e2>] __request_module+0xa2/0xf0
>  [<c10a6136>] ? new_inode+0x76/0x80
>  [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
>  [<c12cc89f>] __sock_create+0x18f/0x1f0
>  [<c107b22a>] ? might_fault+0x4a/0xa0
>  [<c12cc967>] sock_create+0x37/0x40
>  [<c12ccb1e>] sys_socket+0x3e/0x70
>  [<c12ccbb0>] sys_socketcall+0x60/0x270
>  [<c1002b43>] ? sysenter_exit+0xf/0x18
>  [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c1002b10>] sysenter_do_call+0x12/0x36
> no locks held by sshd/1863.
> 
> No locks - what does it mean?



This is the call_usermodehelper_exec path, so probably
the kernel tries to ask userspace to load a module, but
since the filesystem is locked up, this can't happen.



> >
> > Usually such softlockup happens because we have a lock
> > inversion, in which case you should have a lockdep report
> > before the softlockup.
> 
> No, I do not have it. 120 seconds after boot I see these messages on
> the console,
> no lockdep reports (lockdep is enabled).



So this is probably this event waited thing.



> >
> > Otherwise this can also happen when we wait for an event
> > that needs the lock to complete but
> > that can not happen because we already have the lock.
> >
> > Task A hold reiserfs lock and wait for event 1
> > Task B wants to complete event 1 but it need the reisers lock
> > for that => deadlock.
> >
> > This can usually be found in a softlockup report: lots of
> > tasks are blocked on reiserfs_write_lock/mutex_lock
> > except one, and this one is important as it is probably
> > the waiter: the task that holds the lock and that is waiting
> > for another event (that in turn needs the lock to complete).
> >
> > Having more reports could probably help us:
> >
> > echo 100 > /proc/sys/kernel/hung_task_warnings
> 
> Ok, I will modify rc scripts to do it, as I can't login.


Thanks!

