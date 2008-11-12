Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYKLQXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYKLQXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYKLQXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:23:41 -0500
Received: from www.tglx.de ([62.245.132.106]:58226 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYKLQXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:23:40 -0500
Date: Wed, 12 Nov 2008 17:23:33 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Neil Armstrong <narmstrong@neotion.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: add ioctl callback
Message-ID: <20081112162333.GD2891@local>
References: <491AF8D1.4060106@neotion.com> <20081112154919.GC2891@local> <491AFD7C.8090607@neotion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491AFD7C.8090607@neotion.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 04:59:56PM +0100, Neil Armstrong wrote:
> Hi Hans,
> 
> We need an ioctl callback because we need to query some values only
> available when the irq handler is running.
> For example, we have 3 types of reasons why the irq is triggered and
> these bits are no more available when the irq is cleared.

Ah, that one. That's why we invented the irqcontrol hook. In case of
such broken hardware, you need to mask the irq in the kernel without
touching the register containing those volatile bits. On a system where
you can be sure the irq is not shared, you can simply use disable_irq().

If the irq might be shared, you need to find something else. PCI cards,
for example, often have a register within their PCI bridge that contains
irq mask bits (that's how it is done in uio_cif.c).

Userspace can then reenable the irq by writing the value 1 as a signed
32-bit int to /dev/uioX. You need to implement an irqcontrol() function
in your kernel driver that does the right thing (e.g. call enable_irq()
in the first example).

> 
> The cleanest way to have this very specific information is to have a
> dirty old ioctl returning this data.

The cleanest way would be to throw such hardware into the trash bin :-)

A chip where the irq mask register cannot be written without destroying
the irq status register is simply broken and bad design.

Thanks,
Hans

