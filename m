Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbZHYTNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbZHYTNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbZHYTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:13:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32953 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677AbZHYTNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:13:45 -0400
Date: Tue, 25 Aug 2009 21:12:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825191231.GA22821@elte.hu>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org> <alpine.LFD.2.01.0908251155570.3218@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908251155570.3218@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 25 Aug 2009, Yinghai Lu wrote:
> > 
> > initial apic id and apic id could be different.
> > 
> > and we should use initial apic id to get correct phys pkg id in 
> > case BIOS set crazy apic id.
> 
> Yinghai - I think you missed Cyrills' point.  Let me repeat it:
> 
> 	"cpu_has_apic bit turned off"
> 
> there's no apic. No "initial apic id". No "phys pkg id". No 
> nothing.
> 
> Discussions about "correct phys pkg id" are pointless.

that's not the case here though:

[    8.713916] Total of 32 processors activated (162314.96 BogoMIPS).

so APICs are active. The real difference is i think this aspect of 
commit 2759c3287:

 static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 {
-       return hard_smp_processor_id() >> index_msb;
+       return initial_apic_id >> index_msb;
 }

We need to revert back to .30 behavior here. (In case of which 
environment to trust we almost always trust whatever booted millions 
of Linux boxes in the past already.)

Furthermore, commit 2759c3287 did not declare any side-effects and 
clearly causes a side-effect on vSMP which apparently has an 
overlapping set of initial APIC ids.

Ravikiran, your patch does not do a clear revert of this bit though. 
If you do a plain revert of the line above alone, does that fix the 
problem too?

	Ingo
