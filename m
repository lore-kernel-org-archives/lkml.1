Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYGKIvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYGKIvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYGKIuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:50:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38401 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYGKIuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:50:52 -0400
Date: Fri, 11 Jul 2008 02:50:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86-64: Support for multiple MSIs
Message-ID: <20080711085035.GP14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org> <1215738002-4961-5-git-send-email-matthew@wil.cx> <4876E68F.3050200@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876E68F.3050200@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 01:50:23PM +0900, Kenji Kaneshige wrote:
> I'm very sorry for very delayed comment, but I have a concern
> about irq affinity code. Since I didn't have enough time to
> look at your patch, I might be misunderstanding something...
> 
> In my understanding, when irq affinity is changed on one of
> the IRQs corresponding to MSI, it will not completed until
> interrupts occur on all the IRQs. Attempts to change irq
> affinity before previous affinity change is finished will be
> ignored. Here, suppose that device uses three MSI irqs. In
> this case, your patch manages four irqs, but only three
> interrupts are used. If irq affinity changed on this MSI
> interrupts, will it be completed?

I have tested the affinity code with an ICH9 AHCI:

495:     117233     117966     118033     117797   PCI-MSI-edge      ahci
496:      29860      29106      30191      28705   PCI-MSI-edge      ahci
497:          0          0          0          0   PCI-MSI-edge      ahci
498:          0          0          0          0   PCI-MSI-edge      ahci
499:          0          0          0          0   PCI-MSI-edge      ahci
500:          0          0          0          0   PCI-MSI-edge      ahci

This chip requires 16 MSIs to be registered, and it has 6 ports.
Only ports 0 and 1 have a device attached.  If I change the mask of
an active irq (eg 495 or 496), it takes effect on both of them.  If I
change the mask of an inactive irq (497-500), nothing happens.  But I
can subsequently change the mask on 495 or 496 successfully.

I can't tell you why this works this way; I haven't looked in enough
detail at the irq affinity code, but this is my observation.

Thanks for your comment.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
