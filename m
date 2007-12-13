Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbXLMDk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbXLMDk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 22:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbXLMDkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 22:40:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:58579 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbXLMDkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 22:40:15 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1197515098.15741.64.camel@pasglop>
References: <1197514804.15741.60.camel@pasglop>
	 <1197515098.15741.64.camel@pasglop>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 14:40:00 +1100
Message-Id: <1197517200.15741.68.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 14:05 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2007-12-13 at 14:00 +1100, Benjamin Herrenschmidt wrote:
> 
>  .../...
> 
> (oops, sent too fast)
> 
> > So not only we can have a dangling BAR, but nothing prevent us to
> > actually go turn IO or MEM decoding on in case it wasn't already the
> > case on that device.
> 
> And I was about to say before I clicked "send".. can't we do something like
> writing all ff's into the BAR at the same time as we clear res->start ? Isn't
> that supposed to pretty much disable decoding on that BAR ? Or not... Probably
> still better than leaving it to whatever dangling value it had no ?

Ok, reading some other threads, it seems that writing all ff's will not
be a very good alternative on x86 machines where MMCONFIG sits up
there...

I suppose there is nothing totally safe that can be done, thanks to
Intel not thinking about making BARs individually enable/disable'able
(or size-able without interrupting access, among other numerous fuckups
in the PCI spec).

So if a BAR is left dangling, I think we -must- disable MEM and IO
decoding on the whole device. In fact, the whole trick of passing a
bitmask of required BARs to pci_enable_device_bars() in the first place
doesn't fly.

Yuck.

Ben.


