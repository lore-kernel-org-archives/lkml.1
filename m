Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbZDWQuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbZDWQuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZDWQuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:50:01 -0400
Received: from gw.goop.org ([64.81.55.164]:60673 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZDWQuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:50:00 -0400
Message-ID: <49F09C35.1080006@goop.org>
Date: Thu, 23 Apr 2009 09:49:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <alpine.DEB.2.00.0904222200350.24310@gandalf.stny.rr.com> <20090423082031.GA599@elte.hu> <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Ah, this is a lockdep thing.
>
> The raw_local_irq_save/restore in __native_flush_tlb_global does not 
> update hardirqs_enabled.
>
> When we call into ftrace, when we cross page bounderies, we disable 
> interrupts using the normal local_irq_save/restore calls.
>
> But when we restore, it detects that interrupts are not going to be 
> enabled, and keeps hardirqs_enabled off.
>
> The printk solved the issue because it called local_irq_restore, which set 
> the variable back.
>
> I guess there's two solutions here. One, we can change the 
> raw_local_irq_enable/disable variants in __native_flush_tlb_global to the 
> non-raw type (it should protect against recursion).
>
> or we can try to make the ring buffer use the raw_local_irq variants too. 
> I tried this once before, and it did cause issues.
>
> Note, there's a "check_flags" in lockdep, but it is only called on 
> locking, it is not called when we only disable/enable interrupts.
>   

OK, the good news is that its not a callee-save calling convention 
problem, which is what I feared.  But it does sound pretty awkward to 
fix.  Does __native_flush_tlb_global() have to use 
raw_local_irq_save/restore?

    J
