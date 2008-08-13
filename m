Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYHMRFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYHMRFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYHMREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:04:53 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:2331 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbYHMREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:04:52 -0400
X-BigFish: VPS-40(zz1432R9370P98dR1805M936fQzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5JU3K-02-ECC-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: invalidate caches before going into suspend
Date: Wed, 13 Aug 2008 12:09:57 -0500
User-Agent: KMail/1.9.9
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813164728.GD5720@elte.hu>
In-Reply-To: <20080813164728.GD5720@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200808131209.57534.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 13 Aug 2008 17:04:38.0619 (UTC) FILETIME=[AB854AB0:01C8FD66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008, Ingo Molnar wrote:
> 
> * Mark Langsdorf <mark.langsdorf@amd.com> wrote:
> 
> > When a CPU core is shut down, all of its caches need to be flushed to 
> > prevent stale data from causing errors if the core is resumed. Current 
> > Linux suspend code performs an assignment after the flush, which can 
> > add dirty data back to the cache.  On some AMD platforms, additional 
> > speculative reads have caused crashes on resume because of this dirty 
> > data.
> > 
> > Relocate the cache flush to be the very last thing done before 
> > halting.
> 
> nice catch! Applied to x86/urgent.
> 
> I'm really curious: how did you find this bug? Did you see a CPU come up 
> as !CPU_DEAD?

AMD's diagnostic code for new CPUs was hanging when coming out of suspend,
so I presume it was hitting a bug check for not !CPU_DEAD.  I got the
debug lab reports second hand.  They traced the root cause to dirty data
being preserved in the cache and suggested relocating the wbinvd().

> please send a patch for the 32-bit side too, it has the same bug.
> 
> also, we might be safer if the wbinvd(), the CLI and the halt was in a 
> single assembly sequence:

> to make sure the compiler doesnt ever insert something into this 
> codepath? [ And note the double cli which would be further 
> robustification - in theory we could get a spurious interrupt straight 
> after the wbinvd. ] Hm?

I don't think it's necessary.  I can submit a delta patch later if you
think it's really necessary.


Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

diff -r 1e74a821dd00 arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c	Tue Aug 12 12:04:12 2008 -0500
+++ b/arch/x86/kernel/process_32.c	Wed Aug 13 06:40:00 2008 -0500
@@ -95,11 +95,11 @@ static inline void play_dead(void)
 {
 	/* This must be done before dead CPU ack */
 	cpu_exit_clear();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
 
+	wbinvd();
 	/*
 	 * With physical CPU hotplug, we should halt the cpu
 	 */




