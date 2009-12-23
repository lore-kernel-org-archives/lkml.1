Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZLWQvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZLWQvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbZLWQvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:51:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597AbZLWQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:51:08 -0500
Date: Wed, 23 Dec 2009 08:49:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
In-Reply-To: <87bphpd4rt.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B2B4485.6000305@cfl.rr.com> <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain> <4B2B9F9F.7040802@compro.net> <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain>
 <4B2BE05B.9050006@compro.net> <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain> <4B30E1B4.7000702@compro.net> <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain> <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdo
 main> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>
 <87bphpd4rt.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Dec 2009, Andi Kleen wrote:
> 
> I suspect it's a system where the APIC timer stops in deeper idle
> states and it supports them. In this case CPU #0 does timer broadcasts
> when needed to wake the other CPUs up from deep C, but for that it has
> to run with HPET. At least the other ones can still enjoy the LAPIC
> timer.

Ahh, ok, that makes sense. I was assuming the broadcast timer would act in 
that capacity, but..

> This might suggest that Mark's floppy controller doesn't like
> deep C? Mark, did you try booting with processor.max_cstate=1
> and HPET enabled?

We have indeed had historical issues with floppy and sleep states before. 

I do note another issue, though - the floppy driver itself seems totally 
broken when it comes to using interleaved sectors. Alain, that "place 
logical sectors" code is simply _broken_ - the "while" kicks in only if 
the first sector we test is busy _and_ we were at the last sector so that 
we increment past F_SECT_PER_TRACK.

So shouldn't that sector layout be something like the appended?

		Linus
---
 drivers/block/floppy.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3266b4f..9c9148c 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2237,13 +2237,10 @@ static void setup_format_params(int track)
 	for (count = 1; count <= F_SECT_PER_TRACK; ++count) {
 		here[n].sect = count;
 		n = (n + il) % F_SECT_PER_TRACK;
-		if (here[n].sect) {	/* sector busy, find next free sector */
+		while (here[n].sect) {	/* sector busy, find next free sector */
 			++n;
-			if (n >= F_SECT_PER_TRACK) {
+			if (n >= F_SECT_PER_TRACK)
 				n -= F_SECT_PER_TRACK;
-				while (here[n].sect)
-					++n;
-			}
 		}
 	}
 	if (_floppy->stretch & FD_SECTBASEMASK) {
