Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbYD0WGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbYD0WGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYD0WGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:06:06 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56330 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbYD0WGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:06:05 -0400
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080427214837.GA11631@elte.hu>
References: <1209329485.3801.46.camel@localhost.localdomain>
	 <20080427214837.GA11631@elte.hu>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 18:05:59 -0400
Message-Id: <1209333959.3801.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-27 at 23:48 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This patch:
> > 
> > commit 6371b495991debfd1417b17c2bc4f7d7bae05739
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Wed Jan 30 13:33:40 2008 +0100
> > 
> >     x86: change ioremap() to default to uncached
> > 
> > As far as I can tell went blindly into the x86 tree without being 
> > shared on any mailing list at all.  How can something that completely 
> > alters the semantics of ioremap on x86 platforms go in without any 
> > review.
> 
> what happened before was that on x86 ioremap() was "lax" about the PTE 
> cachability and just said "writeback cached". That was utterly false for 
> most of the real ioremap()s done by drivers, but it happened to work out 
> fine due to the courtesy of BIOSes setting up UC MTRRs that forced those 
> areas into uncachable.
> 
> with the PAT changes, what used to be this default and careless 
> ioremap() behavior by x86 turned into a hard cache aliasing conflict. So 
> we pretty much _have to_ default to uncached - like all other sane 
> architectures already did forever. This is a direct consequence of the 
> PAT changes which were discussed on lkml.
> 
> But with PAT we take over from the MTRRs on x86 and using a cacheable 
> ioremap() would give us aliasing conflicts and trouble all around the 
> place.

I'm not saying the patch is wrong ... or that just because it broke
voyager it shouldn't be done.  What I'm saying is that it shouldn't have
been put into the x86 tree without mailing list review.

Running a git tree isn't a private fiefdom, it's a public trust; to keep
the trust of other developers, you have to run the tree in a transparent
fashion ... and making the mailing list the only input to it is one way
of ensuring this.  It also helps with review that we're all so worried
about so little being done ...

> In the Voyager case we should use ioremap_cache(), and thanks for 
> pointing out that dependency of the QIC. Does the patch below fix it for 
> you?
> 
> 	Ingo
> 
> --------------->
> Subject: x86, voyager: fix ioremap_nocache()
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun Apr 27 23:21:03 CEST 2008
> 
> James Bottomley reported that the following PAT related commit:
> 
> | commit 6371b495991debfd1417b17c2bc4f7d7bae05739
> | Author: Ingo Molnar <mingo@elte.hu>
> | Date:   Wed Jan 30 13:33:40 2008 +0100
> |
> |     x86: change ioremap() to default to uncached
> 
> broke Voyager.
> 
> James says:
> 
> " it broke a class of voyager machines: those which
>   rely on the quad interrupt controller (QIC).  The precis of why they
>   broke is because the QIC does IPIs (or CPIs in its terminology) via
>   cache line interference: you interrupt a processor by moving a
>   designated memory area to write exclusive in the cache (by simply
>   writing to the line) and the CPU acks the interrupt by moving it back to
>   read shared (by reading from it).  That area, is, of course, mapped by
>   ioremap, so reversing the ioremap semantics and adding the uncached bit
>   completely breaks the QIC. "
> 
> Sorry about that!
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mach-voyager/voyager_cat.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-x86.q/arch/x86/mach-voyager/voyager_cat.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/mach-voyager/voyager_cat.c
> +++ linux-x86.q/arch/x86/mach-voyager/voyager_cat.c
> @@ -602,7 +602,7 @@ void __init voyager_cat_init(void)
>  
>  		request_resource(&iomem_resource, &res);
>  		voyager_SUS = (struct voyager_SUS *)
> -		    ioremap(addr, 0x400);
> +		    ioremap_cache(addr, 0x400);

Actually, no ... wrong ioremap.  That one is the SUS clickmap remap,
which is irrelevant whether it's cached or not. The QIC cacheline area
is the next one below it.

I've already got the actual patch (with a nice explanation) in the
voyager tree.  I'll send them all out to the mailing list shortly; I'm
just trying to chase down a problem with TSCs before the voyager tree is
ready.

James


