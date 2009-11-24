Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbZKXWmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbZKXWmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934135AbZKXWmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:42:20 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60954 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934105AbZKXWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:42:19 -0500
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
References: <20091120211139.GB19106@sgi.com>
	<m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com>
	<alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
	<1259069986.4531.1453.camel@laptop>
	<alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
	<20091124065022.6933be1a@infradead.org>
	<m1ws1f6csh.fsf@fess.ebiederm.org> <20091124214121.GA15182@sgi.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Nov 2009 14:42:11 -0800
In-Reply-To: <20091124214121.GA15182@sgi.com> (Dimitri Sivanich's message of "Tue\, 24 Nov 2009 15\:41\:21 -0600")
Message-ID: <m1638z1r5o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich <sivanich@sgi.com> writes:

> On Tue, Nov 24, 2009 at 09:41:18AM -0800, Eric W. Biederman wrote:
>> As for the UV code, what we are looking at is a fundamental irq
>> routing property.  Those irqs cannot be routed to some cpus.  That is
>> something the code that sets up the routes needs to be aware of.
>
> Correct.  We can't allow an interrupt to be routed to an invalid node.
>
>> Dimitri could you put your the extra code in assign_irq_vector instead
>> of in the callers of assign_irq_vector?  Since the probably is not
>> likely to stay unique we probably want to put the information you base
>> things on in struct irq_desc, but the logic I seems to live best in
>> in assign_irq_vector.
>
> So you're saying continue to use the node value in irq_desc, or add
> a cpumask there (which will add some size to that structure)?  I'll
> have to take another look at assign_irq_vector, but as things are
> currently structured, we don't return any sort of valid cpumask that
> we'd need for further processing in the caller functions.  One would
> need to pass that back or store that cpumask someplace, like
> irq_desc?

We have cfg->domain which is the set of cpus the irq was setup to work on.
We don't need an extra return value.

All that is needed is an extra line or two up at the very top.
Something like.
	cpumask_and(requested_mask, mask, irq_possible_cpus_mask);
And then use requested_mask where we use cpumask_and today.

Simple and it doesn't require extra code all over the place.

Eric


