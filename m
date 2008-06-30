Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbYF3QWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbYF3QWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYF3QWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:22:33 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:33325 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYF3QWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:22:32 -0400
Date: Mon, 30 Jun 2008 12:22:01 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix extern inline errors with gcc 4.3.0
Message-ID: <20080630162201.GC6643@c2.user-mode-linux.org>
References: <1214488251-20927-1-git-send-email-bhalevy@panasas.com> <20080627162645.GC8381@c2.user-mode-linux.org> <7225594ED4A1304C9E43D030A886D221050BE1@daytona.int.panasas.com> <48673A9B.8050907@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48673A9B.8050907@panasas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 10:32:43AM +0300, Benny Halevy wrote:
> Note that the crash happened with gcc 4.1.2 and it will get the
> -fno-unit-at-a-time flag with the proposed patch.
> 
> That said, this option or the lack of it ought not to cause any
> runtime crashes.  If it does, I'd feel much more comfortable to know
> exactly what the root cause is before deciding to use the flag to
> workaround^hide it.

I agree.

The constraints on [no-]unit-at-a-time that I see are:
	i386 uses no-unit-at-a-time for pre-4.0 (not 4.3)
	x86_64 uses unit-at-a-time always

	Uli reported a crash on x86_64 with gcc 4.1.2 with unit-at-a-time
	Ingo reported a gcc internal error with gcc 4.3 with
no-unit-at-a-time 
	You are seeing extern inlines not resolved with gcc 4.3 with
no-unit-at-a-time 

I'm tempted to follow x86 on this, with the results that
	extern inlines should be fine
	Ingo's gcc crash should not reappear
	Uli's crash may reappear

If that crash does come back, I'd say we should just debug it.  It's
likely UML implicitly relying on some gcc behavior anyway.

This is the patch that I'm dropping into my tree:

Index: linux-2.6.22/arch/um/Makefile-i386
===================================================================
--- linux-2.6.22.orig/arch/um/Makefile-i386	2008-05-29 11:21:25.000000000 -0400
+++ linux-2.6.22/arch/um/Makefile-i386	2008-06-30 12:20:01.000000000 -0400
@@ -32,4 +32,10 @@ cflags-y += $(call cc-option,-mpreferred
 # an unresolved reference.
 cflags-y += -ffreestanding
 
+# Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
+# a lot more stack due to the lack of sharing of stacklots.  Also, gcc
+# 4.3.0 needs -funit-at-a-time for extern inline functions.
+KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0403 ] ; then \
+			echo $(call cc-option,-fno-unit-at-a-time); fi ;)
+
 KBUILD_CFLAGS += $(cflags-y)
Index: linux-2.6.22/arch/um/Makefile-x86_64
===================================================================
--- linux-2.6.22.orig/arch/um/Makefile-x86_64	2008-05-29 11:21:25.000000000 -0400
+++ linux-2.6.22/arch/um/Makefile-x86_64	2008-06-30 12:21:01.000000000 -0400
@@ -21,3 +21,6 @@ HEADER_ARCH := x86
 
 LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib64
 LINK-y += -m64
+
+# Do unit-at-a-time unconditionally on x86_64, following the host
+KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)

				Jeff

-- 
Work email - jdike at linux dot intel dot com
