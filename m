Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYGNRV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYGNRV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYGNRVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:21:17 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63503 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752542AbYGNRVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:21:16 -0400
Date: Mon, 14 Jul 2008 18:20:26 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
In-Reply-To: <20080714164809.GA6986@asus>
Message-ID: <Pine.LNX.4.55.0807141805500.16334@cliff.in.clinika.pl>
References: <200807080141.05436.yhlu.kernel@gmail.com>
 <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
 <200807111841.55403.yhlu.kernel@gmail.com> <20080713010843.GD1678@linux-os.sc.intel.com>
 <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com>
 <20080713162804.GI1678@linux-os.sc.intel.com> <Pine.LNX.4.55.0807131737240.10630@cliff.in.clinika.pl>
 <20080713171634.GD7459@asus> <Pine.LNX.4.55.0807140016140.10630@cliff.in.clinika.pl>
 <20080714164809.GA6986@asus>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Cyrill Gorcunov wrote:

> Maciej, but if we eliminate LOCK# by using simple MOV there will not
> be guarantee for atomicity. Am I wrong?

 You are right, but we do not care about atomicity.  We only care about
interrupts.  This is because the local APIC is private to its associated
CPU and inaccessible from the outside, at least for writes (mind the
Remote Read command), so as long as the local CPU does not issue
consecutive write cycles, there is no problem with another CPU getting in
the way.  Which means any RMW instruction would suffice here, with the R
part of the cycle separating any possible preceding write from one
immediately following, but unfortunately the only one we can use is the
XCHG and it has always implied the LOCK#, since the 8086, which at that
point was considered a microoptimization (the LOCK# was cheap and an extra
memory byte, otherwise needed for the LOCK prefix, expensive back then).  
So atomicity is an unfortunate side effect rather than a part of the
design here.

 Now if we know the APIC does not suffer from the double-write erratum,
then we can use a straight MOV as consecutive writes are not a concern
anymore.

  Maciej
