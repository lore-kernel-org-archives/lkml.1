Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZDWUIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZDWUIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZDWUHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:07:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56517 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbZDWUHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:07:52 -0400
Message-ID: <49F0CA5C.8090409@redhat.com>
Date: Thu, 23 Apr 2009 16:06:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anders Kaseorg <andersk@MIT.EDU>
CC: Tim Abbott <tabbott@MIT.EDU>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeffrey B Arnold <jbarnold@MIT.EDU>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu> <20090422091645.GB18226@elte.hu> <alpine.DEB.1.10.0904221250280.24280@vinegar-pot.mit.edu> <49EFA0DE.9070407@redhat.com> <alpine.DEB.2.00.0904221901190.7725@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.2.00.0904221901190.7725@vinegar-pot.mit.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Kaseorg wrote:
> On Wed, 22 Apr 2009, Masami Hiramatsu wrote:
>> Could you also add "use text_poke() on x86" to your plan? :-)
> 
> That should be possible now that it is usable inside stop_machine().  It 
> would be nicer to have an API that isn’t x86-specific, though.

Now, text_poke() become atomic and can be called inside stop_machine().
I agree with that text_poke() is currently implemented only on x86,
but adding a generic text_poke() which just do memcpy() is easy.

> Another issue is that Ksplice supports patching rodata as well as text, 
> and text_poke() does not support changes bigger than PAGE_SIZE.  Though 
> perhaps text_poke() is not the right function for rodata patches anyway.

PAGE_SIZE limitation is not a problem, because you can call text_poke()
repeatedly.
But indeed, handling rodata in text_poke() is a bit odd...

I assume that you are using alias pages (mapping ro-pages to rw-area) in
Ksplice, and if so, I think we can make it as a generic function and
share it with text_poke().

>> Hmm, I can't agree that we allow module to modify kernel text...
>> Is that possible to separate kernel-text swapping routine from Ksplice
>> module? In that case, we don't need to export text_mutex.
> 
> No, it’s not enough for Ksplice to lock the kernel text only while 
> actively swapping it.  We also need to prevent changes to the kernel text 
> while Ksplice is doing run-pre matching to ensure safety.  This means that 
> Ksplice wants to hold text_mutex for essentially the entire time it’s 
> running.

Then, why can't you move that "matching" routine into the kernel too? :-)

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

