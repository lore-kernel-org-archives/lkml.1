Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633Ab0ALC10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab0ALC10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620Ab0ALC1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:27:25 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59631 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab0ALC1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:27:24 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	<4B47E7A9.6090904@zytor.com>
	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>
	<4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>
	<4B4BB0B7.3000106@zytor.com>
	<1263254812.2859.890.camel@sbs-t61.sc.intel.com>
	<4B4BBEBA.4060403@zytor.com> <m17hro6ua9.fsf@fess.ebiederm.org>
	<4B4BC401.6010605@zytor.com> <m1k4vo144h.fsf@fess.ebiederm.org>
	<4B4BDBBA.3090406@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 Jan 2010 18:27:18 -0800
In-Reply-To: <4B4BDBBA.3090406@zytor.com> (H. Peter Anvin's message of "Mon\, 11 Jan 2010 18\:17\:30 -0800")
Message-ID: <m18wc412ih.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 01/11/2010 05:52 PM, Eric W. Biederman wrote:
>> 
>> After having the documentation quoted at me.  I am having a distinct
>> memory of one piece of documentation saying:
>> "interrupts within a priority level can be delivered in any order"
>> 
>> So I am guessing there is not any ordering of interrupts in the same
>> priority level until they get to the local apic.
>> 
>
> There is no ordering of interrupts before they hit the local APIC, since
> the local APIC is what would serialize them...

The two wire bus that the all came across would serialize them.
I'm not certain how much of that was preserved with front-side
bus delivery.

>
>> What guarantee we need is the interesting question.
>> 
>> The cleanup ipi is sent when we have seen an interrupt arrive at it's
>> newly configured location.  It is possible that there is still an
>> interrupt in flight to the old configured location (think NUMA where
>> the interrupt has been migrated from off node to on node).  We want
>> the guarantee that the ipi arrives after the inflight irq.  Which
>> means on the wire ordering as well as in the local apic ordering is
>> interesting.
>
> I don't think there is any such guarantee possible, but that that has
> nothing to do with the interrupt priority.  Suresh tells me that that is
> handled by detecting and re-posting the migration IRQ.

The re-posting should only be for the case where we are migrating more
than one irq at a time.


>> I am slammed with other stuff right now so I don't think I will have
>> time to find the old documentation I was looking at for a couple of
>> more days.
>
> I'm wondering if what you're thinking of are the really old LAPICs which
> could only remember two pending interrupts per priority level?

Not precisely, but it could easily be something similar.


Eric
