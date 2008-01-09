Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYAIGWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYAIGWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYAIGWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:22:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:33985 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYAIGWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kH5BpiR8RtVtClnz4gsXmDRm/jKB0/3LIRxQsqVcqB3OKhdg6OS6mZ7Z2kqFW1dsjzbVoCxAlHaJF0OauXURWYxs+DXVT00Ir/dCQYKsidwvs/VlP1pvC/02ziVu7UyoqinCE9DVQvmcnheVY1dEzjLjz/omf4QZ4/dhFgLDsbU=
Subject: Re: [PATCHv3] kprobes: Introduce kprobe_handle_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20080109061408.GA9486@osiris.ibm.com>
References: <1199737486.7666.12.camel@brick>
	 <18307.64807.204087.375733@cargo.ozlabs.ibm.com>
	 <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>
	 <20080109061408.GA9486@osiris.ibm.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 22:22:22 -0800
Message-Id: <1199859742.6424.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 07:14 +0100, Heiko Carstens wrote:
> > +/*
> > + * If it is a kprobe pagefault we can not be premptible so return before
> 
> Missing 'e' in preemptible.

OK.

> However, the old code you removed had a lot of preempt_disable/enable calls
> that you removed. Hope you checked that preemption was always disabled
> already and the calls were not necessary (true at least for s390).
> 
> Are there cases where this code could be called with preemption enabled?
> If so then that looks like a bug anyway. I'd say the preemptible check
> should be removed or turned into a WARN_ON.
> 
> I like this better (not including any other changes):
> 
> 	if (!user_mode(regs) && !preemptible() && kprobe_running())
> 		return kprobe_fault_handler(regs, trapnr);
> 	return 0;

I could live with that too, will defer to kprobes maintainers if they
prefer that as a follow-on.

Regarding the preempt_enable/disable, the reasoning behind it comes from
the following, I stole the changelog from x86.git which has a good
description of why this should be safe:

commit 6624c638928acce52fbe57d73284efcf9f86abd2
Author: Quentin Barnes <qbarnes@gmail.com>
Date:   Wed Jan 9 02:32:57 2008 +0100

    Code clarification patch to Kprobes arch code
    
    When developing the Kprobes arch code for ARM, I ran across some
code
    found in x86 and s390 Kprobes arch code which I didn't consider as
    good as it could be.
    
    Once I figured out what the code was doing, I changed the code
    for ARM Kprobes to work the way I felt was more appropriate.
    I've tested the code this way in ARM for about a year and would
    like to push the same change to the other affected architectures.
    
    The code in question is in kprobe_exceptions_notify() which
    does:
    ====
              /* kprobe_running() needs smp_processor_id() */
              preempt_disable();
              if (kprobe_running() &&
                  kprobe_fault_handler(args->regs, args->trapnr))
                      ret = NOTIFY_STOP;
              preempt_enable();
    ====
    
    For the moment, ignore the code having the preempt_disable()/
    preempt_enable() pair in it.
    
    The problem is that kprobe_running() needs to call
smp_processor_id()
    which will assert if preemption is enabled.  That sanity check by
    smp_processor_id() makes perfect sense since calling it with
preemption
    enabled would return an unreliable result.
    
    But the function kprobe_exceptions_notify() can be called from a
    context where preemption could be enabled.  If that happens, the
    assertion in smp_processor_id() happens and we're dead.  So what
    the original author did (speculation on my part!) is put in the
    preempt_disable()/preempt_enable() pair to simply defeat the check.
    
    Once I figured out what was going on, I considered this an
    inappropriate approach.  If kprobe_exceptions_notify() is called
    from a preemptible context, we can't be in a kprobe processing
    context at that time anyways since kprobes requires preemption to
    already be disabled, so just check for preemption enabled, and if
    so, blow out before ever calling kprobe_running().  I wrote the ARM
    kprobe code like this:
    ====
              /* To be potentially processing a kprobe fault and to
               * trust the result from kprobe_running(), we have
               * be non-preemptible. */
              if (!preemptible() && kprobe_running() &&
                  kprobe_fault_handler(args->regs, args->trapnr))
                      ret = NOTIFY_STOP;
    ====
    
    The above code has been working fine for ARM Kprobes for a year.
    So I changed the x86 code (2.6.24-rc6) to be the same way and ran
    the Systemtap tests on that kernel.  As on ARM, Systemtap on x86
    comes up with the same test results either way, so it's a neutral
    external functional change (as expected).
    
    This issue has been discussed previously on linux-arm-kernel and the
    Systemtap mailing lists.  Pointers to the by base for the two
    discussions:

http://lists.arm.linux.org.uk/lurker/message/20071219.223225.1f5c2a5e.en.html
    http://sourceware.org/ml/systemtap/2007-q1/msg00251.html


Cheers,

Harvey

