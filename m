Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbXBFLRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbXBFLRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXBFLRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:17:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39434 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbXBFLRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:17:42 -0500
Date: Tue, 6 Feb 2007 11:30:23 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>, akpm@osdl.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, drzeus-wbsd@drzeus.cx,
       wbsd-devel@list.drzeus.cx
Subject: [PATCH] kernel: shut up the IRQ mismatch messages (Re: wbsd: IRQ
 handler type mismatch)
Message-ID: <20070206113023.3c845bb2@localhost.localdomain>
In-Reply-To: <45C7F32B.1060402@shaw.ca>
References: <45C7F32B.1060402@shaw.ca>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Feb 2007 21:16:59 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> I'm seeing this on bootup on my laptop with recent kernels (currently 
> 2.6.20-rc6-mm3):

The problem is various drivers legally validly and sensibly try to claim
IRQs but the kernel insists on vomiting forth a giant irrelevant
debugging spew when the types clash.

Edit kernel/irq/manage.c go down to mismatch: in setup_irq() and ifdef
out the if clause that checks for mismatches. It'll then just do the
right thing and work sanely.

For the current -mm kernel this will do the trick (and moves it into
shared irq debugging as in debug mode the info spew is useful). I've had
a variant of this in my private tree for some time as I got fed up on the
mess on boxes where old legacy IRQs get reused.

Signed-off-by: Alan Cox <alan@redhat.com>

--- linux.vanilla-2.6.20-rc6-mm3/kernel/irq/manage.c	2007-01-31 14:20:43.000000000 +0000
+++ linux-2.6.20-rc6-mm3/kernel/irq/manage.c	2007-02-06 11:01:00.796928504 +0000
@@ -372,12 +372,14 @@
 	return 0;
 
 mismatch:
+#ifdef CONFIG_DEBUG_SHIRQ
 	if (!(new->flags & IRQF_PROBE_SHARED)) {
 		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
 		if (old_name)
 			printk(KERN_ERR "current handler: %s\n", old_name);
 		dump_stack();
 	}
+#endif	
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return -EBUSY;
 }
