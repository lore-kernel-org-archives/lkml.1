Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZDDI3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZDDI3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZDDI3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:29:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:50446 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbZDDI3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:29:06 -0400
Subject: RE: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
From: David Woodhouse <dwmw2@infradead.org>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A2F7C435@pdsmsx503.ccr.corp.intel.com>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
	 <1238781474.27006.7866.camel@localhost.localdomain>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C435@pdsmsx503.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Apr 2009 09:28:58 +0100
Message-Id: <1238833738.3560.14.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 11:37 +0800, Han, Weidong wrote:
> Siddha, Suresh B wrote:
> > On Fri, 2009-04-03 at 02:15 -0700, Han, Weidong wrote:
> >> 
> >> -#ifdef CONFIG_INTR_REMAP
> >> +#ifdef CONFIG_X86_X2APIC
> > 
> > Weidong, Can we also fix these config options?
> > 
> > Today, selecting CONFIG_INTR_REMAP automatically selects
> > CONFIG_X86_X2APIC. It should be the other way round.
> > 
> > i.e., turning on CONFIG_X86_X2APIC should automatically enable
> > CONFIG_INTR_REMAP and just enabling CONFIG_INTR_REMAP shouldn't enable
> > CONFIG_X86_X2APIC.
> > 
> > Also please make sure that the code compiles (and works :)) in
> > different combinations of these config settings.
> 
> 
> Thanks for your reminder. Following patch changes the config options
> selection. The code can compiles in different combinations.

Doesn't build for me.

Firstly, your patch 2/2 doesn't apply against git HEAD. I needed to
massage it to work. I think you're testing against an old kernel.

Then (with the massaged version in the iommu-2.6.git tree) if I apply
your third patch below I get this error when building with INTR_REMAP
&& !X2APIC:

arch/x86/kernel/apic/apic.c: In function ‘lapic_resume’:
arch/x86/kernel/apic/apic.c:2054: error: ‘EIM_32BIT_APIC_ID’ undeclared (first use in this function)
arch/x86/kernel/apic/apic.c:2054: error: (Each undeclared identifier is reported only once
arch/x86/kernel/apic/apic.c:2054: error: for each function it appears in.)
make[2]: *** [arch/x86/kernel/apic/apic.o] Error 1

If I apply the naïve fix of just changing a couple more #ifdef
CONFIG_INTR_REMAP to #ifdef CONFIG_X86_X2APIC (in enable_IR_x2apic() and
lapic_resume()), it builds but doesn't boot -- it just hangs after
reporting Queued Invalidation, at the code you added in dmar.c to call
enable_intr_remapping().

Please make sure you're testing against a current kernel, and test that
it builds and boots in all three configurations (no remapping, remapping
but no x2apic, and with both enabled).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

