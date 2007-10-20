Return-Path: <linux-kernel-owner+w=401wt.eu-S966394AbXJTGHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966394AbXJTGHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 02:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXJTGH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 02:07:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:24251 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXJTGHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 02:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fylnlRopG5liy9zOLdXoKy1MvMi3DGMDJp/xaDrxA5N1RsUgm2uZazLY81iiVGSeI8T1p2WJD0BQn7wCsbCUBJp4q2EADpATVRZ2eqM9JgEebHixk4CoywXs3lw5hSoZIXXEawpohqPv/QxSbwYhjzftIgZhA2lV0Ml852glqkA=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH] synchronize_irq needs a barrier
Date: Sat, 20 Oct 2007 08:06:41 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
References: <1192670742.12879.5.camel@pasglop> <200710200736.22129.maximlevitsky@gmail.com> <1192859184.6745.8.camel@pasglop>
In-Reply-To: <1192859184.6745.8.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710200806.41562.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 October 2007 07:46:24 Benjamin Herrenschmidt wrote:
> 
> > I probably need to add this synchronize_irq() logic in dmfe.c too, but I probably do it later,
> > I think I am overestimating this race, since most drivers don't do dev->insuspend checks in IRQ handler.
> > Maybe even just use free_irq() after all....
> 
> Most drivers are probably underestimating the race :-)
> 
> free_irq() would work provided that you did the masking on chip before
> (and unmask only after request_irq on the way back in). But it's a bit
> like using a 10 tons truck to crush an ant... 
Agreed.

So, I will add synchronize_irq() to both saa7134, and dmfe, the two drivers that their .suspend/.resume 
routines were written by me.

I already added a synchronize_irq()  plus few more fixes to the driver , but those patches are still in v4l tree.

I now has this:

	saa_writel(SAA7134_IRQ1, 0);
	saa_writel(SAA7134_IRQ2, 0);
	saa_writel(SAA7134_MAIN_CTRL, 0);

	synchronize_irq(pci_dev->irq);
	dev->insuspend = 1;

and I will probably need (with the synchronize_irq patch applied)


	/* Disable interrupts, DMA, and rest of the chip*/
	saa_writel(SAA7134_IRQ1, 0);
	saa_writel(SAA7134_IRQ2, 0);
	saa_writel(SAA7134_MAIN_CTRL, 0);
	
	dev->insuspend = 1;
	synchronize_irq(pci_dev->irq);

	/* ACK pending interrupts just in case*/
	saa_writel(SAA7134_IRQ_REPORT,saa_readl(SAA7134_IRQ_REPORT));

	......
This should be bullet-proof.


> 
> Ben.
> 
> 
> 
Best regards,
	Maxim Levitsky
