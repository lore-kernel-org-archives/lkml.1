Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbXINVGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbXINVGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXINVGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:06:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55634 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbXINVGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:06:14 -0400
Date: Fri, 14 Sep 2007 23:07:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>, Bernhard Walle <bwalle@suse.de>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Add ELF note with Linux version
Message-ID: <20070914210738.GA5031@uranus.ravnborg.org>
References: <20070904150018.GA4357@suse.de> <46DFD825.2020109@goop.org> <20070913144228.2efcd5d9.akpm@linux-foundation.org> <20070913221340.GA29181@uranus.ravnborg.org> <46E9BD3D.4050102@goop.org> <20070914060805.GA32169@uranus.ravnborg.org> <46EAE534.5030900@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EAE534.5030900@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This seems outright silly.
> > Either we should revert the notes changes or someone caring about it 
> > should sweep all archs and make sure it does not hurt there.
> 
> Hm, sounds like yet another binutils bug; unfortunately common when ELF
> notes are about.  Was there any further effort to isolate what was
> causing the problem?

Lennart posted this:
An ARM vmlinux kernel image built with pre-build-id binutils has:

        Program Header:
            LOAD off    0x00008000 vaddr 0xc0008000 paddr 0xc0008000 align 2**15
                 filesz 0x002e503c memsz 0x003032c0 flags rwx
        private flags = 4000002: [Version4 EABI] [has entry point]


Whereas a build-id binutils-built vmlinux kernel image ends up with:

        Program Header:
            LOAD off    0x00008000 vaddr 0x00000000 paddr 0x00000000 align 2**15
                 filesz 0x00000024 memsz 0x00000024 flags r--
            LOAD off    0x00010000 vaddr 0xc0008000 paddr 0xc0008000 align 2**15
                 filesz 0x002e503c memsz 0x003032c0 flags rwx
            NOTE off    0x00008000 vaddr 0x00000000 paddr 0x00000000 align 2**2
                 filesz 0x00000024 memsz 0x00000024 flags r--
        private flags = 4000002: [Version4 EABI] [has entry point]


The .note.gnu.build-id section causes objcopy to produce a 3G+
Image file, breaking the build.


Samuel Ortiz posted following patch:
> With build-id binutils (e.g. the latest bintuils 2.18), objcopy produces
> a 3.1 Gbytes Image file. Adding a note section fixes the problem.
> 
> Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> 
> ---
>  arch/arm/kernel/vmlinux.lds.S |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.22/arch/arm/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6.22.orig/arch/arm/kernel/vmlinux.lds.S   2007-09-11 18:32:29.000000000 +0200
> +++ linux-2.6.22/arch/arm/kernel/vmlinux.lds.S        2007-09-11 18:33:42.000000000 +0200
> @@ -94,6 +94,7 @@
>                       TEXT_TEXT
>                       SCHED_TEXT
>                       LOCK_TEXT
> +                     *(.note.*)
>  #ifdef CONFIG_MMU
>                       *(.fixup)
>  #endif


I cannot see why this should fix it since the patch does
not discard the section. Maybe the inclusion of the section in
some oter section does some good.

Anyway the original submitter of the build-id should have identified such
issues and fixed all archs.

And I still do not get exactly what problem the note section solves when
included in vmlinux....

	Sam
