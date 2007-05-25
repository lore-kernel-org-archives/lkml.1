Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbXEYWAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbXEYWAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbXEYWAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:00:34 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbXEYWAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:00:33 -0400
Date: Fri, 25 May 2007 15:00:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Mattia Dongili <malattia@linux.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stuart Hayes <stuart_hayes@dell.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [2.6.22-rc1-mm1] ehci-hcd - BUG: scheduling while atomic:
 rmmod/0x00000001/4568
Message-Id: <20070525150015.b5eaafc3.akpm@linux-foundation.org>
In-Reply-To: <20070525214005.GA6925@suse.de>
References: <20070521024437.GA4751@inferi.kami.home>
	<20070525214005.GA6925@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 14:40:05 -0700 Greg KH <gregkh@suse.de> wrote:

> On Mon, May 21, 2007 at 11:44:37AM +0900, Mattia Dongili wrote:
> > Hello,
> > 
> > with gregkh-usb-usb-ehci-cpufreq-fix.patch removing ehci-hcd causes the
> > following BUG:
> 
> Thanks for letting me know.
> 
> Stuart, any help here?

pretty obvious.  cpufreq_unregister_notifier() sleeps, and that patch
causes it to be called under spinlock.

Something like this...

--- a/drivers/usb/host/ehci-hcd.c~fix-gregkh-usb-usb-ehci-cpufreq-fix
+++ a/drivers/usb/host/ehci-hcd.c
@@ -452,14 +452,14 @@ static void ehci_stop (struct usb_hcd *h
 	if (HC_IS_RUNNING (hcd->state))
 		ehci_quiesce (ehci);
 
-#ifdef CONFIG_CPU_FREQ
-	cpufreq_unregister_notifier(&ehci->cpufreq_transition,
-				    CPUFREQ_TRANSITION_NOTIFIER);
-#endif
 	ehci_reset (ehci);
 	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
 	spin_unlock_irq(&ehci->lock);
 
+#ifdef CONFIG_CPU_FREQ
+	cpufreq_unregister_notifier(&ehci->cpufreq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+#endif
 	/* let companion controllers work when we aren't */
 	ehci_writel(ehci, 0, &ehci->regs->configured_flag);
 
_

