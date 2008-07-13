Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbYGMXq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbYGMXq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 19:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYGMXqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 19:46:49 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64134 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754338AbYGMXqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 19:46:49 -0400
Date: Mon, 14 Jul 2008 00:46:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
In-Reply-To: <20080713171634.GD7459@asus>
Message-ID: <Pine.LNX.4.55.0807140016140.10630@cliff.in.clinika.pl>
References: <200807080141.05436.yhlu.kernel@gmail.com>
 <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
 <200807111841.55403.yhlu.kernel@gmail.com> <20080713010843.GD1678@linux-os.sc.intel.com>
 <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com>
 <20080713162804.GI1678@linux-os.sc.intel.com> <Pine.LNX.4.55.0807131737240.10630@cliff.in.clinika.pl>
 <20080713171634.GD7459@asus>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Cyrill Gorcunov wrote:

> Guys, when I was in attempt to unify apic code first thing was -
> renaming apic_write. Here is a patch for this - only ESR and K8
> registers are untouched - may be usefull to apply (actually not
> sure if it will apply without fuzz now). Wonder if this help :)

 Confirmed -- with one exception all the generic write accesses to the
APIC absolutely have to use apic_write_around() because of the lethal
implications of the double-write erratum of some local APIC versions
integrated with Pentium CPUs.

 The exception is the ESR register which cannot use the function because
of: 1. its semantics which gives side-effects on a read, 2. another
erratum, which makes the register lose its contents on a write.  
Therefore the approach is to avoid writes, which are architecturally
required, altogether on Pentium CPUs, which ignore them by their
implementation, and then use straigth apic_write() on all the newer APIC
versions which would lose some information if a read happened before a
write.

 The K8 does not have to use apic_write_around() for the same reasons
x86-64 does not, as neither are hit by the double-write erratum, so all
their processor-specific write accesses may use apic_write() to avoid a
performance hit when used with a kernel with X86_GOOD_APIC cleared.  
Unfortunately, the LOCK# bus access always implied by the XCHG is quite
expensive, but still less intrusive than a sequence involving masking
interrupts locally beforehand and then restoring the IF flag to the
previous state afterwards.  As the APIC is local to the CPU, the grant
should not extend outside to the external bus though.

 And last, but not least, alternatives can be used these days to patch the
expensive XCHG instructions out with cheap MOV ones -- something that was
not available when the workaround was designed some ten years ago.

  Maciej
