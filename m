Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYIPUrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYIPUrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYIPUq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:46:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55212 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751417AbYIPUqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:46:55 -0400
Date: Tue, 16 Sep 2008 15:46:54 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080916204654.GA3532@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu> <20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916082448.GA17287@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 10:24:48AM +0200, Ingo Molnar wrote:
> 
> * Dean Nelson <dcn@sgi.com> wrote:
> 
> > > while i understand the UV_BAU_MESSAGE case (TLB flushes are 
> > > special), why does sgi-gru and sgi-xp need to go that deep? They are 
> > > drivers, they should be able to make use of an ordinary irq just 
> > > like the other 2000 drivers we have do.
> > 
> > The sgi-gru driver needs to be able to allocate a single irq/vector 
> > pair for all CPUs even those that are not currently online. The sgi-xp 
> > driver has similar but not as stringent needs.
> 
> why does it need to allocate a single irq/vector pair? Why is a regular 
> interrupt not good?

When you speak of a 'regular interrupt' I assume you are referring to simply
the irq number, with the knowledge of what vector and CPU(s) it is mapped to
being hidden?


    sgi-gru driver

The GRU is not an actual external device that is connected to an IOAPIC.
The gru is a hardware mechanism that is embedded in the node controller
(UV hub) that directly connects to the cpu socket. Any cpu (with permission)
can do direct loads and stores to the gru. Some of these stores will result
in an interrupt being sent back to the cpu that did the store.

The interrupt vector used for this interrupt is not in an IOAPIC. Instead
it must be loaded into the GRU at boot or driver initialization time.

The OS needs to route these interrupts back to the GRU driver interrupt
handler on the cpu that received the interrupt. Also, this is a performance
critical path. There should be no globally shared cachelines involved in the
routing.

The actual vector associated with the IRQ does not matter as long as it is
a relatively high priority interrupt. The vector does need to be mapped to
all of the possible CPUs in the partition. The GRU driver needs to know
vector's value, so that it can load it into the GRU.

    sgi-xp driver

The sgi-xp driver utilizes the node controller's message queue capability to
send messages from one system partition (a single SSI) to another partition.

A message queue can be configured to have the node controller raise an
interrupt whenever a message is written into it. This configuration is
accomplished by setting up two processor writable MMRs located in the
node controller. The vector number and apicid of the targeted CPU need
to be written into one of these MMRs. There is no IOAPIC associated with
this.

So one thought was that, once insmod'd, sgi-xp would allocate a message queue,
allocate an irq/vector pair for a CPU located on the node where the message
queue resides, and then set the MMRs with the memory address and length of the
message queue and the vector and CPU's apicid. And then repeat, as there are
actually two message queues required by this driver.


I hope this helps answer your question, or at least shows you what problem
we are trying to solve.

Thanks,
Dean

