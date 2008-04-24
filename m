Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYDXVVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYDXVVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYDXVVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:21:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYDXVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:21:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: microblaze syscall list
Date: Thu, 24 Apr 2008 23:21:06 +0200
User-Agent: KMail/1.9.9
Cc: Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200804241311.09881.arnd@arndb.de> <4810D4A4.7050900@seznam.cz>
In-Reply-To: <4810D4A4.7050900@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804242321.07968.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+mGGimgUhlsEMynP8GPoUVi6sFu5JQYfianOJ
 FUEn/KxyZ3A6ZCVGyxkIwdWOVBxMANXKNozXC1YfvmZJcKZLJb
 oDMrWL+46mrw3YA1u9OZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2008, Michal Simek wrote:

> >> 	.long sys_exit
> >> 	.long sys_ni_syscall		/* was fork */
> > 
> > it might be useful to renumber your calls once all the irrelevant ones
> > have been removed, so you can get rid of all the sys_ni_syscalls here.
> 
> I'll delete all sys_ni_syscall from syscall_table.S and I'll remove it from
> unistd.h too. I hope I'll keep the same call numbers.

there is not much point in keeping the syscall numbers, as you'll have
to do incompatible changes to your libc in order to do all the changes
I'm asking for.
 
> >> 	.long sys_read
> >> 	.long sys_write
> >> 	.long sys_open			/* 5 */
> > 
> > Since we have all the new sys_*at calls like openat, we don't really
> > need the old versions any more. The kernel implementation of sys_open
> > basically calls openat. You could do the same in libc instead.
> > Don't know if that's worth it though, opinions?
> 
> I looked at it and there are the different arguments for open and openat
> syscalls. Implementation is almost the same. I keep it now.

There is no "for now". If you keep them for submission, you'll have to
keep them forever. You'll have to wrap them in your libc to adapt the
arguments.

> >> 	.long sys_close
> >> 	.long sys_waitpid
> > 
> > waitpid and wait4 can be replaced with waitid
> 
> Can I keep number of syscall(unistd.h) and only add reference to waitid in
> syscall_table? or just remove?

if you keep the syscall number in unistd.h, you may confuse user space
that relies on it when the actual call is not there. It's most important
to keep the two in sync.

It may turn out to be better to leave them in, but then you still need
both the number and the sys_call_table entry.

The wait/waitpid/wait4/waitid case is much less interesting than
the uid16/uid32 and off_t/loff_t cases, where you don't ever want
anyone to call the old functions.

the openat/*at family of calls probably falls into the same category
as waitid: there are user space programs that call either one, and
it doesn't matter much which one (kernel or libc) does the conversion.

> >> 	.long sys_creat
> >> 	.long sys_link
> >> 	.long sys_unlink		/* 10 */
> >> 	.long sys_execve_wrapper
> > 
> > having an execve_wrapper instead of execve looks like a strange convention,
> > though I guess you had a good reason for it, could you explain?
> >
> > This one looks architecture specific, so you may want to rename it
> > microblaze_execve_wrapper instead of sys_execve_wrapper.
> 
> I looked at it and the same of style is used in arm
> (arch/arm/kernel/entry-common.S) and some others arch. This wrapper only set one
> parameter to correct pointer to stack.

right, but other architectures don't seem to need it.

> I'll comment the rest later. I need time to look at it.

I guess you should also wait for other comments on my list.

	Arnd <><
