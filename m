Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYDAOQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYDAOQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbYDAOPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:15:55 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36569 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbYDAOPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:15:55 -0400
Date: Tue, 1 Apr 2008 09:15:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
Message-ID: <20080401141540.GB13213@sergelap.ibm.com>
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F203EC.7090806@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> Manfred Spraul wrote:
> > Pavel Emelyanov wrote:
> >> Manfred Spraul wrote:
> >>   
> >>> Hi,
> >>>
> >>> the attached patch should fix the combination of CLONE_NEWIPC with 
> >>> shared sysv undo structures (the common case, just 
> >>> sys_unshare(CLONE_NEWIPC)):
> >>> lookup_undo() now locates the undo array based on both semid and the 
> >>> namespace pointer.
> >>>     
> >> If you start using any IPC object and then call unshare with CLONE_NEWIPC,
> >> then it's your problem, but not the kernel.
> >>   
> > The result is a kernel memory corruption, and kernel memory corruptions 
> > are always the kernel's problem.
> 
> Agree. Must be fixed, but I'm not sure we should try handling this
> case by trying to de-op semaphores for former task namespace. I think
> that destroying this list or returning -EBUSY for this case is OK.
> 
> > The code assumed that a semaphore id is globally unique. With 
> > namespaces,  this is not true anymore.
> > If two semaphore arrays exist with the same id, but different sizes, 
> > then semops will cause memory corruptions: The undo structure contains 
> > one element for each semaphore, thus the semop will write behind the end 
> > of the memory allocation.
> > 
> >> I agree, that we should probably destroy this one when the task calls 
> >> unshare, but trying to keep this list relevant is useless.
> >>   
> > A very tricky question: Let's assume we have a process with two threads.
> > The undo structure is shared, as per opengroup standard.
> > Now one thread calls unshare(CLONE_NEWIPC). What should happen? We 
> > cannot destroy the undo structure, the other thread might be still 
> > interested in it.
> > If we allow sys_unshare() for multithreaded processes with CLONE_NEWIPC 
> > and without CLONE_SYSVSEM, then we must handle this case.
> 
> Hm... I'd simply disable creating any new namespaces for threads.
> I think other namespaces developers agree with me. Serge, Suka, Eric
> what do you think?

Absolutely.

-serge
