Return-Path: <linux-kernel-owner+w=401wt.eu-S966238AbXJSM57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966238AbXJSM57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbXJSM5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:57:43 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:44609 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976AbXJSM5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:57:42 -0400
Date: Fri, 19 Oct 2007 13:57:33 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
In-Reply-To: <20071019081706.GA2598@ff.dom.local>
Message-ID: <Pine.LNX.4.64N.0710191345020.13279@blysk.ds.pg.gda.pl>
References: <20071015125301.GC3015@ff.dom.local>
 <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl> <20071016062108.GB1000@ff.dom.local>
 <Pine.LNX.4.64N.0710161759050.22596@blysk.ds.pg.gda.pl> <20071017085809.GA1658@ff.dom.local>
 <Pine.LNX.4.64N.0710171221510.28993@blysk.ds.pg.gda.pl> <20071019081706.GA2598@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Jarek Poplawski wrote:

> But then... your patch seems to make it possible, because it enables
> irq to the initial state of the counter. Of course, this could happen
> on closing only.

 That's because free_irq() does not disable the interrupt in the correct 
manner.  The scenario is more or less like this:

phy_interrupt()				[depth == 0]
	disable_irq()
		depth++; status |= IRQ_DISABLED;
...
free_irq()				[depth == 1]
	status |= IRQ_DISABLED;
...
phy_change()				[depth == 1]
	enable_irq()
		depth--; status &= ~IRQ_DISABLED;
		oops!

Now if free_irq() correctly incremented the depth counter, then the last
enable_irq() would still decrement it, but with its initial value of 2 it 
would not change the status to reenable the line.

  Maciej
