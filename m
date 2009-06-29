Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbZF2XeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbZF2XeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZF2XeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:34:10 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59491
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZF2XeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:34:10 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: Can't boot 2.6.30 powerpc kernel under qemu.
Date: Mon, 29 Jun 2009 18:34:06 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
References: <200906281033.09842.jk@ozlabs.org>
In-Reply-To: <200906281033.09842.jk@ozlabs.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906291834.07902.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 June 2009 21:33:09 Jeremy Kerr wrote:
> Hi Rob,
>
> > I bisected the problem in the linux kernel repository, and wound up
> > here:
> >
> > 60ee031940c1b09c137b617a8829e2f081961fe0 is first bad commit
> > commit 60ee031940c1b09c137b617a8829e2f081961fe0
> > Author: Jeremy Kerr <jk@ozlabs.org>
> > Date:   Tue Feb 17 11:44:14 2009 +1100
> >
> >     powerpc/spufs: Use correct return value for spu_handle_mm_fault
>
> I think it's very unlikely that this commit would be causing the
> problem, as qemu doesn't have any SPEs (they're specific to the Cell
> architecture), which would be required to hit this code. Also, you're
> not compiling with CONFIG_SPU_BASE, so the file that this changed
> shouldn't even be built.

Yeah, it seemed odd.  That's why I needed help. :)

> Perhaps try the bisect again?

Sorry about that.  I suck at git.

Part of the reason is that git bisect assumes that "good" always comes before 
"bad" in the repository, so if you're looking for the patch that _fixed_ a bug 
(I.E. good == new and bad == old), you have to reverse 'em to humor git 
bisect.  I had to do that this time to patch an intermediate version that 
build breaks, which "git bisect run" called "skip" on over a dozen times 
without noticeable progress.  If good and bad then mean the opposite on the 
_next_ bisect, I tend to get 'em confused occasionally.  (Especially when I've 
hit three or more unrelated bugs in the same bisect run.  In this case the 
build break in kmap_atomic_prot, whatever memory glitch is corrupting the 
squashfs root filesystem image and spamming the console about it, and this bug.  
Oh, and the really _fun_ part is that the squashfs bug only reproduces about 
half the time.  If you run the same binary twice, sometimes it'll work and 
sometimes it'll spam squashfs errors to the console.  Wheee...)

Anyway, on something like my fifth attempt I managed to bisect it to:

28794d34ecb6815a3fa0a4256027c9b081a17c5f is first bad commit
commit 28794d34ecb6815a3fa0a4256027c9b081a17c5f
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Tue Mar 10 17:53:27 2009 +0000

    powerpc/kconfig: Kill PPC_MULTIPLATFORM
    
    CONFIG_PPC_MULTIPLATFORM is a remain of the pre-powerpc days and isn't
    really meaningful anymore. It was basically equivalent to PPC64 || 6xx.
    
    This removes it along with the following changes:
    
     - 32-bit platforms that relied on PPC32 && PPC_MULTIPLATFORM now rely
       on 6xx which is what they want anyway.
    
     - A new symbol, PPC_BOOK3S, is defined that represent compliance with
       the "Server" variant of the architecture. This is set when either 6xx
       or PPC64 is set and open the door for future BOOK3E 64-bit.
    
     - 64-bit platforms that relied on PPC64 && PPC_MULTIPLATFORM now use
       PPC64 && PPC_BOOK3S
    
     - A separate and selectable CONFIG_PPC_OF_BOOT_TRAMPOLINE option is now
       used to control the use of prom_init.c
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Which suggested that the problem was the new CONFIG_PPC_OF_BOOT_TRAMPOLINE 
symbol wasn't set, and once I switched that on it started working again.

> linuxppc-dev@lists.ozlabs.org is the one you want for this:
>
>  https://lists.ozlabs.org/listinfo/linuxppc-dev

Cool!  Is there a reason it's hidden?  (Or at least not listed in either 
vger.kernel.org's list info page or in the "Maling lists" page linked from 
ozlabs.org's top level web page.)  Just curious, I couldn't find it when I 
looked in the obvious (to me) places.

Rob

P.S.  Yes I tried google: top hit for "linux powerpc list" is penguinppc.org, 
which links to mailing lists on the right which is the ozlabs.org page that 
doesn't list linuxppc-dev.  In fact the entire first page of google hits for 
that search doesn't give a hint of the existence of that list, although some 
of the later ones might if I clicked through more of them...
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
