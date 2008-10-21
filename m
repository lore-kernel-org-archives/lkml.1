Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYJUSFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYJUSFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYJUSE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:04:56 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:52313 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbYJUSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:04:55 -0400
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081021174008.GH12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 21 Oct 2008 11:04:54 -0700
Message-Id: <1224612294.6161.43.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 10:40 -0700, Andi Kleen wrote:
> > > It would be far nicer if VMware just emulated the "constant_tsc" bit
> > > in the AMD CPUID leaf, instead of adding all that gunk to Linux.
> > > Right now it's only checked for AMD CPUs, but that could be changed.
> >
> > I am not sure if we might want to skip the tsc_sync code for all the
> > cpus which have this constant_tsc bit set, can we ?
> 
> It should be ok, although normally sanity checks should be kept.
> 
> > Since i have seen that we can have cases where tsc is marked unstable as
> > its not found to be perfectly stable between cpus, we have to make sure
> > that we avoid this check when on VMware. Even with slight difference in
> 
> Normally tsc sync should only fail when the error is large.
> It cannot detect very small derivation by design. It's more like
> a sanity check "does the TSC sync look half way sane"

FWIU from the code, even if  cpu A's TSC is just 1 tick behind that of
cpu B, we increment the nr_wraps value.
And the code expects that there are no wraps in TSC throughout the
20msec measurement window. 
So IMO its fairly easy to fail this test.
> 
> If it fails on VMware perhaps the margins are not big enough or
> something else is fishy.
> 
> But still it could be skipped with constant_tsc. But again you
> shouldn't really fail that check -- if you do fail are you
> sure your clock is really synchronized enough that there
> are no observable differences?
> 
> > TSC between cpus, we know that TSC is the best available clocksource as
> > the hypervisor (VMware) makes sure that the drift is always marginal (if
> > ever there is).
> 
> The drift has to be unobservable, otherwise you still risk
> non monotonity.  Also when there is drift it has to be short
> term only, otherwise it would accumulate over longer times.

Usually the problem is more pronounced during the boot process, the
TSC's between processors are not perfectly in sync at bootup but the
drift is not observable later, and from timekeeping perspective we are
perfectly fine.

Thanks,
Alok


> 
> -Andi
> 
> --
> ak@linux.intel.com

