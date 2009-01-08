Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZAHCTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZAHCTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 21:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZAHCTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 21:19:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34198 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZAHCTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 21:19:34 -0500
Date: Thu, 8 Jan 2009 11:18:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Message-Id: <20090108111827.f6f8bcd9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LFD.2.00.0901071552550.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>
	<20090103191706.GA2002@parisc-linux.org>
	<1231368870.6686.16.camel@norville.austin.ibm.com>
	<alpine.LFD.2.00.0901071518570.3057@localhost.localdomain>
	<alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
	<alpine.LFD.2.00.0901071552550.3057@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 15:57:06 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 7 Jan 2009, Steven Rostedt wrote:
> > 
> > Should that be:
> > 
> > #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_MEMORY_HOTPLUG)
> 
> Well, probably CONFIG_MEMORY_HOTREMOVE, no? And I'd actually suggest that 
> unplugging should have a stop-machine if it doesn't already, just because 
> it's such a special case - like module removal.
> 
I looked memory hotplug code again, then..

 1. stop_machine() is not used.
 2. x86-64 code doesn't have "unmap physical memory from the kernel space".
    (because ia64, my (old) target machine, doesn't need it.)
    I'm not sure about powerpc.

I'd like to look into this for x86-64 when I can. 

BTW, can I make a quiestion ?
==
			if (lock->owner != thread)
				break;

			/*
			 * Need to access the cpu field knowing that
			 * DEBUG_PAGEALLOC could have unmapped it if
			 * the mutex owner just released it and exited.
			 */
			if (__get_user(cpu, &thread->cpu))
				break;
==
"thread" can be obsolete while lock->owner == thread ?
Isn't this depends on  CONFIG_DEBUG_MUTEXES ?


Thanks,
-Kame

