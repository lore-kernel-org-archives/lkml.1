Return-Path: <linux-kernel-owner+w=401wt.eu-S1762387AbXJRLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387AbXJRLqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762095AbXJRLqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:46:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36365
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761309AbXJRLqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:46:04 -0400
Date: Thu, 18 Oct 2007 04:46:11 -0700 (PDT)
Message-Id: <20071018.044611.21595530.davem@davemloft.net>
To: Shane.Huang@amd.com
Cc: gregkh@suse.de, htejun@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Henry.Su@amd.com,
       Libin.Yang@amd.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
From: David Miller <davem@davemloft.net>
In-Reply-To: <5CAB7B5D6F8AB84AA868A46B47A507055D8C67@sshaexmb1.amd.com>
References: <20071018.031957.104033396.davem@davemloft.net>
	<5CAB7B5D6F8AB84AA868A46B47A507055D8C67@sshaexmb1.amd.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Shane Huang" <Shane.Huang@amd.com>
Date: Thu, 18 Oct 2007 18:37:59 +0800

> Hi Miller:
> 
> Thank you for your response.
> 
> The reason why MSIs of these northbridges do not work is still under
> further debug, we are NOT able to tell its hardware issue or software
> issue at this  time. But enablement of them will lead to the OS
> installation failure in many distributions like openSUSE, Ubuntu etc:
> https://bugzilla.novell.com/show_bug.cgi?id=302016
> 
> So we have to disable them firstly before we find out the root cause,
> maybe they are just workarounds.

This logic seems backwards, to me.  "shoot first, ask questions later"
To me this it not how to approach this problem.

Once you turn MSI off, there is next to no incentive to fix the
problem because users aren't running into it any longer.

The only two devices in that bug report which should be using MSI
would be the SATA controller and the broadcom ethernet NIC.  And by
the failed bootup logs provided by the user the problem is clearly
with the SATA controller.

One common problem we're finding is that some devices have a hardware
bug where setting INTX_DISABLE in the PCI COMMAND register masks MSI
interrupts too.

I mention this because the user in that report mentions that the
kernel upgrade causes the failure, and one thing we started doing not
too long ago was to set the INTX_DISABLE bit when MSI is enabled for a
device.

So maybe this SATA controller has this problem too.  It is easy to
test, simply comment out all of the pci_intx() function calls in
drivers/pci/msi.c and perform a test boot with MSI enabled.

I would rather you approach analysis of these kinds of MSI bugs in
this manner, instead of disabling MSI wholesale.  Because with the
latter approach it is nearly guarenteed that the real reason will only
be discovered with an extremely low priority.

Thank you.
