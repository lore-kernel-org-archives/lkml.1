Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbYA1JLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbYA1JLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYA1JLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:11:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbYA1JLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:11:33 -0500
Date: Mon, 28 Jan 2008 01:10:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Vinay Sridhar <vinay@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, drepper@redhat.com, wli@holomorphy.com,
       sripathik@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Per-thread getrusage
Message-Id: <20080128011010.d162d336.akpm@linux-foundation.org>
In-Reply-To: <479D88C7.5030101@openvz.org>
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
	<20080127215242.b873c341.akpm@linux-foundation.org>
	<479D88C7.5030101@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 10:48:23 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:

> Andrew Morton wrote:
> > 	On Thu, 17 Jan 2008 13:57:05 +0530 Vinay Sridhar <vinay@linux.vnet.ibm.com> wrote:
> > 
> >> Hi All,
> >>
> >> Last year, there was discussion about per-thread getrusage by adding
> >> RUSAGE_THREAD flag to getrusage(). Please refer to the thread
> >> http://lkml.org/lkml/2007/4/4/308. Ulrich had suggested that we should
> >> design a better user-space API. Specifically, we need a
> >> pthread_getrusage interface in the thread library, which accepts
> >> pthread_t, converts pthread_t into the corresponding tid and passes it
> >> down to the syscall.
> >>
> >> There are two ways to implement this in the kernel:
> >> 1) Introduce an additional parameter 'tid' to sys_getrusage() and put
> >> code in glibc to handle getrusage() and pthread_getrusage() calls
> >> correctly.
> >> 2) Introduce a new system call to handle pthread_getrusage() and leave
> >> sys_getrusage() untouched.
> >>
> >> We implemented the second idea above, simply because it avoids touching
> >> any existing code. We have implemented a new syscall, thread_getrusage()
> >> and we have exposed pthread_getrusage() API to applications.
> >>
> >> Could you please share your thoughts on this? Does the approach look
> >> alright? The code is hardly complete. It is just a prototype that works
> >> on IA32 at the moment.
> >>
> >> ...
> >>
> >> +asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru);
> > 
> > What happens if `tid' refers to a thread in a different pid namespace?
> > 
> 
> That's impossible. I explicitly deny namespace creation in case the
> CLONE_THREAD is specified. So all threads of a single process always
> live in one pid namespace.
> 

If the code was using find_task_by_vpid() then OK (I guess).  But it is
looking the tids up in the init_pid_ns.  Which I assume means that if it's
in a new namespace and is looking up a sibling thread it will simply fail?

Or am I missing something?
