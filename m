Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbYFBOTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbYFBOTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYFBOTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:19:45 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:50160 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYFBOTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:19:45 -0400
X-BigFish: VPS-28(zz98dR168aJ62a3L7efVzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K1UAGD-02-BY5-01
Date: Mon, 2 Jun 2008 16:19:29 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Add PCI extended config space access for AMD
	Barcelona
Message-ID: <20080602141928.GH23679@erda.amd.com>
References: <20080526180616.GB2752@erda.amd.com> <20080528165813.8D8E5814C@erda.amd.com> <20080528120253.26fcdb9d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080528120253.26fcdb9d@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 02 Jun 2008 14:19:29.0192 (UTC) FILETIME=[AB4CBA80:01C8C4BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan,

On 28.05.08 12:02:53, Arjan van de Ven wrote:
> Comment 1:
> Can we make the 256/4096 thing conditional on actually having the
> feature somehow? (while not making the code TOO ugly)

In the first version I had 2 functions also. The patch have had lots
of duplicate code or inline functions. Since the conditional check is
already in raw_pci_* I decided to not implement an additional check
and use only one function.

int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
                                                int reg, int len, u32 *val)
{
	if (reg < 256 && raw_pci_ops)
	   return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
	   if (raw_pci_ext_ops)
	      return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
	      return -EINVAL;
}

That leaves as a difference to the basic access is the shift left of
bits 8:11 in the PCI_CONF1_ADDRESS macro. Functional the new macro is
the same and the overhead for this is small. So I see keeping all code
in one function as the best solution.

> Comment 2: 
> The cpu_has_XXX is a bit dubious; while it's dependent on your cpu
> model right now, I'm a bit hesitant to consider a PCI feature something
> that belongs in the cpu_has_XXX namespace. (Yes I know PCI is moving
> into the cpu package, but on a logical level it seems just the wrong
> place).
> Do we need a platform_has_XXX namespace for things like this?

An alternative implementation would be here to use a check something
like pci_probe & PCI_HAS_EXT_CFG. If needed, I will send an updated
patch.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

