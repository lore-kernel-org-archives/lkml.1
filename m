Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbXJ3WvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbXJ3WvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbXJ3WvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:51:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:14710 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbXJ3WvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:51:10 -0400
X-IronPort-AV: E=Sophos;i="4.21,349,1188802800"; 
   d="scan'208";a="244676469"
To: Jeff Garzik <jeff@garzik.org>
Cc: Shawn Jin <shawnxjin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Multiple MSI messages support
X-Message-Flag: Warning: May contain useful information
References: <c3d0340b0710301413r2607ee08x8b27c5bffa43f1c4@mail.gmail.com>
	<4727AED2.6010908@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Oct 2007 15:51:08 -0700
In-Reply-To: <4727AED2.6010908@garzik.org> (Jeff Garzik's message of "Tue, 30 Oct 2007 18:23:14 -0400")
Message-ID: <adaejfci5cz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Oct 2007 22:51:08.0672 (UTC) FILETIME=[5C63A000:01C81B47]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > If this is really off-topic here, I apologize first. But I cannot
 > > think a better place to ask this particular question.
 > > I understand that the current PCI subsystem or linux kernel (x86)
 > > supports only one message when MSI is enabled even for devices having
 > > multiple MSI messages. But why? Is this a limitation solely due to the
 > > OS or due to the x86 APIC?
 > > I know the current linux kernel (2.6.23) changed MSI message data
 > > format a little bit to support other architectures. But some older
 > > version (e.g. 2.6.18) defined a specific format for the MSI msg data
 > > in a way that 8 bits contain the irq number and the other 8 bits have
 > > the interrupt attributes, which is x86 specific. Why does the msg data
 > > need to contain the irq number? Here is my hypothetic explanation. The
 > > device writes the MSI msg data to the specified MSI msg address. And
 > > APIC uses the irq number in the msg data to generate appropriate
 > > interrupt, which of course results in an appropriate ISR invoked. A
 > > device having multiple MSI messages typically appends some information
 > > of which MSI message to the msg data field. For example, if the system
 > > (or OS) configures the MSI msg data as 0x5000, a device having 4 MSI
 > > messages could write 0x5000, 0x5001, 0x5002, 0x5003 to differentiate
 > > the MSI messages. However this cannot work with the APIC due to the
 > > way how APIC asserts interrupts as I described above (if my
 > > understanding is correct).
 > > Hence my answer to the question is this is due to the x86 APIC. For
 > > other architectures such as powerpc this is probably not a problem
 > > since the interrupt controller is different. Am I correct?

 > IMO it's more like there has never been enough need for anybody to
 > look into it, I bet...

Actually the original poster's explanation is pretty accurate.  MSI
imposes a restriction on how a device generates multiple messages,
since there is only one message data register and the rest of the
messages must be based on that in a simple way.  And the format of
"Intel-style" APIC MSI messages does not match up with the way the PCI
spec generates multiple messages.

In fact at least IBM pSeries boxes seem to be able to use MSI to
generate multiple interrupts from the same device -- BenH can probably
give details.

Multiple interrupt messages are supported by Linux via MSI-X (which
allows each message to have completely different data).

 > The way drivers are written, you are typically must touch a few key
 > hardware registers _anyway_, so the multiple messages in practice are
 > not much more useful than the simple fact that your MSI irq handler
 > function was called (with all that indicates and implies).

For high-performance devices this is not really true.  The InfiniBand
mthca driver can use MSI to get a single interrupt, or MSI-X to get
different interrupts for different types of events.  MSI-X allows the
read of the "interrupt cause register" to be avoided, and this ends up
making a measurable performance difference for the fast path.

Also, obviously, having multiple interrupts means you can bind
different interrupts to different CPUs, which will become very
important if/when things like multi-queue NICs are supported.

 - R.
