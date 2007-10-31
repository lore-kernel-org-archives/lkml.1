Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbXJaBfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbXJaBfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXJaBe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:34:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:34766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbXJaBe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C3WY2TWpTJaxUx2YGARejTevAAP2deKBebvb64CKhuO97ktvmkjTSQOqcOYaRCHy+3MfsAkGm9G4O2NnlXmEJ7Twjwf44aiVYsZSbGb6iX02FCwVm9jKMh0/RbVaqmnKS2G6UzLXVCba/RM20QJkuB5yPRxOjei9F+PCvXORYdA=
Message-ID: <c3d0340b0710301834x451d3fa1jb46cdd51d40e225e@mail.gmail.com>
Date: Tue, 30 Oct 2007 17:34:56 -0800
From: "Shawn Jin" <shawnxjin@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Multiple MSI messages support
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org
In-Reply-To: <adaejfci5cz.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c3d0340b0710301413r2607ee08x8b27c5bffa43f1c4@mail.gmail.com>
	 <4727AED2.6010908@garzik.org> <adaejfci5cz.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 30, 2007 2:51 PM, Roland Dreier <rdreier@cisco.com> wrote:
>
>  > > I understand that the current PCI subsystem or linux kernel (x86)
>  > > supports only one message when MSI is enabled even for devices having
>  > > multiple MSI messages. But why? Is this a limitation solely due to the
>  > > OS or due to the x86 APIC?
>  > > I know the current linux kernel (2.6.23) changed MSI message data
>  > > format a little bit to support other architectures. But some older
>  > > version (e.g. 2.6.18) defined a specific format for the MSI msg data
>  > > in a way that 8 bits contain the irq number and the other 8 bits have
>  > > the interrupt attributes, which is x86 specific. Why does the msg data
>  > > need to contain the irq number? Here is my hypothetic explanation. The
>  > > device writes the MSI msg data to the specified MSI msg address. And
>  > > APIC uses the irq number in the msg data to generate appropriate
>  > > interrupt, which of course results in an appropriate ISR invoked. A
>  > > device having multiple MSI messages typically appends some information
>  > > of which MSI message to the msg data field. For example, if the system
>  > > (or OS) configures the MSI msg data as 0x5000, a device having 4 MSI
>  > > messages could write 0x5000, 0x5001, 0x5002, 0x5003 to differentiate
>  > > the MSI messages. However this cannot work with the APIC due to the
>  > > way how APIC asserts interrupts as I described above (if my
>  > > understanding is correct).
>  > > Hence my answer to the question is this is due to the x86 APIC. For
>  > > other architectures such as powerpc this is probably not a problem
>  > > since the interrupt controller is different. Am I correct?
>
>  > IMO it's more like there has never been enough need for anybody to
>  > look into it, I bet...
>
> Actually the original poster's explanation is pretty accurate.  MSI
> imposes a restriction on how a device generates multiple messages,
> since there is only one message data register and the rest of the
> messages must be based on that in a simple way.  And the format of
> "Intel-style" APIC MSI messages does not match up with the way the PCI
> spec generates multiple messages.
>
> In fact at least IBM pSeries boxes seem to be able to use MSI to
> generate multiple interrupts from the same device -- BenH can probably
> give details.
>
> Multiple interrupt messages are supported by Linux via MSI-X (which
> allows each message to have completely different data).

Thanks for confirming this. I found that Windows also allocates only
one MSI message for such device, though I know nobody here is
interested in Windows. :-P This also confirms from another perspective
that supporting only one MSI message is actually due to the APIC
limitation.

>  > The way drivers are written, you are typically must touch a few key
>  > hardware registers _anyway_, so the multiple messages in practice are
>  > not much more useful than the simple fact that your MSI irq handler
>  > function was called (with all that indicates and implies).
>
> For high-performance devices this is not really true.  The InfiniBand
> mthca driver can use MSI to get a single interrupt, or MSI-X to get
> different interrupts for different types of events.  MSI-X allows the
> read of the "interrupt cause register" to be avoided, and this ends up
> making a measurable performance difference for the fast path.

I agree. Accessing HW registers across PCIe is not quite desirable
since it takes relatively long time especially for reads. In some
situation, if multiple MSI messages were supported, even a single
interrupt would handle multiple events and avoid reading some HW
status register to determine the type of event since the message data
has such information. Hence the performance should be improved quite a
bit.

-Shawn.
