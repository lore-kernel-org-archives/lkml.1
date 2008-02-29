Return-Path: <linux-kernel-owner+w=401wt.eu-S934050AbYB2WHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbYB2WHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761743AbYB2WHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:07:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761379AbYB2WHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:07:44 -0500
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204310323.24514.1239870063@webmail.messagingengine.com>
References: <20080224174605.GA21661@mailshack.com>
	 <47C22568.1010405@zytor.com>
	 <1203958478.20033.1239002461@webmail.messagingengine.com>
	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
	 <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
	 <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff>
	 <1204310323.24514.1239870063@webmail.messagingengine.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 22:06:59 +0000
Message-Id: <1204322819.6299.1.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 19:38 +0100, Alexander van Heukelum wrote:
> On Fri, 29 Feb 2008 17:14:07 +0000, "Mark McLoughlin"
> <markmc@redhat.com> said:
>  
> > 	I haven't investigated in any detail, but with 2.6.25-rc3 and your
> > patch I'm seeing a Xen guest hit this BUG:
> > 
> > void __init smp_alloc_memory(void)
> > {
> >         trampoline_base = alloc_bootmem_low_pages(PAGE_SIZE);
> >         /*                                                                
> >          * Has to be in very low memory so we can execute                 
> >          * real-mode AP code.                                             
> >          */
> >         if (__pa(trampoline_base) >= 0x9F000)
> >                 BUG();
> > }
> > 
> > 	Stack looks like:
> > 
> >   [<c137ef97>] smp_alloc_memory+0x25  <--
> >   [<c137ef97>] smp_alloc_memory+0x25 
> >   [<c137a500>] setup_arch+0x28e 
> >   [<c13735f7>] start_kernel+0x7a 
> >   [<c1379240>] xen_start_kernel+0x300 
> 
> Ouch.
> 
> My first guess is that the BIOS data area is completely non-existent for
> Xen.
> Is it guaranteed that the memory is zeroed out on boot?

Yep, that seems to be the case

> In that case we can special-case it easily:
> 
> change:
>         /* Paranoia: should never happen, but... */
>         if (lowmem >= 0x100000)
>                 lowmem = 0xa0000;
> 
> into:
>         /* Strange case, like Xen ;) */
>         if (lowmem == 0 || lowmem >= 0x100000)
>                 lowmem = 0x9f000;
> 
> Can you test that?

Yes, that fixes boot for me.

Thanks,
Mark.

