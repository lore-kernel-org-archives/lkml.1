Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878Ab0AHUKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab0AHUKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079Ab0AHUKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:10:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38454 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0AHUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:10:34 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
	<1262951595-1729-5-git-send-email-yinghai@kernel.org>
	<m1bph4o1il.fsf@fess.ebiederm.org> <4B4785C3.4030505@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 08 Jan 2010 12:10:27 -0800
In-Reply-To: <4B4785C3.4030505@zytor.com> (H. Peter Anvin's message of "Fri\, 08 Jan 2010 11\:21\:39 -0800")
Message-ID: <m1my0oici4.fsf@fess.ebiederm.org>
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

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 01/08/2010 11:11 AM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>> 
>>> that is max number on run time.
>> 
>> Ouch!  Unless I misread this code this will leave nr_irqs at
>> NR_IRQS_LEGACY. aka 16.

I goofed and misread this.  I was looking at nr_irqs_gsi which
is initialized to 16.

We actually initialize nr_irqs to NR_IRQS, which has an unfortunately
convoluted formula, that winds up being 8*NR_CPUS or 32 *MAX_IO_APICS.
in the extreme cases.

Since there are still arrays sized at NR_IRQS (bleh) we can not
increase nr_irqs to be greater than NR_IRQS.

So YN can you do the simple thing here and simply remove
arch_probe_nr_irqs().  Sane code doesn't care how big nr_irqs is and
code that does care needs to be fixed.

>> Let's do something stupid and simple.
>> nr_irqs = nr_cpus_ids * 256;  /* Semi-arbitrary number */
>
> This would be 1048576 on the biggest machines we currently support.
> Now, the number of IRQ *vectors* is limited to
> (224-system vectors)*(cpu count), so one could argue that if there is
> anything that is not semi-arbitrary it would be that number, but that
> doesn't account for vector sharing.

Except we have irq sources that we know about that are never utilized,
Think of unconnected inputs to ioapics.

I don't know if we ever actually perform vector sharing.  The only case
I recall where the code could share vectors is if the firmware tables
told us to irq sources were the same interrupt.  I don't think that
happens.  We do have the remains of support for vector sharing
in the code but I don't think it is utilized.  MSI interrupts certainly
can not share vectors.

My point with the semi-arbitrary number is that we should not think of
nr_irqs as something defined by the resources of the receivers of
interrupts.  NR_IRQS has never been that.  nr_irqs really is a limit
on how many interrupt sources we have.

> Do we have any place which requires nr_irqs to be *stable*, or can we
> simply treat it as a high water mark for IRQ numbers used?

We have several loops that walk through the irq descriptors and look for
an unbound irq.  Which means having nr_irqs as a high water mark is not
going to work today.

>> Ideally we would set "nr_irqs = 0x7fffffff;" but we have just enough
>> places using nr_irqs that I think those loops would get painful if we
>> were to do that.
>
> Ideally we should presumably get rid of nr_irqs completely?

Yes.  It was enough of a pain the first pass at it that we wound
up with nr_irqs, a value that can vary at boot time.

Once YH's radix tree changes get it in.  A war on NR_IRQS and nr_irqs
seems appropriate.

Eric
