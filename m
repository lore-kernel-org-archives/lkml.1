Return-Path: <linux-kernel-owner+w=401wt.eu-S1764812AbXIMS6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764812AbXIMS6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbXIMS54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:57:56 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:32366 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754189AbXIMS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:57:55 -0400
X-YMail-OSG: kFXqmsQVM1npo2j239lZVAW0qf.AT8KU3tKsGI4hZpqD_gNSM8JgzbmVbhB6ppOeJ9uFaLPw_g--
Date: Thu, 13 Sep 2007 11:57:53 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, davej@redhat.com,
       Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070913185753.GA9259@puku.stupidest.org>
References: <20070912232534.GA26868@puku.stupidest.org> <20070913183359.GA27146@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913183359.GA27146@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 08:34:00PM +0200, Sam Ravnborg wrote:

> A few. Please address them and resubmit with full changelog and
> proper attribution (if possible) and a signed-of-by.

sure

> I would strongly prefer the name "build-pkg".

right

> The prefix -pkg is just to use the magic in top-level Makefile to
> dicert it to the right Makefile.

yeah, i had something a bit like originally but didn't like the name
so changed it and poked the top-level Makefile

> I would like to attribute whoever made this somehow.

so would i, i assume it was davej + others so i cc'd him on this
hoping for feedback

> This becomes obsolete when target is named -pkg

yes

> Here we could do a $(MAKE) KBUILD_SRC= clean
> This will leave all files needed for building external modules
> but delete the rest (almost).

ok, i'll try that

> set -e to bail out on error could do it for now.

will do

> kbuild will not like it either so you can drop this FIXME

ok


> > +# This relies on the following environment variables being sane and
> > +# passed in from the Makefiles:
> > +#
> > +#    INSTALL_MINTREE_PATH
> > +#    KERNELVERSION

> Could we pass this as parameters. This makes it explicit.
> You do not need to check them since this script is not
> supposed to be used stand-alone.

can do

> > +if [ "$srctree" != "$objtree" ] ; then
> > +    cp --parents $(find -type f -name "Makefile*" -o -name "Kconfig*" -not -ipath "$objtree/*Makefile" ) ${tgtdir}
>                                                                                                ^
> Why this wildcard??? (objtree/>*<Makefile)
> Seems to be a typing error.

no, it's so we catch things like

linux/build/Makefile

 *and*

linux/build/foo/bar/Makefile

> > +#rm -rf ${tgtdir}/Documentation
> Remove this line since it is commented out

right, actually, it can be uncommented but the 'make help' fails; i'm
not sure if we need make help to work since most of the other targets
won't anyhow

so should i remove it (leaving 'make help' as usable) or remove it?

> > +rm -f ${tgtdir}/scripts/*.o
> > +rm -f ${tgtdir}/scripts/*/*.o
> If we do the make clean this is not needed.

ok

> Something less hardcoded are preferred. Maybe like:
> cp -a `ls | grep -v ^asm` asm-generic $(tgtdir}/include

ok (though i'm not a big fan of ls | grep as a rule, it tends to be
fragile when people do dumb things)

> Here we use readlink but in next line we use $ARCH.
> We should be consitent and use ARCH all over.

i tried to preserve as much logic as possible from the original
script, at least initially

i'll change that

> > +if [ "$ARCH" = "x86_64" ]; then
> > +    cp -a asm-i386 ${tgtdir}/include
> > +fi
> Too hardcoded.
> Here we could use some sed magic to extract a potential ALTARCH from asm-${ARCH}/Kbuild
> My sed skills are too limited to do this in a minute... :-(

what about something like?

    sed -n "s/^ALTARCH[[:space:]]:=[[:space:]]\(.*$\)\+/\1/p"

(i'm sure there is a better way though)

> This part I did not check up on - I assume it is correct.

it all seems to work
