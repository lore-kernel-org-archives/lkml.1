Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXJCWD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXJCWD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 18:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbXJCWDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 18:03:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:39434 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbXJCWDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 18:03:47 -0400
Subject: Re: MSI problem since 2.6.21 for devices not providing a mask in
	their MSI capability
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Loic Prylli <loic@myri.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <m14ph7amxq.fsf@ebiederm.dsl.xmission.com>
References: <470405BB.2000208@myri.com>
	 <m14ph7amxq.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 08:03:12 +1000
Message-Id: <1191448992.22572.110.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> We should also be leaving the INTx irqs disabled.  So no irq
> should be generated.
> 
> If you have a mask bit implemented you are required to be
> able to refire it after the msi is enabled.  I don't recall
> the requirements for when both intx and msi irqs are both
> disabled.  Intuitively I would expect no irq message to
> be generated, and at most the card would need to be polled
> manually to recognize a device event happened.
> 
> Certainly firing an irq and having it get completely lost is
> unfortunate, and a major pain if you are trying to use the
> card.
> 
> As for the previous no-op behavior that was a bug.

Well, yes and no ... A valid option here would be to use soft-masking,
which is possible because MSIs are edge interrupts. That is, basically,
when masked, just ignore them and set IRQF_PENDING, and when unmasked,
replay (which can be done with softirq if there is no HW mechanism for
that). The genirq code contains all the necessary infrastructure for
doing that stuff, it's fairly trivial, and would probably avoid stepping
in HW lalaland (how much do you bet HW generally get that masking thing
wrong ?)

> The PCI spec requires disabling/masking the msi when reprogramming it.
> So as a general rule we can not do better.  Further because we are
> writing to multiple pci config registers the only way we can safely
> reprogram the message is with the msi disabled/masked on the card in
> some fashion.

Hrm... all right, that will be an issue, so migration need a real
masking.

> I suspect what needs to happen is a spec search to verify that the
> current linux behavior is at least reasonable within the spec.
> 
> Once we have verified that the generic code can not do better.
> We can look at work-arounds.   One possibility is for the generic
> code to provide some overrides for the methods for masking and
> reading/writing to a msi message.
> 
> I don't want to break anyones hardware, but at the same time I want us
> to be careful and in spec for the default case.

Ben.


