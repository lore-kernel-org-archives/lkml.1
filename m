Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYGNSJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYGNSJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYGNSJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:09:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:62114 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbYGNSJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aC2wvoy8Ux5lipZ391TJHyoy5pQCGLQBM7Rvd3ndFv3MOeS4BgjE1QK6J8nLylb8J5
         gbmknQhCsxhqZdfw3CQ/Ej0GuRhcHq8FPexhXNuD5F6F6dgWm68kXWlC+kkn3hfPBzpg
         sRN6F7EchG6kr6XPCNt7tIdUWcwol9IzmSVhA=
Date: Mon, 14 Jul 2008 22:09:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
Message-ID: <20080714180908.GB6986@asus>
References: <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <20080713010843.GD1678@linux-os.sc.intel.com> <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com> <20080713162804.GI1678@linux-os.sc.intel.com> <Pine.LNX.4.55.0807131737240.10630@cliff.in.clinika.pl> <20080713171634.GD7459@asus> <Pine.LNX.4.55.0807140016140.10630@cliff.in.clinika.pl> <20080714164809.GA6986@asus> <Pine.LNX.4.55.0807141805500.16334@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807141805500.16334@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Mon, Jul 14, 2008 at 06:20:26PM +0100]
| On Mon, 14 Jul 2008, Cyrill Gorcunov wrote:
| 
| > Maciej, but if we eliminate LOCK# by using simple MOV there will not
| > be guarantee for atomicity. Am I wrong?
| 
|  You are right, but we do not care about atomicity.  We only care about
| interrupts.  This is because the local APIC is private to its associated
| CPU and inaccessible from the outside, at least for writes (mind the
| Remote Read command), so as long as the local CPU does not issue
| consecutive write cycles, there is no problem with another CPU getting in
| the way.  Which means any RMW instruction would suffice here, with the R
| part of the cycle separating any possible preceding write from one
| immediately following, but unfortunately the only one we can use is the
| XCHG and it has always implied the LOCK#, since the 8086, which at that
| point was considered a microoptimization (the LOCK# was cheap and an extra
| memory byte, otherwise needed for the LOCK prefix, expensive back then).  
| So atomicity is an unfortunate side effect rather than a part of the
| design here.
| 
|  Now if we know the APIC does not suffer from the double-write erratum,
| then we can use a straight MOV as consecutive writes are not a concern
| anymore.
| 
|   Maciej
| 

  Maciej, check me please (it's a bit shame but I don't understand the problem
that deep) - we have only two errata here 3AP and 11AP. 3AP says - "Writes to
error register clears register" so we don't care about locking there since
our mostly task is to read error number or clear it (well we're recommened
to write before read - but that is different and not related to the hw
error).

  The second problem - 11AP says the following: "Back to back assertions of
HOLD or BOFF# may cause lost APIC write cycle". For this case we use LOCK#
since - HOLD is not recognized during LOCK cycles (as Intel docs says).

  Did I miss something? Or maybe it's completely out-of-topic? :)

		- Cyrill -
