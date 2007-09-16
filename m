Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbXIPAfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbXIPAfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 20:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXIPAfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 20:35:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbXIPAfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 20:35:06 -0400
Date: Sat, 15 Sep 2007 17:34:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
In-Reply-To: <46EC6F2A.5090008@oracle.com>
Message-ID: <alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
 <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com>
 <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
 <46EC6F2A.5090008@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Sep 2007, Randy Dunlap wrote:
> Command: ./crashme +2000 666 1000 1:00:00 1

Ok, that's close to what I was testing (one of the examples from the 
crashme docs).

> > The original gjc crashme doesn't even do a "mprotect(PROT_EXEC)" by default
> > (nor does it even compile on a modern unix), so it's not going to do
> > anything. I hacked it up, and it appears to work ok for me, but I'm not at
> > all confident that I'm even close to recreating what you are doing.
> 
> So I'm missing some mprotect() call also?
> Oops.

Yeah, by default, it won't do a mprotect(), so as far as I can tell, 
you're always going to hit NX on a writable data page. I'm running with 
the appended patch.

That said, I didn't actually *check* that the mprotect makes any 
difference, and maybe you have one of the early EM64T chips that didn't 
have NX support at all. Or maybe it's dodgy, and is actually the whole 
*reason* for the page fault problem..

I don't have any P4's capable of 64-bit operation (nor do I really want 
any ;)

		Linus

---
diff --git a/crashme.c b/crashme.c
index 5e7e663..19a2fbb 100644
--- a/crashme.c
+++ b/crashme.c
@@ -1,3 +1,5 @@
+#define pyr
+#define PAGSIZ 4096
 /* crashme: Create a string of random bytes and then jump to it.
             crashme [+]<nbytes>[.inc] <srand> <ntrys> [nsub] [verboseness] */
 
@@ -143,7 +145,6 @@ a script.
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/param.h>
-#include <sys/vmmac.h>
 #define strchr index
 #endif
 
@@ -215,7 +216,7 @@ unsigned char *bad_malloc(n)
 {unsigned char *data;
  data = (unsigned char *) malloc(n);
 #ifdef pyr
- if (mprotect(((int)data/PAGSIZ)*PAGSIZ, (n/PAGSIZ+1)*PAGSIZ,
+ if (mprotect(((long)data/PAGSIZ)*PAGSIZ, (n/PAGSIZ+1)*PAGSIZ,
 	      PROT_READ|PROT_WRITE|PROT_EXEC))
    perror("mprotect");
 #endif
@@ -259,11 +260,8 @@ void my_signal(sig, func)
  signal(sig, func);
 #else
  struct sigaction act;
+ memset(&act, 0, sizeof(act));
  act.sa_handler = func;
- act.sa_mask = 0;
-#ifdef linux
- act.sa_restorer = 0;
-#endif /* linux */
  act.sa_flags = SA_NOMASK;
 #ifdef SA_RESTART
  act.sa_flags |= SA_RESTART;
