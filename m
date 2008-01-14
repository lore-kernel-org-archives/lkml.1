Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYANT74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYANT74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYANT7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:59:48 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57608 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYANT7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:59:47 -0500
Date: Mon, 14 Jan 2008 20:59:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080114195950.GA9257@uranus.ravnborg.org>
References: <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150103.GA2700@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114150103.GA2700@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 04:01:03PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Would be great to have them automated - just dunno how to do it. Do 
> > > you see a feasible way to do it?
> > 
> > a good starting point would be to make the warnings a lot more 
> > self-explanatory. Right now it's often non-obvious trying to figure 
> > out how the dependencies are structured and which one should be 
> > changed to get rid of the bug.
> 
> for example, in current -git, could you tell me why this triggers:
> 
>  WARNING: vmlinux.o(.text+0x87e2a): Section mismatch: reference to 
>           .init.text: (between 'process_zones' and 'setup_per_cpu_pageset')
> 
> and how to resolve it? I had a quick look and it was not obvious to me.
I was confused by your error message - it looked all wrong.

process_zones is .text but setup_per_cpu_pageset is __init. I expect you
had some local changes.

So I tried myself and got this warning:
WARNING: mm/built-in.o(.text+0x6864): Section mismatch: reference to .init.text: (between 'process_zones' and 'pageset_cpuup_callback')

This made much more sense.
So I looked closely at process_zones() and the first
thing I always do is to check all the local functions.

I noticed that we use the function zone_batchsize() which is marked __devinit.
A function marked __cpuinit may use other functions marked __cpuinit, data marked
__cpuinitdata and .text/.data. But references to __devinit is not ok.

I furthermore noticed that zone_batchsize() were used in anohter
function marked __meminit.

So the simple fix for this warning is to remove the annotation of zone_batchsize.
It looks like a real opps candidate to me..

Why modpost did not pick up the zone_batchsize symbol is anohter matter.
It is present in the file:
$ objdump --syms vmlinux.o | grep zone_batchsize
0000000000016929 l     F .init.text     0000000000000053 zone_batchsize

Debugging modpost I could see that we had an addend value of 695,
but the addr of the symbol is 699. So somehow we point 4 bytes wrong.

Strange...

Anyway - here follows the patch.

	Sam

[PATCH] mm: fix section mismatch warning in page_alloc.c

With CONFIG_HOTPLUG=n and CONFIG_HOTPLUG_CPU=y we saw
following warning:
WARNING: mm/built-in.o(.text+0x6864): Section mismatch: reference to .init.text: (between 'process_zones' and 'pageset_cpuup_callback')

The culprint was zone_batchsize() which were annotated
__devinit but used from process_zones() which is annotated __cpuinit.
zone_batchsize() are used from another function annotated __meminit
so the only valid option is to drop the annotation of
zone_batchsize() so we know it is always valid to use it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e1028fa..b2838c2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2566,7 +2566,7 @@ static void __meminit zone_init_free_lists(struct pglist_data *pgdat,
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __devinit zone_batchsize(struct zone *zone)
+static int zone_batchsize(struct zone *zone)
 {
 	int batch;
 
