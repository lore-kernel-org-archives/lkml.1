Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbZDWWc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbZDWWc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZDWWcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:32:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62490 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbZDWWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:32:50 -0400
Date: Thu, 23 Apr 2009 18:31:25 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>
cc: Anders Kaseorg <andersk@MIT.EDU>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeffrey B Arnold <jbarnold@MIT.EDU>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
In-Reply-To: <20090423195754.GA24963@Krystal>
Message-ID: <alpine.DEB.1.10.0904231612180.28329@vinegar-pot.mit.edu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu> <20090422091645.GB18226@elte.hu> <alpine.DEB.1.10.0904221250280.24280@vinegar-pot.mit.edu>
 <49EFA0DE.9070407@redhat.com> <alpine.DEB.2.00.0904221901190.7725@vinegar-pot.mit.edu> <20090423195754.GA24963@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, Mathieu Desnoyers wrote:
> how about a kernel Ksplice API which lets your patch modules get
> their handlers executed under the right execution context ? E.g. :
[...]
> This way, the kernel code-base would contain the tricky locking bits.
> It seems much better than exporting the text_mutex to modules.

On Thu, 23 Apr 2009, Masami Hiramatsu wrote:
> Then, why can't you move that "matching" routine into the kernel too? :-)

I think both of you are assuming that Ksplice is grabbing text_mutex in 
the patch modules for each update, which isn't what's going on.  There are 
two types of modules associated with Ksplice, the per-update patch modules 
and the Ksplice core, which could be built as a module.

The patch modules for each update are already stub modules that just load 
some data into a data structure and call into the Ksplice core at 
module_init/cleanup (by Ksplice core, I mean kernel/ksplice.c).  All the 
tricky bits including the run-pre matching routine and the locking code 
are in the Ksplice core.

The reason that we want to export text_mutex is that it can be useful for 
the Ksplice core (still kernel/ksplice.c) to be built as a module.  This 
is desirable when a different version of the kernel/ksplice.c code is 
needed in order to apply a particular update (e.g. because there was a bug 
in Ksplice).


I agree that great care should be taken when writing code that patches the 
kernel's text.  However, I don't think failing to export text_mutex to GPL 
modules helps ensure that.  In particular, not exporting text_mutex 
doesn't prevent modules from patching the kernel text.  It just prevents 
any modules that do so from grabbing the appropriate lock.

	-Tim Abbott


