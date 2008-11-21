Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYKUEgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYKUEgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYKUEf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 23:35:56 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50068 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYKUEfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 23:35:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
References: <patchbomb.1226603398@abulafia.goop.org>
	<d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
	<20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org>
	<m1y6ze87w6.fsf@frodo.ebiederm.org> <4925D762.6040406@goop.org>
	<m1prkpj3nl.fsf@frodo.ebiederm.org> <49260BE7.1080909@goop.org>
Date: Thu, 20 Nov 2008 20:27:21 -0800
In-Reply-To: <49260BE7.1080909@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 20 Nov 2008 17:16:23 -0800")
Message-ID: <m1tza1hffa.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2866]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

>
> Yes, I suppose we can statically partition the irq space.  In fact the original
> 2.6.18-xen dom0 kernel does precisely that, but runs into limitations because of
> the compile-time limit on NR_IRQS in that kernel.  If we move to a purely
> dynamically allocated irq space, then having a sparse allocation if irqs becomes
> reasonable again, for msis and vectorless Xen interrupts.
>
>> The difference is that the xen sources are not delivered using vectors.  The cpu
>> vector numbers we do hide and treat as an implementation detail.  And I am totally
>> happy not going through the vector allocation path.
>>
>
> Right.  And in the physical irq event channel case, the vector space is managed
> by Xen, so we need to use Xen to allocate the vector, then program that into the
> appropriate place in the ioapic.

We should be able to share code with iommu for irqs handling, at first glance you
are describing a pretty similar problem.  Now I don't know think the interrupt
remapping code is any kind of beauty but that seems to be roughly what you
are doing with Xen domU.  I certainly think with some careful factoring
we can share the ioapic munging code.  And the code to pick how we program
the ioapics.

>> My gut feel says that you just want to use a different set of irq operations when
>> doing Xen native and working with hardware interrupts.  I haven't seen the code so
>> I don't know how you interact there.  Except in dom0 this is not a consideration so
>> I don't how it is handled.
>>
>
> Yeah.  In the domU case, where there's no physical interrupts, the Xen code
> completely avoids the ioapic/vector stuff, and directly converts an event
> channel into an irq.  Indeed, physical irq delivery is handled the same way; its
> just that the setup requires touching the ioapics to program the appropriate
> vector and bind it to an event channel.

Reasonable.  A lot like the intel interrupt remapping code in that respect.  The
message we program in has little to do with the vector the interrupt arrives on.

So I don't quite know where to hook it but if we are careful we should be able
to get a good interrupt mapping.

Eric
