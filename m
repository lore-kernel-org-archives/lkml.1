Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYHDOMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYHDOMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYHDOMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:12:18 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:51376 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYHDOMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:12:17 -0400
Message-ID: <48970E07.60804@s5r6.in-berlin.de>
Date: Mon, 04 Aug 2008 16:11:19 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1 2/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
References: <51617.166.70.238.45.1217831286.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <51617.166.70.238.45.1217831286.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> Netware style debugger for Linux written by Jeffrey Vernon Merkey
> 
> --- a/arch/x86/kernel/traps_32.c	2008-08-03 16:09:54.000000000 -0600
> +++ b/arch/x86/kernel/traps_32.c	2008-08-03 17:33:06.000000000 -0600
...
> @@ -865,6 +896,16 @@
>  }
>  #endif
> 
> +#if defined(CONFIG_MDB) && !defined(CONFIG_KPROBES)
> +fastcall void do_int3(struct pt_regs * regs, long error_code)
> +{
> +#ifdef	CONFIG_MDB
> +        if (mdb(BREAKPOINT_EXCEPTION, error_code, regs))
> +           return;
> +#endif
> +	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
> +}
> +#endif	/* CONFIG_KDB && !CONFIG_KPROBES */

The inner #ifdef is always true.


>  /*
>   * Our handling of the processor debug registers is non-trivial.
>   * We do not clear them on entry and exit from the kernel. Therefore
> @@ -895,6 +936,10 @@
>  	trace_hardirqs_fixup();
> 
>  	get_debugreg(condition, 6);
> +#ifdef	CONFIG_MDB
> +        if (mdb(DEBUGGER_EXCEPTION, error_code, regs))
> +           return;
> +#endif
> 
>  	/*
>  	 * The processor cleared BTF, so don't mark that we need it set.

I wonder if it would be beneficial to
 - include an mdb header file in source files like this one,
 - in the mdb header, define mdb() as a static inline function which
   does nothing but return false if CONFIG_MDB is not defined.

Would get rid of the visual clutter introduced by #ifdef/#endif and
catch potential syntax errors when people later modify this code.  I
assume that a compiler is used which eliminates code properly when mdb()
is nothing but constant false...
-- 
Stefan Richter
-=====-==--- =--- --=--
http://arcgraph.de/sr/
