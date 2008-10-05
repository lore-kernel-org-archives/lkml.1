Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYJEOxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYJEOxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 10:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYJEOxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 10:53:03 -0400
Received: from www.tglx.de ([62.245.132.106]:53718 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbYJEOxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:53:01 -0400
Date: Sun, 5 Oct 2008 16:52:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional
 hotplug CPUs to be set at compile time
In-Reply-To: <20081005102835.GA8947@elte.hu>
Message-ID: <alpine.LFD.2.00.0810051626150.3398@apollo>
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org>
 <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com> <20081005102835.GA8947@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Ingo Molnar wrote:
> * Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > Yes, it works and I don't see how it could cause any problems.
> > 
> > Ingo, can we get this in 2.6.27? You can drop my original patch.
> > 
> > Tested-by: Chuck Ebbert <cebbert@redhat.com>
> 
> looks good, applied to tip/x86/core, thanks!

No, this patch is horrible. 

The correct check is num_present_cpus(). There is no need to make the
weird additional_cpus hackery globally available.

Btw, additional_cpus has interesting properties. Providing a negative
number < -1 on the kernel command line - happened due to a typo -
explodes in early boot, which is not really surprising, but should be
sanity checked.

Thanks,

	tglx
---------------->
Subject: x86: make UP alternatives switch depend on present cpus
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 05 Oct 2008 16:45:22 +0200

num_possible_cpus() can be > 1 when disabled CPUs have been accounted.

Disabled CPUs are not in the cpu_present_map, so we can use
num_present_cpus() as a safe indicator to switch to UP alternatives.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index fb04e49..a84ac7b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -444,7 +444,7 @@ void __init alternative_instructions(void)
 					    _text, _etext);
 
 		/* Only switch to UP mode if we don't immediately boot others */
-		if (num_possible_cpus() == 1 || setup_max_cpus <= 1)
+		if (num_present_cpus() == 1 || setup_max_cpus <= 1)
 			alternatives_smp_switch(0);
 	}
 #endif
