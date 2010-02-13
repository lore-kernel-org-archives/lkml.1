Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0BMERR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 23:17:17 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39038 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab0BMERQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 23:17:16 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B762137.4050604@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 12 Feb 2010 20:17:05 -0800
In-Reply-To: <4B762137.4050604@zytor.com> (H. Peter Anvin's message of "Fri\, 12 Feb 2010 19\:49\:11 -0800")
Message-ID: <m1k4uhrcqm.fsf@fess.ebiederm.org>
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

> On 02/12/2010 07:44 PM, Eric W. Biederman wrote:
>> 
>> Thanks for keeping this work alive.
>> 
>
> Indeed.  I am hoping to put this in tip tomorrow or so.
>
>> I just skimmed through do_IRQ and I happened to notice that
>> we have an unnecessary inefficiency that using a radix tree for
>> irq_to_desc will magnify.
>> 
>> handle_irq should take an struct irq_desc * instead of a unsigned int irq.
>> 
>> and the per cpu vector_irq array should become a per cpu vector_desc array.
>> 
>> As soon as irq_to_desc is more than &irq_desc[irq] this saves us work
>> and cache line misses  at the cost of a simple code cleanup.
>
> Good catch.  I haven't looked through the details yet, but I presume
> this can be done on top of this changeset?

Codewise the changes should be completely independent.



Probably the trickiest bit is that drivers/xen/events.c calls handle_irq
and makes handle_irq on ia64 a wrapper for __do_IRQ.

Jeremy is there any good reason why drivers/xen/events.c does not just do:

desc = irq_to_desc(irq);
if (desc)
	generic_handle_irq_desc(irq, desc);

And instead introduces a weird one-off xen specific multi-arch function?


Eric
