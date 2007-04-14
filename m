Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbXDNRvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbXDNRvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXDNRvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:51:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXDNRvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:51:14 -0400
Date: Sat, 14 Apr 2007 10:50:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070414172920.GA2433@1wt.eu>
Message-ID: <Pine.LNX.4.64.0704141036210.5473@woody.linux-foundation.org>
References: <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu>
 <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu>
 <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu>
 <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu>
 <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com>
 <20070414172920.GA2433@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Apr 2007, Willy Tarreau wrote:
> 
> It is clearly possible. What I found strange is that I could still fork
> processes (eg: ls, dmesg|tail), ... but not switch to another VT anymore.

Considering the patches in question, it's almost definitely just a CPU 
scheduling problem with starvation.

The VT switching is obviously done by the kernel, but the kernel will 
signal and wait for the "controlling process" for the VT. The most obvious 
case of that is X, of course, but even in text mode I think gpm will 
have taken control of the VT's it runs on (all of them), which means that 
when you initiate a VT switch, the kernel will actually signal the 
controlling process (gpm), and wait for it to acknowledge the switch.

If gpm doesn't get a timeslice for some reason (and it sounds like there 
may be some serious unfairness after "fork()"), your behaviour is 
explainable.

(NOTE! I've never actually looked at gpm sources or what it really does, 
so maybe I'm wrong, and it doesn't try to do the controlling VT thing, and 
something else is going on, but quite frankly, it sounds like the obvious 
candidate for this bug. Explaining it with some non-scheduler-related 
thing sounds unlikely, considering the patch in question).

		Linus
