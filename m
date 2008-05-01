Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbYEASQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbYEASQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbYEASQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:16:45 -0400
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:59737 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753712AbYEASQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:16:44 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Why such a big difference in init-time PCI resource call-paths (x86 vs x86_64) ?
Date: Thu, 1 May 2008 11:16:31 -0700
User-Agent: KMail/1.9.9
Cc: TJ <linux@tjworld.net>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1209571638.25051.54.camel@hephaestion.lan.tjworld.net>
In-Reply-To: <1209571638.25051.54.camel@hephaestion.lan.tjworld.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011116.31782.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2008 9:07 am TJ wrote:
> In preparation for writing a Windows-style PCI resource allocation
> strategy
>
>  - use all e820 gaps for IOMEM resources; top-down allocation -
>
> and thus giving devices with large IOMEM requirements more chance of
> allocation in the 32-bit address space below 4GB (see bugzilla #10461),
> I'm mapping out the current implementation to ensure I understand the
> implications and guard against breaking any quirks or undocumented
> features.

Excellent, definitely a worthwhile change...

> There are significant differences between the x86 and x86_64
> implementations and I've not been able to find any explanation or deduce
> a reason for it.
>
> The first difference is mainly cosmetic. With one minor difference the
> source code of:
>
>   arch/x86/kernel/e820_32.c::e820_register_memory()
>   arch/x86/kernel/e820_64.c::e820_setup_gap()
>
> is identical. The purpose is to find the single largest gap in the e820
> map and point pci_mem_start to the start of the region (with a
> rounding-up adjustment).
>
> Why do these functions have such differing names?
> Which name is preferable?

Well e820_setup_gap is a bit more descriptive, but if you're factoring out 
common code in the x86 tree, it may as well be even more descriptive, e.g. 
e820_find_pci_gap or somesuch.

> The second difference appears more profound. In the x86_64 call path,
> the code that reserves resources and requests the ioport resource is
> called in:
>
>   arch/x86/kernel/setup_64.c::setup_arch()
>
> immediately *before* the call to e820_setup_gap():
>
> 	e820_reserve_resources();
> 	e820_mark_nosave_regions();
>
> 	/* request I/O space for devices used on all i[345]86 PCs */
> 	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
> 		request_resource(&ioport_resource, &standard_io_resources[i]);
>
> 	e820_setup_gap();
>
>
> On x86 however:
>
> 	e820_register_memory();
> 	e820_mark_nosave_regions();
>
> Although e820_register_memory() and e820_mark_nosave_regions() are
> called at basically the same point in:
>
>   arch/x86/kernel/setup_32.c::setup_arch()
>
> as the 64-bit setup_arch() call to e820_setup_gap(), the equivalent of
> the 64-bit e820_reserve_resources():
>
>   arch/x86/kernel/e820_32.c::init_iomem_resources()
>
> and the loop calling request_resource() is in:
>
>   arch/x86/kernel/setup_32.c::request_standard_resources()
>
> which is declared as:
>
>   subsys_initcall(request_standard_resources);
>
>
> Now, unless my call-path tracing has gone way wrong, this initcall won't
> happen until *much* later after a *lot* of other 'stuff' has been done.
> If my understanding of the initcall mechanism is correct, it finally
> gets called in:
>
>   init/main.c::do_initcalls()
>
> as part of the generic multi-level device init call-by-address
> functionality where each function is in the .initcallX.init section and
> they have names of the form __initcall_functionX (where X is the level
> id).
>
> So, why the big difference in implementations?
> What are the implications of each?
> Is one preferable to the other?

Andi may remember some of the history here.  It seems like we should be 
reserving those regions early on like the x86_64 code does, but it's possible 
that will create more conflicts later on for some platforms (I don't know of 
any offhand though).

> Any other observations or caveats?

For future patches and x86 specific questions, you should probably cc lkml and 
the x86 maintainers, they may be able to provide additional feedback.

Thanks,
Jesse
