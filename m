Return-Path: <linux-kernel-owner+w=401wt.eu-S934697AbXGZTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697AbXGZTOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761239AbXGZTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:14:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761013AbXGZTOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:14:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [2.6.23-rc1 REGRESSION] CPU hotplug totally broken on HPC nx6325 (x86_64)
Date: Thu, 26 Jul 2007 21:22:49 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <200707261440.50649.rjw@sisk.pl> <alpine.LFD.0.999.0707260924150.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707260924150.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262122.50517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 July 2007 18:43, Linus Torvalds wrote:
> 
> On Thu, 26 Jul 2007, Rafael J. Wysocki wrote:
> >
> > On my Turion64-based HPC nx6325 with the 2.6.23-rc1 x86_64 kernel doing
> > 
> > # echo 0 > /sys/devices/system/cpu/cpu1/online
> > 
> > causes the system to crash in a spectacular fashion (call traces going
> > continuously on the console, no reaction to anything except for the power
> > button).  For this reason, suspend and hibernation don't work as well.
> 
> Yeah, I really shouldn't have applied that patch. I didn't notice that it 
> not only cleaned up the direct memcpy's, it also re-introduced the damn 
> broken code that we fixed once already.
> 
> Dammit, that read-only debug support IS NOT WORTH THIS CRAP.
> 
> I absolutely *detest* it when "debugging features" end up being the thing 
> that causes crashes. I think it shows a total lack of taste and 
> understanding, and I'm totally tired of it. This has happened too many 
> times.
> 
> Andi: please don't send this patch *ever* again. If a patch that is 
> supposed to help debugging just causes problems, that patch should be 
> thrown away FOREVER.
> 
> Andrew - on that same note: please throw away the dwarf traceback crap 
> from your tree that Andi is still apparently pushing. Exact same issue. 
> 
> Debugging "helper" code that has historically only caused problems. We 
> could equally well just enable frame pointers for debugging and add the 
> trivial code to follow that instead, and it would work (the way it has 
> worked on x86 basically forever).
> 
> Rafael, does reverting just this part (and leaving the "text_poke()" 
> cleanups) work for you?

Yes, it does, with the appended fix on top. :-)

Greetings,
Rafael


---
 arch/i386/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc1/arch/i386/kernel/alternative.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/i386/kernel/alternative.c
+++ linux-2.6.23-rc1/arch/i386/kernel/alternative.c
@@ -432,7 +432,7 @@ void __init alternative_instructions(voi
  */
 void __kprobes text_poke(void *oaddr, unsigned char *opcode, int len)
 {
-	memcpy(addr, opcode, len);
+	memcpy(oaddr, opcode, len);
 	sync_core();
 	/* Not strictly needed, but can speed CPU recovery up. Ignore cross cacheline
 	   case. */
