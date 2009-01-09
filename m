Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZAISQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZAISQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZAISQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:16:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZAISQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:16:36 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <alpine.DEB.1.10.0901091142060.17378@gandalf.stny.rr.com>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
	 <1231498062.11687.608.camel@twins> <1231513614.442.11.camel@twins>
	 <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901090828510.6528@localhost.localdomain>
	 <alpine.DEB.1.10.0901091142060.17378@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 19:16:04 +0100
Message-Id: <1231524964.442.103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 11:44 -0500, Steven Rostedt wrote:

> When we get to the schedule() it then needs to be a:
> 
> 	preempt_enable_no_resched();
> 	schedule();

On that note:

Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -220,7 +220,9 @@ __mutex_lock_common(struct mutex *lock, 
 		__set_task_state(task, state);
 
 		/* didnt get the lock, go to sleep: */
+		preempt_disable();
 		spin_unlock_mutex(&lock->wait_lock, flags);
+		preempt_enable_no_resched();
 		schedule();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}


actually improves mutex performance on PREEMPT=y
