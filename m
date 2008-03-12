Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYCLTMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYCLTMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYCLTLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:11:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:36716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYCLTLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:11:53 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Date: Wed, 12 Mar 2008 15:11:17 -0400
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Andi Kleen <andi@firstfloor.org>, Lee Revell <rlrevell@joe-job.com>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080310100008.GA9520@elf.ucw.cz> <20080310134915.45ae7446@mjolnir.drzeus.cx>
In-Reply-To: <20080310134915.45ae7446@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121511.17389.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > USB keeps processor out of C3 in many cases.
> 
> I figured that was the case. But I did not see any difference in powertop.

Modern Intel mobile processors have a feature called "C2 popup"
that allows the processor to retire DMA from C3 without
breaking into C0.  Instead the processor pops up to C2
where the cache snoop can allow the DMA to retire --
then it returns to C3, all transparent to software.

That is why powertop does not see it.

> > > 4. Battery and AC
> > > 
> > > The noise increases with the battery present and also when the AC supply is removed.
> > >
> > 
> > On battery, some machines swap C3 for "secret" C4, which is slower but
> > saves power.

ak> Normally such things are not visible in the DSDT, but hidden in SMM traps.

no, this mechanism is totally visible to the OS via a _CST re-evaluation on AC/DC transition.

This is very commmon, as the reference BIOS code does it.
It isn't a secret.  There are two common techniques -- either
re-define C3 to enter hardware C4, or simply add C4 as 4th C-state.

> I guess the only way to find out is to disassemble the DSDT. Exposing myself to such concentrations of ACPI is not an appealing project. :/

the latest cpuidle code actually publishes the details of the C-states being used.
 
$ pwd
/sys/devices/system/cpu/cpu0/cpuidle/state3
$ grep . *
desc:ACPI FFH INTEL MWAIT 0x20
latency:17
name:C3
power:250
time:1862590932
usage:9028970

You'll see "desc" change if ACPI pulls a _CST change on you.

> Disabling the second core makes the noise go away. This might be a subset of 1., as I've been told that a stopped core enters C1.

if you disable it at run-time, Linux puts it in C1.
If you never boot it in the first place (eg. maxcpusp=1), the BIOS leaves it in the deepest available C-sate.

The former will prevent the package from entering a deep package C-state,
as c-states are coordinated in hardware.  The later will allow the package
to enter whatever C-state the running core chooses.
 
> Changing HZ and NO_HZ has no noticeable effect on the problem (except the odd behaviour in 2.).
> This is further supported by the fact that Windows also has the problem (which should behave close to 100 HZ without NO_HZ). 
> 
> 
> So for now, the only viable workaround is processor.max_cstate....

yup, that's why we put it in.  Is it insufficient?

-Len

