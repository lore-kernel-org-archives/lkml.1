Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYJUTrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYJUTrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYJUTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:47:44 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:55296 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbYJUTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:47:44 -0400
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081021192746.GJ12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 21 Oct 2008 12:47:43 -0700
Message-Id: <1224618463.6161.82.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 12:27 -0700, Andi Kleen wrote:
> On Tue, Oct 21, 2008 at 12:10:36PM -0700, Alok Kataria wrote:
> > On Tue, 2008-10-21 at 11:15 -0700, Andi Kleen wrote:

> > the status quo. Apart from that, even on VMware virtualized environment
> > there can different configurations where this margin keeps on varying,
> > under different scenarios, f.e. under overcommitment and all. So i don't
> > think that changing threshold values maybe safe for all cases.
> 
> When the margin changes then it likely won't be good enough for
> gettimeofday(). There are a couple of testers for monotonity around,
> would such a system with shifting marging surive running them
> for a few days?

I meant, the margin changes when you are running different flavors of
the build, or running different user configurations (from overcommitment
POV). Once a system is booted the margin won't vary, apart from the
bootup stage which will always have some extreme states. In all our
internal testing that has been done, we have never noticed time drift is
withing the NTP threshold when its compared to the host system, under
varying load. 

> 
> 
> >
> > I think going with ignoring this check for specific systems is the best
> > way to go further.
> 
> Disagree.

Having a flag like tsc_reliable should be ok, right ? Systems which
provide constant rate TSC guarantees can set this bit and don't have to
pollute the code all over, this is only if we can't avoid the check for
CONSTANT_TSC systems (see below).

> 
> > I hope you also agree with the CONSTANT_TSC check.
> 
> Yes constant_tsc is good, although the question is how much sanity
> check is still needed. I suspect even with it some sanity check
> will still make sense.

Hmm, in one of the cases i have seen that the max_warp value was as high
as 105cycles, and that the nr_warps was as high as 1265, and this is
just one situation, given that the host can be overloaded in some cases,
this value may be high. So adding a sanity check for this is something
that i would prefer to avoid as it will always have false positives in
some cases. 

> 
> And the question is if your HV even sets the bit?
> Also you would need to change the Linux code to check it on Intel too.

It reflects the hardware state right now, though i am going to check
that this bit is set for future products.
Given that, i will still have to add a quirk to the kernel to enable
that capability bit for older products. This solution is acceptable
IMHO, as atleast it doesn't pollute the kernel code.
The quirk will handle the Intel case too for now, but once the bit is
added i will add code to check that leaf for intel too.

Thanks,
Alok
> 
> -Andi
> 
> --
> ak@linux.intel.com

