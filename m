Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbZDSLZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbZDSLZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 07:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbZDSLZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 07:25:16 -0400
Received: from ozlabs.org ([203.10.76.45]:48035 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbZDSLZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 07:25:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
Date: Sun, 19 Apr 2009 20:55:02 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Tim Abbott <tabbott@mit.edu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org>
In-Reply-To: <20090416021928.040177084@goodmis.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904192055.04213.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 11:48:31 am Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: fix and clean up
> 
> The hooks in the module code for the function tracer must be called
> before any of that module code runs. The function tracer hooks
> modify the module (replacing calls to mcount to nops). If the code
> is executed while the change occurs, then the CPU can take a GPF.
> 
> To handle the above with a bit of paranoia, I originally implemented
> the hooks as calls directly from the module code.
> 
> After examining the notifier calls, it looks as though the start up
> notify is called before any of the module's code is executed. This makes
> the use of the notify safe with ftrace.

Hi Steven,

   Unfortunately not: we do parse_args, which can call into the module code.
(Though it shouldn't do anything "significant", as it won't get a chance to
clean up if module load fails later).

I think you need to do something else in general.  Share the module_mutex for
the ftrace code?  The ksplice guys have a similar issue, so maybe we should
generalize this into a "kernel_text" mutex?

Thanks,
Rusty.
