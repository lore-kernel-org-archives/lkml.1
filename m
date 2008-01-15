Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYAORrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYAORrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYAORrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:47:08 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:49700 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbYAORrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:47:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACCAjEdMROHU/2dsb2JhbACBV6oh
Date: Tue, 15 Jan 2008 12:37:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20080115173701.GB8375@Krystal>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk> <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:32:52 up 72 days, 22:38,  6 users,  load average: 0.49, 0.64,
	0.65
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Tue, 15 Jan 2008, Russell King wrote:
> > 
> > I don't particularly like stuffing the options into some random place
> > in the architectures Kconfig file when they should stay along side the
> > instrumentation configuration entries.
> 
> Well, I have to say that I don't particularly like obviously 
> architecture-specific stuff in an obviously non-architecture file..
> 
> I'd almost prefer to revert the thing that caused the problem, because 
> with Adrian's patch, I think the end result may *work*, but it's uglier 
> than what we started out with.
> 
> However, I think the *cleanest* solution right now may be something like 
> the appended. Totally untested, of course. It basically just copies the 
> generic kernel/Kconfig.instrumentation file into the arm directory, makes 
> arm use its own instead of the generic one, and removes the dependencies 
> on ARM in there (including all of the KPROBES entry that apparently isn't 
> an issue on ARM anyway). It then adds back the ARM-specific ones.
> 
> This follows the sacred rules of good code:
> 
>  - generic code is either generic or not. If it's not generic, don't claim 
>    it is.
> 
>  - don't *force* people to use generic code if it doesn't suit them. Make 
>    it available for the cases it makes sense for, but don't shoe-horn it 
>    into cases where it doesn't work well.
> 
> So it allows the sharing of the common case and *many* architectures end 
> up using the generic Kconfig file, but hey, if it doesn't make sense for 
> ARM, it doesn't make sense for ARM. It's that simple.
> 
> But as mentioned, it's totally untested and I don't have (or really want 
> to have) a cross-compiling environment. And I don't care *that* much. I 
> just want something we can all live with.
> 
> So does something like this work for people?
> 

Hi,

Well, it goes along the lines of the patch I suggested as a reply to
Adrian, with these differences :

- I still source the kernel/Kconfig.instrumentation file.
- I put back the missing OPROFILE options directly in arch/arm/Kconfig

Then end result is the same as your patch, but without the code
duplication.

Here is the patch :


Fix ARMv6 oprofile support

This patch restores the ARMv6 OProfile support that was killed by
commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

It puts the config options in arch/arm/Kconfig.

Thanks to Adrian Bunk for finding this bug and providing an initial
patch.

Changelog :
Use def_bool.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <adrian.bunk@movial.fi>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: rmk@arm.linux.org.uk
CC: phil.el@wanadoo.fr
CC: oprofile-list@lists.sourceforge.net
---
 arch/arm/Kconfig |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-12-29 16:58:32.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-12-29 16:59:25.000000000 -0500
@@ -130,6 +130,23 @@ config FIQ
 config ARCH_MTD_XIP
 	bool
 
+if OPROFILE
+
+config OPROFILE_ARMV6
+	def_bool y
+	depends on CPU_V6 && !SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	def_bool y
+	depends on CPU_V6 && SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
+endif
+
 config VECTORS_BASE
 	hex
 	default 0xffff0000 if MMU || CPU_HIGH_VECTOR


- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
