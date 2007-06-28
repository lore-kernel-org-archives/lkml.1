Return-Path: <linux-kernel-owner+w=401wt.eu-S1764897AbXF1SY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764897AbXF1SY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbXF1SYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:24:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2393 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbXF1SYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:24:20 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 28 Jun 2007 11:24:13 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andy Isaacson <adi@hexapodia.org>
cc: Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] MAP_NOZERO - implement a new VM_NOZERO/MAP_NOZERO
 page retirement policy
In-Reply-To: <20070628061911.GA16986@hexapodia.org>
Message-ID: <Pine.LNX.4.64.0706281120390.31307@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912259.1>
 <4681D37E.2020706@redhat.com> <Pine.LNX.4.64.0706262016080.26540@alien.or.mcafeemobile.com>
 <4681E52A.8030300@redhat.com> <Pine.LNX.4.64.0706262127300.26540@alien.or.mcafeemobile.com>
 <20070628061911.GA16986@hexapodia.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Andy Isaacson wrote:

> On Tue, Jun 26, 2007 at 09:32:44PM -0700, Davide Libenzi wrote:
> > > Because an SUID program can change its UID back.
> > > 
> > > At least, one that was SUID root.  OTOH, any
> > > program running as root can change UID, so we
> > > should probably not allow root to get nonzeroed
> > > pages.
> > 
> > Well, root can in general access the whole system in any case. At the 
> > moment, root cannot access othe UIDs pages. Only their own. And this 
> > differs from standard security policies where root can access everything.
> > Pages used internally by the kernel, cannot be reused by anyone.
> 
> But MAP_NOZERO adds a new possible information leak from root out to the
> non-root user.  If root does
> 
>     setuid(newuid);
>     exec(...);
>     exit(1);
> 
> and there are MAP_NOZERO pages which contain sensitive information,
> a process running as newuid would be able to race the exec with
> PTRACE_ATTACH and extract the sensitive information.  Without MAP_NOZERO
> the information leak is limited to information which was in the setuid
> program's address space (and presumably, setuid programs are written to
> be careful about such things).

That probably deserves a patch alone (see below), besides MAP_NOZERO. 
Basically, a new "exec uid" is added and such exec-uid is set only after 
the binary completed the detach from the old context. Ptrace check that 
uid also, and part of the may_attach() function.



> That said, I think I like the idea of MAP_NOZERO.  Could it be
> generalized to some kind of "free pool" rather than keyed off of uid?

Problem is, you end up with yet another pool to be looked up, flushed 
under memory pressure, etc..



- Davide



---
 fs/exec.c             |    2 ++
 include/linux/sched.h |    2 +-
 kernel/ptrace.c       |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/exec.c
===================================================================
--- linux-2.6.mod.orig/fs/exec.c	2007-06-28 11:15:53.000000000 -0700
+++ linux-2.6.mod/fs/exec.c	2007-06-28 11:18:47.000000000 -0700
@@ -905,6 +905,8 @@
 	flush_signal_handlers(current, 0);
 	flush_old_files(current->files);
 
+	current->xuid = current->uid;
+
 	return 0;
 
 mmap_failed:
Index: linux-2.6.mod/include/linux/sched.h
===================================================================
--- linux-2.6.mod.orig/include/linux/sched.h	2007-06-28 11:16:15.000000000 -0700
+++ linux-2.6.mod/include/linux/sched.h	2007-06-28 11:16:49.000000000 -0700
@@ -917,7 +917,7 @@
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	uid_t uid,euid,suid,fsuid;
+	uid_t uid,euid,suid,fsuid,xuid;
 	gid_t gid,egid,sgid,fsgid;
 	struct group_info *group_info;
 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted;
Index: linux-2.6.mod/kernel/ptrace.c
===================================================================
--- linux-2.6.mod.orig/kernel/ptrace.c	2007-06-28 11:09:27.000000000 -0700
+++ linux-2.6.mod/kernel/ptrace.c	2007-06-28 11:18:35.000000000 -0700
@@ -135,6 +135,7 @@
 		return 0;
 	if (((current->uid != task->euid) ||
 	     (current->uid != task->suid) ||
+	     (current->xuid != task->xuid) ||
 	     (current->uid != task->uid) ||
 	     (current->gid != task->egid) ||
 	     (current->gid != task->sgid) ||
