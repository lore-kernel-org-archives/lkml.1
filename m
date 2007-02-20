Return-Path: <linux-kernel-owner+w=401wt.eu-S965627AbXBTDRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627AbXBTDRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 22:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965637AbXBTDRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 22:17:21 -0500
Received: from ozlabs.org ([203.10.76.45]:50279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965627AbXBTDRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 22:17:21 -0500
Date: Tue, 20 Feb 2007 14:17:17 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Andrew Morton <akpm@osdl.org>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Use resource_size_t for serial MMIO addresses
Message-ID: <20070220031717.GI17818@localhost.localdomain>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Andrew Morton <akpm@osdl.org>, Russell King <rmk@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please apply to -mm.  I think these should be good to merge
for 2.6.22.

At present, MMIO addresses for serial port (the ->mapbase field in
uart_port and other structures) are unsigned longs.  This causes
problems on some 32-bit platforms which have a >32-bit physical
address bus, for example the embedded PowerPC 440GP chip, which has a
36-bit physical address bus, and on-chip serial ports located at an
MMIO address above 4GB.

The second patch in this series changes mapbase to a resource_size_t
(which can be 64-bit on the problematic platforms) in struct uart_port
and struct plat_serial8250_port.  It does *not* change the type in
serial_struct, because that structure is exposed to userspace.  It is
therefore unsafe to use setserial to change the address parameters on
a port using a mapbase above 4GB.

The first patch in the series contains the damage of the setserial
problem.  It allows serial ports to be marked with a new
UPF_FIXED_PORT flag, which causes any attempts to change the port's
type (PIO/MMIO etc.), address or irq with setserial to be ignored.
While using setserial to alter the port address is useful for legacy
ISA ports, it is generally a bad idea for ports such as on-chip or
other hardwired ports where the arch code has good information (from
firmware or hardware probing) on the port's type and address.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
