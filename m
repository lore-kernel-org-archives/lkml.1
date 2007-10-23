Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbXJWANR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbXJWANR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXJWAM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:12:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33192
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbXJWAM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:12:57 -0400
Date: Mon, 22 Oct 2007 17:13:18 -0700 (PDT)
Message-Id: <20071022.171318.104036671.davem@davemloft.net>
To: barkalow@iabervon.org
Cc: jeff@garzik.org, linas@austin.ibm.com, chunhao.huang@hotmail.com,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0710221700120.32497@iabervon.org>
References: <Pine.LNX.4.64.0710221555190.32497@iabervon.org>
	<471D0ADC.7000005@garzik.org>
	<Pine.LNX.4.64.0710221700120.32497@iabervon.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Barkalow <barkalow@iabervon.org>
Date: Mon, 22 Oct 2007 17:31:04 -0400 (EDT)

> It's likewise documented (although maybe arguable in wording) that the 
> device shouldn't send legacy interrupts if MSI is in use, regardless of 
> INTX_DISABLE, but this also happens in the field.
> 
> I think that the current Linux behavior with respect to INTX_DISABLE is 
> simply due to which hardware bug was present in the device whose driver 
> first got Linux support, but one or the other or both needs a quirk, since 
> there's no behavior that works with everything. And it's still impossible 
> to tell which bug is more common, since MSI isn't used most of the time, 
> even if the hardware supports it, so it's pretty arbitrary which way Linux 
> goes in the non-quirk case.

I think this pretty much sums up the situation accurately.

My suggestion is:

1) Leave the pci_intx() twiddling code in drivers/pci/msi.c

2) Add quirks for "INTX_DISABLE turns off MSI too", this sets
   a flag in the pci_dev.

3) The pci_intx() calls in drivers/pci/msi.c are skipped if this
   flag from #2 is set.

4) Add quirk entries for drivers/net/tg3.c chips and these SATA
   devices we are learning about here, as well as any others we
   are aware of right now.

5) Remove the pci_intx() workaround code from drivers/net/tg3.c
   and elsewhere.
