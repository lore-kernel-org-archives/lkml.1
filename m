Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbXE2PYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbXE2PYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXE2PYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:24:12 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:59911 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXE2PYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:24:11 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 11:24:11 EDT
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=XzNKYLxRFYK3EK2q7u6va15YW9lSAlAlMChUm8JLquD+ER54CbNO4y2aMN+8xbMzt/f6DaI4TDcQ4TWQ4oH4j4e+E3eW5b3umIBpiLCu4j15c7m48VRv3suvgnCOY039;
X-IronPort-AV: E=Sophos;i="4.14,589,1170655200"; 
   d="scan'208";a="275781087"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.22-rc1-mm1] ehci-hcd - BUG: scheduling while atomic: rmmod/0x00000001/4568
Date: Tue, 29 May 2007 10:14:35 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9524D51@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <20070525150015.b5eaafc3.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.22-rc1-mm1] ehci-hcd - BUG: scheduling while atomic: rmmod/0x00000001/4568
Thread-Index: AcefGBpgDz3Tb61dTcuCogNSiM7QgQC69Qng
References: <20070521024437.GA4751@inferi.kami.home><20070525214005.GA6925@suse.de> <20070525150015.b5eaafc3.akpm@linux-foundation.org>
From: <Stuart_Hayes@Dell.com>
To: <gregkh@suse.de>
Cc: <malattia@linux.it>, <linux-kernel@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 29 May 2007 15:14:36.0536 (UTC) FILETIME=[11C9DF80:01C7A204]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry about that.  Would it be helpful if I verified that and sent it in
signed off?

Thanks
Stuart

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Friday, May 25, 2007 5:00 PM
To: Greg KH
Cc: Mattia Dongili; Linux Kernel Mailing List; Hayes, Stuart; David
Brownell; linux-usb-devel@lists.sourceforge.net
Subject: Re: [2.6.22-rc1-mm1] ehci-hcd - BUG: scheduling while atomic:
rmmod/0x00000001/4568

On Fri, 25 May 2007 14:40:05 -0700 Greg KH <gregkh@suse.de> wrote:

> On Mon, May 21, 2007 at 11:44:37AM +0900, Mattia Dongili wrote:
> > Hello,
> > 
> > with gregkh-usb-usb-ehci-cpufreq-fix.patch removing ehci-hcd causes 
> > the following BUG:
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
