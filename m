Return-Path: <linux-kernel-owner+w=401wt.eu-S964907AbXBEXEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907AbXBEXEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXBEXEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:04:16 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36169 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbXBEXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:04:16 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Lu, Yinghai" <yinghai.lu@amd.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Luigi Genoni" <luigi.genoni@pirelli.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>
Subject: Re: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during irq migration.
References: <5986589C150B2F49A46483AC44C7BCA4907416@ssvlexmb2.amd.com>
Date: Mon, 05 Feb 2007 16:03:03 -0700
In-Reply-To: <5986589C150B2F49A46483AC44C7BCA4907416@ssvlexmb2.amd.com>
	(Yinghai Lu's message of "Mon, 5 Feb 2007 12:54:13 -0800")
Message-ID: <m1d54ow6l4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Lu, Yinghai" <yinghai.lu@amd.com> writes:

> -----Original Message-----
> From: ebiederm@xmission.com [mailto:ebiederm@xmission.com] 
> Sent: Monday, February 05, 2007 12:37 PM
>
>
>>The only corner case I can see that might potentially happen is
>>"apic_in_service_vector() != irq_vector[irq]" and if that is the case
>>we don't want to migrate, because the precondition that we are in the
>>irq handler servicing the expected irq isn't true.
>
> Reuse vector could help in that case.

A little but you are still on the wrong cpu, and that corner case might
even be worth looking at on i386.  I haven't assessed what might go wrong
yet but the current strategy of migrating irqs is based in the interrupt
service routine being where new instances of that irq will be
delivered.

What I do know is all of this is a very narrow window, and insanely
hard to trigger with consequences that shouldn't hang the machine.
The only reason we are even getting a reasonable number of irqs being
in service and in the irr is because we are acking a level triggered
vector used by two irqs and then the pending irq retriggers.  Avoiding
that case would certainly be an efficiency improvement.

Basically I think it takes the alignment of several 1 in a million
chances before the code I posted will have problems with this
theoretical case.  

> In another case, if two irq are migrated from one cpu to another cpu.
> ack_apic_edge for irq2 could use get apci_in_servier_vector for irq1,
> and handle that to clear irr for irq1. instead of irq2.

Nope. irq routines are a stack.  if apic_in_service_vector could return
the wrong value.  ack_APIC_irq() which use the same information would
acknowledge the wrong irq.  If there was actually any danger of
mis-computing that information I would just pass it from the interrupt
service routine stash it in a per cpu variable and then read it out.
But the apic already has registers doing that, so I was lazy and used
what was available.  It should be the common case that we need that
information.


Eric
