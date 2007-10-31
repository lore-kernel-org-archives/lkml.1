Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbXJaJEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbXJaJEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXJaJEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:04:10 -0400
Received: from www.tglx.de ([62.245.132.106]:32868 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbXJaJEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:04:09 -0400
Subject: kbuild: possible regression?
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: sam@ravnborg.org
Cc: miltonm@bga.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 31 Oct 2007 10:03:50 +0100
Message-Id: <1193821430.3839.88.camel@bender.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm not quite sure if this might be a regression, but I recognized a
change to kbuild's behaviour, which causes some of my build scripts to
fail.

The build scripts do:

return system(('make -C %s O=%s ARCH=%s CROSS_COMPILE=%s '+
                      'oldconfig %s %s < /dev/null || exit %i') % 
                      (srcdir, 
                       builddir, 
                       arch,
                       crosscompile, 
                       target,
                       modules_target,
                       FAILED_RETCODE))

which results in something like:

make -C /here/workdir/linux-2.6/common/src O=/here/workdir/linux-2.6/common/build/build \
ARCH=i386 CROSS_COMPILE=/opt/i686-linux/bin/i686-linux- \
oldconfig bzImage  < /dev/null || exit 1

In the past, oldconfig was the first target, which has been handled.

Now, bzImage seems to get handled at first. That causes my build scripts
to fail, because the bzImage target does a silentoldconfig, which
doesn't allow console redirection.

[...]

Kernel log buffer size (16 => 64KB, 17 => 128KB) (LOG_BUF_SHIFT) [14] 14
Control Group support (CGROUPS) [N/y/?] (NEW) aborted!

Console input/output is redirected. Run 'make oldconfig' to update configuration.

make[5]: *** [silentoldconfig] Error 1
make[4]: *** [silentoldconfig] Error 2
make[3]: *** [include/config/auto.conf] Error 2
make[2]: *** [sub-make] Error 2
make[1]: *** [/here/workdir/linux-2.6/common/src/scripts/Kbuild.include] Error 2
make: *** [sub-make] Error 2
make: Leaving directory `/here/workdir/linux-2.6/common/src'

[...]

After silentoldconfig has failed, oldconfig seems to get executed and
after that the bzImage build is starting. So far so good, BUT: My script
checks the return value and fails after the execution of
silentoldconfig. That's why I recognized the different behaviour.

I did a git bisect to identify the commit, which caused the change to
kbuild's behaviour. The offending commit is:

commit 0b35786d77ba4037f181982cc8ca20a7a3bf0fd2
Author: Milton Miller <miltonm@bga.com>
Date:   Fri Sep 21 18:09:02 2007 -0500

    kbuild: call make once for all targets when O=.. is used
    
    Change the invocations of make in the output directory Makefile and the
    main Makefile for separate object trees to pass all goals to one $(MAKE)
    via a new phony target "sub-make" and the existing target _all.
    
    When compiling with separate object directories, a separate make is called
    in the context of another directory (from the output directory the main
    Makefile is called, the Makefile is then restarted with current directory
    set to the object tree).  Before this patch, when multiple make command
    goals are specified, each target results in a separate make invocation.
    With make -j, these invocations may run in parallel, resulting in multiple
    commands running in the same directory clobbering each others results.
    
    I did not try to address make -j for mixed dot-config and no-dot-config
    targets.  Because the order does matter, a solution was not obvious.
    Perhaps a simple check for MAKEFLAGS having -j and refusing to run would
    be appropriate.
    
    Signed-off-by: Milton Miller <miltonm@bga.com>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

So, am I facing a kbuild regression?

Cheers,
	Jan

