Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXDMPgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXDMPgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXDMPgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:36:20 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:37173 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754049AbXDMPgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:36:19 -0400
Date: Fri, 13 Apr 2007 17:35:53 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
cc: Andi Kleen <ak@suse.de>, Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH 0/4] v2: Fix MTRR suspend support for specific machines (some
 AMD64, maybe others also)
Message-ID: <Pine.LNX.4.64.0704131712280.9589@jbgna.fhfr.qr>
References: <20070408023544.8d954464.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   This is an updated repost of http://lkml.org/lkml/2007/4/3/110 whith the
changes which Andrew Morton added in http://lkml.org/lkml/2007/4/8/88 to fix
'make headers_check' applied to the 2nd patch, which he updated.

The oops of Andrew's Viao on s2ram was caused by a merge error which
was caused by me sending the patches diffed against 2.6.20 initially.

It is diffed against 2.6.21-rc6-mm1 to allow Andrew to apply it
without rejects to his tree.

Best Regards,
Bernhard

PS: Short summary of the complese description of the patches:

Summary:

With these patches, s2ram and s2disk are fixed on at least the Acer Ferrari
1000 notebooks and at least s2disk on the Acer Ferrari 5000 notebooks.

The BIOS of these Acer AMD Turion 64 notebooks makes use of fixed-range
IORRs to implement Shadow RAM and direct write-back memory, and it does
this while it transitions the system into ACPI mode, but Linux MTTR code
does not handle situations like this yet, which results in errors which
look like hardware errors. Symptoms vary from from instant resets and
power-offs to SATA link failures.

Short problem description:

These system errors is the of Linux MTRR code being unaware of the AMD
IORRs so far and that the Linux MTRR code so far isn't able to cope with
BIOSes which change the MTRRs of CPUs in SMM, e.g. when it is called by
acpi_enable() to transition the system into ACPI mode. The resulting
combinations of AMD IORR MSR bits and Intel-style MTRR bits is not
allowed and causes undefined and unpredictable behaviour (according
to the AMD manual), the fix needs to (at least) save the MTRRs of
the BSP before suspend to make sure that it does not change the fixed-
range MTRR bits on resume, where, with current code, the errors start.

The intro text of initial posting at http://lkml.org/lkml/2007/4/3/110
contains more detail and an overview over the four patches of the fix.
