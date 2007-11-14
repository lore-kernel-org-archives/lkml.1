Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbXKNNrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbXKNNrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbXKNNrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:47:11 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33307 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbXKNNrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:47:10 -0500
Date: Wed, 14 Nov 2007 14:48:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] enable "make ARCH=x86"
Message-ID: <20071114134843.GA8208@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull the 'enable "make ARCH=x86"' patchset.

Pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git

As per feedback from Thomas Gleixner:

On Wed, Nov 14, 2007 at 10:06:00AM +0100, Thomas Gleixner wrote:
> Sam,
>
> On Tue, 13 Nov 2007, Sam Ravnborg wrote:
>
> > Thomas - what is way forward here?
> >
> > I consider the patch serie ready to be applied and I
> > leave it to you (x86 guys) to decide the way forward to mainline.
> > cleanup -> mm -> linus or straight to linus.
>
> I'd like to see this merged right away, so we can finalize the build
> environment change in the .24 release rather than having two releases
> with gradual changes.
>
> Linus, I know it's late, but you really should consider to pull this
> into .24 so we are done with it once and forever. The patchset is
> straight forward and as far as I can tell Sam really worked out all
> the corner cases and fixed the review comments so we can be pretty
> sure that there is not hidden wreckage lurking round the corner.
>
> Thanks,
>
>       tglx

Diffstat:

 Makefile                                           |   13 +-
 README                                             |    2 +
 arch/x86/{Kconfig.i386 => Kconfig}                 |  567 ++++++++++----
 arch/x86/Kconfig.cpu                               |  121 ++--
 arch/x86/Kconfig.x86_64                            |  839 --------------------
 arch/x86/Makefile                                  |   10 +-
 arch/x86/Makefile_32                               |    8 +-
 arch/x86/Makefile_64                               |    8 +-
 arch/x86/boot/Makefile                             |    6 +-
 arch/x86/boot/cpucheck.c                           |    6 -
 arch/x86/kernel/Makefile_32                        |    3 +-
 arch/x86/kernel/Makefile_64                        |    2 +
 .../x86/kernel/cpu/cpufreq/{Kconfig_32 => Kconfig} |   69 ++-
 arch/x86/kernel/cpu/cpufreq/Kconfig_64             |  108 ---
 arch/x86/vdso/Makefile                             |    2 +-
 scripts/kconfig/Makefile                           |    7 +-
 scripts/kconfig/conf.c                             |    1 +
 scripts/kconfig/confdata.c                         |  146 +++--
 scripts/kconfig/lkc_proto.h                        |    1 +
 19 files changed, 684 insertions(+), 1235 deletions(-)

	Sam



The announcement mail to lkml is below:
--------------------------------------------------------------------------
This revised patchset does the followings things:

o unify the i386 and x86_64 Kconfig files
o introduce support for K64BIT to set CONFIG_64BIT on command line
o introdue support for "make ARCH=x86"
o degraded ARCH={i386,x86_64} to select between 32/64 for all*targets
  and otherwise just selecting the x86 architecture

I suggest we should merge this despite being at -rc2 so we can start
teaching distributors to use "ARCH=x86" - but I leave it to the
x86 Maintainers to decide.

I have always thought that the x86 merge could not be considered ready
until we could do a "make ARCH=x86" becasue it is so intuitive
if you have not typed "make ARCH=i386" one thousand times.


Based on feedback from previous submissions the following have changed:
- The backwards compatibility links are kept
- The backwards compatibility ARCH={i386,x86_64} are kept but degraded
  to select 32/64 bit during configuration for all*config targets.
- ARCH={i386,x86_64} are not broken by any patches so bisect will
  not choke
- patchset shrinked to 13 logical patches


With this change we have a setup where we have a common Kconfig
for 32-bit and 64-bit x86 like all other architectures.
And we can configure and build a kernel using ARCH="name of arch dir"

As an added bonus "make update-po-config" is fixed :-)

The diffstat tells it own story:
 19 files changed, 684 insertions(+), 1235 deletions(-)

And this is with new functionality added...

The patches explained...

Unification of Kconfig.i386 + Kconfig.x86_64:
      x86: unification of cfufreq/Kconfig
      x86: start unification of arch/x86/Kconfig.*
      x86: arch/x86/Kconfig.cpu unification
      x86: add X86_32 dependency to i386 specific symbols in Kconfig.i386
      x86: add X86_64 dependency to x86_64 specific symbols in Kconfig.x86_64
      x86: copy x86_64 specific Kconfig symbols to Kconfig.i386
      x86: move all simple arch settings to Kconfig
      x86: move the rest of the menu's to Kconfig

Adding support for K64BIT=y on commandline
      kconfig: factor out code in confdata.c
      kconfig: add helper to set config symbol from environment variable
      kconfig: use $K64BIT to set 64BIT with all*config targets

Preparational patch that just clean up a few bits in x86:
      x86: do not use $(ARCH) when not needed

Introducing "make ARCH=x86"
      x86: enable "make ARCH=x86"

After the preparation then introducing "make ARCH=x86" actually
deleted more lines than is added (last patch):
    5 files changed, 19 insertions(+), 49 deletions(-)


The patchset is available at:

	git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git

Patches will be sent to lkml for another review round.

	Sam


Diffstat:

 Makefile                                           |   13 +-
 README                                             |    2 +
 arch/x86/{Kconfig.i386 => Kconfig}                 |  567 ++++++++++----
 arch/x86/Kconfig.cpu                               |  121 ++--
 arch/x86/Kconfig.x86_64                            |  839 --------------------
 arch/x86/Makefile                                  |   10 +-
 arch/x86/Makefile_32                               |    8 +-
 arch/x86/Makefile_64                               |    8 +-
 arch/x86/boot/Makefile                             |    6 +-
 arch/x86/boot/cpucheck.c                           |    6 -
 arch/x86/kernel/Makefile_32                        |    3 +-
 arch/x86/kernel/Makefile_64                        |    2 +
 .../x86/kernel/cpu/cpufreq/{Kconfig_32 => Kconfig} |   69 ++-
 arch/x86/kernel/cpu/cpufreq/Kconfig_64             |  108 ---
 arch/x86/vdso/Makefile                             |    2 +-
 scripts/kconfig/Makefile                           |    7 +-
 scripts/kconfig/conf.c                             |    1 +
 scripts/kconfig/confdata.c                         |  146 +++--
 scripts/kconfig/lkc_proto.h                        |    1 +
 19 files changed, 684 insertions(+), 1235 deletions(-)

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


