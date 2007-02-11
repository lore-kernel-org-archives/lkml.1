Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbXBKWCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbXBKWCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXBKWCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:02:14 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40515 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbXBKWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:02:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: What are the real ioapic rte programming constraints?
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
Date: Sun, 11 Feb 2007 15:01:20 -0700
In-Reply-To: <Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com> (Zwane
	Mwaikambo's message of "Sun, 11 Feb 2007 08:16:39 -0800 (PST)")
Message-ID: <m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zwane Mwaikambo <zwane@infradead.org> writes:
>
> The 7500 issue isn't actually a race but a disease, if you mask a pending 
> irq in its RTE, the PCI hub generates an INTx message corresponding to 
> that irq. This apparently was done to support booting OSes without APIC 
> support. So the following would occur;
>
> - irqN pending on IOAPIC
> - mask
> => INTx message for irqN
>
> Unfortunately it appears the below code would also be affected by this as 
> well, the appropriate reference is;
>
> 2.15.2 PCI Express* Legacy INTx Support and Boot Interrupt
> http://download.intel.com/design/chipsets/datashts/30262802.pdf

Ouch.  And this kind of thing isn't exactly uncommon.

However if we have the irqs also disabled in the i8259 we should
be safe from actually receiving this interrupt (even if it generates
bus traffic), and when we enable the irq since it is level triggered  
we should still get an interrupt message.

It isn't immediately obvious where the i8259 irq enable/disable
happens.  So i"m having trouble auditing that bit of code.

Plus we can get very strange things like the irq number changing
and the sharing rules being different when going through the i8259.
So irqN may be irqM when going through the i8259.

As long as we aren't using anything on the i8259 including the timer
in ExtINT mode we can disable every interrupt pin and not worry about
interrupts from that source.

Eric
