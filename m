Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZBDK0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZBDK0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZBDK00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:26:26 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51900 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbZBDK0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:26:25 -0500
Date: Wed, 4 Feb 2009 05:26:04 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Jeff Arnold <jbarnold@MIT.EDU>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 2/7] x86: Add an option to compile with -ffunction-sections
 -fdata-sections
In-Reply-To: <200902041908.42173.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0902040453590.32142@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu> <1228521840-3886-3-git-send-email-jbarnold@mit.edu> <200902041908.42173.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Rusty Russell wrote:
> You need to make this depend on X86, otherwise allmodconfig will turn it on
> and break other archs.

Okay.

> What's the conflict with FTRACE?

This actually should have changed from FTRACE to FUNCTION_TRACER as of 
commit 606576ce816603d9fe1fb453a88bc6eea16ca709 in v2.6.28-rc3.

The conflict is that FUNCTION_TRACER enables KBUILD_CFLAGS += -pg, and 
passing -pg to current gcc causes it to emit a warning and disable 
-ffunction-sections:
  <http://gcc.gnu.org/ml/gcc-help/2008-11/msg00128.html>

(If this gcc problem is resolved in the future, the code should work fine 
with FUNCTION_TRACER.  A small amount of extra matching code is needed to 
handle DYNAMIC_FTRACE.)

Patch for these two issues:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6e23e10..1d63b5f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -29,6 +29,7 @@ config X86
 	select HAVE_KSPLICE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
+	select HAVE_FUNCTION_DATA_SECTIONS
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6d64083..c6a2674 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -591,9 +591,13 @@ config FRAME_POINTER
 	  larger and slower, but it gives very useful debugging information
 	  in case of kernel bugs. (precise oopses/stacktraces/warnings)

+config HAVE_FUNCTION_DATA_SECTIONS
+	bool
+
 config FUNCTION_DATA_SECTIONS
 	bool "Compile with -ffunction-sections -fdata-sections"
-	depends on !FTRACE
+	depends on HAVE_FUNCTION_DATA_SECTIONS
+	depends on !FUNCTION_TRACER
 	help
 	  If you say Y here the compiler will give each function
 	  and data structure its own ELF section.
