Return-Path: <linux-kernel-owner+w=401wt.eu-S2992970AbXDRXaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992970AbXDRXaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992989AbXDRXaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:30:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2961 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992970AbXDRXaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:30:16 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 18 Apr 2007 16:30:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070418214816.GA10902@elte.hu>
Message-ID: <Pine.LNX.4.64.0704181515290.25880@alien.or.mcafeemobile.com>
References: <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
 <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
 <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu>
 <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com>
 <20070418214816.GA10902@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Ingo Molnar wrote:

> That's one reason why i dont think it's necessarily a good idea to 
> group-schedule threads, we dont really want to do a per thread group 
> percpu_alloc().

I still do not have clear how much overhead this will bring into the 
table, but I think (like Linus was pointing out) the hierarchy should look 
like:

Top (VCPU maybe?)
    User
        Process
            Thread

The "run_queue" concept (and data) that now is bound to a CPU, need to be 
replicated in:

ROOT <- VCPUs add themselves here
    VCPU <- USERs add themselves here
        USER <- PROCs add themselves here
            PROC <- THREADs add themselves here
                THREAD (ultimate fine grained scheduling unit)

So ROOT, VCPU, USER and PROC will have their own "run_queue". Picking up a 
new task would mean:

VCPU = ROOT->lookup();
USER = VCPU->lookup();
PROC = USER->lookup();
THREAD = PROC->lookup();

Run-time statistics should propagate back the other way around.


> In fact for threads the _reverse_ problem exists, threaded apps tend to 
> _strive_ for more performance - hence their desperation of using the 
> threaded programming model to begin with ;) (just think of media 
> playback apps which are typically multithreaded)

The same user nicing two different multi-threaded processes would expect a 
predictable CPU distribution too. Doing that efficently (the old per-cpu 
run-queue is pretty nice from many POVs) is the real challenge.



- Davide


