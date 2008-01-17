Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYAQPWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYAQPWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYAQPWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:22:33 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:44329 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYAQPWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:22:31 -0500
Date: Thu, 17 Jan 2008 10:22:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Paul Mackerras <paulus@samba.org>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080117041443.GA9513@Krystal>
Message-ID: <Pine.LNX.4.58.0801171013000.23340@gandalf.stny.rr.com>
References: <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
 <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
 <1200523867.6127.5.camel@localhost.localdomain>
 <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com>
 <1200536889.6127.52.camel@localhost.localdomain> <20080117024000.GD2322@Krystal>
 <20080117025004.GE2322@Krystal> <18318.51622.37470.246611@cargo.ozlabs.ibm.com>
 <20080117041443.GA9513@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Crazy ideas :
>
> Could we do something along the lines of the thread local storage ?
>
> Or could we map a per-thread page that would contradict this
> "definition" ?

When working on lguest64, I implemented a "per CPU" shadow page. That the
process of a guest running on one real CPU, could never see this page for
a process of the same guest running on another real CPU.

This is a nightmare to manage.  The thing is that threads share the same
pgd. With shadow pages, it's doable, but hard to manage. It required
making a "copy" of the pgd for each real CPU.

Here we are not talking about guests, but bare-metal.  So this complicates
things even more. The problem is that each thread shares the same pgd. If
two threads run on the same time on two different CPUS, then the two
threads would see the same counter. But we need to make this per cpu.

Now if the thread was given a clue to what CPU it was running on, then we
might be able to accomplish something. But then we have the same issue.
How do you tell a thread what CPU it's on, without running into the same
issues as where to store this data?

-- Steve

>
> Or can we move down the beginning of the user-space thread stack of 4
> bytes (it's already put at a random address anyway) and use these 32
> bits to put our variable ? We don't care if userspace also modifies it;
> the kernel would blindly increment it, so there would be no security
> concerns involved.

