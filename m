Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604Ab0AQGFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab0AQGFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 01:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258Ab0AQGFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 01:05:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab0AQGFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 01:05:33 -0500
Date: Sun, 17 Jan 2010 07:05:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: clean up rwsem type system
Message-ID: <20100117060517.GA26525@elte.hu>
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain>
 <4B4D1865.5000107@zytor.com>
 <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain>
 <alpine.LFD.2.00.1001121708100.17145@localhost.localdomain>
 <alpine.LFD.2.00.1001121755220.17145@localhost.localdomain>
 <alpine.LFD.2.00.1001121810410.17145@localhost.localdomain>
 <4B4EC1A5.4010701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4EC1A5.4010701@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/12/2010 06:16 PM, Linus Torvalds wrote:
> > 
> > In case anybody wants to test, the final piece is appended.
> > 
> > Again, note the 32767-thread limit here. So this really does need that 
> > whole "make rwsem_count_t be 64-bit and fix the BIAS values to match" 
> > extension on top of it, but that is conceptually a totally independent 
> > issue.
> > 
> > NOT TESTED! The original patch that this all was based on were tested by 
> > KAMEZAWA Hiroyuki, but maybe I screwed up something when I created the 
> > cleaned-up series, so caveat emptor..
> > 
> > Also note that it _may_ be a good idea to mark some more registers 
> > clobbered on x86-64 in the inline asms instead of saving/restoring them. 
> > They are inline functions, but they are only used in places where there 
> > are not a lot of live registers _anyway_, so doing for example the 
> > clobbers of %r8-%r11 in the asm wouldn't make the fast-path code any 
> > worse, and would make the slow-path code smaller. 
> > 
> 
> Hi Linus,
> 
> I have put these into a separate topic branch in the tip tree, which should 
> get them some test coverage.  I will look at 64-bit counters to support 2^31 
> threads hopefully later this week, unless you prefer to do it yourself.

FYI, -tip testing found that these changes break the UML build:

kernel/built-in.o: In function `__up_read':
/home/mingo/tip/arch/x86/include/asm/rwsem.h:192: undefined reference to `call_rwsem_wake'
kernel/built-in.o: In function `__up_write':
/home/mingo/tip/arch/x86/include/asm/rwsem.h:210: undefined reference to `call_rwsem_wake'
kernel/built-in.o: In function `__downgrade_write':
/home/mingo/tip/arch/x86/include/asm/rwsem.h:228: undefined reference to `call_rwsem_downgrade_wake'
kernel/built-in.o: In function `__down_read':
/home/mingo/tip/arch/x86/include/asm/rwsem.h:112: undefined reference to `call_rwsem_down_read_failed'
kernel/built-in.o: In function `__down_write_nested':
/home/mingo/tip/arch/x86/include/asm/rwsem.h:154: undefined reference to `call_rwsem_down_write_failed'
collect2: ld returned 1 exit status

	Ingo
