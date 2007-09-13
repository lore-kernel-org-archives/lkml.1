Return-Path: <linux-kernel-owner+w=401wt.eu-S1765845AbXIMScx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765845AbXIMScx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763406AbXIMSch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:32:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56200 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762090AbXIMScg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:32:36 -0400
Date: Thu, 13 Sep 2007 20:34:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: LKML <linux-kernel@vger.kernel.org>, davej@redhat.com,
       Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070913183359.GA27146@uranus.ravnborg.org>
References: <20070912232534.GA26868@puku.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912232534.GA26868@puku.stupidest.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris.

On Wed, Sep 12, 2007 at 04:25:34PM -0700, Chris Wedgwood wrote:
> This is a somewhat rough first-pass at making a 'minimal tree'
> installation target.  This installs a partial source-tree which you
> can use to build external modules against.  It feels pretty unclean
> but I'm not aware of a much better way to do some of this.
> 
> This patch works for me, even when using O=<buildtree>.  It probably
> needs further cleanups.
> 
> Comments?
A few. Please address them and resubmit with full changelog and
proper attribution (if possible) and a signed-of-by.

	Sam

> 
> -----
> Add a 'mintree-install' makefile target.
I would strongly prefer the name "build-pkg".
The prefix -pkg is just to use the magic in top-level Makefile to
dicert it to the right Makefile.

> Red Hat and other distributions typically have some logic in their
> kernel package build system to create/install 'minimalist source tree'
> which contains enough state to build external modules against but is
> much smaller than the entire build-tree.
> 
> This introduces similar logic, the guts of this was taken from a
> Fedora Core spec file and mutilated to make it work for O=<...>
> builds.

I would like to attribute whoever made this somehow.
Dave - do you know?

> diff --git a/Makefile b/Makefile
> index 3067f6a..1246939 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1085,6 +1085,11 @@ package-dir	:= $(srctree)/scripts/package
>  	$(Q)$(MAKE) $(build)=$(package-dir) $@
>  rpm: include/config/kernel.release FORCE
>  	$(Q)$(MAKE) $(build)=$(package-dir) $@
> +# /usr/src/linux to match what most distro's do
> +#export INSTALL_MINTREE_PATH ?= /usr/src/linux
> +export INSTALL_MINTREE_PATH ?= /tmp/mt-test/
> +mintree-install: include/config/kernel.release FORCE
> +	$(Q)$(MAKE) $(build)=$(package-dir) $@

This becomes obsolete when target is named -pkg

> +# minimal tree installation target
> +# ---------------------------------------------------------------------------
> +mintree-install: FORCE
> +	$(MAKE) KBUILD_SRC=

Here we could do a $(MAKE) KBUILD_SRC= clean
This will leave all files needed for building external modules
but delete the rest (almost).

> +	$(CONFIG_SHELL) $(srctree)/scripts/package/mintree-install
> +
>  # Help text displayed when executing 'make help'
>  # ---------------------------------------------------------------------------
>  help: FORCE
> @@ -96,4 +102,6 @@ help: FORCE
>  	@echo '  tar-pkg         - Build the kernel as an uncompressed tarball'
>  	@echo '  targz-pkg       - Build the kernel as a gzip compressed tarball'
>  	@echo '  tarbz2-pkg      - Build the kernel as a bzip2 compressed tarball'
> +	@echo '  mintree-install - Build the kernel and install a minimal-build-tree'
> +	@echo '                    that can be used to build external modules against'

This chunk needs to be updated to the new install target.

>  
> diff --git a/scripts/package/mintree-install b/scripts/package/mintree-install
> new file mode 100644
> index 0000000..1362cc2
> --- /dev/null
> +++ b/scripts/package/mintree-install
> @@ -0,0 +1,87 @@
> +#!/bin/bash
> +
> +# miniman-tree-install
> +#
> +# This should install necessary the headers, makefiles and
> +# configuration files in a location so that you can use kbuild to
> +# build external (out of tree) modules without needing the entire
> +# kernel build tree.
> +#
> +
> +# This has been shamelessly taken from a Red Hat's spec file,
> +# http://cvs.fedora.redhat.com/viewcvs/devel/kernel/kernel.spec?rev=1.145&view=markup
> +
> +# FIXME:cw Some parts of this are still icky, it's not clear how best
> +# to clean some of this up.  Error handling is more or less
> +# non-existent.  You could argue that this entire process should be
> +# done differently (ie. using kbuild knowledge instead of a whole lot
> +# of hard-coded magic here).
set -e to bail out on error could do it for now.

