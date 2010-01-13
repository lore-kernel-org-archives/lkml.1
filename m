Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865Ab0AMAyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0AMAyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897Ab0AMAyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:54:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:42059 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0AMAx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:53:59 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Jim Keniston <jkenisto@us.ibm.com>
To: ananth@in.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100112081412.GD28425@in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <20100112053559.GL5243@nowhere>  <20100112081412.GD28425@in.ibm.com>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 16:53:48 -0800
Message-Id: <1263344028.4983.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 13:44 +0530, Ananth N Mavinakayanahalli wrote:
> On Tue, Jan 12, 2010 at 06:36:00AM +0100, Frederic Weisbecker wrote:
...
> > So, as stated before, uprobe seems to handle too much standalone
> > policies such as freeing on exec, always inherit on clone and never
> > on fork. Such rules should be decided from uprobe clients not
> > from uprobe itself and that makes it not enough flexible to
> > be usable for now.
> 
> The freeing on exec is only housekeeping of uprobe data structures. And
> probepoints are inherited only on CLONE_THREAD and not otherwise, simply
> since the existing probes can be hit in the new thread's context. Not
> sure what other policy you are hinting at.
> 
...
> > 
> > 
> > Typically, to use it with perf toward a pmu, perf tools need to
> > create a uprobe on perf process and activate its hook on the next exec.
> > Thereafter, it's up to perf to decide if we inherit through clone
> > and fork.
> 
> As mentioned above, the inheritance is only for threads. It should be
> fairly easy to inherit probes on fork, and that can be made a perf based
> policy decision.
> 

One reason we don't currently support inheritance (or cloning) of
uprobes across fork is that a uprobe object is (a) per-process (and I
think we want to keep it that way); and (b) owned by the uprobes client.
That is, the client creates and populates that uprobe object, and passes
a pointer to it to both register_uprobe() and unregister_uprobe().  We
could clone this object on fork, but then how would the client refer to
the cloned uprobes in the new process -- e.g., to unregister them?

I guess each cloned uprobe could remember its "patriarch" uprobe -- its
ultimate ancestor, the one created by the client; and we could add an
"unregister_uprobe_clone" function that takes both the address of the
patriarch uprobe and the pid of the (clone) uprobe to be unregistered.

It has also been suggested that it might be more user-friendly to 
let the client discard (or reuse) the uprobe object as soon as
register_uprobe() returns.  register_uprobe() would presumably copy 
everything it needs from the uprobe to the uprobe_kimg, and pass back 
a handle (e.g., the address of the uprobe_kimg) that the client can
later pass to unregister_uprobe() -- or unregister_uprobe_clone().  (In
this case, only the uprobe_kimg would be cloned.)  It might be good to
consider both these enhancement requests together.

Anyway, as previously described, the clone-on-fork feature can be (and
has been) implemented by a utrace-based task-finder that notices forks,
and creates and registers a whole new set of uprobes for the new
process.

Jim

