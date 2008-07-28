Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbYG1V6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbYG1V6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYG1V6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:58:16 -0400
Received: from www.tglx.de ([62.245.132.106]:60006 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYG1V6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:58:15 -0400
Date: Mon, 28 Jul 2008 23:51:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI/CPUIDLE: prevent setting pm_idle to NULL
In-Reply-To: <20080728195324.GE30344@one.firstfloor.org>
Message-ID: <alpine.LFD.1.10.0807282340590.14925@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807272343480.574@apollo.tec.linutronix.de> <20080728174644.GC30344@one.firstfloor.org> <alpine.LFD.1.10.0807282107500.14925@apollo.tec.linutronix.de> <20080728195324.GE30344@one.firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, Andi Kleen wrote:

> > The problem here is that the acpi/cpuidle code can be in a state where
> > the _save/old variables _ARE_ NULL because they had not been
> > initialized with the original pm_idle before the module is removed or
> > the cst state changes. So all we have to do is to prevent pm_idle to
> > be set to NULL.
> 
> It still seems wrong to me to fall back to the cpuidle idle function
> instead of the earlier idle function just because cpuidle was loaded
> in a weird way. 

WTF are you talking about ? 

pm_idle_save is initialized with pm_idle (the original idle function
selected by the arch code).

When CST changes or the acpi/cpuidle modules are removed we need to
restore the original pm_idle function from pm_idle_save.

When pm_idle_save was not initialized, which can happen, then we wrote
NULL to pm_idle, which is obviously wrong. We simply want to avoid
that we write NULL into pm_idle.

That's all what the patch does. Nothing else. 

This problem was hidden by the magic

   if (!pm_idle)
      pm_idle = default_idle;

in the arch/x86 code which was removed when I refactored the pm_idle
initialization code.

Just get it. That "if (!pm_idle)" check in the arch code was just
papering over the fact that the acpi code set pm_idle to NULL under
certain conditions.

Thanks,

	tglx
