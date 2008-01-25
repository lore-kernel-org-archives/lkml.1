Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYAYVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYAYVwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYAYVwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:21 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37911 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754745AbYAYVwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:20 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 11] x86: separate pmd lifetime from pgd
Message-Id: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series addresses various cleanups in pagetable allocation in the
direction of unifying 32/64 bits (that's still a while off yet).

The significant change in here is that I'm separating the lifetime of
a pmd from its pgd in the 32-bit PAE case.  This makes it logically
the same as 64-bit pagetable allocation, and it overall simplifies the
code.

The patches are:
 - A pure Xen fix I tacked on for convenience
 - Use the same pgd_list mechanism for 32 and 64 bits
 - Add an mm parameter for paravirt_alloc_pd, for consistency
 - Some fixes to early_ioremap to make sure the right paravirt
   hooks are called appropriately
 - de-macro asm-x86/pgalloc_32.h
 - make mm/pgtable_32.c:pgd_ctor a single function
 - dynamically allocate pmds rather than always allocating
   them with the pgd
 - Add Xen bits for dealing with pmd allocation
 - Preallocate pmds to avoid excessive tlb flushes
 - Allocate and initialize kernel pmds when they're not shared
 - Avoid excessive tlb flushes when pulling down pmds.

I've done a number of randconfig test builds to shake out various
configurations on 32 nd 64 bits.

One caveat: in order to demacro pgalloc_32.h, I had to rearrange some
headers in asm-generic/tlb.h, as it was including asm/pgalloc.h for no
good reason.  As a result, any other file which was expecting to
implicitly pick up asm/pgalloc.h when including a asm/tlb.h header may
get header file problems.  I have not done any cross builds to try and
track down any non-x86 fallout from this.

Thanks,
	J


