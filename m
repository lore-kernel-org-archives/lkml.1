Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXA0UzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXA0UzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXA0UzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:55:05 -0500
Received: from www.osadl.org ([213.239.205.134]:38994 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752389AbXA0UzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:55:01 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 27 Jan 2007 21:55:33 +0100
Message-Id: <1169931333.17469.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 18:58 -0800, Linus Torvalds wrote:
> It's been more than a week since -rc5, but I blame everybody (including 
> me) being away for Linux.conf.au and then me waiting for a few days 
> afterwards to let everybody sync up.

Reverting commit 44ade178249fe53d055fd92113eaa271e06acddd
(sky2: power management/MSI workaround) makes the problem go away.

With the commit it breaks sky2 resume on my laptop:

1. request_irq in early resume is triggering:
BUG: sleeping function called from invalid context
at /home/tglx/work/kernel/vanilla/linux-2.6/mm/slab.c:3034

This is easy resolvable by moving the request_irq into the normal resume
path. There is no need to have this in early resume.

2. The network device is unusable after resume. The only way to resurect
it is: rmmod/insmod. 

The reason is, that the driver grabs the normal PCI irq on resume, but
the pci express resume routes it away. All we get is an unhandled
spurious interrupt on the irq line which was used by the net device
before suspend:

irq 219, desc: c045bb80, depth: 0, count: 9607, unhandled: 0
->handle_irq():  c0155c20, handle_bad_irq+0x0/0x1f0
->chip(): c0418920, no_irq_chip+0x0/0x40
->action(): 00000000
  IRQ_DISABLED set
unexpected IRQ trap at vector db

	tglx


