Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYGGRs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYGGRs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYGGRsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:48:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50695 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYGGRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:48:20 -0400
Date: Mon, 7 Jul 2008 11:48:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       michael@ellerman.id.au, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 3/4] AHCI: Request multiple MSIs
Message-ID: <20080707174803.GD14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-3-git-send-email-matthew@wil.cx> <20080707164534.GF7521@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707164534.GF7521@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 10:45:34AM -0600, Grant Grundler wrote:
> If the system is busy, the readl is the cost of coalescing the
> interrupts.  I suspect it's cheaper to take one readl than
> handle 16 individual interrupts.

16 would be a maximum imposed by the AHCI spec.  My ICH9 board has 6
ports, but requests all 16 interrupts

> I'm just pointing out the only upside of the existing code and not trying
> to argue against this patch.

There may well be an upside to the existing code, but it's pretty slim.
The oprofile shows clearly that ahci_interrupt is the largest consumer of
time during an iozone run.  The only thing that routine does is read the
HOST_IRQ_STAT register, acquire the spinlock and loop calling
ahci_port_intr().

I don't have a profile for this new code yet.  Hopefully we'll have one
by the end of the day.

> BTW, one more downside of the regular IRQ is it's possibly shared.
> Using MSI guaratees exclusive IRQ and avoids spurious readl's
> when AHCI is not busy but the other device is. This would be worth
> noting (or as a reminder) in the change log or as a comment in
> the code.

AHCI already allocates itself a new MSI if the machine supports MSI.
This change merely extends AHCI to use multiple MSIs.

Thanks.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
