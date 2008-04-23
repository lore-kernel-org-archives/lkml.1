Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYDWSo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYDWSo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYDWSoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:44:18 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39678 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYDWSoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:44:17 -0400
Date: Wed, 23 Apr 2008 20:44:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Will Newton <will.newton@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Message-ID: <20080423184447.GA6024@uranus.ravnborg.org>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <20080422081211.e85989ec.randy.dunlap@oracle.com> <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com> <20080422152426.GG19802@phobos.i.cabal.ca> <87a5b0800804220834q4d6daec1x4146d211115ab5c@mail.gmail.com> <20080422153849.GH19802@phobos.i.cabal.ca> <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 03:36:23PM +0100, Will Newton wrote:
> On Tue, Apr 22, 2008 at 4:38 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
> > On Tue, Apr 22, 2008 at 04:34:03PM +0100, Will Newton wrote:
> >  > On Tue, Apr 22, 2008 at 4:24 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
> >  > > On Tue, Apr 22, 2008 at 04:16:17PM +0100, Will Newton wrote:
> >  > >  > It can be done with Kconfig. Whether it should be or not depends on
> >  > >  > your point of view, hence RFC. Currently __ARCH_WANT macros is the way
> >  > >  > syscalls are enabled and disabled across architectures. If there's
> >  > >  > consensus that it should be done via Kconfig that could certainly be
> >  > >  > implmented, but that's a different patch.
> >  > >  >
> >  > >
> >  > >  It's currently done in unistd.h for hysterical raisins. All new
> >  > >  conditional syscalls have been done in Kconfig.
> >  >
> >  > Do you have a syscall in mind that does this in the correct way?
> >  >
> >
> >  epoll is the most immediate example at hand, since it touches
> >  fs/compat.c similarly to how you would be touching fs/filesystem.c, and
> >  touches kernel/sys_ni.c and init/Kconfig in much the same way.
> 
> I implemented the approach you suggested - Kconfig symbol and
> cond_syscall definition. I think I actually like the previous approach
> better:
> 
> 1. The arch Kconfig files are quite non-uniform compared to unistd.h
> so the definitions wind up at different places in the file which is a
> bit messy.
> 2. Changes to Kconfig may cause churn in defconfigs perhaps?
> 3. There is more churn in arch Kconfig than unistd.h so getting a
> cross arch patch applied is likely to be more difficult.
> 4. The patch is about 4 times as many lines.
> 
> What do you think?

If we go the Kconfig route we should use the
HAVE_ semantic as expressed by the patch below.
It is preferable to defining a config symbol for each
arch.
This also address your point 1) and 4)
2) is not an issue since the symbols are not visible.

	Sam

Note: cut'n'pasted...

diff --git a/arch/Kconfig b/arch/Kconfig
index 694c9af..759bd5b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -36,3 +36,9 @@ config HAVE_KPROBES

 config HAVE_KRETPROBES
        def_bool n
+
+# syscall symbols.
+# archs shall select the SYMBOL if they
+# implment this syscall
+config HAVE_SYS_SYSFS
+       defbool n
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 87a693c..487310f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,6 +24,8 @@ config X86
        select HAVE_KRETPROBES
        select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
        select HAVE_ARCH_KGDB
+       # kconfig selectable syscalls
+       select HAVE_SYS_SYSFS

