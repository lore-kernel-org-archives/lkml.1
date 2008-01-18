Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYARI4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYARI4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYARI4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:56:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40079 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYARI4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:56:05 -0500
Date: Fri, 18 Jan 2008 09:56:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, Zan Lynx <zlynx@acm.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
Message-ID: <20080118085612.GC15956@uranus.ravnborg.org>
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp> <20080117181935.02294863.akpm@linux-foundation.org> <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp> <20080117204247.5318e500.akpm@linux-foundation.org> <200801180640.m0I6enPI029212@www262.sakura.ne.jp> <a8e1da0801172259s3377895dwb0b2ca1dd781d11b@mail.gmail.com> <20080118002152.c9e76c51.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118002152.c9e76c51.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 12:21:52AM -0800, Andrew Morton wrote:
> On Fri, 18 Jan 2008 14:59:32 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> 
> > On Jan 18, 2008 2:40 PM, Tetsuo Handa
> > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > Hello.
> > >
> > > Andrew Morton wrote:
> > > > It could be compiler version dependent.  I used gcc-4.1.0.  Which version
> > > > were you and Zan using please?
> > 
> > I have the same problem, gcc 3.4.6
> > 
> > >
> > > I'm using gcc 3.3.5 on Debian/Sarge .
> > >
> > > By the way, 2.6.24-rc8-mm1 doesn't hang with a kernel config
> > >
> > > # make -s allnoconfig
> > > # make -s menuconfig
> > >
> > >   Set [*] to all entries in "Kernel hacking  --->" section
> > >   (except "KGDB: kernel debugging with remote gdb").
> > >
> > > # make -s && make -s install
> 
> The only machine I have with gcc-3.x takes an amazing amount of time to
> compile a quite minimal kernel then barfs in headers_install with
> 
>   CHK     include/linux/version.h
> make[1]: `scripts/unifdef' is up to date.
> make[1]: *** No rule to make target `|', needed by `asm-generic'.  Stop.
> 
> which is a mainline bug, too.  ISTR someone else reported it but I don't
> recall it getting fixed.

I know about this bug and I plan to fix it one day.

I have not considered it important because the bug is only triggered
by following connditions:
1) In kernel hacking the check headers options is selected
2) make is older than version 3.80

Documentation/changes do not require us to use make 3.80.
 
> I think I'll give up on this.  Either someone else fixes it or we merge the
> bug into mainline.

One way to fix this is to disable the config option like this.

	Sam

[PATCH] kbuild: disable headers_check

The headers_check command requires make version 3.80 due to use
of ordered dependencies. But kernel build does otherwise
not require this recent make.
Disable the option until it get properly fixed.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a601093..98b2431 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -67,7 +67,7 @@ config DEBUG_FS
 
 config HEADERS_CHECK
 	bool "Run 'make headers_check' when building vmlinux"
-	depends on !UML
+	depends on !UML || BROKEN
 	help
 	  This option will extract the user-visible kernel headers whenever
 	  building the kernel, and will run basic sanity checks on them to
