Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZIKUAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZIKUAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbZIKUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:00:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47605 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZIKUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:30 -0400
Message-Id: <20090911195849.451244684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:58:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dick Streefland <dick@streefland.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 00/15] [GIT PULL] kconfig: localmodconfig for v2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

This is the patch set that creates localmodconfig and localyesconfig.
This will facilitate testers by removing the thousand modules that
distributions enable with only the ones that they have loaded.

Yes it may miss usb devices that you don't have plugged in, but it will
save a lot of time in compiling by only compiling the code that you
have loaded.

The usage is quite simple. Just download the latest kernel.org kernel
(with this changeset in), cd to that directory and then do:

  make localmodconfig

It will search for a .config locally first, then will look for
/proc/config.gz, then it will search the /boot directory for configs
matching the local kernel (uname -r). If it still does not find one
It search for configurations in the local binarys (vmlinux, /lib/modules..,
kernel/configs.ko, etc).

Once it finds a config to use, it will then read all the Kconfigs
and Makefiles to find out what config compiles what module. Then lsmod
is used to see what modules are loaded, and it will keep enabled all
the configs (including dependencies) that those modules require to
build. It disables all modules not needed.

Note, it only disables it does not enable, because a lot of modules
can be enabled by more than one config, and I don't want to guess.
I could someday enable easy configs (1 to 1 matches of config to module).

It also does nothing with built in code (=y). It does not enable or
disable them.

I've been using this code (various versions of) since 2005, and
so have others. When I get a new box, the first thing I do is
boot up the distribution kernel, download kernel.org kernel, and run
this script to get the modules needed to boot the kernel.

** CONFLICTS **

linux-next has proven that there is a conflict between these patches
and Sam Ravnborg's tree. I've tried to get in contact with Sam, but
he seems to be out. I don't want to hold up this push on that account.
But if you want, I could wait to fix the conflicts, or you can pull
this and he can fix it on his end. I'm fine with it. I just think
that this tool is important enough to get into mainline, especially
early in the merge window since it will help others test it. ;-)

Please pull kconfig updates for v2.6.32 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-kconfig.git
     for-linus


Steven Rostedt (15):
      kconfig: add streamline_config.pl to scripts
      kconfig: make localmodconfig to run streamline_config.pl
      kconfig: add make localyesconfig option
      kconfig: streamline_config.pl do not stop with no depends
      kconfig: do not warn about modules built in
      kconfig: enable CONFIG_IKCONFIG from streamline_config.pl
      kconfig: add check if end exists in extract-ikconfig
      kconfig: have extract-ikconfig read ELF files
      kconfig: keep config.gz around even if CONFIG_IKCONFIG_PROC is not set
      kconfig: search for a config to base the local(mod|yes)config on
      kconfig: unset IKCONFIG_PROC and clean up nesting
      kconfig: test for /boot/config-uname after /proc/config.gz in localconfig
      kconfig: make local .config default for streamline_config
      kconfig: test if a .config already exists
      kconfig: add missing dependency of conf to localyesconfig

----
 kernel/Makefile                      |    2 +-
 scripts/extract-ikconfig             |   14 ++
 scripts/kconfig/Makefile             |   34 +++-
 scripts/kconfig/streamline_config.pl |  366 ++++++++++++++++++++++++++++++++++
 4 files changed, 414 insertions(+), 2 deletions(-)
-- 
