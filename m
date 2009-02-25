Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZBYEjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZBYEjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZBYEjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:39:12 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:7294 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZBYEjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:39:12 -0500
Date: Tue, 24 Feb 2009 20:41:15 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250441.UAA12527@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 00/15] bitops: Change bitmap index from int to unsigned long
Cc: bjorn.helgaas@hp.com, justin.chen@hp.com, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to change the bitmap index in the bitops from "int" to "unsigned long".

In many bitops implementations, the bitmap index is a signed int.  If the caller passes a large unsigned integer and we interpret it as being negative, we compute an address outside the bitmap.  This can cause memory corruption or other errors.

The issue that triggered me to do this change is the routine mark_bootmem_node() while we ran on an ia64 box with large memory.  As long as the EFI maps the available memory chunk at the physical address 0x200000000000 (or above), the routine mark_bootmem_node() will get the start PFN>=0x80000000.  While it calls the __free() with this sidx=0x80000000 (bit31 set), the bitops (test_and_clear_bit) will treat this idx as a negative number since it accepts it as an "int".  It turns out the memory outside the bitmap will be corrupted.

Following 15 patches will change all the bitmap index "nr" in all bitops from "int" to "unsigned long".

The patch is based on 2.6.29-rc6

Please comment -

--jchen

(00/15): intro
(01/15): generic
(02/15): arm
(03/15): avr32
(04/15): blackfin
(05/15): cris
(06/15): h8300
(07/15): ia64
(08/15): m68k
(09/15): mn10300
(10/15): parisc
(11/15): powerpc
(12/15): sh
(13/15): x86
(14/15): frv
(15/15): m32r

 arch/arm/include/asm/bitops.h           |   39 +++++++++-------
 arch/arm/lib/changebit.S                |    2 
 arch/arm/lib/clearbit.S                 |    2 
 arch/arm/lib/setbit.S                   |    2 
 arch/avr32/include/asm/bitops.h         |   12 ++---
 arch/blackfin/include/asm/bitops.h      |   74 +++++++++++++++++++-------------
 arch/cris/include/asm/bitops.h          |    9 ++-
 arch/h8300/include/asm/bitops.h         |    8 +-
 arch/ia64/include/asm/bitops.h          |   30 ++++++------
 arch/ia64/include/asm/sync_bitops.h     |   21 ++++++---
 arch/m68k/include/asm/bitops_mm.h       |   63 ++++++++++++++++-----------
 arch/m68k/include/asm/bitops_no.h       |   34 +++++++++-----
 arch/mn10300/lib/bitops.c               |    4 -
 arch/parisc/include/asm/bitops.h        |   12 ++---
 arch/powerpc/include/asm/bitops.h       |   14 +++---
 arch/sh/include/asm/bitops-grb.h        |   12 ++---
 arch/sh/include/asm/bitops-llsc.h       |   12 ++---
 arch/sh/include/asm/bitops-op32.h       |   19 ++++----
 arch/x86/boot/bitops.h                  |    6 +-
 arch/x86/include/asm/bitops.h           |   48 +++++++++++++-------
 arch/x86/include/asm/sync_bitops.h      |   18 +++++--
 include/asm-frv/bitops.h                |   29 ++++++------
 include/asm-generic/bitops/atomic.h     |   17 ++++---
 include/asm-generic/bitops/non-atomic.h |   19 ++++----
 include/asm-m32r/bitops.h               |   14 +++---
 include/asm-mn10300/bitops.h            |   12 ++---
 26 files changed, 307 insertions(+), 219 deletions(-)
