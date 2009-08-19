Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZHSDAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZHSDAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZHSDAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:00:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZHSDAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:36 -0400
Message-Id: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 00/14] kconfig: streamline distro configs for testers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's my rebase of the prior push of streamline-config.pl.

What this patch series does, is add my streamline-config.pl as a make
option for users. What streamline-config.pl does is to look at the
modules loaded in the system (lsmod) and then scans all the Makefiles
and Kconfigs in the current directory tree to find what configs need
to be set for the modules that are loaded.

It then looks at the .config (if .config is not found, it looks
in /boot, /proc/config.gz, vmlinux, configs.ko for .configs that it
may be able to use). This script will remove all options set as =m that
does not need to be set in order to build the modules found by lsmod.

NOTE: This does not touch any =y option. If you do make allyesconfig
and then run this, it will have not effect anything. Nor does this enable
any thing that is not set. Although we may change this in the future.

This patch series provides:

  make localmodconfig

which will look for a .config to streamline. Then it will run silentoldconfig
to clean up any missing options.

  make localyesconfig

will remove all =m that is not needed to build the modules provided
by lsmod, and then convert the rest to =y. Note, once you do this, no more
changes will be made by these scripts.

This is idea to help testers. Since a lot of people download a kernel
from kernel.org and then uses the distro config to configure it. This can
take hours to build. Now all a tester needs to do, is to download the
kernel from kernel.org and run "make localmodconfig". This will disable
most of the modules that are set in distro kernels and speed up the
build time by magnitudes!

Lets try to get this in soon,

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: kconfig


Steven Rostedt (14):
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

----
 kernel/Makefile                      |    2 +-
 scripts/extract-ikconfig             |   14 ++
 scripts/kconfig/Makefile             |   34 +++-
 scripts/kconfig/streamline_config.pl |  366 ++++++++++++++++++++++++++++++++++
 4 files changed, 414 insertions(+), 2 deletions(-)
-- 
