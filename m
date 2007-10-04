Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbXJDSlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbXJDSlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbXJDSlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:41:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414AbXJDSlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:41:14 -0400
Date: Thu, 4 Oct 2007 14:41:07 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 2/3] x86: fix IO write barriers
Message-ID: <20071004184107.GC23300@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20071004052153.GA15131@wotan.suse.de> <200710041953.16656.ak@suse.de> <20071004181044.GA23300@redhat.com> <200710042021.59704.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710042021.59704.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 08:21:59PM +0200, Andi Kleen wrote:
 > On Thursday 04 October 2007 20:10:44 Dave Jones wrote:
 > > On Thu, Oct 04, 2007 at 07:53:16PM +0200, Andi Kleen wrote:
 > >  > 
 > >  > > The only vendor that ever implemented OOSTOREs was Centaur, and they
 > >  > > only did in the Winchip generation of the CPUs.  When they dropped it
 > >  > > from the C3, I asked whether they intended to bring it back, and the
 > >  > > answer was "extremely unlikely".
 > >  > >
 > >  > 
 > >  > Do you know if it made a big performance difference?
 > > 
 > > On the winchip, it was a huge win. I can't remember exact numbers,
 > > but pretty much every benchmark I threw at it at the time showed
 > > significant improvement.
 > 
 > Significant as in >10%?

"Worth about 10-20% performance" according to the 2.4.18pre9-ac4
release notes: http://www.linuxtoday.com/news_story.php3?ltsn=2002-02-14-015-20-NW-KN

 > >  > But yes we should probably just remove this special case to make 
 > >  > maintenance easier.
 > > It's CONFIG_SMP anyway, which none of the winchips were.
 > 
 > It's not.

You're right it isn't now, but Nicks patch seems to change it so that it is.

...

 #ifdef CONFIG_SMP
 #define smp_mb()       mb()
 #define smp_rmb()      rmb()
-#define smp_wmb()      wmb()
+#ifdef CONFIG_X86_OOSTORE
+# define smp_wmb()     wmb()
+#else
+# define smp_wmb()     barrier()
+#endif

 > And we need memory barriers even without SMP 
 > when talking to device drivers. Only the smp_*b()s get noped
 > on UP.

Good point.

	Dave

-- 
http://www.codemonkey.org.uk
