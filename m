Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYDCTFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYDCTFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbYDCTFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:05:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617AbYDCTFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:05:02 -0400
Date: Thu, 3 Apr 2008 12:04:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: xemul@openvz.org, manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, sukadev@us.ibm.com, ebiederm@xmission.com,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
Message-Id: <20080403120406.dbc84cbd.akpm@linux-foundation.org>
In-Reply-To: <20080401141540.GB13213@sergelap.ibm.com>
References: <47EFFD1C.5020204@colorfullife.com>
	<47F08ED6.1090103@openvz.org>
	<47F10DF7.5010702@colorfullife.com>
	<47F203EC.7090806@openvz.org>
	<20080401141540.GB13213@sergelap.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008 09:15:41 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Pavel Emelyanov (xemul@openvz.org):
> > Manfred Spraul wrote:
> > > Pavel Emelyanov wrote:
> > >> Manfred Spraul wrote:
> > >>   
> > >>> Hi,
> > >>>
> > >>> the attached patch should fix the combination of CLONE_NEWIPC with 
> > >>> shared sysv undo structures (the common case, just 
> > >>> sys_unshare(CLONE_NEWIPC)):
> > >>> lookup_undo() now locates the undo array based on both semid and the 
> > >>> namespace pointer.
> > >>>     
> > >> If you start using any IPC object and then call unshare with CLONE_NEWIPC,
> > >> then it's your problem, but not the kernel.
> > >>   
> > > The result is a kernel memory corruption, and kernel memory corruptions 
> > > are always the kernel's problem.
> > 
> > Agree. Must be fixed, but I'm not sure we should try handling this
> > case by trying to de-op semaphores for former task namespace. I think
> > that destroying this list or returning -EBUSY for this case is OK.
> > 
> > > The code assumed that a semaphore id is globally unique. With 
> > > namespaces,  this is not true anymore.
> > > If two semaphore arrays exist with the same id, but different sizes, 
> > > then semops will cause memory corruptions: The undo structure contains 
> > > one element for each semaphore, thus the semop will write behind the end 
> > > of the memory allocation.
> > > 
> > >> I agree, that we should probably destroy this one when the task calls 
> > >> unshare, but trying to keep this list relevant is useless.
> > >>   
> > > A very tricky question: Let's assume we have a process with two threads.
> > > The undo structure is shared, as per opengroup standard.
> > > Now one thread calls unshare(CLONE_NEWIPC). What should happen? We 
> > > cannot destroy the undo structure, the other thread might be still 
> > > interested in it.
> > > If we allow sys_unshare() for multithreaded processes with CLONE_NEWIPC 
> > > and without CLONE_SYSVSEM, then we must handle this case.
> > 
> > Hm... I'd simply disable creating any new namespaces for threads.
> > I think other namespaces developers agree with me. Serge, Suka, Eric
> > what do you think?
> 
> Absolutely.
> 

Guys, what's the status here?

afaict Manfred has identified an available-to-unprivileged-apps kernel
memory corrupter?  If so, we should fix it asap for 2.6.25.  And for
2.6.24.x if it's also present there.

Manfred's patch doesn't come close to applying against the 2.6.26 IPC
things which we have queued but that's OK - bugfixes come first.
