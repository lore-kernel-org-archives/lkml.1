Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966278Ab0BZVmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:42:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:35047 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966239Ab0BZVmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:42:53 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
References: <1266979632.23523.1668.camel@pasglop>
	 <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 08:40:29 +1100
Message-ID: <1267220429.23523.1811.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 16:25 +0000, Catalin Marinas wrote:
> 
> For mmap'ed pages (and present in the page cache), is it guaranteed that
> the HCD driver won't write to it once it has been mapped into user
> space? If that's the case, it may solve the problem by just reversing
> the meaning of PG_arch_1 on ARM and assume that a newly allocated page
> has dirty D-cache by default.

Well, I don't see why the HCD would write to it unless it's swapped out,
and thus unmapped or read() to or similar.

> The filesystem layer does it only if it needs to touch the data written
> by the block device (e.g. cramfs, jffs). Some block devices call
> flush_dcache_page (like mmci.c) while some others don't (and those that
> use DMA actually don't since the DMA API handles the flushing). 

Hrm, the DMA API certainly doesn't handle the I$/D$ coherency on
powerpc.. I'm afraid that whole cache handling stuff is totally
inconsistent since different archs have different expectations here.

Maybe we need to revisit things in that area, though it might require to
be done properly to have not one but two bits in struct page to
separately track the D$ and I$ state ...

Cheers,
Ben.


