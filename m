Return-Path: <linux-kernel-owner+w=401wt.eu-S937654AbYD1Umx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937654AbYD1Umx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936529AbYD1Umj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:42:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:44123 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008AbYD1Umi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:42:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,718,1199692800"; 
   d="scan'208";a="322291194"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ARCH: Fix 32-bit x86 MSI-X allocation leakage
Date: Mon, 28 Apr 2008 13:42:40 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32904F9EC8C@orsmsx414.amr.corp.intel.com>
In-Reply-To: <alpine.LFD.1.10.0804282216570.3261@apollo.tec.linutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ARCH: Fix 32-bit x86 MSI-X allocation leakage
Thread-Index: AcipbrTiXKNe5aE5QuS00730ftqEaQAACccw
References: <20080426005850.7098.77479.stgit@scrappy.jf.intel.com> <alpine.LFD.1.10.0804282216570.3261@apollo.tec.linutronix.de>
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, <netdev@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2008 20:42:37.0418 (UTC) FILETIME=[64E464A0:01C8A970]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 25 Apr 2008, PJ Waskiewicz wrote:
> > This bug was introduced in the 2.6.24 i386/x86_64 tree merge, where
> 
> Can you please explain what exactly caused the bug. 
> Definitely not the move from arch/i386 to arch/x86 as the 
> code there was not changed at all and has not be changed since then.
> 
> CC'ed Eric as well.

Eric replied with the actual commit during the 2.6.24 merge window that
introduced this bug.  The io_apic.c code from the i386 tree did not stay
completely static when it was merged into the x86 io_apic_32.c code.
Here is the commit that Eric identified that introduced the defect:

In particular commit dbeb2be21d678c49a8d8bbf774903df15dd55474
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Oct 19 20:35:03 2007 +0200

    i386: introduce "used_vectors" bitmap which can be used to reserve
vectors.
    
    This simplifies the io_apic.c __assign_irq_vector() logic and
removes
    the explicit SYSCALL_VECTOR check, and also allows for vectors to be
    reserved by other mechanisms (ie. lguest).
    
    [ tglx: arch/x86 adaptation ]
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Basically the code introduced the test_and_set_bit() on the used_vectors
bitmap, but it didn't have a corresponding clear_bit() on IRQ
destruction.

Cheers,
-PJ Waskiewicz
