Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbYDJThi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbYDJThi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYDJTha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:37:30 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:34286 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYDJTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:37:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIGAHYJ/kdMQWoK/2dsb2JhbACBXaoS
Date: Thu, 10 Apr 2008 15:32:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: Re: [patch 12/17] Immediate Values - Kconfig menu in EMBEDDED
	(updated)
Message-ID: <20080410193226.GA22894@Krystal>
References: <20080409150829.855195878@polymtl.ca> <20080409152050.721310907@polymtl.ca> <200804101323.56697.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200804101323.56697.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:30:27 up 41 days, 15:41,  6 users,  load average: 0.64, 0.93,
	0.73
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thursday 10 April 2008 01:08:41 Mathieu Desnoyers wrote:
> > +config IMMEDIATE
> > +	default y if !DISABLE_IMMEDIATE
> 
> Wouldn't it be simlpler to roll DISABLE_IMMEDIATE into this?
> 
> ie.
> 	default y
> 	depends on HAVE_IMMEDIATE
> 	bool "Immediate value optimization" if EMBEDDED
> 	help
> 	  Immediate values are used as read-mostly variables that are rarely
> 	  updated. They use code patching to modify the values inscribed in the
> 	  instruction stream. It provides a way to save precious cache lines
> 	  that would otherwise have to be used by these variables.
> 
> 	  It consumes slightly more memory and requires to modify the instruction
> 	  stream each time a variable is updated. Should really be disabled for
> 	  embedded systems with read-only text.
> 

Sure, thanks for the tip. Here is the updated version.


Immediate Values - Kconfig menu in EMBEDDED

Immediate values provide a way to use dynamic code patching to update variables
sitting within the instruction stream. It saves caches lines normally used by
static read mostly variables. Enable it by default, but let users disable it
through the EMBEDDED menu with the "Disable immediate values" submenu entry.

Note: Since I think that I really should let embedded systems developers using
RO memory the option to disable the immediate values, I choose to leave this
menu option there, in the EMBEDDED menu. Also, the "CONFIG_IMMEDIATE" makes
sense because we want to compile out all the immediate code when we decide not
to use optimized immediate values at all (it removes otherwise unused code).

Changelog:
- Change ARCH_SUPPORTS_IMMEDIATE for HAS_IMMEDIATE
- Turn DISABLE_IMMEDIATE into positive logic

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
---
 init/Kconfig |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-04-10 15:22:37.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2008-04-10 15:29:09.000000000 -0400
@@ -758,6 +758,24 @@ config PROC_PAGE_MONITOR
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
 
+config HAVE_IMMEDIATE
+	def_bool n
+
+config IMMEDIATE
+	default y
+	depends on HAVE_IMMEDIATE
+	bool "Immediate value optimization" if EMBEDDED
+	help
+	  Immediate values are used as read-mostly variables that are rarely
+	  updated. They use code patching to modify the values inscribed in the
+	  instruction stream. It provides a way to save precious cache lines
+	  that would otherwise have to be used by these variables. They can be
+	  disabled through the EMBEDDED menu.
+
+	  It consumes slightly more memory and requires to modify the
+	  instruction stream each time a variable is updated. Should really be
+	  disabled for embedded systems with read-only text.
+
 endmenu		# General setup
 
 config SLABINFO

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
