Return-Path: <linux-kernel-owner+w=401wt.eu-S1751874Ab0AVHCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0AVHCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 02:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490Ab0AVHCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 02:02:42 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39093 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0AVHCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 02:02:41 -0500
Date: Fri, 22 Jan 2010 12:32:32 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 0/7] UBP, XOL and Uprobes [ Summary of Comments and
 actions to be taken ]
Message-ID: <20100122070232.GA2975@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a summary of the Comments and actions that need to be taken for
the current uprobes patchset. Please let me know if I missed or
misunderstood any of your comments.  

1. Uprobes depends on trap signal.
	Uprobes depends on trap signal rather than hooking to the global
die notifier. It was suggested that we hook to the global die notifier.

	In the next version of patches, Uprobes will use the global die
	notifier and look at the per-task count of the probes in use to
	see if it has to be consumed.

	However this would reduce the ability of uprobe handlers to
	sleep. Since we are dealing with userspace, sleeping in handlers
	would have been a good feature. We are looking at ways to get
	around this limitation.


2. XOL vma vs Emulation vs Single Stepping Inline vs using Protection
Rings.
	XOL VMA is an additional process address vma.  This is
	opposition to add an additional vma without user actually
	requesting for the same.

	XOL vma and single stepping inline are the two architecture
	independent implementations. While other implementations are
	more architecture specific. Single stepping inline wouldnt go
	well with multithreaded process.

	Even though XOL vma has its own issues, we will go with it since
	other implementations seem to have more complications.

	we would look forward to implementing boosters later. 
	Later on, if we come across another techniques with lesser
	side-effects than the XOL vma, we would switch to using them.


3. Current Uprobes looks at process life times and not vma lifetimes. 
Also it needs threads to quiesce when inserting and removing
breakpoints.
	
	Current uprobes was quiesing threads of a process before
	insertion and deletion. This resulted in uprobes having to track
	process lifetimes. An alternative method to track vma lifetimes
	was suggested.

	Next version would update the copy of the page and flip the
	pagetables as suggested by Peter. Hence it would no more depend on
	threads quiescing.

	However this would need hooks in munmap/rmap so that uprobes can
	remove breakpoints that are placed in that vma.
	
	This would also mean removing the rcu_deference we were using.

4. Move the ftrace plugin to use trace events.

	Since ftrace plugins are relegated to obsolescence, it was
	suggested we use trace events which would have much wider scope.	

	Next version will use trace events.

5. rename UBP to user_bkpt

6. updating the authors for all files that are getting added.

I shall work towards v2 of uprobes and send across the patches at the
earliest.

--
Thanks and Regards
Srikar
