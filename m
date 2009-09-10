Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZIJL2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZIJL2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 07:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZIJL2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 07:28:35 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:49789 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbZIJL2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 07:28:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19112.57690.867979.462172@cargo.ozlabs.ibm.com>
Date: Thu, 10 Sep 2009 21:22:02 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/5] perf_counter: Add open/close pmu callbacks
In-Reply-To: <1252571367-25876-2-git-send-email-fweisbec@gmail.com>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
	<1252571367-25876-2-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> Add the open() and close() callback to the pmu structure.
> Open is called when a counter is initialized just after it's allocation
> and close is called when the counter is about to be released.
> 
> These callbacks are useful for example when a pmu has to deal with
> several registers and needs to maintain an internal list of counters
> using them. Given such list, the pmu is able to check if the the number
> of physical registers are still sufficient for the new created counter
> and then accept or refuse this counter.

We already do that sort of thing on powerpc for hardware counters.

It looks to me that you can easily do that stuff in the appropriate
xxx_perf_counter_init function, since pmu->open() is only called
immediately on return from one the various xxx_perf_counter_init
functions, and xxx_perf_counter_init is what says what pmu struct to
use.

As for ->close(), that's what counter->destroy is there for.  On
powerpc, hw_perf_counter_init sets counter->destroy to an appropriate
destructor function, as does tp_perf_counter_init.  So if you need a
destructor for breakpoint counters, just make bp_perf_counter_init set
counter->destroy appropriately.

Paul.
