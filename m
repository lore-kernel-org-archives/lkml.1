Return-Path: <linux-kernel-owner+w=401wt.eu-S1761845AbZAGVJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845AbZAGVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761341AbZAGVJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:09:42 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37769 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605AbZAGVJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:09:41 -0500
Date: Wed, 7 Jan 2009 14:09:23 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Message-ID: <20090107210923.GV2002@parisc-linux.org>
References: <1231279660.11687.121.camel@twins> <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 12:55:49PM -0800, Linus Torvalds wrote:
> 	void loop_while_oncpu(struct mutex *lock, struct thread_struct *thread)
> 	{
> 		for (;;) {
> 			unsigned cpu;
> 			struct runqueue *rq;
> 
> 			if (lock->owner != thread)
> 				break;
> 
> 			/*
> 			 * Need to access the cpu field knowing that
> 			 * DEBUG_PAGEALLOC could have unmapped it if
> 			 * the mutex owner just released it and exited.
> 			 */
> 			if (__get_user(cpu, &thread->cpu))
> 				break;

I appreciate this is sample code, but using __get_user() on
non-userspace pointers messes up architectures which have separate
user/kernel spaces (eg the old 4G/4G split for x86-32).  Do we have an
appropriate function for kernel space pointers?  Is this a good reason
to add one?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
