Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYIGWYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYIGWYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYIGWYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:24:15 -0400
Received: from gw.goop.org ([64.81.55.164]:39649 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYIGWYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:24:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 7] x86: lay groundwork for Xen domain 0 support
Message-Id: <patchbomb.1220826072@localhost>
Date: Sun, 07 Sep 2008 15:21:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series begins to lay the groundwork for Xen domain 0 support.
Domain 0 is much like a normal Xen domain, but it is also allowed to
have direct access to the underlying hardware (including both IO space
and various BIOS tables), so it can run device drivers, etc.  This
means that we need to be able to distinguish between a Xen domain's
normal pseudo-physical address space, and the real machine physical
address space.

This series:
 - Adds a new pte flag - _PAGE_IOMAP - used to indicate that a mapping
   is intended to map an IO device, and the physical address is
   actually a real machine physical address rather than a
   pseudo-physical address.  This is exposed as PAGE_KERNEL_IO and so
   on.  ioremap() and early_ioremap() are modified to set this flag,
   as they (should) always be used to map IO devices and not other
   memory.  By default __supported_pte_mask masks this flag out, so it
   won't end up in the final pagetable.  The Xen (and any other) code
   which cares about this flag unmask it from __supported_pte_mask.

 - Add early_memremap() to deal with the cases where early_ioremap()
   actually being used to map normal memory.

 - Remove a bogus check in x86-64's implementation of
   set_pte_vaddr_pud(), which prevents memory mappings from being
   updated.

 - Convert __acpi_map_table to use early_ioremap(), rather than have
   its own implementation.

 - Make __acpi_map_table always map the memory rather than assuming
   that the linear map maps some of the acpi tables.  This won't be
   true in the virtual case, and always mapping doesn't hurt in the
   native case.

I've tested these patches on both 32 and 64 native booting, and it all
works for me.

Thanks,
	J

