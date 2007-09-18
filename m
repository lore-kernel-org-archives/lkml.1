Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbXIRUbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbXIRUbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbXIRUbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:31:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36656 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714AbXIRUbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:31:15 -0400
Date: Tue, 18 Sep 2007 22:32:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1 - Mostly working, with a kbuild oddity
Message-ID: <20070918203239.GB27836@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <7319.1190143977@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7319.1190143977@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 03:32:57PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 18 Sep 2007 01:18:41 PDT, Andrew Morton said:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> 
> % uname -a
> Linux turing-police.cc.vt.edu 2.6.23-rc6-mm1 #1 SMP PREEMPT Tue Sep 18 12:32:13 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
> % uptime
>  15:11:48 up 36 min,  1 user,  load average: 0.05, 0.11, 0.09
> 
> Had a few issues, all self-inflicted (the biggie was 2 iptables modules that
> needed fixing for the net namespace changes in git-net.patch - stuck an
> &init_net in the right 2 places, a new #include line, and all was good).
> 
> I *did* have an odd issue with an out-of-tree GPL driver for a webcam.
> (It's from http://mxhaard.free.fr/ if anybody cares).
> 
> The Makefile does this:
> 
> make -C /lib/modules/`uname -r`/build SUBDIRS=/home/valdis/src/gspcav1-20070508 CC=cc modules
> 
> and has this sort of stuff in it:
> 
> DEFINES   += -DGSPCA_ENABLE_DEBUG
> DEFINES   += -DCONFIG_USB_GSPCA_MODULE=1 -DMODULE -D__KERNEL__
> DEFINES   += -DVID_HARDWARE_GSPCA=0xFF -DGSPCA_VERSION=\"$(VERSION)\"
> 
> In -rc4-mm1, $DEFINES got added to the compile command - in -rc6-mm1, I
> had to namually add a 'CFLAGS += $(DEFINES)' or GSPCA_VERSION came up undefined.
> 
> The actual problematic code in the Makefile:
> 
> -- begin Makefile snippet
> ifneq ($(KERNELRELEASE),)   # We were called by kbuild
> CFLAGS += $(DEFINES)
> obj-m += gspca.o
> gspca-objs := gspca_core.o decoder/gspcadecoder.o

So the external module were fiddeling with CFLAGS which is wrong.
Yes - it worked before by accident.

>From Documentation/kbuild/makefiles.txt:
=====================================================================
--- 3.7 Compilation flags

    EXTRA_CFLAGS, EXTRA_AFLAGS, EXTRA_LDFLAGS, EXTRA_ARFLAGS

        All the EXTRA_ variables apply only to the kbuild makefile
        where they are assigned. The EXTRA_ variables apply to all
        commands executed in the kbuild makefile.

        $(EXTRA_CFLAGS) specifies options for compiling C files with
        $(CC).

        Example:
                # drivers/sound/emu10k1/Makefile
                EXTRA_CFLAGS += -I$(obj)
                ifdef DEBUG
                    EXTRA_CFLAGS += -DEMU10K1_DEBUG
                endif


        This variable is necessary because the top Makefile owns the
        variable $(KBUILD_CFLAGS) and uses it for compilation flags for the
        entire tree.
=====================================================================

Nowhere are the use of CFLAGS documented.
The use of EXTRA_CFLAGS has been working as far back as I remember so
there is no backward compatibility issues to my best knowledge.

Pelase ask the author of the module to either fix it or even better
submit the driver for inclusion because then we will find it during
the review pahse.

But anyway - thanks for reporting an issue related to an external module.

	Sam
