Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbYBLSuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbYBLSuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762131AbYBLSuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:50:07 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:32985 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762047AbYBLSuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:50:05 -0500
Date: Tue, 12 Feb 2008 19:50:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080212185012.GA2348@uranus.ravnborg.org>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212090001.3fcc4ca0@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:00:01AM -0800, Arjan van de Ven wrote:
> 
> Hi,
> 
> I just read the excellent LWN writeup of the vmsplice security thing, and that got me
> wondering why this attack wasn't stopped by the CONFIG_CC_STACKPROTECTOR option... because
> it plain should have been...
> 
> some analysis later.. it turns out that the following line in the top level Makefile,
> added by you in October 2007, entirely disables CONFIG_CC_STACKPROTECTOR ;(
> With this line removed the exploit will be nicely stopped.
> 
> # Force gcc to behave correct even for buggy distributions
> CFLAGS          += $(call cc-option, -fno-stack-protector)
> 
> 
> Now I realize that certain distros have patched gcc to compensate for their lack of distro
> wide CFLAGS, and it's great to work around that... but would there be a way to NOT
> disable this for CONFIG_CC_STACKPROTECTOR please? It would have made this
> exploit not possible for those kernels that enable this feature (and that includes distros
> like Fedora)

I guess the problem is that we in arch/x86/Makefile enable the stackprotector
but then later in the main Makefile disables it.
So the right way to approach this should be to always disable it and the reenable it in
the arch Makefile.
So something like this?

	Sam

diff --git a/Makefile b/Makefile
index c162370..7ccf6f5 100644
--- a/Makefile
+++ b/Makefile
@@ -507,6 +507,9 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+# Force gcc to behave correct even for buggy distributions
+KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_FRAME_POINTER
@@ -525,9 +528,6 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
 endif
 
-# Force gcc to behave correct even for buggy distributions
-KBUILD_CFLAGS         += $(call cc-option, -fno-stack-protector)
-
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
