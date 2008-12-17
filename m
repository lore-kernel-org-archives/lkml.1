Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756904AbYLQCFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYLQCFB (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYLQCEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:04:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbYLQCEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:04:49 -0500
Date: Tue, 16 Dec 2008 18:03:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
        manfred@colorfullife.com, dipankar@in.ibm.com,
        josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
        dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
        rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
        andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH -tip] v10 scalable classic RCU implementation
Message-Id: <20081216180313.23bcd252.akpm@linux-foundation.org>
In-Reply-To: <20081217003744.GA26660@linux.vnet.ibm.com>
References: <20081202222157.GA14911@linux.vnet.ibm.com>
	<20081217003744.GA26660@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 16:37:44 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> This patch fixes a long-standing performance bug in classic RCU that
> results in massive internal-to-RCU lock contention on systems with
> more than a few hundred CPUs.  Although this patch creates a separate
> flavor of RCU for ease of review and patch maintenance, it is intended
> to replace classic RCU.
> 
> This patch still handles stress better than does mainline, so I am still
> calling it ready for inclusion.  This patch is against the -tip tree.
> Nevertheless, experience on an actual 1000+ CPU machine would still be
> most welcome.
> 
> Most of the changes noted below were found while creating an rcutiny
> (which should permit ejecting the current rcuclassic) and while doing
> detailed line-by-line documentation.
> 
> Updates from v9 (http://lkml.org/lkml/2008/12/2/334):
> 
> o	Fixes from remainder of line-by-line code walkthrough,
> 	including comment spelling, initialization, undesirable
> 	narrowing due to type conversion, removing redundant memory
> 	barriers, removing redundant local-variable initialization,
> 	and removing redundant local variables.
> 
> 	I do not believe that any of these fixes address the CPU-hotplug
> 	issues that Andi Kleen was seeing, but please do give it a whirl
> 	in case the machine is smarter than I am.
> 
> 	A writeup from the walkthrough may be found at the following
> 	URL, in case you are suffering from terminal insomnia or
> 	masochism:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/paulmck/tmp/rcutree-walkthrough.2008.12.16a.pdf
> 
> o	Made rcutree tracing use seq_file, as suggested some time
> 	ago by Lai Jiangshan.
> 
> o	Added a .csv variant of the rcudata debugfs trace file, to allow
> 	people having thousands of CPUs to drop the data into
> 	a spreadsheet.	Tested with oocalc and gnumeric.  Updated
> 	documentation to suit.
> 
> Updates from v8 (http://lkml.org/lkml/2008/11/15/139):
> Updates from v7 (http://lkml.org/lkml/2008/10/10/291):
> Updates from v6 (http://lkml.org/lkml/2008/9/23/448):
> Updates from v5 (http://lkml.org/lkml/2008/9/15/92, bad subject line):
> Updates from v4 for those missing v5 given its bad subject line:

It strikes me that this code is at the level of maturity where it
should have been in linux-next months ago.

> 
> To build, start with 2.6.28-rc3, and apply:
> 
> 	http://www.rdrop.com/users/paulmck/patches/linux-2.6-tip.2008.11.29a.patch
> 	http://www.rdrop.com/users/paulmck/patches/2.6.28-rc3-tip-treeRCU-7.patch
> 
> The former gets you to commit #29cbda77a67cf263d636feea65d3bbc9c7de2e24
> in /tip/core/rcu in the -tip tree, and the latter is the following patch.
> 
> Thoughts?

Merge it?

> +choice
> +	prompt "RCU Implementation"
> +	default CLASSIC_RCU

But toggle that.

> +config CLASSIC_RCU
> +	bool "Classic RCU"
> +	help
> +	  This option selects the classic RCU implementation that is
> +	  designed for best read-side performance on non-realtime
> +	  systems.
> +	  
> +	  Select this option if you are unsure.
> +
> +config TREE_RCU
> +	bool "Tree-based hierarchical RCU"
> +	help
> +	  This option selects the RCU implementation that is
> +	  designed for very large SMP system with hundreds or
> +	  thousands of CPUs.
> +

If it blows up, we can trivially disable it in config, yes?

> Documentation/RCU/00-INDEX             |    2 
> Documentation/RCU/trace.txt            |  413 ++++++++
> arch/powerpc/platforms/pseries/rtasd.c |    4 
> include/linux/hardirq.h                |   14 
> include/linux/rcupdate.h               |   10 
> include/linux/rcutree.h                |  329 +++++++
> init/Kconfig                           |   18 
> kernel/Kconfig.preempt                 |   62 +
> kernel/Makefile                        |    6 
> kernel/rcupreempt.c                    |   10 
> kernel/rcupreempt_trace.c              |   10 
> kernel/rcutree.c                       | 1535 +++++++++++++++++++++++++++++++++
> kernel/rcutree_trace.c                 |  271 +++++
> kernel/softirq.c                       |    5 
> lib/Kconfig.debug                      |   13 
> 15 files changed, 2671 insertions(+), 31 deletions(-)

What's the plan for removal of the classic RCU code?  (asap, please. 
No more slabs!)

