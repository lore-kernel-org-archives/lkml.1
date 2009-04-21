Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZDUStH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZDUStH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDUSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:48:52 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33886 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbZDUSsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:48:51 -0400
Date: Tue, 21 Apr 2009 14:47:35 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Jeffrey B Arnold <jbarnold@MIT.EDU>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
In-Reply-To: <alpine.DEB.2.00.0904211415520.10097@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0904211421260.18037@vinegar-pot.mit.edu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu> <alpine.DEB.2.00.0904211415520.10097@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Steven Rostedt wrote:

> > However, Ksplice does its run-pre matching checks outside stop_machine, 
> 
> Does Ksplice use break points to do the modification? 

No, we use jump instructions.

> I'd be interested in knowing how Ksplice protects against the nastiness 
> of code executing on one CPU that is being modified by another CPU.

The run-pre matching checks, which verify that the pre-patch code the user 
gave Ksplice matches the running kernel, occur before stop_machine with 
the module_mutex held.  Then, inside stop_machine, we check that no thread 
is in the process of executing a to-be-patched function before inserting 
the jump instructions.  We need the transition from the old code to the 
new code to be atomic (i.e. no old code can run after any new code is 
run).  So, we need to check all the return addresses on each thread's 
kernel stack as well as the instruction pointers.

	-Tim Abbott
