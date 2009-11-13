Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZKMPMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZKMPMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbZKMPMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:12:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40145 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937AbZKMPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:12:10 -0500
Date: Fri, 13 Nov 2009 15:11:19 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: d451564 breakage
Message-ID: <20091113151119.GA27752@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change:

highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE

Appears to break ARM:

mm/highmem.c: In function ‘debug_kmap_atomic’:
mm/highmem.c:436: error: ‘KM_NMI’ undeclared (first use in this function)
mm/highmem.c:436: error: (Each undeclared identifier is reported only once
mm/highmem.c:436: error: for each function it appears in.)
mm/highmem.c:436: error: ‘KM_NMI_PTE’ undeclared (first use in this function)
mm/highmem.c:443: error: ‘KM_IRQ_PTE’ undeclared (first use in this function)
make[2]: *** [mm/highmem.o] Error 1
make[1]: *** [mm] Error 2

I'd prefer not to have to add these definitions just so that highmem
debugging can work for two reasons:

1. either we allocate mappings for these which will never be used, which
   unnecessarily wastes precious virtual memory space.

2. we define them to be some other KM_* value and hope that they never
   get used.  If they do get used, we'll never know by way of compiler
   error but could result in silent data corruption.

The only sane alternative I can see would be to define these as KM_TYPE_NR
and either ensure that kmap_atomic() always fails for out-of-bounds kmap
types (more preferable to catch problems but has a performance impact) or
we have the kmap debugging detect this as well.

Any preferences?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
