Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbXFLTH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbXFLTH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXFLTHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:07:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:58138 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751323AbXFLTHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:07:20 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18xeZJeffgxkUNAE48m8WLfAjpWSCY5RSRy35eGFw
	a5rQC5QYugHyNJ
Date: Tue, 12 Jun 2007 21:07:30 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
       perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       levon@movementarian.org
Subject: Re: OProfile issues
Message-ID: <20070612190730.GA6978@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Stephane Eranian <eranian@hpl.hp.com>,
	oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
	perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
	levon@movementarian.org
References: <20070612150246.GJ32163@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070612150246.GJ32163@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.12 08:02:46 -0700, Stephane Eranian wrote:
> Hello,
> 
> I am working on perfmon2 to allow Oprofile and perfmon2 to co-exist
> as suggested by Andi Kleen. I looked at the Oprofile init/shutdown
> code and I am puzzled by several things which you might be able to
> explain for me. I am looking at 2.6.22-rc3.
> 
> Here are the issues:
> 
>  * model->fill_in_addresses is called once for all CPUs
>    on X86, it does more than just filling in the addresses,
>    it also coordinates with the NMI watchdog by reserving
>    registers via the reserve_*nmi() interface.
> 
>    The problem is that the release of the registers is done
>    in model->shutdown() which happens to be executed on every
>    CPU. So you end up releasing the registers too many times.
>    This is *not* harmless once you start sharing the PMU with
>    other subsystems given the way the allocator is designed.

Hm, currently it should be ok to move the call to model->shutdown() into
nmi_shutdown(), but you might want to instead set addr to 0 when the
register is released to still allow for per cpu actions in shutdown().

>  * allocate_msrs() allocates two tables per CPU. One for the
>    counters, the other for the eventsel registers. But then
>    nmi_setup() copies the cpu_msrs[0] into cpu_msrs[] of all
>    other cpus. This operation overrides the cpu_msrs[].counters
>    and cpu_msrs[].controls pointers for all CPUs but CPU0.
>    But free_msrs() will free the same tables multiple times. This
>    causes a kernel dump when you enable certain kernel debugging
>    features. The fix is to copy the content of the counters and
>    controls array, not the pointers.

This was fixed in commit 0939c17c7bcf1.

>  * the fill_in_addresses() callback for X86 invokes the NMI watchdog
>    reserve_*_nmi() register allocation routines. This is done regardless
>    of whether the NMI watchdog is active. When the NMI watchdog is not
>    active, the allocator will satisfy the allocation for the first MSR
>    of each type (counter or control), but then it will reject any
>    request for the others. You end up working with a single
>    counter/control register.

Hm, ouch. I'll try to move the reservation parts into a separate system.

Björn
