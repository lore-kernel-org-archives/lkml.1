Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbZLFT7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbZLFT7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZLFT7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:59:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224AbZLFT7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:59:18 -0500
Date: Sun, 6 Dec 2009 11:58:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <20091206113555.5a646713@infradead.org>
Message-ID: <alpine.LFD.2.00.0912061144100.3560@localhost.localdomain>
References: <200912052216.19540.rjw@sisk.pl> <200912060055.36130.rjw@sisk.pl> <alpine.LFD.2.00.0912051635330.3560@localhost.localdomain> <200912060254.10081.rjw@sisk.pl> <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
 <20091206113555.5a646713@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Dec 2009, Arjan van de Ven wrote:
> 
> in suspend, there's a PCI device (:1b) that does take some time, which
> is the audio controller. The bulk of the time is in the serio driver
> though..

That serio thing is disgusting. We had serious problems with the serial 
driver timeouts for boot-time optimizations too, didn't we?

I assume that you don't even _use_ that serial port, do you? Or is it open 
for serial console logging or something? If it isn't even open, we 
shouldn't waste any time on the hardware.

Your graph seems to say that serio1 shutdown is roughly from 29.40 to 
29.85, ie almost half a second. That's just bogus. 

I don't see where it comes from, though. It looks like we have

 - pciserial_suspend_ports/serial_pnp_suspend ->
      serial8250_suspend_port ->
        uart_suspend_port ->
          (wait for tx_empty, but only for ASYNC_INITIALIZED, which 
	  shouldn't be true if it's closed, and should be limited to 30ms)
          uart_change_pm ->
            serial8250_pm

and none of them look like they should take anywhere close to half a 
second. So I'm obviously missing something, and your chart didn't include 
the sleep/wakeup pairs.

			Linus
