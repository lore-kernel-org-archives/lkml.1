Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZDWT6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZDWT6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZDWT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:57:58 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:43445 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbZDWT55 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:57:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQEAChl8ElMQW1W/2dsb2JhbACBT841g3QFh2U
Date: Thu, 23 Apr 2009 15:57:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Anders Kaseorg <andersk@MIT.EDU>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeffrey B Arnold <jbarnold@MIT.EDU>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
Message-ID: <20090423195754.GA24963@Krystal>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu> <20090422091645.GB18226@elte.hu> <alpine.DEB.1.10.0904221250280.24280@vinegar-pot.mit.edu> <49EFA0DE.9070407@redhat.com> <alpine.DEB.2.00.0904221901190.7725@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.00.0904221901190.7725@vinegar-pot.mit.edu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:53:52 up 54 days, 16:20,  1 user,  load average: 0.11, 0.31,
	0.37
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anders Kaseorg (andersk@MIT.EDU) wrote:
> On Wed, 22 Apr 2009, Masami Hiramatsu wrote:
> > Could you also add "use text_poke() on x86" to your plan? :-)
> 
> That should be possible now that it is usable inside stop_machine().  It 
> would be nicer to have an API that isn’t x86-specific, though.
> 
> Another issue is that Ksplice supports patching rodata as well as text, 
> and text_poke() does not support changes bigger than PAGE_SIZE.  Though 
> perhaps text_poke() is not the right function for rodata patches anyway.
> 
> > Hmm, I can't agree that we allow module to modify kernel text...
> > Is that possible to separate kernel-text swapping routine from Ksplice
> > module? In that case, we don't need to export text_mutex.
> 
> No, it’s not enough for Ksplice to lock the kernel text only while 
> actively swapping it.  We also need to prevent changes to the kernel text 
> while Ksplice is doing run-pre matching to ensure safety.  This means that 
> Ksplice wants to hold text_mutex for essentially the entire time it’s 
> running.
> 

how about a kernel Ksplice API which lets your patch modules get
their handlers executed under the right execution context ? E.g. :

int do_ksplice(void (*pre_hook)(struct blah *context),
	void (*code_update_hook)(struct blah *context),
	void (*post_hook)(struct blah *context));

Which returns either 0 or -ESOMETHING. It would take care of locking and
everything within core kernel code. The "patch" modules would simply
provide the functions that does the code updates, assuming that the
do_ksplice function makes sure to provide correct locking semantics.
This way, the kernel code-base would contain the tricky locking bits.
It seems much better than exporting the text_mutex to modules.

Mathieu



> Anders
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
