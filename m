Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbZLDXMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbZLDXMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932506AbZLDXMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:12:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56349 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbZLDXMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:12:20 -0500
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>
References: <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
	<20091124065022.6933be1a@infradead.org>
	<m1ws1f6csh.fsf@fess.ebiederm.org>
	<20091125074033.4c46c1b0@infradead.org>
	<20091203165004.GA14665@sgi.com>
	<Pine.WNT.4.64.0912030851500.13880@ppwaskie-MOBL2.amr.corp.intel.com>
	<20091203170149.GA15151@sgi.com>
	<Pine.WNT.4.64.0912030905530.16084@ppwaskie-MOBL2.amr.corp.intel.com>
	<20091203171946.GC15151@sgi.com>
	<Pine.WNT.4.64.0912031048590.8104@ppwaskie-MOBL2.amr.corp.intel.com>
	<20091204164227.GA28378@sgi.com> <1259961477.23199.39.camel@localhost>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 04 Dec 2009 15:12:14 -0800
In-Reply-To: <1259961477.23199.39.camel@localhost> (Peter P. Waskiewicz, Jr.'s message of "Fri\, 04 Dec 2009 13\:17\:57 -0800")
Message-ID: <m1eina9vw1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com> writes:

>
>> > 
>> > > 
>> > > Also, can we add a restricted mask as I mention above into this scheme?  If we can't send an IRQ to some node, we don't want to bother attempting to change affinity to cpus on that node (hopefully code in the kernel will eventually restrict this).
>> > > 
>> > 
>> > The interface allows you to put in any CPU mask.  The way it's written 
>> > now, whatever mask you put in, irqbalance *only* balances within that 
>> > mask.  It won't ever try and go outside that mask.
>> 
>> OK.  Given that, it might be nice to combine the restricted cpus that I'm describing with your node_affinity mask, but we could expose them as separate masks (node_affinity and restricted_affinity, as I describe above).
>> 
>
> I think this might be getting too complicated.  The only thing
> irqbalance is lacking today, in my mind, is the feedback mechanism,
> telling it what subset of CPU masks to balance within.

You mean besides knowing that devices can have more than one irq?
You mean besides making good on it's promise not to move networking
irqs?  A policy of BALANCE_CORE sure doesn't look like a policy of
don't touch.
You mean besides realizing that irqs can only be directed at one cpu on
x86?  At least when you have more than 8 logical cores in the system, the
cases that matter.

> There is a
> allowed_mask, but that is used for a different purpose.  Hence why I
> added another.  But I think your needs can be met 100% with what I have
> already, and we can come up with a different name that's more generic.
> The flows would be something like this:

Two masks?  You are asking the kernel to move irqs for you then?

> Driver:
> - Driver comes online, allocates memory in a sensible NUMA fashion
> - Driver requests kernel for interrupts, ties them into handlers
> - Driver now sets a NUMA-friendly affinity for each interrupt, to match
> with its initial memory allocation
> - irqbalance balances interrupts within their new "hinted" affinities.
>
> Other:
> - System comes online
> - In your case, interrupts must be kept away from certain CPUs.
> - Some mechanism in your architecture init can set the "hinted" affinity
> mask for each interrupt.
> - irqbalance will not move interrupts to the CPUs you left out of the
> "hinted" affinity.
>
> Does this make more sense?


>> > > As a matter of fact, driver's allocating rings, buffers, queues on other nodes should optimally be made aware of the restriction.
>> > 
>> > The idea is that the driver will do its memory allocations for everything 
>> > across nodes.  When it does that, it will use the kernel interface 
>> > (function call) to set the corresponding mask it wants for those queue 
>> > resources.  That is my end-goal for this code.
>> > 
>> 
>> OK, but we will eventually have to reject any irqbalance attempts to send irqs to restricted nodes.
>
> See above.

Either I am parsing this conversation wrong or there is a strong
reality distortion field in place.  It appears you are asking that we
depend on a user space application to not attempt the physically
impossible, when we could just as easily ignore or report -EINVAL to.

We really have two separate problems hear.
- How to avoid the impossible.
- How to deal with NUMA affinity.

Eric

