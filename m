Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYGCMOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYGCMOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbYGCMOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:14:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:19682 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbYGCMOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:14:06 -0400
Message-ID: <aec7e5c30807030323y51cffd78x6ea1727796e90b62@mail.gmail.com>
Date: Thu, 3 Jul 2008 19:23:34 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] uio: User IRQ Mode
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, hjk@linutronix.de, lethal@linux-sh.org,
       tglx@linutronix.de
In-Reply-To: <20080702121153.4d464885@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
	 <20080702121153.4d464885@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Alan,

On Wed, Jul 2, 2008 at 8:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 02 Jul 2008 19:59:51 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
>>
>> This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
>> is responsible for acknowledging and re-enabling the interrupt.
>> Shared interrupts are not supported by this mode.
>
> This doesn't work even for some non shared interrupts.
>
> If I take a level triggered interrupt then the IRQ handler code must
> clear the IRQ before the line can be unmasked.
>
> It might work for edge triggered providing you don't get too many edges
> before you respond (in which case we will decide its a stuck IRQ and turn
> it off for good).

Below is a little description of how this is supposed to work, see
point 5, 8, 9.

--- Regular in-kernel driver approach ---

1. hardware device signals the processor
   -> interrupt signal to interrupt controller gets asserted

2. interrupt controller passes through interrupt signal
   the source is enabled so the interrupt controller does not mask
   -> interrupt signal to processor gets asserted

3. processor saves context and starts executing kernel interrupt code
   the processor will mask interrupts for this certain interrupt level

4. mask_ack_irq()
   this modifies the state of the interrupt controller
   -> interrupt signal to processor is no longer asserted

5. kernel interrupt handler acknowledges interrupt
   this modifies the state of the hardware device
   -> interrupt signal to interrupt controller is no longer asserted

6. unmask_irq() - unmask interrupt controller
   this modifies the state of the interrupt controller
   -> interrupt signal to processor is let through, but is no longer asserted

7. processor restores context
   this will unmask interrupts for the current interrupt level

--- UIO "User IRQ Mode" approach ---

1. hardware device signals the processor
   -> interrupt signal to interrupt controller gets asserted

2. interrupt controller passes through interrupt signal
   the source is enabled so the interrupt controller does not mask
   -> interrupt signal to processor gets asserted

3. processor saves context and starts executing kernel interrupt code
   the processor will mask interrupts for this certain interrupt level

4. mask_ack_irq()
   this modifies the state of the interrupt controller
   -> interrupt signal to processor is no longer asserted

5. kernel interrupt handler _disables_ interrupts, notifies user space
   this may modify the state of the interrupt controller
   -> interrupt signal from device to interrupt controller is still asserted
   -> interrupt source is still masked by interrupt controller

6. unmask_irq() - unmask interrupt controller
   this may modify the sate of the interrupt controller
   -> interrupt source is still masked by interrupt controller

7. processor restores context
   this will unmask interrupts for the current interrupt level
   -> interrupt signal from device to interrupt controller is still asserted
   -> interrupt source is still masked by interrupt controller

8. user space driver get scheduled, acknowledges interrupt
   this modifies the state of the hardware device
   -> interrupt signal from device to interrupt controller gets deasserted
   -> interrupt source is still masked by interrupt controller

9. user space driver uses write() to re-enable the interrupt
   this modifies the state of the interrupt controller
   -> interrupt source is no longer masked by interrupt controller

Hope this clarifies a bit. Thank for your feedback!

/ magnus
