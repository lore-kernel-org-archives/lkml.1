Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXJDRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXJDRcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXJDRcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:32:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbXJDRcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:32:09 -0400
Date: Thu, 4 Oct 2007 13:32:03 -0400
From: Dave Jones <davej@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 2/3] x86: fix IO write barriers
Message-ID: <20071004173203.GC5828@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <ak@suse.de>
References: <20071004052153.GA15131@wotan.suse.de> <20071004052258.GB15131@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004052258.GB15131@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 07:22:58AM +0200, Nick Piggin wrote:

 > -#ifdef CONFIG_X86_OOSTORE
 > -/* Actually there are no OOO store capable CPUs for now that do SSE, 
 > -   but make it already an possibility. */
 > -#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
 > -#else
 > -#define wmb()	__asm__ __volatile__ ("": : :"memory")
 > -#endif
 > -
 >  #ifdef CONFIG_SMP
 >  #define smp_mb()	mb()
 >  #define smp_rmb()	rmb()
 > -#define smp_wmb()	wmb()
 > +#ifdef CONFIG_X86_OOSTORE
 > +# define smp_wmb() 	wmb()
 > +#else
 > +# define smp_wmb()	barrier()
 > +#endif

The only vendor that ever implemented OOSTOREs was Centaur, and they
only did in the Winchip generation of the CPUs.  When they dropped it
from the C3, I asked whether they intended to bring it back, and the
answer was "extremely unlikely".

So we can probably just drop that "just in case" clause above, and just
do..

 #define smp_wmb()  barrier()


	Dave

-- 
http://www.codemonkey.org.uk
