Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZJAH3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZJAH3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbZJAH3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:29:02 -0400
Received: from [195.41.46.236] ([195.41.46.236]:47524 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbZJAH3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:29:01 -0400
Date: Thu, 1 Oct 2009 09:28:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20091001072857.GA16070@merkur.ravnborg.org>
References: <4AC37FE5.7020200@gmail.com> <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain> <20090930185315.GA9716@elte.hu> <20090930220342.GA2118@elte.hu> <alpine.LFD.2.01.0909301738220.6996@localhost.localdomain> <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain> <4AC43E7E.1000600@gmail.com> <20091001061109.GA21488@elte.hu> <4AC449BD.1060003@gmail.com> <20091001064209.GA25189@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091001064209.GA25189@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 08:42:09AM +0200, Ingo Molnar wrote:
> 
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Ingo Molnar a écrit :
> > > 
> > > That's not enough - the inline assembly code in 
> > > arch/x86/include/asm/cmpxchg_32.h should also not reference 
> > > cmpxchg8b_emu in that case.
> > > 
> > 
> > I believe it is OK as is, since cmpxchg8b_emu is referenced only
> > once, in a section guarded by :
> > #ifndef CONFIG_X86_CMPXCHG64
> 
> yeah. But this bit is wrong:
> 
> > +++ b/arch/x86/lib/Makefile
> > @@ -15,8 +15,10 @@ ifeq ($(CONFIG_X86_32),y)
> >          obj-y += atomic64_32.o
> >          lib-y += checksum_32.o
> >          lib-y += strstr_32.o
> > -        lib-y += semaphore_32.o string_32.o cmpxchg8b_emu.o
> > -
> > +        lib-y += semaphore_32.o string_32.o
> > +ifeq ($(CONFIG_X86_CMPXCHG64),n)
> > +        lib-y += cmpxchg8b_emu.o
> > +endif
> >          lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
> >  else
> >          obj-y += io_64.o iomap_copy_64.o
> 
> The way to check for a disabled option in a Make rule is:
> 
> 	ifneq ($(CONFIG_X86_CMPXCHG64),y)
or
 	ifeq ($(CONFIG_X86_CMPXCHG64),)

Both variants are suboptimal - but I have not been
able to come up with something readable in this situation.

Looking at the above the first is the better version as
it is a bit more obvious what we test for (assuming reader
knows this is a boolean value and not tristate).

	Sam
