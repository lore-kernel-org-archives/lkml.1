Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbXJKCNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbXJKCNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 22:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbXJKCNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 22:13:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:30565 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbXJKCNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 22:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=afDgTcqic0InoGbN03/G5fSSBxG8f/EtGMb8acxjGUuY9NC7DJuXPw9NqCjccue3+z0Xc3FwcMIEOQbi0XDQODvl3O6WYLFYCINqnpCJ7cyyemlAdo/VRXootJqcXmmKYZNHgv4MokDFkjUsnsTnmUEqAMCOEuhtnP+5Pdk85LI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [QUESTION] I need advice for writing .suspend/.resume functions
Date: Thu, 11 Oct 2007 05:13:10 +0200
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710110513.10753.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have few questions about .suspend()/.resume() driver functions and how best to write them.

I have written a support for suspend/resume for saa7134 v4l driver.
Now looking at code again and again, I found few problems, and I am seeking your advice how to fix them.

First of all the .suspend() function:

Looking at various drivers (including v4l ones) it seems that in general the function:

1) tells upper layers that it is suspended
2) saves the state of device
(generally there is nothing to save, since the driver maintains a copy of device state in memory)

3) disables the device (including DMA)
4) does usual pci_save_state+pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state))
(I am talking about pci devices of course)

But there is one problem that my .suspend() function have together with quite a lot of drivers:
It can race with IRQ handler. Suppose the handler is called just before .suspend(), and thus .suspend() literally 
pulls the hadware from that handler.

I was told that I should use synchronize_irq(), and it looks exactly like the solution.
But I was surprised to see that very few drivers use it in their .suspend() routines.

Another issue, even bigger happens during the resume:
Suppose the IRQ line is shared with some other device and it gets resumed first.
And my IRQ handler is called because of the other device.
Now my IRQ handler can't determine whenever the IRQ for the device, since the hardware is still powered off.

Probably I can fix the following issues doing this:

1) do free_irq() in .suspend(), and request_irq() in .resume
this solves both problems since free_irq()  calls synchronize_irq()
Few drivers do that this way. I would like to know if this is the right way.


2) Disable the card's IRQ register , then call synchronize_irq(), at that point I can be sure that no IRQ handler is running and will run
then set some per device flag say dev->insuspend

let IRQ handler check this flag, and bail out if set, so false interrupts are caught on resume
Probably not a good idea, since I didn't find such implementation in kernel


Best regards,
	Maxim levitsky

