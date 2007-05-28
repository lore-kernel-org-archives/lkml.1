Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbXE1Prj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbXE1Prj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXE1Prc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:47:32 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:54277 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbXE1Prb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:47:31 -0400
Date: Mon, 28 May 2007 17:46:47 +0200
Message-Id: <17638824@web.de>
MIME-Version: 1.0
From: Uwe Bugla <saubermann60@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: b44: regression in 2.6.22
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18YT6g5+/wVXOUCcU2tE7wOopy6l0vTkYqYqSVfyZBGdvyQK
 lZpz4KGpHIpVDIOYkb5727otCNRv1+18pWDMBiXC26ovmEmYRHllLi1VMLYo
 Q==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007, Michael Buesch wrote:
> Can you also test the following patch?
> I think there's a bug in b44 that is doesn't properly discard
> shared IRQs, so it might possibly generate a NAPI storm, dunno.
> Worth a try.
>
> Index: linux-2.6.22-rc3/drivers/net/b44.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/drivers/net/b44.c 2007-05-27 23:01:44.000000000
> +0200 +++ linux-2.6.22-rc3/drivers/net/b44.c 2007-05-28 12:48:27.000000000
> +0200 @@ -911,6 +911,8 @@ static irqreturn_t b44_interrupt(int irq
> spin_lock(&bp->lock);
>
> istat = br32(bp, B44_ISTAT);
> + if (istat == 0xFFFFFFFF)
> + goto out; /* Shared IRQ not for us */
> imask = br32(bp, B44_IMASK);
>
> /* The interrupt mask register controls which interrupt bits
> @@ -942,6 +944,7 @@ irq_ack:
> bw32(bp, B44_ISTAT, istat);
> br32(bp, B44_ISTAT);
> }
> +out:
> spin_unlock(&bp->lock);
> return IRQ_RETVAL(handled);
> }

I did try this patch on a affected kernel, but I didn't notice any big
difference. Perhaps the kernel is a bit less slow during the test, but It's
hard to tell.

Maxi


I tried that one also, but it did not help to solve the real problem.

The real problem is the b44 -----> b44-ssb-port in 2.6.22-rc2-mm1.
This port was not done correctly, as my bcm4401 runs fine with all 2.6 kernels except 2.6.22-rc2-mm1.

I also tried to load the two modules that way:

modprobe ssb debug=4
modprobe b44 debug=4

Unfortunately those two modules do not understand those command line parameters.

I even reverted significant parts of module b44.h (i. e. the backplane definitions).
But that did not help either.

In so far the changes for b44.c in kernel 2.6.22-rc2-mm1 are definitely responsible for the fact that my bcm4401 controller refuses to work.

Cheers

Uwe

P. S.: I am basically not against those ports like the above mentioned one.
But if they are done they at least should be done more severe and correct.

As this port is a deep cut into the architecture, it would be very helpful to make the
two new modules understand debug command line parameters.
Just to somplify troubleshooting.

You cannot rip out code of one module, attempt to do a port, and afterwards jump around crying:
"For me it works - what can I do?"

You moreover cannot chase bug reporters to test 3 different developper kernels containing the same code expecting that there will
be a real result to help resolve the real issue.

You moreover cannot accuse bug reporters for typo errors in DNS server, for the ACPI system to be buggy etc.

This is no professional bug handling, but it is just wasting time and nerves due to lack of concept how to resolve the real
issue (i. BAD b44 ------> b44-ssb port).

Hint: Please everyone reading this see the following threads for positive examples how bug reports
are to be resolved:

A. the sis900.c Oops (before kernel 2.6.21.2)
B. The "alsa architecture broken in parts" issue

Those are only 2 examples on how to resolve bug report issues in a real sovereign and sophisticated manner.

_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

