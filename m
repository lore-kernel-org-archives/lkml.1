Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZDRRxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZDRRxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 13:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZDRRxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 13:53:16 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40419 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZDRRxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 13:53:15 -0400
Date: Sat, 18 Apr 2009 19:55:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: kbuild - introduce support for subdir-ccflags-y
Message-ID: <20090418175519.GA25541@uranus.ravnborg.org>
References: <20090418125159.GA23008@uranus.ravnborg.org> <20090418125839.GA3668@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090418125839.GA3668@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 01:58:39PM +0100, Russell King wrote:
> On Sat, Apr 18, 2009 at 02:51:59PM +0200, Sam Ravnborg wrote:
> > The typical use cases are an architecture or a subsystem that
> > decide to cover all files with -Werror.
> > Today alpha, mips and sparc uses -Werror in almost all their
> > Makefile - with subdir-ccflag-y it is now simpler to do so
> > as only the top-level directories needs to be covered.
> 
> Hmm, this won't make sense for ARM.  We have things like #warning and
> deprecated functions in machine specific headers, and adding -Werror
> to the whole of arch/arm/ will result in these causing builds to fail.

For arm I would suggest the following preparational patch:

diff --git a/arch/arm/Kbuild b/arch/arm/Kbuild
new file mode 100644
index 0000000..33b6645
--- /dev/null
+++ b/arch/arm/Kbuild
@@ -0,0 +1,7 @@
+# core part of arm kernel
+# The file is referenced from arch/arm/Makefile
+
+core-y                          += kernel/ mm/ common/
+core-$(CONFIG_FPE_NWFPE)        += nwfpe/
+core-$(CONFIG_VFP)              += arch/arm/vfp/
+
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index e84729b..5ccdca1 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -186,18 +186,9 @@ endif
 
 export	TEXT_OFFSET GZFLAGS MMUEXT
 
-# Do we have FASTFPE?
-FASTFPE		:=arch/arm/fastfpe
-ifeq ($(FASTFPE),$(wildcard $(FASTFPE)))
-FASTFPE_OBJ	:=$(FASTFPE)/
-endif
-
 # If we have a machine-specific directory, then include it in the build.
-core-y				+= arch/arm/kernel/ arch/arm/mm/ arch/arm/common/
+core-y                          += arch/arm/
 core-y				+= $(machdirs) $(platdirs)
-core-$(CONFIG_FPE_NWFPE)	+= arch/arm/nwfpe/
-core-$(CONFIG_FPE_FASTFPE)	+= $(FASTFPE_OBJ)
-core-$(CONFIG_VFP)		+= arch/arm/vfp/
 
 drivers-$(CONFIG_OPROFILE)      += arch/arm/oprofile/
 

[The above patch include deletion of unused FASTFPE stuff]

Then to cover all of kernel/ mm/ common/ nwfpe/ and vfp/
is a single line in arch/arm/Kbuild.

Another benefit of arch/arm/Kbuild is that you can use:

    make arch/arm/

and get all the above listed directories built.

You would need dedicated subdir-* for oprofile/ as 
it is linked together with drivers.
And for machine and platforms it would be a case-by-case
decision.

So it can be of benefit for arm too - but only if a preparational
step is done (which brings in other benefits).

If you want the preparational patch - independent of subdir-* support
then let me know and I will submit a proper patch to you.

	Sam
