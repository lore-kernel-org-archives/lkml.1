Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbZJNVoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbZJNVoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZJNVon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:44:43 -0400
Received: from www.tglx.de ([62.245.132.106]:52379 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbZJNVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:44:42 -0400
Date: Wed, 14 Oct 2009 23:43:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch 11/28] nvram: Drop the bkl from nvram_llseek()
In-Reply-To: <200910131440.45623.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910142338500.9428@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <200910112350.24870.arnd@arndb.de> <20091011221448.GA8146@nowhere> <200910131440.45623.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Arnd Bergmann wrote:
> On Monday 12 October 2009, Frederic Weisbecker wrote:
> > On Sun, Oct 11, 2009 at 11:50:24PM +0200, Arnd Bergmann wrote:
> > >
> > > There are various *_operations structures that have a .ioctl pointer.
> > > While there are a lot of struct file_operations with a locked .ioctl
> > > operation, stuff like block_device_operations does not hold the
> > > BKL in .ioctl but in .locked_ioctl.
> > 
> > Oh right. Thanks for the tip.
> > 
> 
> FWIW, I've done a grep through the current source tree, this should be
> the full list of all .ioctl methods in struct file_operations, a total
> of 141 instances in 2.6.32-rc4.
> 
> When we do a pushdown of the BKL into these functions, we can kill off
> the file operation.
> 
> 	Arnd <><
> 
> arch/blackfin/mach-bf561/coreb.c:	.ioctl   = coreb_ioctl,

That one is scary. The BKL is protecting against parallel ioctl
operations, but the operation on the sys control registers is not
protected against other operations on the same registers in
arch/blackfin/mach-bf561/smp.c. IPI code does not take the BKL
afaict. Mike ?

Thanks,

	tglx
