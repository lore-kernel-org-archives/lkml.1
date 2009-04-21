Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZDUR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZDUR4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZDUR4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:56:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46483 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbZDUR4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:56:03 -0400
Date: Tue, 21 Apr 2009 13:51:48 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Jeffrey B Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
In-Reply-To: <200904192055.04213.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Apr 2009, Rusty Russell wrote:

> I think you need to do something else in general.  Share the module_mutex for
> the ftrace code?  The ksplice guys have a similar issue, so maybe we should
> generalize this into a "kernel_text" mutex?

Yes, a kernel_text mutex is on my list of things to propose once Ksplice 
gets merged.

There are at present several systems that modify the kernel text after a 
machine is booted (e.g. dynamic ftrace and toggling of smp_locks when 
hotplugging a cpu).  Currently, they avoid stepping on each other by only 
making changes inside stop_machine.

However, Ksplice does its run-pre matching checks outside stop_machine, 
and Ksplice needs a way to prevent e.g. dynamic ftrace from changing the 
code out from under it between those checks and actually applying the 
patches [1].  A kernel_text mutex would be a reasonable solution to this 
problem.

	-Tim Abbott

[1] At present this isn't a real problem because Ksplice and ftrace 
conflict with each other for unrelated reasons.
