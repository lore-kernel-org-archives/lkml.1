Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486Ab0AKVbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0AKVbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867Ab0AKVbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:31:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab0AKVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:31:40 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v3a)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100111205250.GA6866@Krystal>
References: <20100110014456.GG25790@Krystal>
	 <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com>
	 <1263124209.28171.3798.camel@gandalf.stny.rr.com>
	 <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal>
	 <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal>
	 <20100111042903.GC32213@Krystal> <1263232240.4244.70.camel@laptop>
	 <20100111205250.GA6866@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 22:31:14 +0100
Message-ID: <1263245474.4244.87.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 15:52 -0500, Mathieu Desnoyers wrote:

> >  - receiving an IPI implies an mb, or
> 
> So, I think that if we have other concurrent IPI requests sent, we have
> no guarantee that the IPI handler will indeed issue the memory barrier 
> _after_ we added the entry to the list. The list itself is synchronized
> with a spin lock-irqoff, but not with an explicit memory barrier. Or am
> I missing a subtlety here ?

Linus once said ( http://lkml.org/lkml/2009/2/18/145 ) :

"... at least on x86, taking an interrupt should be a serializing 
event, so there should be no reason for anything on the receiving side."

But he also notes that in generic this does not need to be so.

My question was more generic than: is this currently the case for x86,
though, I was wondering if we want this to be true and should therefore
make it so.

However re-reading the referenced discussion I think we might not want
to force it in generic because it might cause unneeded slow-down.

> >  - enter/leave kernelspace implies an mb
> > ?
> 
> On x86, iret is a serializing instruction. However, I haven't found any
> information saying that int 0x80 nor sysenter/sysexit are serializing
> instructions. And there seem to be no explicit mfence in x86 entry_*.S
> (except a 64-bit gs swap workaround). So I'm tempted to answer: no,
> entry/return kernelspace does not seem to imply a mb on x86. 

Right, there's some TIF_flags we can play with, but simply executing the
mb is a much simpler (and clearer) alternative.



