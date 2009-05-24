Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbZEXTOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbZEXTOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZEXTN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:13:59 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:55579 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZEXTN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UdAMu/qBUt+YeTbAYdwwOEJuApES/EvBVG7clSa+5wA5BGkfEy3BXARSFkmms1he1V
         6Jc3Q0RROMbW1N0kfmuAbtRb/jpJETAbNRgNyvxrey/wcWR5nl+r/b7lCAI2dV8ELJuV
         ZeZHsUMxZpx4PAdVT3h+WxOq+5FjtYHubOy/Y=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0905240947490.3435@localhost.localdomain>
References: <20090518142707.GA24142@elte.hu> <20090518164921.GA6903@elte.hu>
	 <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
	 <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
	 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
	 <20090518202031.GA26549@elte.hu>
	 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
	 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0905240947490.3435@localhost.localdomain>
Date: Sun, 24 May 2009 22:13:58 +0300
X-Google-Sender-Auth: c19e7123bc4018c5
Message-ID: <84144f020905241213g365362bi130669aff2be58a9@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, 24 May 2009, Pekka J Enberg wrote:
>> Ingo, here's a patch that boots UMA+SMP+SLUB x86-64 kernel on qemu all
>> the way to userspace. It probably breaks bunch of things for now but
>> something for you to play with if you want.

On Sun, May 24, 2009 at 9:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> In fact, it would be nice to perhaps try to move it even earlier. Now you
> moved it to before the scheduler init (good!), but I do wonder if it could
> be moved up to even before the setup_per_cpu_areas() etc crud.

Oh, sure, we can look into that. I just wanted to take the
conservative approach because I worry about breaking bunch of
configurations I cannot test. I suspect it's going to get pretty hairy
if we do kmem_cache_init() even earlier. Furthermore, SLUB does sysfs
setup in kmem_cache_init() so we probably need to split slab
initialization in two stages.

On Sun, May 24, 2009 at 9:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I realize that the allocator wants to use the per-CPU area, but if we have
> just the boot CPU area set up statically at that point, since it's only
> the boot CPU running, maybe we could do those per-cpu area allocations
> without the bootmem allocator too?

We probably can. I don't see any fundamental reason why slab
allocators can't bootstrap early in the boot sequence after we've set
up the page allocator.

On Sun, May 24, 2009 at 9:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> But even just getting bootmem out of the scheduler setup is a big
> improvement, I think. So this patch looks very promising as is.
>
> Did you test whether the other allocators were ok with this too?

SLUB and SLOB are fine but SLAB explodes. I didn't investigate it yet
but it's probably because SLAB expects interrupts to be enabled when
kmem_cache_init() is called.

                       Pekka
