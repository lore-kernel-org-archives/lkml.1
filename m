Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYE1QLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYE1QLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYE1QKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:10:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48777 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYE1QKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:10:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
References: <483B34CA.8000600@goop.org> <20080527083729.GF29246@elte.hu>
	<483BD843.5080009@goop.org> <20080527145606.GB24457@elte.hu>
	<483C35AA.5060102@goop.org> <m1ve0yai0j.fsf@frodo.ebiederm.org>
	<483D3697.1070702@goop.org>
Date: Wed, 28 May 2008 09:04:19 -0700
In-Reply-To: <483D3697.1070702@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 28 May 2008 11:40:23 +0100")
Message-ID: <m13ao28lfg.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1742]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Question about interrupt routing and irq allocation
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> - I think using create_irq is a good step.
>> - I think all vectors are wasted in the case of Xen.
>>
>
> The case I'm discussing now is in hvm domains - ie, fully virtualized PC
> platform. I'm adding a driver to poke a hole through all the emulated hardware
> to get directly to the underlying Xen layer so that we can run paravirtual
> drivers to get better performance. Only the irqs associated with pv drivers will
> waste their vectors.

I see. The fully virtualized machine case.  So we do have apics
visible to us.

>> - I think we want a individual irq for each xen irq source.
>>   Sparc already does a demux in similar circumstances with
>>   a queue of received MSI messages an a single cpu irq
>>   that these get demuxed from.
>>   If we don't have individual irqs per drivers it will be hard
>>   to share a source base with native drivers.
>>
>
> In this case the sharing is between fully paravirtualized paravirt_ops Xen and
> pv-on-hvm drivers. In general I want those drivers to look as normal as
> possible, so they should use irqs in a normal way.

Right.  We should be able to assume that the native irqs for
those devices are not shared, and we should be able to extend
that property (among others) to the virtualzed irqs for the
devices.

Under other hypervisors sparc, ppc we can run unmodified pci
drivers just the OS platform code changes.  How close to that
can we come in the Xen case?

I think running unmodified drivers with the OS platform code doing
the adaption should be the goal, unless there is a real need for
the driver to know about Xen.  Is that compatible with what you
are trying to achieve?

>> - I think it would be very nice if we could get irqs allocated
>>   in request_irq instead of create_irq (and equivalents).
>>
>
> Something along the lines of passing -1 as the irq, and it would return the
> allocated irq? It's not clear to me how all that would fit together.

Groan.  I mispoke.  I meant:
- I think it would be very nice if we could get vectors allocated
  in request_irq instead of in create_irq (and equivalents).

Just delayed vector allocation.  I wasn't after something driver
visible.

>> - I think ultimately it makes sense to port the per vector
>>   code to 32bit linux.  On single cpu systems the cost should
>>   be just a hair more code, but no extra data structures.  We
>>   can easily restrict the irq allocation to allocating the same
>>   vector on all cpus for any old machines that prove flaky with
>>   irq migration.
>>
>>   The code between the two architectures we kept fairly close
>>   in sync when I worked on it so a merge should not be a big deal.
>
> Well, if I find myself at a loose end, I'll have a look at it.

Thanks.

Eric

