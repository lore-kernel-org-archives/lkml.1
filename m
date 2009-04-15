Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZDOOw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZDOOw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZDOOwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:52:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbZDOOwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:52:46 -0400
Date: Wed, 15 Apr 2009 07:45:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ali Gholami Rudi <ali@rudi.ir>, Ingo Molnar <mingo@elte.hu>,
       Valdis.Kletnieks@vt.edu, Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
In-Reply-To: <20090415013456.cf5ce205.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904150739100.4132@localhost.localdomain>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org>
 <20090415081534.GA2894@lilem.mirepesht> <20090415013456.cf5ce205.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Andrew Morton wrote:
> 
> <stares suspiciously at smp_call_function_many()>
> 
>  * smp_call_function_many(): Run a function on a set of other CPUs.
> 
> "other".  It refuses to call the function on *this* CPU.  Tricky.

.. Argh. And totally different from all the other smp_call_function's. In 
smp_call_function_single(), for example, we literally test

        if (cpu == this_cpu) {
                local_irq_save(flags);
                func(info);
                local_irq_restore(flags);
	}  else {
		.. do the cross-call ..

so I think this is just smp_call_function_many() breakage.

In fact, right now the PPC flush_tlb_page() does that insane dance just 
because of this issue. So yes, there are a few current users, and they 
seem to dislike the bad semantics (the kvm code doesn't care).

Duh duh duh.

		Linus
