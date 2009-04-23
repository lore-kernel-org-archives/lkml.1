Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbZDWTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbZDWTmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZDWTmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:42:03 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46193 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbZDWTmB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:42:01 -0400
Date: Thu, 23 Apr 2009 15:40:42 -0400 (EDT)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Tim Abbott <tabbott@MIT.EDU>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <49EFA0DE.9070407@redhat.com>
Message-ID: <alpine.DEB.2.00.0904221901190.7725@vinegar-pot.mit.edu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu> <20090422091645.GB18226@elte.hu> <alpine.DEB.1.10.0904221250280.24280@vinegar-pot.mit.edu>
 <49EFA0DE.9070407@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Masami Hiramatsu wrote:
> Could you also add "use text_poke() on x86" to your plan? :-)

That should be possible now that it is usable inside stop_machine().  It 
would be nicer to have an API that isn’t x86-specific, though.

Another issue is that Ksplice supports patching rodata as well as text, 
and text_poke() does not support changes bigger than PAGE_SIZE.  Though 
perhaps text_poke() is not the right function for rodata patches anyway.

> Hmm, I can't agree that we allow module to modify kernel text...
> Is that possible to separate kernel-text swapping routine from Ksplice
> module? In that case, we don't need to export text_mutex.

No, it’s not enough for Ksplice to lock the kernel text only while 
actively swapping it.  We also need to prevent changes to the kernel text 
while Ksplice is doing run-pre matching to ensure safety.  This means that 
Ksplice wants to hold text_mutex for essentially the entire time it’s 
running.

Anders
