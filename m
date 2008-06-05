Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYFEXHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYFEXHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYFEXHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:07:13 -0400
Received: from saeurebad.de ([85.214.36.134]:38565 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYFEXHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:07:12 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun  6 00:57:19 2008
Message-Id: <20080605224940.434439989@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 00:49:40 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 00/14] bootmem rewrite v4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a complete overhaul of the bootmem allocator while preserving
most of its original functionality.

free_bootmem and reserve_bootmem become a bit stricter than they are
right now, callsites have to make sure that the PFN range is
contiguous but it might go across node boundaries.

alloc_bootmem satisfying the allocation goal is more likely as the
routines will try to allocate on the node holding the goal first
before falling back as opposed to the original behaviour that
satisfies the goal only if it is on the first node.

All in all, I think the code has become simpler and cleaner.  All
public interfaces have been documented, too.

version 4: based on -mmotm from 08-06-05
  o fixed fallback logic in alloc_bootmem_core (take the fallback even
    in cases where sidx is zero) to make Yasunori's machine boot again
  o fixed bogus range checks in ___alloc_bootmem_nopanic
  o removed bogus `fallback'-offset calculation in alloc_bootmem_core
  o renamed last_offset to last_end_off
  o renamed last_success to hint_idx
  o start searching after the end of the previous allocation, not at
    its beginning
  o improved more identifier names for offsets, pfns, indices and
    addresses
  o adjusted debugging output to output hex numbers consistently

version 3:
  o fixed kerneldoc as noted by Chris Malley
  o fixed incorrect bdata->last_success treatment as noted by
    Yasunori Goto

version 2:
  o broken up patches into logical chunks

---

 arch/alpha/mm/numa.c     |    2 +-
 arch/arm/plat-omap/fb.c  |    4 +-
 arch/avr32/mm/init.c     |    3 +-
 arch/ia64/mm/discontig.c |   19 +-
 arch/m32r/mm/discontig.c |    3 +-
 arch/m32r/mm/init.c      |    4 +-
 arch/mn10300/mm/init.c   |    6 +-
 arch/sh/mm/init.c        |    2 +-
 include/linux/bootmem.h  |   87 +++---
 mm/bootmem.c             |  934 +++++++++++++++++++++++++---------------------
 10 files changed, 570 insertions(+), 494 deletions(-)

