Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbZFDNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbZFDNnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZFDNnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:43:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZFDNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:43:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Thu, 4 Jun 2009 14:42:52 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <200906041235.34686.arnd@arndb.de> <20090604125119.GB24491@flint.arm.linux.org.uk>
In-Reply-To: <20090604125119.GB24491@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906041442.53170.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX194PgTCvqUDCCb+ASydxpZ7dZo8ON/yTfKFfGt
 D16683m1AW20oHXbBPpKYv2wHSuJx7uAZ9dg9lUrz7u6fzNMRP
 srqyGlxCV9WoE1itjzO9R/pJJ+0ZHUm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Russell King wrote:
> And here we go promoting dma-mask-is-not-a-mask-but-a-limit (which I
> brought up in the KS thread on linux-arch.)
> 
> It's fine if your DMA-able memory starts at physical address 0 and ends
> somewhere else, but this is no longer the case with embedded platforms.
> As pointed out in the other thread, there are platforms which have two
> separate banks of memory, the one at the lower physical address is not
> DMA capable.

The dma-mapping-linear.h only cares about the platforms that have a
linear contigous mapping between DMA and phys addresses. Other
platforms will have to do something more fancy in their dma mapping
implementation.

The device sets a mask (really a limit) of the address ranges it can
handle. Basically every user in the kernel currently passes DMA_BIT_MASK()
limit into {dma,pci}_set_mask,  and I am not aware of any driver
that needs something more fancy. If you know one, please tell us.

The DMA-capable addresses of the platform are a completely different
issue and these should not be confused. Some architecture solve this
by bus-specific mapping operations, which sounds like what you would
need here as well. The bus is the only instance in the system that knows
how the device-visible DMA space maps into the physical memory space,
and it needs to be the instance checking the mask.

The only place where the mask is really used later is dma_alloc_coherent,
which can also be bus specific, and should know how to interpret the
mask.

	Arnd <><
