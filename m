Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZE0BrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZE0BrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZE0BrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:47:07 -0400
Received: from [65.98.92.6] ([65.98.92.6]:2186 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZE0BrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:47:06 -0400
Message-Id: <26a78e954b7e1570179fba0c56aa129af1a247e0@localhost>
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 26 May 2009 16:57:34 -0700
Subject: [PATCH 0/1] MIPS: Disable address swizzling on __raw MMIO operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a big-endian MIPS32-based ASIC configured as follows:

CONFIG_SWAP_IO_SPACE is not set

mangle-port.h says:

#define __swizzle_addr_b(port)	((port) ^ 3)
#define __swizzle_addr_w(port)	((port) ^ 2)
#define __swizzle_addr_l(port)	(port)
#define __swizzle_addr_q(port)	(port)

(copied from mach-ip32/mangle-port.h)

The PCI drivers use {read,write}[bwl].  PCI byte and word (16-bit)
accesses are address-swizzled but not endian-swapped.  Since 32-bit
accesses are the common case, this generates the most efficient code.

The MTD drivers (in my case, physmap) use __raw_{read,write}[bwl].
This is a problem because on MIPS, the __raw functions still enable
address swizzling.

I am submitting a patch to disable address swizzling for the __raw
operations.

There are currently three other MIPS platforms using address
swizzling:

txx9/jmr3927 only uses the swizzle facility to make the rtc-ds1742
driver work.  This driver uses standard (non-__raw) readb()
operations, which will continue to function normally with my patch in
place.

sgi-ip27 swizzles 16-bit PCI word addresses but not byte addresses.
It only registers a single platform_device (rtc-m48t35) which has no
__raw operations.

sgi-ip32 swizzles both 16-bit and 8-bit PCI addresses.  It registers
the following platform_device's:

8250 - uses standard read/write operations
meth - uses volatile struct accesses only
sgio2audio - uses readq/writeq
sgi_btns - uses readq/writeq
rtc_cmos - uses inb_p/outb_p

Based on this information, I do not believe that my change will have
an adverse impact on any other systems.
