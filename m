Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYAJS2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYAJS2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYAJS2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:28:36 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50006 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909AbYAJS2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:28:35 -0500
Date: Thu, 10 Jan 2008 19:28:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 01/22 -v2] Add basic support for gcc profiler instrumentation
Message-ID: <20080110182828.GA19399@uranus.ravnborg.org>
References: <20080109232914.676624725@goodmis.org> <20080109233042.386384204@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109233042.386384204@goodmis.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven.

> Index: linux-compile-i386.git/arch/x86/Kconfig
> ===================================================================
> --- linux-compile-i386.git.orig/arch/x86/Kconfig	2008-01-09 14:09:36.000000000 -0500
> +++ linux-compile-i386.git/arch/x86/Kconfig	2008-01-09 14:10:07.000000000 -0500
> @@ -28,6 +28,10 @@ config GENERIC_CMOS_UPDATE
>  	bool
>  	default y
>  
> +config ARCH_HAS_MCOUNT
> +       bool
> +       default y
> +

Please use the following scheme:

arch/x86/Kconfig:
 config X86
+	select HAVE_MCOUNT

lib/tracing/Kconfig

+ # ARCH shall select HAVE_MCOUNT if they provide this function
+ config HAVE_MCOUNT
+	bool
+
+ config MCOUNT
+	bool
+	select FRAME_POINTER

And then in your later patches:
+config MCOUNT_TRACER
+       bool "Profiler instrumentation based tracer"
+       depends on DEBUG_KERNEL && HAVE_MCOUNT
+       select MCOUNT
+       help
+         Use profiler....

The "default n" is a noop since this is the default.
And note that the depends on is removed from MCOUNT
because you use it as a select target (so dependencies
are not checked anyway).

With this scheme implmented you:
- Use new naming convention (HAVE_*)
- Avoid defining one config variable per arch
- Do not have dependencies on selected symbols
- More compact representation in arch Kconfig files

	Sam
