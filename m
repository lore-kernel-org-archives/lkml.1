Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbXFLPDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbXFLPDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXFLPDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:03:01 -0400
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:45812 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXFLPDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:03:01 -0400
Date: Tue, 12 Jun 2007 08:02:46 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: oprofile-list@lists.sourceforge.net
Cc: wcohen@redhat.com, ak@suse.de, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org, levon@movementarian.org
Subject: OProfile issues
Message-ID: <20070612150246.GJ32163@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am working on perfmon2 to allow Oprofile and perfmon2 to co-exist
as suggested by Andi Kleen. I looked at the Oprofile init/shutdown
code and I am puzzled by several things which you might be able to
explain for me. I am looking at 2.6.22-rc3.

Here are the issues:

 * model->fill_in_addresses is called once for all CPUs
   on X86, it does more than just filling in the addresses,
   it also coordinates with the NMI watchdog by reserving
   registers via the reserve_*nmi() interface.

   The problem is that the release of the registers is done
   in model->shutdown() which happens to be executed on every
   CPU. So you end up releasing the registers too many times.
   This is *not* harmless once you start sharing the PMU with
   other subsystems given the way the allocator is designed.

 * allocate_msrs() allocates two tables per CPU. One for the
   counters, the other for the eventsel registers. But then
   nmi_setup() copies the cpu_msrs[0] into cpu_msrs[] of all
   other cpus. This operation overrides the cpu_msrs[].counters
   and cpu_msrs[].controls pointers for all CPUs but CPU0.
   But free_msrs() will free the same tables multiple times. This
   causes a kernel dump when you enable certain kernel debugging
   features. The fix is to copy the content of the counters and
   controls array, not the pointers.

 * the fill_in_addresses() callback for X86 invokes the NMI watchdog
   reserve_*_nmi() register allocation routines. This is done regardless
   of whether the NMI watchdog is active. When the NMI watchdog is not
   active, the allocator will satisfy the allocation for the first MSR
   of each type (counter or control), but then it will reject any
   request for the others. You end up working with a single
   counter/control register.

Are those known bugs?

-- 
-Stephane