> +
> +# FIXME:cw If any of srctree, objtree or INSTALL_MINTREE_PATH have
> +# spaces in them some parts of this will fail as-is, it shouldn't be
> +# that hard to fix (it's not clear if the rest of t kbuild is clean in
> +# that respect though)
kbuild will not like it either so you can drop this FIXME

> +
> +# This relies on the following environment variables being sane and
> +# passed in from the Makefiles:
> +#
> +#    INSTALL_MINTREE_PATH
> +#    KERNELVERSION
Could we pass this as parameters. This makes it explicit.
You do not need to check them since this script is not
supposed to be used stand-alone.

> +
> +
> +# target directory
> +tgtdir="${INSTALL_MINTREE_PATH}"/${KERNELVERSION}/
> +
> +
> +# And save the headers/makefiles etc for building modules against
> +#
> +# This all looks scary, but the end result is supposed to be:
> +# * all arch relevant include/ files
> +# * all Makefile/Kconfig files
> +# * all script/ files
> +
> +cd "$srctree" || exit $?
> +
> +mkdir -p ${tgtdir}
> +
> +# first copy everything.  If objtree differs from srctree (ie. O=<...>
> +# is used) then make sure we don't copy the Makefile(s) from inside
> +# $objtree
> +if [ "$srctree" != "$objtree" ] ; then
> +    cp --parents $(find -type f -name "Makefile*" -o -name "Kconfig*" -not -ipath "$objtree/*Makefile" ) ${tgtdir}
                                                                                               ^
Why this wildcard??? (objtree/>*<Makefile)
Seems to be a typing error.

> +else
> +    cp --parents $(find -type f -name "Makefile*" -o -name "Kconfig*") ${tgtdir}
> +fi
> +
> +cp "${objtree}/Module.symvers" ${tgtdir}
> +# then drop all but the needed Makefiles/Kconfig files
> +#rm -rf ${tgtdir}/Documentation
Remove this line since it is commented out

> +rm -rf "${tgtdir}/scripts"
> +rm -rf "${tgtdir}/include"
> +cp "${objtree}/.config" ${tgtdir}
> +cp -a scripts ${tgtdir}
> +if [ -d ${srctree}/arch/${ARCH}/scripts ]; then
> +    cp -a ${srctree}/arch/${ARCH}/scripts ${tgtdir}/arch/${ARCH} || :
> +fi
> +if [ -f ${objtree}/arch/${ARCH}/*lds ]; then
> +    cp -a ${objtree}/arch/${ARCH}/*lds ${tgtdir}/arch/${ARCH}/ || :
> +fi
> +rm -f ${tgtdir}/scripts/*.o
> +rm -f ${tgtdir}/scripts/*/*.o
If we do the make clean this is not needed.

> +mkdir -p ${tgtdir}/include
> +
> +cd include
> +cp -a acpi keys linux math-emu media mtd net pcmcia rdma rxrpc scsi sound video asm-generic ${tgtdir}/include
Something less hardcoded are preferred. Maybe like:
cp -a `ls | grep -v ^asm` asm-generic $(tgtdir}/include

> +cp -a ${objtree}/include/config ${objtree}/include/asm ${tgtdir}/include
> +cp -a $(readlink ${objtree}/include/asm) ${tgtdir}/include
Here we use readlink but in next line we use $ARCH.
We should be consitent and use ARCH all over.

> +if [ "$ARCH" = "x86_64" ]; then
> +    cp -a asm-i386 ${tgtdir}/include
> +fi
Too hardcoded.
Here we could use some sed magic to extract a potential ALTARCH from asm-${ARCH}/Kbuild
My sed skills are too limited to do this in a minute... :-(

> +# Make sure the Makefile and version.h have a matching timestamp so
> +# that external modules can be built
> +touch -r ${tgtdir}/Makefile ${tgtdir}/include/linux/version.h
> +touch -r ${tgtdir}/.config ${tgtdir}/include/linux/autoconf.h
> +# Copy .config to include/config/auto.conf so "make prepare" is
> +# unnecessary.
> +cp ${tgtdir}/.config ${tgtdir}/include/config/auto.conf
This part I did not check up on - I assume it is correct.

	Sam
