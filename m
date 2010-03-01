Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0CASfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:35:05 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41105 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0CASfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:35:01 -0500
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add arch_probe_nr_irqs() again
References: <20100207210250.GB8256@jenkins.home.ifup.org>
	<tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
	<4B881097.1050505@kernel.org>
	<1267442545.11737.20718.camel@zakaz.uk.xensource.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Mar 2010 10:34:50 -0800
In-Reply-To: <1267442545.11737.20718.camel@zakaz.uk.xensource.com> (Ian Campbell's message of "Mon\, 01 Mar 2010 11\:22\:25 +0000")
Message-ID: <m1d3zn7uwl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <ijc@hellion.org.uk> writes:

> On Fri, 2010-02-26 at 10:19 -0800, Yinghai Lu wrote:
>> 
>> 
>> for x86, with radix tree based irq_to_desc(),
>> removing arch_probe_nr_irqs is intentional. so we get more irq that
>> could be used. 
>
> This sounds interesting for the Xen dom0 use case where we can have
> essentially arbitrary numbers of interrupt sources.
>
> Is there a tree somewhere that I can be looking at?

Ingo's x86 tip tree I imagine.  I think this patch is slated for coming
in sometime this merge window so you should be able to see it
in 2.6.34-rc1.

This is a truly frustrating question.  At this point all of the
practical limitations are in the Xen code itself, and it has been that
way for the last couple of years. Looking at the x86_64 tree it looks
like the core work went in at the end of 2006 about 2.6.19.  Last I
looked the Xen dom0 kernel was stuck at the kernel just before the irq
scaling changes went in.  Every time I look the Xen code is doing
something stupid and unnecessary that makes scaling to large numbers
of irqs hard.

The changes YH is working on are the last couple of changes so that
we can seriously remove NR_IRQs and not have to pay a penalty of
a large static array on small machines when we have a kernel built
to support large machines and a large number of interrupts.

As of 2.6.33 the limitations in DomU support are:
- xen_evtchn_do_upcall starts with the irq number instead of
  the irq_desc, and happens to unnecessarily call into arch
  specific code.  
- Xen has an array irq_info[NR_IRQS] one of the last static arrays
  sized at NR_IRQs in the entire kernel.

One of the big reasons Xen dom0 irq support was not merged was because
merging it would effectively be a revert of the irq scaling work.

If you can fix the Xen code so it isn't dragging the rest of the
kernel down when it comes to large numbers of irqs more power to you.
For now I will continue to write little patches every once in a while
that bonk Xen domU on the head when something Xen domU is doing becomes a
bottleneck for the rest of the kernel.

Eric
