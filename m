Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbYGJTxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbYGJTxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYGJTxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:53:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45479 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYGJTxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:53:43 -0400
Date: Thu, 10 Jul 2008 21:53:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, akpm@linux-foundation.org,
       arjan@linux.intel.com, andi@firstfloor.org, ebiederm@xmission.com,
       jbarnes@virtuousgeek.org, steiner@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080710195320.GA23322@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> x2APIC architecture provides a new x2apic mode, which allows for the 
> increased range of processor addressability ( > 8 bit apic ID 
> support), MSR access to APIC registers, etc. x2apic specification can 
> be found at 
> http://download.intel.com/design/processor/specupdt/318148.pdf 
> (located under 
> http://developer.intel.com/products/processor/manuals/index.htm )
> 
> Interrupt-remapping is part of Intel Virtualization Technology for 
> Directed I/O architecture and the specification can be found from 
> http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf 
> (above link seems to be broken for the moment, but in general it 
> should be found under http://www.intel.com/technology/virtualization/ 
> )
> 
> Interrupt-remapping architecture enables extended Interrupt Mode on 
> x86 platforms supporting 32-bit APIC-IDs. This infrastructure allows 
> the existing interrupt sources such as I/OxAPICs and MSI/MSI-X devices 
> work seamlessly with apic-id's > 8 bits. As such, this is a 
> pre-requisite for enabling x2apic mode in the CPU.
> 
> This patchset adds 64-bit support for interrupt-remapping and x2apic, 
> which introduces apic_ops for basic APIC ops(uncached memory Vs MSR 
> accesses etc), new irq_chip's for supporting interrupt-remapping and 
> new genapic for supporting IPI's, logical cluster/physical x2apic 
> modes.
> 
> irq migration in the presence of interrupt-remapping is done from the 
> process-context as opposed to interrupt-context. Interrupt-remapping 
> infrastrucutre allows us to do this migration in a simple fashion 
> (atleast for edge triggered interrupts).
> 
> Interrupt-remapping (CONFIG_INTR_REMAP) and DMA-remapping 
> (CONFIG_DMAR) can be enabled separately.
> 
> More details in the individual patches that follow.

quite some stuff!

For review and testing purposes i've created a new topic branch for 
this: tip/x86/x2apic and have picked up your patches into it.

I've pushed it out, but it's not merged into tip/master yet (obviously, 
you sent this just a few minutes ago :)

It integrates fine with tip/master. If you do this:

  git-checkout tip/master
  git-merge tip/x86/x2apic

you'll get a clean merge.

Btw., i threw it at the -tip test-cluster and got back a quick build 
bugreport:

arch/x86/xen/enlighten.c: In function 'xen_patch':
arch/x86/xen/enlighten.c:1084: warning: label 'patch_site' defined but not used
arch/x86/xen/enlighten.c: At top level:
arch/x86/xen/enlighten.c:1272: error: expected identifier before '(' token
arch/x86/xen/enlighten.c:1273: error: expected '}' before '.' token
arch/x86/kernel/paravirt.c:376:2: error: invalid preprocessing directive 
#ifndedarch/x86/kernel/paravirt.c:384:2: error: #endif without #if

with this config:

  http://redhat.com/~mingo/misc/config-Thu_Jul_10_21_43_28_CEST_2008.bad

bisection shows that it was caused by:

| 38c56e6b674074f8ec98722ceca3d15771e17abe is first bad commit
| commit 38c56e6b674074f8ec98722ceca3d15771e17abe
| Author: Suresh Siddha <suresh.b.siddha@intel.com>
| Date:   Thu Jul 10 11:16:49 2008 -0700
|
|    x64, x2apic/intr-remap: basic apic ops support

(that's all for tonight - will have another look tomorrow.)

	Ingo
