Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZAWJq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZAWJq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758781AbZAWJqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:46:00 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:21618 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093AbZAWJp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:45:58 -0500
X-IronPort-AV: E=Sophos;i="4.37,311,1231131600"; 
   d="scan'208";a="36895748"
Subject: Re: [PATCH] HVC: do not request the irq twice.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <200901222009.43342.borntraeger@de.ibm.com>
References: <1232646968-32671-1-git-send-email-Ian.Campbell@citrix.com>
	 <200901222009.43342.borntraeger@de.ibm.com>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 23 Jan 2009 09:45:23 +0000
Message-Id: <1232703923.22248.230.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2009 09:45:57.0630 (UTC) FILETIME=[645259E0:01C97D3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 20:09 +0100, Christian Borntraeger wrote:
> Am Thursday 22 January 2009 18:56:08 schrieb Ian Campbell:
> > --- a/drivers/char/hvc_irq.c
> > +++ b/drivers/char/hvc_irq.c
> > @@ -28,6 +28,10 @@ int notifier_add_irq(struct hvc_struct *hp, int irq)
> >  		hp->irq_requested = 0;
> >  		return 0;
> >  	}
> > +
> > +	if (hp->irq_requested)
> > +		return 0;
> > +
> >  	rc = request_irq(irq, hvc_handle_interrupt, IRQF_DISABLED,
> >  			   "hvc_console", hp);
> >  	if (!rc)
> 
> Unfortunately I have no system with an irq based hvc console - I cannot test 
> this patch. Anyway, the patch looks sane:
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> If this really fixes a problem, I am asking myself, if notifier_del can be 
> called several times as well. If yes, it might be better to call free_irq at 
> the last notifier_del - which means we need proper refcounting. Otherwise the 
> console switches into polling mode....

Hmm, interesting question. It looks like the count field in struct
hvc_struct is being used to count opens and closes which should
reference count the IRQ usage too.

Oh, I see, hvc_hangup resets count but the Xen dom0 hv_ops was missing
the hangup hook to release the IRQ -- I'll fix this.

I think this patch can be ignored, real bug is on the Xen side.

Ian.

